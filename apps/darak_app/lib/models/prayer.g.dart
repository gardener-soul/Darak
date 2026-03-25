// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrayerImpl _$$PrayerImplFromJson(Map<String, dynamic> json) => _$PrayerImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  churchId: json['churchId'] as String,
  groupId: json['groupId'] as String?,
  content: json['content'] as String,
  visibility: const PrayerVisibilityConverter().fromJson(
    json['visibility'] as String,
  ),
  status: const PrayerStatusConverter().fromJson(json['status'] as String),
  periodType: const PrayerPeriodTypeConverter().fromJson(
    json['periodType'] as String,
  ),
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  answeredAt: json['answeredAt'] == null
      ? null
      : DateTime.parse(json['answeredAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$$PrayerImplToJson(
  _$PrayerImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'churchId': instance.churchId,
  'groupId': instance.groupId,
  'content': instance.content,
  'visibility': const PrayerVisibilityConverter().toJson(instance.visibility),
  'status': const PrayerStatusConverter().toJson(instance.status),
  'periodType': const PrayerPeriodTypeConverter().toJson(instance.periodType),
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'answeredAt': instance.answeredAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
};
