// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meetup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MeetUpImpl _$$MeetUpImplFromJson(Map<String, dynamic> json) => _$MeetUpImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  churchId: json['churchId'] as String,
  meetLeaderId: json['meetLeaderId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  participantIds:
      (json['participantIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  description: json['description'] as String?,
  scheduledAt: json['scheduledAt'] == null
      ? null
      : DateTime.parse(json['scheduledAt'] as String),
  maxParticipants: (json['maxParticipants'] as num?)?.toInt(),
  reportedBy:
      (json['reportedBy'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  notificationSent: json['notificationSent'] as bool? ?? false,
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$$MeetUpImplToJson(_$MeetUpImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'churchId': instance.churchId,
      'meetLeaderId': instance.meetLeaderId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'participantIds': instance.participantIds,
      'description': instance.description,
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'maxParticipants': instance.maxParticipants,
      'reportedBy': instance.reportedBy,
      'notificationSent': instance.notificationSent,
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
