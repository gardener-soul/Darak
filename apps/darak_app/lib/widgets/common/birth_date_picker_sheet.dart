import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'bouncy_button.dart';
import 'core/app_bottom_sheet.dart';

/// 한국 친화적 생년월일 선택 바텀시트
///
/// Material 달력 대신 연/월/일 드럼(스피너) 방식의 CupertinoDatePicker를 사용합니다.
/// 한국어 로케일을 강제하여 드럼이 '년/월/일' 순서로 표시됩니다.
///
/// 사용법:
/// ```dart
/// BirthDatePickerSheet.show(
///   context,
///   initialDate: _selectedBirthDate,
///   onDateSelected: (date) => setState(() => _selectedBirthDate = date),
/// );
/// ```
class BirthDatePickerSheet extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const BirthDatePickerSheet({
    super.key,
    this.initialDate,
    required this.onDateSelected,
  });

  /// 생년월일 선택 바텀시트를 표시합니다.
  static Future<void> show(
    BuildContext context, {
    DateTime? initialDate,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    return AppBottomSheet.show(
      context: context,
      child: BirthDatePickerSheet(
        initialDate: initialDate,
        onDateSelected: onDateSelected,
      ),
    );
  }

  @override
  State<BirthDatePickerSheet> createState() => _BirthDatePickerSheetState();
}

class _BirthDatePickerSheetState extends State<BirthDatePickerSheet> {
  late DateTime _tempDate;

  @override
  void initState() {
    super.initState();
    // 현재 선택된 날짜가 없으면 2000년 1월 1일로 초기화
    _tempDate = widget.initialDate ?? DateTime(2000, 1, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ─── 제목 ───────────────────────────────────────────
        Text(
          '생년월일 선택',
          style: AppTextStyles.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '연도, 월, 일을 선택해주세요',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // ─── 드럼 picker ─────────────────────────────────────
        // Localizations.override: 한국어 로케일 강제 → 드럼이 년/월/일 순으로 표시됨
        SizedBox(
          height: 200,
          child: Localizations.override(
            context: context,
            locale: const Locale('ko', 'KR'),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: _tempDate,
              minimumDate: DateTime(1900),
              maximumDate: DateTime.now(),
              backgroundColor: AppColors.creamWhite,
              onDateTimeChanged: (date) {
                _tempDate = date;
              },
            ),
          ),
        ),
        const SizedBox(height: 24),

        // ─── 확인 버튼 ───────────────────────────────────────
        BouncyButton(
          text: '확인',
          icon: const Icon(Icons.check_rounded),
          onPressed: () {
            widget.onDateSelected(_tempDate);
            Navigator.of(context).pop();
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
