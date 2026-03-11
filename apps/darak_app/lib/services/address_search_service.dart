import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';

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
/// ※ Web 플랫폼 미지원 (MVP 범위). Phase 2에서 교체 예정.
class AddressSearchService {
  /// 카카오 주소 검색 화면을 열고 선택된 주소 결과를 반환합니다.
  Future<AddressResult?> searchAddress(BuildContext context) async {
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
      // 주소 검색 실패 시 null 반환 (View에서 에러 처리)
      return null;
    }
  }
}
