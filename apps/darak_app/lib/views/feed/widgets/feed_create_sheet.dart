import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/user_providers.dart';
import '../../../models/feed/feed_content_type.dart';
import '../../../models/feed/feed_visibility.dart';
import '../../../models/prayer.dart';
import '../../../viewmodels/prayer/prayer_list_viewmodel.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/feed/feed_create_viewmodel.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/core/app_bottom_sheet.dart';
import '../../../widgets/common/core/soft_chip.dart';
import '../../../widgets/common/soft_text_field.dart';

/// 게시물 작성 바텀시트
class FeedCreateSheet extends ConsumerStatefulWidget {
  const FeedCreateSheet({super.key});

  @override
  ConsumerState<FeedCreateSheet> createState() => _FeedCreateSheetState();
}

class _FeedCreateSheetState extends ConsumerState<FeedCreateSheet> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(feedCreateViewModelProvider);
    final userAsync = ref.watch(currentUserProvider);

    return AppBottomSheet(
      child: userAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            const Center(child: Text('사용자 정보를 불러오지 못했어요.')),
        data: (user) {
          if (user == null) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 콘텐츠 유형 선택
              Text(
                '나눔 유형',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              _ContentTypeSelector(
                selected: vm.contentType,
                onSelect: (type) => ref
                    .read(feedCreateViewModelProvider.notifier)
                    .updateContentType(type),
              ),
              const SizedBox(height: 16),

              // 텍스트 입력
              SoftTextField(
                controller: _textController,
                hintText: '오늘 하루 어떠셨나요? 나눔을 시작해보세요 (최대 500자)',
                maxLines: 5,
                onChanged: (v) => ref
                    .read(feedCreateViewModelProvider.notifier)
                    .updateText(v),
              ),
              const SizedBox(height: 16),

              // 기도제목 연결
              if (vm.contentType == FeedContentType.prayerShare)
                _PrayerLinkSelector(
                  userId: user.id,
                  linkedPrayerId: vm.linkedPrayerId,
                  onLink: (id) => ref
                      .read(feedCreateViewModelProvider.notifier)
                      .linkPrayer(id),
                  onUnlink: () => ref
                      .read(feedCreateViewModelProvider.notifier)
                      .unlinkPrayer(),
                ),

              // 공개 범위
              Text(
                '공개 범위',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              _VisibilitySelector(
                selected: vm.visibility,
                hasGroup: user.groupId != null,
                onSelect: (v) => ref
                    .read(feedCreateViewModelProvider.notifier)
                    .updateVisibility(v),
              ),
              const SizedBox(height: 8),

              // 오류 메시지
              if (vm.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    vm.errorMessage!,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: Colors.red.shade400),
                  ),
                ),

              // 제출 버튼
              BouncyButton(
                onPressed: vm.isLoading
                    ? null
                    : () async {
                        final success = await ref
                            .read(feedCreateViewModelProvider.notifier)
                            .submit(
                              userId: user.id,
                              churchId: user.churchId ?? '',
                              groupId: user.groupId,
                            );
                        if (success && context.mounted) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('나눔이 게시되었어요 🌱'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                text: vm.isLoading ? '게시 중...' : '나눔',
                color: AppColors.softCoral,
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── 콘텐츠 유형 선택 ─────────────────────────────────────────────────────────

class _ContentTypeSelector extends StatelessWidget {
  final FeedContentType selected;
  final void Function(FeedContentType) onSelect;

  const _ContentTypeSelector({
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: FeedContentType.values.map((type) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SoftChip(
            label: type.label,
            isSelected: selected == type,
            color: AppColors.softCoral,
            onTap: () => onSelect(type),
          ),
        );
      }).toList(),
    );
  }
}

// ─── 공개 범위 선택 ────────────────────────────────────────────────────────────

class _VisibilitySelector extends StatelessWidget {
  final FeedVisibility selected;
  final bool hasGroup;
  final void Function(FeedVisibility) onSelect;

  const _VisibilitySelector({
    required this.selected,
    required this.hasGroup,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: FeedVisibility.values.map((v) {
        final isDisabled = v == FeedVisibility.group && !hasGroup;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Opacity(
            opacity: isDisabled ? 0.4 : 1.0,
            child: SoftChip(
              label: v.label,
              isSelected: selected == v,
              color: AppColors.sageGreen,
              onTap: isDisabled ? null : () => onSelect(v),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── 기도제목 연결 선택기 ──────────────────────────────────────────────────────

class _PrayerLinkSelector extends ConsumerWidget {
  final String userId;
  final String? linkedPrayerId;
  final void Function(String) onLink;
  final VoidCallback onUnlink;

  const _PrayerLinkSelector({
    required this.userId,
    required this.linkedPrayerId,
    required this.onLink,
    required this.onUnlink,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayersAsync = ref.watch(myPrayerListProvider(userId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '기도제목 연결',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        prayersAsync.when(
          loading: () => const SizedBox(height: 32),
          error: (_, _) => const SizedBox.shrink(),
          data: (prayers) {
            if (prayers.isEmpty) {
              return Text(
                '연결할 기도제목이 없어요.',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textGrey),
              );
            }
            return Column(
              children: [
                if (linkedPrayerId != null)
                  _LinkedPrayerChip(
                    prayer: prayers.firstWhere(
                      (p) => p.id == linkedPrayerId,
                      orElse: () => prayers.first,
                    ),
                    onUnlink: onUnlink,
                  )
                else
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: prayers.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (_, i) => SoftChip(
                        label: prayers[i].content.length > 20
                            ? '${prayers[i].content.substring(0, 20)}...'
                            : prayers[i].content,
                        isSelected: false,
                        color: AppColors.softLavender,
                        onTap: () => onLink(prayers[i].id),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _LinkedPrayerChip extends StatelessWidget {
  final Prayer prayer;
  final VoidCallback onUnlink;

  const _LinkedPrayerChip({required this.prayer, required this.onUnlink});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.softLavender.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.softLavender.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🙏', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              prayer.content,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textDark),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onUnlink,
            child: Icon(Icons.close_rounded,
                size: 16, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}
