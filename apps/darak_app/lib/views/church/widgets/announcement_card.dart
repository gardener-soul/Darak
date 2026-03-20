import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/announcement.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/clay_card.dart';

/// 공지사항 카드 위젯
/// 고정 여부(isPinned) 아이콘 표시 + 제목/내용 2줄 + 날짜
class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementCard({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final dateStr =
        DateFormat('M월 d일', 'ko_KR').format(announcement.createdAt);

    return ClayCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (announcement.isPinned)
            const Padding(
              padding: EdgeInsets.only(right: 8, top: 2),
              child: Icon(
                Icons.push_pin_rounded,
                size: 16,
                color: AppColors.softCoral,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement.title,
                  style: AppTextStyles.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  announcement.content,
                  style: AppTextStyles.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(dateStr, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
