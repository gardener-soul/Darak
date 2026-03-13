/// 사용자 입력값 Sanitize 공통 유틸 (XSS 방어)
///
/// [ChurchRepository], [UserRepository] 등 모든 Repository에서
/// 중복 없이 동일한 로직을 사용하기 위해 공통 모듈로 추출합니다.
library;

/// 사용자 입력값에서 HTML 태그를 제거하고 길이를 제한합니다 (XSS 방어).
///
/// - HTML 태그(`<...>`) 제거
/// - 앞뒤 공백 제거
/// - [maxLength] 초과 시 잘라냄 (기본값 500자)
String sanitizeInput(String input, {int maxLength = 500}) {
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
