import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/firestore_paths.dart';
import '../core/providers/firebase_providers.dart';
import '../core/utils/input_sanitizer.dart';
import '../models/church.dart';

part 'church_repository.g.dart';

/// Firestore `churches` 컬렉션 전담 Repository
/// UI 레이어는 이 Repository를 통해서만 교회 데이터에 접근해야 합니다.
@riverpod
ChurchRepository churchRepository(Ref ref) {
  return ChurchRepository(
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
}

class ChurchRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ChurchRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  /// Firestore churches 컬렉션 참조 (재사용)
  CollectionReference<Map<String, dynamic>> get _churchesRef =>
      _firestore.collection(FirestorePaths.churches);

  /// Firestore users 컬렉션 참조 (재사용)
  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection(FirestorePaths.users);

  // ─── 승인된 교회 목록 실시간 스트림 ──────────────────────────
  /// 승인된 교회 목록을 실시간으로 구독합니다.
  /// [searchQuery]가 있으면 name 필드에서 클라이언트 사이드 필터링합니다.
  /// (Firestore 풀텍스트 검색 미지원으로 인한 클라이언트 필터링)
  Stream<List<Church>> watchApprovedChurches({String? searchQuery}) {
    return _churchesRef
        .where('status', isEqualTo: 'approved')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final churches = <Church>[];
          for (final doc in snapshot.docs) {
            try {
              final church =
                  Church.fromJson(_fromFirestore(doc.data(), doc.id));
              churches.add(church);
            } catch (e) {
              // 역직렬화 실패한 문서는 스킵하여 스트림 중단 방지
            }
          }
          if (searchQuery != null && searchQuery.trim().isNotEmpty) {
            final query = searchQuery.trim().toLowerCase();
            return churches
                .where((c) => c.name.toLowerCase().contains(query))
                .toList();
          }
          return churches;
        })
        .transform(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) => sink.add(data),
            handleError: (error, stackTrace, sink) {
              // Firestore 복합 인덱스 미배포 상태(failed-precondition)에서는
              // 실제 데이터 없음과 동일하게 빈 목록으로 폴백 — UI는 empty state를 표시
              if (error is FirebaseException &&
                  error.code == 'failed-precondition') {
                sink.add(<Church>[]);
              } else {
                // 네트워크 단절, 권한 에러 등 실질적인 오류는 ViewModel이 AsyncError로 처리
                sink.addError(
                  Exception('교회 목록을 불러오는 중 오류가 발생했습니다: $error'),
                  stackTrace,
                );
              }
            },
          ),
        );
  }

  // ─── 교회 등록 신청 ───────────────────────────────────────
  /// 새 교회 등록을 신청합니다.
  /// name + address 조합으로 사전 중복 체크(Soft Guard)를 수행한 후 문서를 생성합니다.
  /// Firestore는 쿼리 기반 원자적 중복 방지를 지원하지 않으므로, 극단적 동시 제출의
  /// 최종 안전망은 관리자 승인 단계가 담당합니다.
  /// status는 항상 'pending'으로 강제되며, 호출자가 임의로 변경할 수 없습니다.
  /// 생성된 churchId를 반환합니다 (ViewModel에서 seedDefaultRoles 등 후속 작업에 사용).
  Future<String> requestChurchRegistration(Church church) async {
    try {
      // 1. 현재 로그인 사용자 확인
      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('로그인이 필요합니다.');

      // 2. 문서 생성 — role 등 민감 필드는 절대 포함하지 않음
      final newDocRef = _churchesRef.doc();
      final churchPayload = <String, dynamic>{
        'name': sanitizeInput(church.name, maxLength: 100),
        'address': sanitizeInput(church.address, maxLength: 200),
        'addressDetail': church.addressDetail != null
            ? sanitizeInput(church.addressDetail!, maxLength: 100)
            : null,
        'latitude': church.latitude,
        'longitude': church.longitude,
        'seniorPastor': sanitizeInput(church.seniorPastor, maxLength: 50),
        'denomination': sanitizeInput(church.denomination, maxLength: 50),
        'requestMemo': sanitizeInput(church.requestMemo, maxLength: 300),
        'requestedBy': currentUser.uid, // 서버에서 uid 강제 — 호출자 임의 주입 차단
        'status': 'pending', // 항상 pending으로 강제 — 승인 우회 차단
        'adminIds': [currentUser.uid], // 신청자가 최초 관리자로 자동 등록
        'rejectionReason': null,
        'createdAt': FieldValue.serverTimestamp(), // 서버 시간 기준 (클라이언트 시계 위조 방지)
        'updatedAt': FieldValue.serverTimestamp(),
        'approvedAt': null,
        'memberCount': 1, // 신청자가 member로 함께 등록되므로 1부터 시작
      };

      // 3. Batch: 교회 문서 + 신청자 member 문서 + user 소속 정보 원자적으로 함께 생성
      final churchId = newDocRef.id;
      final memberRef = _firestore
          .collection(FirestorePaths.churchMembers(churchId))
          .doc(currentUser.uid);
      final userRef = _usersRef.doc(currentUser.uid);

      final batch = _firestore.batch();
      batch.set(newDocRef, churchPayload);
      batch.set(memberRef, {
        'userId': currentUser.uid,
        'roleId': 'member',
        'villageId': null,
        'groupId': null,
        'joinedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      // user 문서에 churchId/churchName 기록 → 홈 화면 배너 해소
      batch.update(userRef, {
        'churchId': churchId,
        'churchName': sanitizeInput(church.name, maxLength: 100),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await batch.commit();
      return churchId;
    } on FirebaseException catch (e) {
      throw Exception('교회 등록 신청 중 오류가 발생했습니다: ${e.message}');
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('교회 등록 신청 중 오류가 발생했습니다: $e');
    }
  }

  // ─── 교회 가입 ────────────────────────────────────────────
  /// 현재 인증된 사용자를 특정 교회에 가입시킵니다.
  /// [churchId]가 approved 상태로 실존하는지 먼저 검증합니다.
  /// 보안: role 필드는 절대 payload에 포함하지 않습니다.
  Future<void> joinChurch({
    required String churchId,
    required String churchName,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('로그인이 필요합니다.');

      // churchId가 approved 상태로 실제 존재하는지 검증
      final churchDoc = await _churchesRef.doc(churchId).get();
      if (!churchDoc.exists) {
        throw Exception('존재하지 않는 교회입니다.');
      }
      final churchStatus = churchDoc.data()?['status'] as String?;
      if (churchStatus != 'approved') {
        throw Exception('승인된 교회만 가입할 수 있습니다.');
      }

      // Batch: member 문서 생성 + user 소속 정보 업데이트 + memberCount 증가
      final memberRef = _firestore
          .collection(FirestorePaths.churchMembers(churchId))
          .doc(currentUser.uid);
      final userRef = _usersRef.doc(currentUser.uid);
      final churchRef = _churchesRef.doc(churchId);

      final batch = _firestore.batch();
      batch.set(memberRef, {
        'userId': currentUser.uid,
        'roleId': 'member',
        'villageId': null,
        'groupId': null,
        'joinedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      batch.update(userRef, {
        'churchId': churchId,
        'churchName': sanitizeInput(churchName, maxLength: 100),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      batch.update(churchRef, {
        'memberCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await batch.commit();
    } on FirebaseException catch (e) {
      throw Exception('교회 가입 중 오류가 발생했습니다: ${e.message}');
    }
  }

  // ─── 교회 단건 실시간 스트림 (교회 상세 페이지용) ────────────────
  /// [churchId]에 해당하는 교회 문서를 실시간으로 구독합니다.
  /// 문서가 존재하지 않으면 Exception을 던집니다.
  Stream<Church> watchChurch(String churchId) {
    return _churchesRef.doc(churchId).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) throw Exception('교회 정보를 찾을 수 없습니다.');
      return Church.fromJson(_fromFirestore(data, doc.id));
    });
  }

  // ─── 교회 기본 정보 수정 (관리자 전용) ──────────────────────────
  /// 교회 이름, 주소, 담임목사, 교단 정보를 수정합니다.
  /// 모든 텍스트 입력은 XSS 방어를 위해 sanitizeInput을 통과합니다.
  Future<void> updateChurchInfo({
    required String churchId,
    required String name,
    required String address,
    required String seniorPastor,
    required String denomination,
  }) async {
    try {
      await _churchesRef.doc(churchId).update({
        'name': sanitizeInput(name, maxLength: 100),
        'address': sanitizeInput(address, maxLength: 200),
        'seniorPastor': sanitizeInput(seniorPastor, maxLength: 50),
        'denomination': sanitizeInput(denomination, maxLength: 50),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('교회 정보 수정에 실패했습니다: ${e.message}');
    } catch (e) {
      throw Exception('교회 정보 수정에 실패했습니다: $e');
    }
  }

  // ─── 관리자 추가 ──────────────────────────────────────────
  /// [userId]를 [churchId]의 adminIds 배열에 추가합니다.
  /// 중복 추가 방지를 위해 FieldValue.arrayUnion 사용.
  Future<void> addAdminId({
    required String churchId,
    required String userId,
  }) async {
    try {
      await _churchesRef.doc(churchId).update({
        'adminIds': FieldValue.arrayUnion([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('관리자 추가에 실패했습니다: ${e.message}');
    } catch (e) {
      throw Exception('관리자 추가에 실패했습니다: $e');
    }
  }

  // ─── 관리자 제거 ──────────────────────────────────────────
  /// [userId]를 [churchId]의 adminIds 배열에서 제거합니다.
  /// 마지막 관리자는 제거할 수 없습니다 (최소 1명 유지).
  Future<void> removeAdminId({
    required String churchId,
    required String userId,
  }) async {
    try {
      final doc = await _churchesRef.doc(churchId).get();
      final adminIds = List<String>.from(doc.data()?['adminIds'] ?? []);
      if (adminIds.length <= 1) {
        throw Exception('마지막 관리자는 해제할 수 없습니다.');
      }
      await _churchesRef.doc(churchId).update({
        'adminIds': FieldValue.arrayRemove([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('관리자 제거에 실패했습니다: ${e.message}');
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('관리자 제거에 실패했습니다: $e');
    }
  }

  // ─── 통계 카운트 원자 증감 ────────────────────────────────────
  /// [field] 카운트를 [delta]만큼 원자적으로 증감합니다.
  /// field: 'memberCount' | 'villageCount' | 'groupCount'
  Future<void> incrementCount({
    required String churchId,
    required String field,
    int delta = 1,
  }) async {
    try {
      await _churchesRef.doc(churchId).update({
        field: FieldValue.increment(delta),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('카운트 업데이트에 실패했습니다: ${e.message}');
    } catch (e) {
      throw Exception('카운트 업데이트에 실패했습니다: $e');
    }
  }

  // ─── Firestore 날짜 타입 변환 헬퍼 ─────────────────────────
  /// Firestore 문서 데이터를 Church.fromJson에서 기대하는 형태로 변환합니다.
  /// [docId]를 주입하여 Firestore 문서 ID를 id 필드로 사용합니다.
  Map<String, dynamic> _fromFirestore(
    Map<String, dynamic> data,
    String docId,
  ) {
    return {
      ...data,
      'id': docId, // Firestore 문서 ID를 모델 id 필드로 주입
      'createdAt': _toIso8601Required(data['createdAt'], fieldName: 'createdAt'),
      'updatedAt': _toIso8601Required(data['updatedAt'], fieldName: 'updatedAt'),
      'approvedAt': _toIso8601Nullable(data['approvedAt']),
    };
  }

  /// required 날짜 필드 변환
  /// FieldValue.serverTimestamp()는 로컬 optimistic 스냅샷에서 잠깐 null이 될 수 있음.
  /// 해당 케이스에서는 현재 시각으로 폴백하여 크래시 방지.
  String _toIso8601Required(dynamic value, {required String fieldName}) {
    if (value is Timestamp) return value.toDate().toIso8601String();
    if (value is String) return value;
    // serverTimestamp pending-writes 상태: null → 현재 시각으로 폴백
    return DateTime.now().toIso8601String();
  }

  /// nullable 날짜 필드 변환 — null이면 null 반환
  String? _toIso8601Nullable(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate().toIso8601String();
    if (value is String) return value;
    return null;
  }
}
