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
  Future<void> requestChurchRegistration(Church church) async {
    try {
      // 1. 현재 로그인 사용자 확인
      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('로그인이 필요합니다.');

      // 2. 문서 생성 — role 등 민감 필드는 절대 포함하지 않음
      final newDocRef = _churchesRef.doc();
      final payload = <String, dynamic>{
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
        'rejectionReason': null,
        'createdAt': FieldValue.serverTimestamp(), // 서버 시간 기준 (클라이언트 시계 위조 방지)
        'updatedAt': FieldValue.serverTimestamp(),
        'approvedAt': null,
      };

      await newDocRef.set(payload);
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

      // role 필드를 절대 포함하지 않는 안전한 payload만 업데이트
      await _usersRef.doc(currentUser.uid).update({
        'churchId': churchId,
        'churchName': sanitizeInput(churchName, maxLength: 100),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('교회 가입 중 오류가 발생했습니다: ${e.message}');
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

  /// required 날짜 필드 변환 — null이면 즉시 명시적 예외를 던진다 (조용한 오염 방지)
  String _toIso8601Required(dynamic value, {required String fieldName}) {
    if (value is Timestamp) return value.toDate().toIso8601String();
    if (value is String) return value;
    throw FormatException(
      '필수 날짜 필드 "$fieldName"의 값이 null이거나 알 수 없는 타입입니다. 타입: ${value.runtimeType}',
    );
  }

  /// nullable 날짜 필드 변환 — null이면 null 반환
  String? _toIso8601Nullable(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate().toIso8601String();
    if (value is String) return value;
    return null;
  }
}
