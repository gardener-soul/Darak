
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';
import '../theme/app_theme.dart';

/// 카카오 우편번호 서비스 검색 결과 모델.
/// kpostal 패키지 의존성을 서비스 레이어 안으로 격리합니다.
class AddressResult {
  final String roadAddress;
  final String jibunAddress;
  final String postCode;

  const AddressResult({
    required this.roadAddress,
    required this.jibunAddress,
    required this.postCode,
  });
}

/// 카카오 주소검색 서비스.
/// [searchAddress]를 호출하면 WebView 기반 주소검색 화면이 열리고,
/// 사용자가 주소를 선택하면 [AddressResult]를 반환합니다.
/// 사용자가 취소하거나 오류 발생 시 null을 반환합니다.
///
/// ※ Web 플랫폼에서는 AlertDialog 기반 수동 입력 폴백을 사용합니다.
class AddressSearchService {
  /// 카카오 주소 검색 화면을 열고 선택된 주소 결과를 반환합니다.
  /// Web 환경에서는 직접 입력 다이얼로그로 대체됩니다.
  Future<AddressResult?> searchAddress(BuildContext context) async {
    // Web 플랫폼 분기: kpostal WebView가 Web에서 미지원이므로 수동 입력 폴백 사용
    if (kIsWeb) return _searchAddressOnWeb(context);

    try {
      final result = await Navigator.push<Kpostal>(
        context,
        MaterialPageRoute(
          builder: (_) => KpostalView(
            useLocalServer: false,
            title: '주소 검색',
          ),
        ),
      );

      if (result == null) return null;

      return AddressResult(
        roadAddress: result.roadAddress,
        jibunAddress: result.jibunAddress,
        postCode: result.postCode,
      );
    } catch (e) {
      // 주소 검색 중 예외 발생 — 원인 추적을 위해 로깅 후 null 반환
      debugPrint('[AddressSearchService] 주소 검색 오류: $e');
      return null;
    }
  }

  /// Web 환경 전용 주소 수동 입력 폴백.
  /// AlertDialog를 통해 사용자가 직접 주소를 타이핑합니다.
  /// controller.dispose()는 finally로 보호하여 다이얼로그 중 위젯 소멸 시에도 안전하게 해제됩니다.
  Future<AddressResult?> _searchAddressOnWeb(BuildContext context) async {
    final controller = TextEditingController();

    String? address;
    try {
      address = await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            backgroundColor: AppColors.pureWhite,
            shape: RoundedRectangleBorder(
              borderRadius: AppDecorations.cardRadius,
            ),
            title: Text(
              '주소 입력',
              style: AppTextStyles.bodyLarge,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 안내 문구
                Text(
                  '카카오 주소 검색은 모바일 앱에서 이용 가능합니다.\n아래에 주소를 직접 입력해주세요.',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 16),
                // 주소 입력 필드
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.creamWhite,
                    borderRadius: AppDecorations.defaultRadius,
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: TextField(
                    controller: controller,
                    style: AppTextStyles.bodyMedium,
                    decoration: InputDecoration(
                      hintText: '예) 서울특별시 강남구 테헤란로 123',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textGrey,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              // 취소 버튼
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(null),
                child: Text(
                  '취소',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              // 확인 버튼
              TextButton(
                onPressed: () {
                  final text = controller.text.trim();
                  Navigator.of(dialogContext).pop(text.isEmpty ? null : text);
                },
                child: Text(
                  '확인',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.softCoral,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } finally {
      // 위젯 소멸 여부와 무관하게 컨트롤러를 안전하게 해제
      controller.dispose();
    }

    if (address == null || address.isEmpty) return null;

    // Web 입력 주소는 도로명/지번 구분 없이 동일하게 처리
    return AddressResult(
      roadAddress: address,
      jibunAddress: address,
      postCode: '',
    );
  }
}
