// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'village.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VillageImpl _$$VillageImplFromJson(Map<String, dynamic> json) =>
    _$VillageImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      leaderId: json['leaderId'] as String?,
      darakLeaderIds: (json['darakLeaderIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      memberIds: (json['memberIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
      churchId: json['churchId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$$VillageImplToJson(_$VillageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'leaderId': instance.leaderId,
      'darakLeaderIds': instance.darakLeaderIds,
      'memberIds': instance.memberIds,
      'description': instance.description,
      'churchId': instance.churchId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
