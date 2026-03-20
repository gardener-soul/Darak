import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/group.dart';
import '../../models/village.dart';
import '../../models/village_with_groups.dart';
import '../../repositories/church_member_repository.dart';
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
    required String leaderId,
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

  /// 특정 멤버를 다락방에 추가하고 소속 정보를 동기화합니다.
  Future<void> addMemberToGroup({
    required String churchId,
    required String groupId,
    required String userId,
  }) async {
    try {
      await ref.read(groupRepositoryProvider).addMemberToGroup(
            groupId,
            userId,
          );
      await ref.read(churchMemberRepositoryProvider).updateMemberCommunity(
            churchId: churchId,
            userId: userId,
            groupId: groupId,
          );
    } catch (e) {
      throw Exception('순원 추가에 실패했습니다: $e');
    }
  }
}
