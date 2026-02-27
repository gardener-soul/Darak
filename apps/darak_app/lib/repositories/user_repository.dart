import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/firestore_paths.dart';
import '../core/providers/firebase_providers.dart';
import '../models/user.dart';

part 'user_repository.g.dart';

/// Firestore `users` 컬렉션 전담 Repository
/// UI 레이어는 이 Repository를 통해서만 유저 데이터에 접근해야 합니다.
@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepository(firestore: ref.watch(firestoreProvider));
}

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  /// Firestore users 컬렉션 참조 (재사용)
  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection(FirestorePaths.users);

  // ─── 단건 조회 (1회 Read) ───────────────────────────────────
  /// [uid]에 해당하는 유저 문서를 한 번 읽어옵니다.
  /// 문서가 존재하지 않으면 null을 반환합니다.
  Future<User?> getUserById(String uid) async {
    try {
      final doc = await _usersRef.doc(uid).get();
      if (!doc.exists || doc.data() == null) return null;
      return User.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw Exception('유저 정보 조회 실패: ${e.message}');
    }
  }

  // ─── 실시간 스트림 구독 ─────────────────────────────────────
  /// [uid]에 해당하는 유저 문서를 실시간으로 구독합니다.
  /// 마이페이지 진입 시 매번 get()하지 않고 이 스트림을 watch합니다.
  Stream<User?> watchUser(String uid) {
    return _usersRef.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;
      return User.fromJson(snapshot.data()!);
    });
  }

  // ─── 프로필 정보 수정 (bio, profileImageUrl) ────────────────
  /// 낙관적 업데이트: 호출자는 로컬 상태를 먼저 변경한 뒤 이 함수를 호출합니다.
  /// [role] 필드는 Firestore Rules에 의해 본인이 변경할 수 없으므로 여기서 차단합니다.
  Future<void> updateUserProfile(
    String uid, {
    String? bio,
    String? profileImageUrl,
  }) async {
    try {
      final Map<String, dynamic> updates = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (bio != null) {
        // XSS 방어: 50자 제한 + HTML 태그 제거
        final sanitized = _sanitizeInput(bio, maxLength: 50);
        updates['bio'] = sanitized;
      }

      if (profileImageUrl != null) {
        updates['profileImageUrl'] = profileImageUrl;
      }

      await _usersRef.doc(uid).update(updates);
    } on FirebaseException catch (e) {
      throw Exception('프로필 수정 실패: ${e.message}');
    }
  }

  // ─── 기도 제목 업데이트 ─────────────────────────────────────
  /// 기도 제목 리스트 전체를 교체합니다.
  /// 배열 필드이므로 개별 추가/삭제보다 전체 교체가 안전합니다.
  Future<void> updatePrayerRequests(
    String uid,
    List<String> requests,
  ) async {
    try {
      // 각 항목 sanitize (최대 200자)
      final sanitized =
          requests.map((r) => _sanitizeInput(r, maxLength: 200)).toList();

      await _usersRef.doc(uid).update({
        'prayerRequests': sanitized,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('기도 제목 저장 실패: ${e.message}');
    }
  }

  // ─── 출석 통계 캐시 업데이트 ─────────────────────────────────
  /// 리더가 출석 체크할 때 호출하여 유저 문서에 통계를 캐싱합니다.
  /// 마이페이지에서는 이 캐시만 읽어 1회 Read로 출석률을 표시합니다.
  Future<void> updateAttendanceStats(
    String uid,
    Map<String, dynamic> stats,
  ) async {
    try {
      await _usersRef.doc(uid).update({
        'attendanceStats': stats,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('출석 통계 업데이트 실패: ${e.message}');
    }
  }

  // ─── 입력값 Sanitize 헬퍼 ──────────────────────────────────
  /// HTML 태그 제거 및 길이 제한으로 XSS/악의적 입력 방어
  String _sanitizeInput(String input, {int maxLength = 100}) {
    // HTML 태그 제거
    final stripped = input.replaceAll(RegExp(r'<[^>]*>'), '');
    // 앞뒤 공백 제거
    final trimmed = stripped.trim();
    // 길이 제한
    if (trimmed.length > maxLength) {
      return trimmed.substring(0, maxLength);
    }
    return trimmed;
  }
}
