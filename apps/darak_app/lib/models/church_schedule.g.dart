// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChurchScheduleImpl _$$ChurchScheduleImplFromJson(Map<String, dynamic> json) =>
    _$ChurchScheduleImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      category: $enumDecode(_$ScheduleCategoryEnumMap, json['category']),
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: json['endAt'] == null
          ? null
          : DateTime.parse(json['endAt'] as String),
      location: json['location'] as String?,
      isRecurring: json['isRecurring'] as bool,
      recurringRule: json['recurringRule'] as String?,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$$ChurchScheduleImplToJson(
  _$ChurchScheduleImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'category': _$ScheduleCategoryEnumMap[instance.category]!,
  'startAt': instance.startAt.toIso8601String(),
  'endAt': instance.endAt?.toIso8601String(),
  'location': instance.location,
  'isRecurring': instance.isRecurring,
  'recurringRule': instance.recurringRule,
  'createdBy': instance.createdBy,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
};

const _$ScheduleCategoryEnumMap = {
  ScheduleCategory.worship: 'worship',
  ScheduleCategory.event: 'event',
  ScheduleCategory.meeting: 'meeting',
};
