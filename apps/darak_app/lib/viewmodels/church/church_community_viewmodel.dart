import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/firestore_paths.dart';
import '../../core/providers/firebase_providers.dart';
import '../../models/group.dart';
import '../../models/village.dart';
import '../../models/village_with_groups.dart';
import '../../repositories/church_repository.dart';
import '../../repositories/group_repository.dart';
import '../../repositories/village_repository.dart';

part 'church_community_viewmodel.g.dart';

/// 공동체 탭(마을/다락방 트리)의 상태를 관리하는 ViewModel.
/// VillageRepository와 GroupRepository 스트림을 실시간으로 결합하여 트리 구조를 제공합니다.
@riverpod
class ChurchCommunityViewModel extends _$ChurchCommunityViewModel {
  @override
  Stream<List<VillageWithGroups>> build(String churchId) {
    final villageRepo = ref.watch(villageRepositoryProvider);
    final groupRepo = ref.watch(groupRepositoryProvider);

    // 마을 스트림과 다락방 스트림을 각각 구독하여 어느 쪽 변경이든 즉시 반영
    final villageStream = villageRepo.watchVillagesByChurch(churchId: churchId);
    final groupStream = groupRepo.watchGroupsByChurch(churchId: churchId);

    late StreamController<List<VillageWithGroups>> controller;
    List<Village>? latestVillages;
    List<Group>? latestGroups;

    void tryEmit() {
      final v = latestVillages;
      final g = latestGroups;
      if (v != null && g != null && !controller.isClosed) {
        final result = v.map((village) {
          final vGroups = g.where((grp) => grp.villageId == village.id).toList();
          return VillageWithGroups(village: village, groups: vGroups);
        }).toList();
        controller.add(result);
      }
    }

    controller = StreamController<List<VillageWithGroups>>(
      onCancel: () {},
    );

    final villageSub = villageStream.listen(
      (villages) {
        latestVillages = villages;
        tryEmit();
      },
      onError: controller.addError,
    );

    final groupSub = groupStream.listen(
      (groups) {
        latestGroups = groups;
        tryEmit();
      },
      onError: controller.addError,
    );

    ref.onDispose(() {
      villageSub.cancel();
      groupSub.cancel();
      controller.close();
    });

    return controller.stream;
  }

  /// 새 마을을 생성하고 교회의 villageCount를 원자적으로 증가시킵니다.
  Future<void> createVillage({
    required String churchId,
    required String name,
    String? description,
    required String leaderId,
  }) async {
    try {
      final village = Village(
        id: '',
        name: name,
        description: description,
        leaderId: leaderId,
        churchId: churchId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await ref.read(villageRepositoryProvider).createVillage(village: village);
      await ref.read(churchRepositoryProvider).incrementCount(
            churchId: churchId,
            field: 'villageCount',
          );
    } catch (e) {
      throw Exception('마을 생성에 실패했습니다: $e');
    }
  }

  /// 새 다락방을 생성하고 교회의 groupCount를 원자적으로 증가시킵니다.
  Future<void> createGroup({
    required String churchId,
    required String villageId,
    required String name,
    String? description,
    String? leaderId,
  }) async {
    try {
      final group = Group(
        id: '',
        name: name,
        description: description,
        leaderId: leaderId,
        villageId: villageId,
        churchId: churchId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await ref.read(groupRepositoryProvider).createGroup(group: group);
      await ref.read(churchRepositoryProvider).incrementCount(
            churchId: churchId,
            field: 'groupCount',
          );
    } catch (e) {
      throw Exception('다락방 생성에 실패했습니다: $e');
    }
  }

  /// 특정 멤버를 다락방에 추가하고 소속 정보를 단일 Batch로 원자적으로 동기화합니다.
  Future<void> addMemberToGroup({
    required String churchId,
    required String groupId,
    required String userId,
  }) async {
    try {
      // 그룹 문서에서 villageId 조회 (ChurchMember 업데이트에 필요)
      final group = await ref
          .read(groupRepositoryProvider)
          .getGroupById(groupId);
      if (group == null) throw Exception('다락방 정보를 찾을 수 없습니다.');

      final firestore = ref.read(firestoreProvider);
      final batch = firestore.batch();

      // 1. groups/{groupId}.memberIds arrayUnion
      final groupRef = firestore.collection(FirestorePaths.groups).doc(groupId);
      batch.update(groupRef, {
        'memberIds': FieldValue.arrayUnion([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 2. churches/{churchId}/members/{userId} 소속 정보 업데이트
      final memberRef = firestore
          .collection(FirestorePaths.churchMembers(churchId))
          .doc(userId);
      batch.update(memberRef, {
        'groupId': groupId,
        'villageId': group.villageId,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('순원 추가에 실패했습니다: $e');
    }
  }

  /// 특정 멤버를 다락방에서 제거하고 소속 정보를 단일 Batch로 원자적으로 null 처리합니다.
  Future<void> removeMemberFromGroup({
    required String churchId,
    required String groupId,
    required String userId,
  }) async {
    try {
      final firestore = ref.read(firestoreProvider);
      final batch = firestore.batch();

      // 1. groups/{groupId}.memberIds arrayRemove
      final groupRef = firestore.collection(FirestorePaths.groups).doc(groupId);
      batch.update(groupRef, {
        'memberIds': FieldValue.arrayRemove([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 2. churches/{churchId}/members/{userId} 소속 정보 null 초기화
      _nullifyMemberGroup(batch, firestore, churchId, userId);

      await batch.commit();
    } catch (e) {
      throw Exception('순원 제거에 실패했습니다: $e');
    }
  }

  /// 멤버를 다른 다락방으로 이동합니다.
  /// GroupRepository.moveMemberBetweenGroups에서 3건을 단일 Batch로 원자적 처리합니다.
  Future<void> moveMemberBetweenGroups({
    required String churchId,
    required String fromGroupId,
    required String toGroupId,
    String? toVillageId,
    required String userId,
  }) async {
    try {
      await ref.read(groupRepositoryProvider).moveMemberBetweenGroups(
            fromGroupId: fromGroupId,
            toGroupId: toGroupId,
            userId: userId,
            churchId: churchId,
            toVillageId: toVillageId,
          );
    } catch (e) {
      throw Exception('멤버 이동에 실패했습니다: $e');
    }
  }

  /// 다락방 이름/설명을 수정합니다.
  Future<void> updateGroup({
    required String groupId,
    required String name,
    String? description,
  }) async {
    try {
      await ref.read(groupRepositoryProvider).updateGroup(
            groupId: groupId,
            name: name,
            description: description,
          );
    } catch (e) {
      throw Exception('다락방 수정에 실패했습니다: $e');
    }
  }

  /// 다락방 순장을 등록/변경/해제합니다.
  /// [leaderId]가 null이면 순장을 해제합니다.
  Future<void> updateGroupLeader({
    required String groupId,
    required String? leaderId,
  }) async {
    try {
      await ref.read(groupRepositoryProvider).updateGroupLeader(
            groupId: groupId,
            leaderId: leaderId,
          );
    } catch (e) {
      throw Exception('순장 변경에 실패했습니다: $e');
    }
  }

  /// 다락방을 Soft Delete하고 소속 멤버들의 groupId를 null로 초기화합니다.
  /// Firestore Batch 500개 한도 방어를 위해 멤버를 499개씩 청크로 나눠 처리합니다.
  /// - 첫 번째 Batch: Soft Delete + groupCount 감소 + 첫 청크 멤버 처리
  /// - 이후 Batch: 나머지 멤버 청크 처리
  Future<void> deleteGroup({
    required String churchId,
    required String groupId,
    required List<String> memberIds,
  }) async {
    try {
      final firestore = ref.read(firestoreProvider);

      // 멤버를 497개씩 청크로 분할 (첫 Batch에 Soft Delete + groupCount 2건 고정 예약)
      const chunkSize = 497;
      final chunks = <List<String>>[];
      for (var i = 0; i < memberIds.length; i += chunkSize) {
        chunks.add(memberIds.sublist(i, min(i + chunkSize, memberIds.length)));
      }

      // 첫 번째 Batch: Soft Delete + groupCount 감소 + 첫 청크 멤버 처리
      final firstBatch = firestore.batch();

      // 1. 다락방 Soft Delete
      final groupRef = firestore.collection(FirestorePaths.groups).doc(groupId);
      firstBatch.update(groupRef, {
        'deletedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 2. groupCount 감소
      final churchRef = firestore.collection(FirestorePaths.churches).doc(churchId);
      firstBatch.update(churchRef, {'groupCount': FieldValue.increment(-1)});

      // 3. 첫 번째 청크 멤버 groupId/villageId null 처리
      if (chunks.isNotEmpty) {
        for (final uid in chunks.first) {
          _nullifyMemberGroup(firstBatch, firestore, churchId, uid);
        }
      }

      await firstBatch.commit();

      // 나머지 청크를 병렬 Batch로 처리
      if (chunks.length > 1) {
        await Future.wait([
          for (var i = 1; i < chunks.length; i++)
            () {
              final batch = firestore.batch();
              for (final uid in chunks[i]) {
                _nullifyMemberGroup(batch, firestore, churchId, uid);
              }
              return batch.commit();
            }(),
        ]);
      }
    } catch (e) {
      throw Exception('다락방 삭제에 실패했습니다: $e');
    }
  }

  /// 멤버의 groupId/villageId를 Batch에 null로 등록하는 헬퍼.
  void _nullifyMemberGroup(
    WriteBatch batch,
    FirebaseFirestore firestore,
    String churchId,
    String uid,
  ) {
    final memberRef = firestore
        .collection(FirestorePaths.churchMembers(churchId))
        .doc(uid);
    batch.update(memberRef, {
      'groupId': null,
      'villageId': null,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
