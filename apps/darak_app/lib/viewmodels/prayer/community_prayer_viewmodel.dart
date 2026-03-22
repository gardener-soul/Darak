import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/prayer.dart';
import '../../repositories/prayer_repository.dart';

part 'community_prayer_viewmodel.g.dart';

/// 공동체 기도 목록 — 같은 다락방의 group 공개 기도 제목 실시간 스트림
@riverpod
Stream<List<Prayer>> communityPrayerList(Ref ref, String groupId) {
  return ref
      .watch(prayerRepositoryProvider)
      .watchCommunityPrayers(groupId: groupId);
}
