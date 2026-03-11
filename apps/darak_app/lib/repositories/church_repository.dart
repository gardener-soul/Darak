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
        .handleError((error) {
          // Firestore 권한 에러, 네트워크 에러 등 — ViewModel에서 AsyncError로 처리하도록 rethrow
          throw Exception('교회 목록을 불러오는 중 오류가 발생했습니다: $error');
        });
  }

  // ─── 교회 등록 신청 ───────────────────────────────────────
  /// 새 교회 등록을 신청합니다.
  /// 트랜잭션 내에서 중복 체크와 문서 생성을 원자적으로 처리하여
  /// 동시 신청 시 발생할 수 있는 Race Condition(TOCTOU)을 방지합니다.
  /// status는 항상 'pending'으로 강제되며, 호출자가 임의로 변경할 수 없습니다.
  Future<void> requestChurchRegistration(Church church) async {
    try {
      // 트랜잭션 밖에서 새 문서 참조를 미리 생성
      final newDocRef = _churchesRef.doc();

      await _firestore.runTransaction((transaction) async {
        // 1. 트랜잭션 내 중복 체크 (읽기): name + address + status 조합
        final duplicateQuery = await _churchesRef
            .where('name', isEqualTo: sanitizeInput(church.name, maxLength: 100))
            .where(
              'address',
              isEqualTo: sanitizeInput(church.address, maxLength: 200),
            )
            .where('status', whereIn: ['pending', 'approved'])
            .limit(1)
            .get();

        if (duplicateQuery.docs.isNotEmpty) {
          throw Exception('동일한 이름과 주소의 교회가 이미 신청되었거나 등록되어 있습니다.');
        }

        // 2. 현재 로그인 사용자 확인
        final currentUser = _auth.currentUser;
        if (currentUser == null) throw Exception('로그인이 필요합니다.');

        final now = DateTime.now().toIso8601String();

        // 3. 트랜잭션 내 쓰기 — role 등 민감 필드는 절대 포함하지 않음
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
          'requestMemo': sanitizeInput(church.requestMemo, maxLength: 500),
          'requestedBy': currentUser.uid, // 서버에서 uid 강제 — 호출자 임의 주입 차단
          'status': 'pending', // 항상 pending으로 강제 — 승인 우회 차단
          'rejectionReason': null,
          'createdAt': now,
          'updatedAt': now,
          'approvedAt': null,
        };

        transaction.set(newDocRef, payload);
      });
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
        'updatedAt': DateTime.now().toIso8601String(),
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
