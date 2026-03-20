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
              // doc.id를 주입하여 id 필드 누락 방지
              return Group.fromJson(
                _fromFirestore({...doc.data(), 'id': doc.id}),
              );
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
              // doc.id를 주입하여 id 필드 누락 방지
              return Group.fromJson(
                _fromFirestore({...doc.data(), 'id': doc.id}),
              );
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

      // doc.id를 주입하여 id 필드 누락 방지
      return Group.fromJson(
        _fromFirestore({...data, 'id': doc.id}),
      );
    } on FirebaseException catch (e) {
      throw Exception('그룹 정보 조회 실패: ${e.message}');
    }
  }

  // ─── 교회별 다락방 목록 단건 조회 (Future) ─────────────────
  /// [churchId] 교회에 속한 모든 다락방을 한 번 조회합니다.
  /// Stream.first 대신 이 메서드를 사용하여 메모리 누수를 방지합니다.
  Future<List<Group>> getGroupsByChurch({required String churchId}) async {
    try {
      final snapshot = await _groupsRef
          .where('churchId', isEqualTo: churchId)
          .where('deletedAt', isNull: true)
          .get();

      if (snapshot.docs.isEmpty) return [];

      return snapshot.docs
          .map((doc) {
            try {
              return Group.fromJson(
                _fromFirestore({...doc.data(), 'id': doc.id}),
              );
            } catch (e) {
              return null;
            }
          })
          .whereType<Group>()
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('교회별 다락방 목록 조회 실패: ${e.message}');
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

  // ─── 교회별 전체 다락방 목록 실시간 스트림 ───────────────────
  /// [churchId] 교회에 속한 모든 다락방을 실시간으로 구독합니다.
  /// Soft Delete된 다락방은 제외합니다.
  Stream<List<Group>> watchGroupsByChurch({required String churchId}) {
    return _groupsRef
        .where('churchId', isEqualTo: churchId)
        .where('deletedAt', isNull: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) {
                try {
                  return Group.fromJson(
                    _fromFirestore({...doc.data(), 'id': doc.id}),
                  );
                } catch (e) {
                  return null;
                }
              })
              .whereType<Group>()
              .toList(),
        );
  }

  // ─── 마을별 다락방 목록 실시간 스트림 ──────────────────────
  /// [churchId] 교회의 [villageId] 마을에 속한 다락방을 실시간으로 구독합니다.
  /// Soft Delete된 다락방은 제외합니다.
  Stream<List<Group>> watchGroupsByVillage({
    required String churchId,
    required String villageId,
  }) {
    return _groupsRef
        .where('churchId', isEqualTo: churchId)
        .where('villageId', isEqualTo: villageId)
        .where('deletedAt', isNull: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) {
                try {
                  return Group.fromJson(
                    _fromFirestore({...doc.data(), 'id': doc.id}),
                  );
                } catch (e) {
                  return null;
                }
              })
              .whereType<Group>()
              .toList(),
        );
  }

  // ─── 다락방에서 멤버 제거 ─────────────────────────────────────
  /// Group.memberIds 배열에서 [userId]를 제거합니다.
  Future<void> removeMemberFromGroup(String groupId, String userId) async {
    try {
      await _groupsRef.doc(groupId).update({
        'memberIds': FieldValue.arrayRemove([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('그룹 멤버 제거 실패: ${e.message}');
    }
  }

  // ─── 다락방 정보 수정 ────────────────────────────────────────
  /// 다락방의 이름과 설명을 수정합니다.
  Future<void> updateGroup({
    required String groupId,
    required String name,
    String? description,
  }) async {
    try {
      await _groupsRef.doc(groupId).update({
        'name': name,
        'description': description,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('다락방 수정 실패: ${e.message}');
    }
  }

  // ─── 다락방 Soft Delete ─────────────────────────────────────
  /// 다락방 문서에 deletedAt을 설정합니다 (물리 삭제 X).
  Future<void> deleteGroup(String groupId) async {
    try {
      await _groupsRef.doc(groupId).update({
        'deletedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('다락방 삭제 실패: ${e.message}');
    }
  }

  // ─── 멤버를 다른 다락방으로 이동 (Batch) ─────────────────────
  /// [fromGroupId]에서 [userId]를 제거하고 [toGroupId]에 추가합니다.
  /// ChurchMember 소속 정보 업데이트까지 포함하여 3건을 단일 Batch로 처리합니다.
  Future<void> moveMemberBetweenGroups({
    required String fromGroupId,
    required String toGroupId,
    required String userId,
    required String churchId,
    String? toVillageId,
  }) async {
    try {
      final batch = _firestore.batch();
      // 1. 이전 다락방에서 제거
      batch.update(_groupsRef.doc(fromGroupId), {
        'memberIds': FieldValue.arrayRemove([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      // 2. 새 다락방에 추가
      batch.update(_groupsRef.doc(toGroupId), {
        'memberIds': FieldValue.arrayUnion([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      // 3. ChurchMember 소속 정보 업데이트 (원자성 보장)
      final memberRef = _firestore
          .collection('churches')
          .doc(churchId)
          .collection('members')
          .doc(userId);
      batch.update(memberRef, {
        'groupId': toGroupId,
        'villageId': toVillageId,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await batch.commit();
    } on FirebaseException catch (e) {
      throw Exception('멤버 이동 실패: ${e.message}');
    }
  }

  // ─── 다락방 생성 ────────────────────────────────────────────
  /// 새 다락방 문서를 Firestore에 생성합니다.
  /// [group.churchId]가 null이면 예외를 던집니다.
  Future<void> createGroup({required Group group}) async {
    try {
      if (group.churchId == null) throw Exception('churchId는 필수입니다.');
      final doc = _groupsRef.doc();
      final data = group.toJson();
      data['id'] = doc.id;
      // DateTime → ISO 8601 문자열 변환 (Freezed toJson은 DateTime 그대로 반환)
      data['createdAt'] = group.createdAt.toIso8601String();
      data['updatedAt'] = group.updatedAt.toIso8601String();
      if (group.deletedAt != null) {
        data['deletedAt'] = group.deletedAt!.toIso8601String();
      }
      await doc.set(data);
    } catch (e) {
      throw Exception('다락방 생성에 실패했습니다: $e');
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
