import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/firestore_paths.dart';
import '../core/providers/firebase_providers.dart';
import '../models/church_member.dart';

part 'church_member_repository.g.dart';

/// Firestore `churches/{churchId}/members` 서브컬렉션 전담 Repository
@riverpod
ChurchMemberRepository churchMemberRepository(Ref ref) {
  return ChurchMemberRepository(
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
}

class ChurchMemberRepository {
  final FirebaseFirestore _firestore;
  // ignore: unused_field
  final FirebaseAuth _auth;

  ChurchMemberRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  // ─── 교회 멤버 목록 실시간 스트림 ─────────────────────────────
  /// [churchId] 교회의 멤버 목록을 실시간으로 구독합니다.
  /// [filterRoleId]가 있으면 해당 역할의 멤버만 필터링합니다.
  Stream<List<ChurchMember>> watchMembers({
    required String churchId,
    String? filterRoleId,
    int limit = 20,
  }) {
    var query = _firestore
        .collection(FirestorePaths.churchMembers(churchId))
        .limit(limit);
    if (filterRoleId != null) {
      query = query.where('roleId', isEqualTo: filterRoleId);
    }
    return query.snapshots().map(
          (snap) => snap.docs
              .map(
                (doc) => ChurchMember.fromJson(
                  _fromFirestore({...doc.data(), 'userId': doc.id}),
                ),
              )
              .toList(),
        );
  }

  // ─── 교회 멤버 목록 단건 조회 (Future) ───────────────────────
  /// [churchId] 교회의 멤버 목록을 한 번 조회합니다.
  /// Stream.first 대신 이 메서드를 사용하여 실시간 구독 없이 안전하게 데이터를 가져옵니다.
  Future<List<ChurchMember>> getMembers({
    required String churchId,
    String? filterRoleId,
    int limit = 20,
  }) async {
    try {
      var query = _firestore
          .collection(FirestorePaths.churchMembers(churchId))
          .limit(limit);
      if (filterRoleId != null) {
        query = query.where('roleId', isEqualTo: filterRoleId);
      }
      final snap = await query.get();
      return snap.docs
          .map(
            (doc) => ChurchMember.fromJson(
              _fromFirestore({...doc.data(), 'userId': doc.id}),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('교회 멤버 목록 조회에 실패했습니다: $e');
    }
  }

  // ─── 특정 멤버 단건 조회 ────────────────────────────────────
  /// [churchId] 교회에서 [userId]에 해당하는 멤버 정보를 조회합니다.
  /// 존재하지 않으면 null을 반환합니다.
  Future<ChurchMember?> getMember({
    required String churchId,
    required String userId,
  }) async {
    try {
      final doc = await _firestore
          .collection(FirestorePaths.churchMembers(churchId))
          .doc(userId)
          .get();
      if (!doc.exists || doc.data() == null) return null;
      return ChurchMember.fromJson(
        _fromFirestore({...doc.data()!, 'userId': doc.id}),
      );
    } catch (e) {
      return null;
    }
  }

  // ─── 교회 가입 (Batch: 멤버 문서 생성 + memberCount 증가) ────
  /// [userId]를 [churchId] 교회에 가입시킵니다.
  /// 멤버 문서 생성과 memberCount 증가를 하나의 Batch로 처리합니다.
  /// joinedAt/updatedAt은 서버 타임스탬프를 사용하여 클라이언트 시간 오차를 제거합니다.
  Future<void> joinChurch({
    required String churchId,
    required String userId,
  }) async {
    try {
      final batch = _firestore.batch();
      batch.set(
        _firestore
            .collection(FirestorePaths.churchMembers(churchId))
            .doc(userId),
        {
          'userId': userId,
          'roleId': 'member',
          'villageId': null,
          'groupId': null,
          'joinedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );
      batch.update(
        _firestore.collection(FirestorePaths.churches).doc(churchId),
        {'memberCount': FieldValue.increment(1)},
      );
      await batch.commit();
    } catch (e) {
      throw Exception('교회 가입에 실패했습니다: $e');
    }
  }

  // ─── 멤버 역할 변경 ──────────────────────────────────────────
  /// [churchId] 교회의 [userId] 멤버 역할을 [newRoleId]로 변경합니다.
  Future<void> updateMemberRole({
    required String churchId,
    required String userId,
    required String newRoleId,
  }) async {
    try {
      await _firestore
          .collection(FirestorePaths.churchMembers(churchId))
          .doc(userId)
          .update({
        'roleId': newRoleId,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('역할 변경에 실패했습니다: $e');
    }
  }

  // ─── 멤버 소속(마을/다락방) 변경 ──────────────────────────────
  /// [churchId] 교회의 [userId] 멤버 소속 마을 및 다락방을 변경합니다.
  Future<void> updateMemberCommunity({
    required String churchId,
    required String userId,
    String? villageId,
    String? groupId,
  }) async {
    try {
      await _firestore
          .collection(FirestorePaths.churchMembers(churchId))
          .doc(userId)
          .update({
        'villageId': villageId,
        'groupId': groupId,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('소속 변경에 실패했습니다: $e');
    }
  }

  // ─── 교회 탈퇴 (Batch: 멤버 문서 삭제 + memberCount 감소) ───
  /// [userId]를 [churchId] 교회에서 탈퇴시킵니다.
  Future<void> leaveChurch({
    required String churchId,
    required String userId,
  }) async {
    try {
      final batch = _firestore.batch();
      batch.delete(
        _firestore
            .collection(FirestorePaths.churchMembers(churchId))
            .doc(userId),
      );
      batch.update(
        _firestore.collection(FirestorePaths.churches).doc(churchId),
        {'memberCount': FieldValue.increment(-1)},
      );
      await batch.commit();
    } catch (e) {
      throw Exception('교회 탈퇴에 실패했습니다: $e');
    }
  }

  // ─── Firestore 날짜 타입 변환 헬퍼 ─────────────────────────
  /// Timestamp → ISO 8601 문자열로 변환하여 Freezed 모델과의 호환성 확보
  Map<String, dynamic> _fromFirestore(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is Timestamp) {
        return MapEntry(key, value.toDate().toIso8601String());
      }
      return MapEntry(key, value);
    });
  }
}
