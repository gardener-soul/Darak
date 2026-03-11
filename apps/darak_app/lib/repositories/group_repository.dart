import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/firestore_paths.dart';
import '../core/providers/firebase_providers.dart';
import '../models/group.dart';

part 'group_repository.g.dart';

/// Firestore `groups` 컬렉션 전담 Repository
/// 온보딩 및 그룹 관리 화면에서 사용됩니다.
@riverpod
GroupRepository groupRepository(Ref ref) {
  return GroupRepository(firestore: ref.watch(firestoreProvider));
}

class GroupRepository {
  final FirebaseFirestore _firestore;

  GroupRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  /// Firestore groups 컬렉션 참조 (재사용)
  CollectionReference<Map<String, dynamic>> get _groupsRef =>
      _firestore.collection(FirestorePaths.groups);

  // ─── 전체 그룹 목록 조회 (페이징 적용) ───────────────────────
  /// 온보딩 화면에서 사용자가 선택할 수 있는 그룹 목록을 가져옵니다.
  /// Firestore 비용 절감을 위해 페이징(limit)을 적용하고,
  /// Soft Delete된 그룹은 제외합니다.
  Future<List<Group>> getAllGroups({int limit = 20}) async {
    try {
      final snapshot = await _groupsRef
          .where('deletedAt', isNull: true)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      if (snapshot.docs.isEmpty) return [];

      return snapshot.docs
          .map((doc) {
            try {
              return Group.fromJson(doc.data());
            } catch (e) {
              // 역직렬화 실패 시 해당 문서만 스킵
              return null;
            }
          })
          .whereType<Group>()
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('그룹 목록 조회 실패: ${e.message}');
    }
  }

  // ─── 그룹 검색 (prefix 검색) ───────────────────────────────
  /// 그룹 이름으로 검색합니다.
  /// Firestore의 한계상 prefix 검색만 가능합니다.
  /// 더 고도화된 검색(오타 교정, 전문 검색 등)이 필요하면 Algolia 등 도입을 고려하세요.
  Future<List<Group>> searchGroups(String query, {int limit = 20}) async {
    try {
      // 빈 쿼리는 전체 목록 반환
      if (query.trim().isEmpty) {
        return getAllGroups(limit: limit);
      }

      final sanitizedQuery = query.trim();

      final snapshot = await _groupsRef
          .where('deletedAt', isNull: true)
          .where('name', isGreaterThanOrEqualTo: sanitizedQuery)
          .where('name', isLessThan: '$sanitizedQuery\uf8ff')
          .orderBy('name')
          .limit(limit)
          .get();

      if (snapshot.docs.isEmpty) return [];

      return snapshot.docs
          .map((doc) {
            try {
              return Group.fromJson(doc.data());
            } catch (e) {
              return null;
            }
          })
          .whereType<Group>()
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('그룹 검색 실패: ${e.message}');
    }
  }

  // ─── 특정 그룹 조회 ───────────────────────────────────────
  /// groupId로 단건 그룹 정보를 가져옵니다.
  /// 문서가 존재하지 않거나 Soft Delete된 경우 null을 반환합니다.
  Future<Group?> getGroupById(String groupId) async {
    try {
      final doc = await _groupsRef.doc(groupId).get();

      if (!doc.exists || doc.data() == null) return null;

      final data = doc.data()!;

      // Soft Delete 체크
      if (data['deletedAt'] != null) return null;

      return Group.fromJson(data);
    } on FirebaseException catch (e) {
      throw Exception('그룹 정보 조회 실패: ${e.message}');
    }
  }

  // ─── 그룹에 멤버 추가 ─────────────────────────────────────
  /// 사용자가 그룹에 가입할 때 Group 문서의 memberIds 배열에 userId를 추가합니다.
  /// 중복 추가를 방지하기 위해 FieldValue.arrayUnion을 사용합니다.
  Future<void> addMemberToGroup(String groupId, String userId) async {
    try {
      await _groupsRef.doc(groupId).update({
        'memberIds': FieldValue.arrayUnion([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('그룹 멤버 추가 실패: ${e.message}');
    }
  }
}
