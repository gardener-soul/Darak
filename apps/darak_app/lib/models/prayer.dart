import 'package:freezed_annotation/freezed_annotation.dart';

import 'prayer_period_type.dart';
import 'prayer_status.dart';
import 'prayer_visibility.dart';

part 'prayer.freezed.dart';
part 'prayer.g.dart';

// ─── JSON Converter: PrayerVisibility ────────────────────────────────────────

class PrayerVisibilityConverter
    implements JsonConverter<PrayerVisibility, String> {
  const PrayerVisibilityConverter();

  @override
  PrayerVisibility fromJson(String json) =>
      PrayerVisibilityX.fromJson(json);

  @override
  String toJson(PrayerVisibility object) => object.toJson();
}

// ─── JSON Converter: PrayerStatus ────────────────────────────────────────────

class PrayerStatusConverter implements JsonConverter<PrayerStatus, String> {
  const PrayerStatusConverter();

  @override
  PrayerStatus fromJson(String json) => PrayerStatusX.fromJson(json);

  @override
  String toJson(PrayerStatus object) => object.toJson();
}

// ─── JSON Converter: PrayerPeriodType ────────────────────────────────────────

class PrayerPeriodTypeConverter
    implements JsonConverter<PrayerPeriodType, String> {
  const PrayerPeriodTypeConverter();

  @override
  PrayerPeriodType fromJson(String json) => PrayerPeriodTypeX.fromJson(json);

  @override
  String toJson(PrayerPeriodType object) => object.toJson();
}

// ─── Prayer 모델 ─────────────────────────────────────────────────────────────

@freezed
class Prayer with _$Prayer {
  const factory Prayer({
    required String id, // 고유 ID (Firestore document ID)
    required String userId, // 작성자 ID
    required String churchId, // 소속 교회 ID
    String? groupId, // 소속 다락방 ID
    required String content, // 기도 제목 본문 (최대 200자)
    @PrayerVisibilityConverter() required PrayerVisibility visibility, // 공개 범위
    @PrayerStatusConverter() required PrayerStatus status, // 상태
    @PrayerPeriodTypeConverter() required PrayerPeriodType periodType, // 기간 유형
    required DateTime startDate, // 기도 시작일
    DateTime? endDate, // 기도 종료일 (indefinite의 경우 null)
    DateTime? answeredAt, // 응답됨 상태로 변경된 일시
    required DateTime createdAt, // 생성일시
    required DateTime updatedAt, // 수정일시
    DateTime? deletedAt, // 삭제일시 (Soft Delete)
  }) = _Prayer;

  factory Prayer.fromJson(Map<String, dynamic> json) => _$PrayerFromJson(json);
}
