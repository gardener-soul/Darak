import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/church_status.dart';
import '../../repositories/church_repository.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/bouncy_button.dart';
import '../../widgets/common/clay_card.dart';
import 'church_detail_screen.dart';

/// 교회 등록 신청 후 관리자 승인을 기다리는 대기 화면.
/// [churchId] 교회 문서를 실시간으로 구독하여 status가 approved로 변경되면
/// 자동으로 교회 메인 화면으로 이동합니다.
class ChurchPendingScreen extends ConsumerStatefulWidget {
  final String churchId;

  const ChurchPendingScreen({super.key, required this.churchId});

  @override
  ConsumerState<ChurchPendingScreen> createState() =>
      _ChurchPendingScreenState();
}

class _ChurchPendingScreenState extends ConsumerState<ChurchPendingScreen> {
  @override
  Widget build(BuildContext context) {
    // 교회 문서 실시간 구독 — status가 approved로 바뀌면 자동 이동
    ref.listen(
      _churchStatusStreamProvider(widget.churchId),
      (_, next) {
        final church = next.valueOrNull;
        if (church == null || !mounted) return;

        if (church.status == ChurchStatus.approved) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => ChurchDetailScreen(churchId: widget.churchId),
            ),
          );
        } else if (church.status == ChurchStatus.rejected) {
          // 거절 시 안내 다이얼로그 표시 후 홈으로 이동
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: const Text('등록 신청 거절'),
              content: Text(
                church.rejectionReason?.isNotEmpty == true
                    ? church.rejectionReason!
                    : '관리자에 의해 등록 신청이 거절되었습니다.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('확인'),
                ),
              ],
            ),
          );
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('⏳', style: TextStyle(fontSize: 80)),
                const SizedBox(height: 24),
                Text(
                  '등록 신청이 완료됐어요!',
                  style: AppTextStyles.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  '관리자 검토 후 승인됩니다.\n승인되면 자동으로 교회 화면으로 이동해요.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ClayCard(
                  color: AppColors.skyBlue.withValues(alpha: 0.2),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.skyBlue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '승인 대기 중...',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.skyBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                BouncyButton(
                  text: '홈으로 돌아가기',
                  icon: const Icon(Icons.home_rounded),
                  color: AppColors.softCoral,
                  onPressed: () {
                    // HomeScreen까지 스택을 모두 제거하고 이동
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

/// 교회 문서 실시간 스트림 Provider (PendingScreen 전용)
final _churchStatusStreamProvider =
    StreamProvider.autoDispose.family((ref, String churchId) {
  return ref.watch(churchRepositoryProvider).watchChurch(churchId);
});
