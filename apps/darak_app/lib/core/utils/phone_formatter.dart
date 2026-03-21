import 'package:flutter/services.dart';

/// 한국 전화번호 자동 포맷팅 (010-0000-0000)
/// 사용자가 하이픈 없이 입력해도 자동으로 하이픈을 삽입합니다.
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 숫자만 남기기 (하이픈 및 모든 비숫자 제거)
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    // 길이에 따른 포맷팅
    String formatted;
    int cursorOffset;

    if (digitsOnly.length <= 3) {
      // 010
      formatted = digitsOnly;
      cursorOffset = formatted.length;
    } else if (digitsOnly.length <= 7) {
      // 010-1234
      formatted =
          '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3)}';
      cursorOffset = formatted.length;
    } else if (digitsOnly.length <= 11) {
      // 010-1234-5678
      formatted =
          '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3, 7)}-${digitsOnly.substring(7)}';
      cursorOffset = formatted.length;
    } else {
      // 11자 초과 방지
      formatted =
          '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3, 7)}-${digitsOnly.substring(7, 11)}';
      cursorOffset = formatted.length;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }
}
