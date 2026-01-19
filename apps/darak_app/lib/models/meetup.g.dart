// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meetup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MeetUpImpl _$$MeetUpImplFromJson(Map<String, dynamic> json) => _$MeetUpImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  participantCount: (json['participantCount'] as num).toInt(),
  meetLeaderId: json['meetLeaderId'] as String,
  participantIds: (json['participantIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  description: json['description'] as String?,
  scheduledAt: json['scheduledAt'] == null
      ? null
      : DateTime.parse(json['scheduledAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$$MeetUpImplToJson(_$MeetUpImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'participantCount': instance.participantCount,
      'meetLeaderId': instance.meetLeaderId,
      'participantIds': instance.participantIds,
      'description': instance.description,
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
