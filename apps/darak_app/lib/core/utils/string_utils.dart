/// 문자열 관련 유틸리티 함수 모음
/// XSS 방어, 전화번호 검증 등 공통 로직을 제공합니다.
class StringUtils {
  StringUtils._(); // 인스턴스화 방지

  /// HTML 태그 제거 및 길이 제한으로 XSS/악의적 입력 방어
  /// [input]: 정제할 문자열
  /// [maxLength]: 최대 길이 (기본값: 100)
  /// 반환: 정제된 문자열
  static String sanitize(String input, {int maxLength = 100}) {
    // HTML 태그 제거
    final stripped = input.replaceAll(RegExp(r'<[^>]*>'), '');
    // 앞뒤 공백 제거
    final trimmed = stripped.trim();
    // 길이 제한
    if (trimmed.length > maxLength) {
      return trimmed.substring(0, maxLength);
    }
    return trimmed;
  }

  /// 한국 전화번호 형식 검증
  /// 지원 형식:
  /// - 010-XXXX-XXXX
  /// - 010XXXXXXXX
  /// - 01012345678
  /// 반환: 유효한 형식이면 true
  static bool isValidKoreanPhone(String phone) {
    if (phone.trim().isEmpty) return false;

    // 하이픈 제거
    final cleaned = phone.replaceAll('-', '').replaceAll(' ', '');

    // 010, 011, 016, 017, 018, 019로 시작하는 11자리 숫자
    final pattern = RegExp(r'^01[0-9]\d{7,8}$');

    return pattern.hasMatch(cleaned);
  }

  /// 전화번호를 표준 포맷(010-XXXX-XXXX)으로 변환
  /// [phone]: 원본 전화번호 (하이픈 유무 무관)
  /// 반환: 포맷팅된 전화번호 (유효하지 않으면 원본 반환)
  static String formatPhoneNumber(String phone) {
    if (phone.trim().isEmpty) return phone;

    // 하이픈 제거
    final cleaned = phone.replaceAll('-', '').replaceAll(' ', '');

    // 11자리 숫자인 경우만 포맷팅
    if (cleaned.length == 11 && RegExp(r'^\d+$').hasMatch(cleaned)) {
      return '${cleaned.substring(0, 3)}-${cleaned.substring(3, 7)}-${cleaned.substring(7)}';
    }

    // 10자리 숫자인 경우 (구형 번호)
    if (cleaned.length == 10 && RegExp(r'^\d+$').hasMatch(cleaned)) {
      return '${cleaned.substring(0, 3)}-${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    }

    // 포맷팅 불가능하면 원본 반환
    return phone;
  }

  /// 생년월일 유효성 검증
  /// [birthDate]: 검증할 생년월일
  /// 반환: 유효하면 true (미래 날짜나 120년 이상 과거는 false)
  static bool isValidBirthDate(DateTime? birthDate) {
    if (birthDate == null) return true; // null은 선택 항목이므로 유효

    final now = DateTime.now();

    // 미래 날짜 방어
    if (birthDate.isAfter(now)) {
      return false;
    }

    // 120년 이상 과거 방어 (비현실적인 나이)
    final minDate = now.subtract(const Duration(days: 365 * 120));
    if (birthDate.isBefore(minDate)) {
      return false;
    }

    return true;
  }
}
