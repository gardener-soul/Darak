import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/announcement.dart';
import '../../repositories/announcement_repository.dart';

part 'church_announcements_viewmodel.g.dart';

/// 교회 상세 화면의 최근 공지사항 3건을 실시간 구독하는 Provider.
/// 홈 미리보기 및 공지 탭 상단 섹션에서 사용합니다.
@riverpod
Stream<List<Announcement>> churchRecentAnnouncements(
  Ref ref,
  String churchId,
) {
  return ref
      .watch(announcementRepositoryProvider)
      .watchRecentAnnouncements(churchId: churchId, limit: 3);
}
