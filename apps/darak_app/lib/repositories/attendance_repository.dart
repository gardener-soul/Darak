import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/firestore_paths.dart';
import '../core/providers/firebase_providers.dart';
import '../models/attendance.dart';
import '../models/attendance_status.dart';
import '../models/attendance_type.dart';

part 'attendance_repository.g.dart';

@riverpod
AttendanceRepository attendanceRepository(Ref ref) {
  return AttendanceRepository(firestore: ref.watch(firestoreProvider));
}

/// 출석 기록 데이터 레이어
/// - 루트 컬렉션 `attendances/{id}` 사용
/// - Upsert 전략: Query-then-set (WriteBatch 일괄 처리)
/// - deletedAt isNull 필터: 인덱스 배포 전 클라이언트 사이드 처리
class AttendanceRepository {
  final FirebaseFirestore _firestore;

  AttendanceRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  // ─── 다락방 전원 일괄 Upsert (WriteBatch) ─────────────────────
  /// 순장이 다락방 멤버 전원의 출석을 한 번에 저장합니다.
  /// [records]: {userId → status} 맵.
  /// [notes]: {userId → note} 맵 (선택).
  Future<void> batchUpsertAttendance({
    required String groupId,
    required DateTime date,
    required AttendanceType type,
    required String checkedById,
    required Map<String, AttendanceStatus> records,
    Map<String, String?> notes = const {},
  }) async {
    try {
      final batch = _firestore.batch();
      final col = _firestore.collection(FirestorePaths.attendances);

      // QA-1 [CRITICAL]: N+1 쿼리 방어 (사전에 1번의 쿼리로 전체 기록을 가져옴)
      final existingRecords = await getAttendancesByGroupAndDate(
        groupId: groupId,
        date: date,
        type: type,
      );
      final existingMap = {for (var r in existingRecords) r.userId: r};

      for (final entry in records.entries) {
        final userId = entry.key;
        final status = entry.value;
        final note = notes[userId];

        // 메모리 상에서 매핑 비교 (네트워크 O(1) 유지)
        final existing = existingMap[userId];

        if (existing != null) {
          batch.update(col.doc(existing.id), {
            'status': status.name,
            'note': note,
            'checkedById': checkedById,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } else {
          final docRef = col.doc();
          batch.set(docRef, {
            'id': docRef.id,
            'userId': userId,
            'groupId': groupId,
            'type': _typeToJson(type),
            'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
            'status': status.name,
            'note': note,
            'checkedById': checkedById,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            // deletedAt: null → 저장하지 않음 (isNull 쿼리 호환)
          });
        }
      }

      await batch.commit();
    } catch (e) {
      throw Exception('일괄 출석 저장에 실패했습니다: $e');
    }
  }

  // ─── 다락방 특정 날짜·유형 출석 목록 조회 ───────────────────────
  /// 순장이 이미 저장된 날짜의 출석 기록을 불러올 때 사용합니다 (수정 모드).
  Future<List<Attendance>> getAttendancesByGroupAndDate({
    required String groupId,
    required DateTime date,
    required AttendanceType type,
  }) async {
    try {
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      final snap = await _firestore
          .collection(FirestorePaths.attendances)
          .where('groupId', isEqualTo: groupId)
          .where('type', isEqualTo: _typeToJson(type))
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart))
          .where('date', isLessThan: Timestamp.fromDate(dayEnd))
          .get();

      return _snapToAttendanceList(snap);
    } catch (e) {
      throw Exception('출석 기록 조회에 실패했습니다: $e');
    }
  }

  // ─── 다락방 월별 출석 목록 실시간 스트림 ────────────────────────
  /// AttendanceHistorySheet에서 월별 출석 이력을 실시간으로 구독합니다.
  Stream<List<Attendance>> watchGroupAttendanceByMonth({
    required String groupId,
    required int year,
    required int month,
  }) {
    final from = DateTime(year, month, 1);
    final to = DateTime(year, month + 1, 1); // Dart가 월 오버플로우 자동 처리

    return _firestore
        .collection(FirestorePaths.attendances)
        .where('groupId', isEqualTo: groupId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .where('date', isLessThan: Timestamp.fromDate(to))
        .orderBy('date', descending: false)
        .snapshots()
        .map(_snapToAttendanceList)
        .handleError((e, stackTrace) {
          debugPrint('월별 출석 스트림 오류: $e');
          return <Attendance>[];
        });
  }

  // ─── 복수 다락방 기간별 출석 집계 조회 ─────────────────────────
  /// 마을장·관리자가 여러 다락방의 출석 현황을 집계할 때 사용합니다.
  /// QA-2 [CRITICAL]: Firestore whereIn 최대 30개 제한을 안전하게 분할 처리(Chunking)
  Future<List<Attendance>> getAttendancesByGroups({
    required List<String> groupIds,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      if (groupIds.isEmpty) return [];

      const int chunkSize = 30;
      final List<List<String>> chunks = [];
      for (var i = 0; i < groupIds.length; i += chunkSize) {
        chunks.add(groupIds.sublist(i, min(i + chunkSize, groupIds.length)));
      }

      final futures = chunks.map((chunk) async {
        final snap = await _firestore
            .collection(FirestorePaths.attendances)
            .where('groupId', whereIn: chunk)
            .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
            .where('date', isLessThan: Timestamp.fromDate(to))
            .orderBy('date', descending: false)
            .get();

        return _snapToAttendanceList(snap);
      });

      final results = await Future.wait(futures);
      return results.expand((x) => x).toList();
    } catch (e) {
      throw Exception('마을 출석 현황 조회에 실패했습니다: $e');
    }
  }

  // ─── 특정 사용자 출석 이력 조회 (마이페이지) ────────────────────
  /// 순원 본인의 최근 출석 기록을 조회합니다.
  Future<List<Attendance>> getMyAttendances({
    required String userId,
    int limit = 5,
  }) async {
    try {
      final snap = await _firestore
          .collection(FirestorePaths.attendances)
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .limit(limit)
          .get();

      return _snapToAttendanceList(snap);
    } catch (e) {
      throw Exception('내 출석 기록 조회에 실패했습니다: $e');
    }
  }

  // ─── 특정 그룹의 최근 출석 기록 조회 (GroupDetailBottomSheet 요약용) ─
  Future<List<Attendance>> getRecentGroupAttendances({
    required String groupId,
    int limit = 20,
  }) async {
    try {
      final snap = await _firestore
          .collection(FirestorePaths.attendances)
          .where('groupId', isEqualTo: groupId)
          .orderBy('date', descending: true)
          .limit(limit)
          .get();

      return _snapToAttendanceList(snap);
    } catch (e) {
      throw Exception('최근 출석 기록 조회에 실패했습니다: $e');
    }
  }

  // ─── 출석 Soft Delete ────────────────────────────────────────
  Future<void> deleteAttendance(String attendanceId) async {
    try {
      await _firestore
          .collection(FirestorePaths.attendances)
          .doc(attendanceId)
          .update({
        'deletedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('출석 기록 삭제에 실패했습니다: $e');
    }
  }

  // ─── 히트맵용 기간 내 출석 데이터 조회 (마이페이지) ─────────────
  /// 특정 기간의 모든 출석 기록을 조회합니다 (히트맵 렌더링용).
  Future<List<Attendance>> getHeatmapAttendances({
    required String userId,
    required DateTime from,
  }) async {
    try {
      final snap = await _firestore
          .collection(FirestorePaths.attendances)
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
          .orderBy('date', descending: false)
          .get();

      return _snapToAttendanceList(snap);
    } catch (e) {
      throw Exception('히트맵 출석 데이터 조회에 실패했습니다: $e');
    }
  }

  // ─── 연속 출석 계산용 최근 출석 기록 조회 ──────────────────────
  /// present/late 상태의 출석 기록을 최신순으로 조회합니다.
  Future<List<Attendance>> getAttendancesForStreak({
    required String userId,
    int limit = 100,
  }) async {
    try {
      final snap = await _firestore
          .collection(FirestorePaths.attendances)
          .where('userId', isEqualTo: userId)
          .where('status', whereIn: [
            AttendanceStatus.present.name,
            AttendanceStatus.late.name,
          ])
          .orderBy('date', descending: true)
          .limit(limit)
          .get();

      return _snapToAttendanceList(snap);
    } catch (e) {
      throw Exception('연속 출석 기록 조회에 실패했습니다: $e');
    }
  }

  // ─── 내부 헬퍼: QuerySnapshot → Attendance 리스트 변환 ────────────
  List<Attendance> _snapToAttendanceList(
    QuerySnapshot<Map<String, dynamic>> snap,
  ) {
    return snap.docs
        .map((doc) => Attendance.fromJson(
              _fromFirestore({...doc.data(), 'id': doc.id}),
            ))
        .where((a) => a.deletedAt == null)
        .toList();
  }

  // ─── 내부 헬퍼: Timestamp → ISO 8601 변환 ──────────────────────
  Map<String, dynamic> _fromFirestore(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is Timestamp) {
        return MapEntry(key, value.toDate().toIso8601String());
      }
      return MapEntry(key, value);
    });
  }

  // ─── 내부 헬퍼: AttendanceType → JSON 값 ──────────────────────
  String _typeToJson(AttendanceType type) {
    switch (type) {
      case AttendanceType.onlySundayService:
        return 'onlySundayService';
      case AttendanceType.prayerMeeting:
        return 'prayer_meeting';
      case AttendanceType.specialEvent:
        return 'special_event';
    }
  }
}
