// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClubImpl _$$ClubImplFromJson(Map<String, dynamic> json) => _$ClubImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  clubLeaderId: json['clubLeaderId'] as String?,
  clubMemberIds: (json['clubMemberIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  description: json['description'] as String?,
  status: $enumDecode(_$ClubStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$$ClubImplToJson(_$ClubImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'clubLeaderId': instance.clubLeaderId,
      'clubMemberIds': instance.clubMemberIds,
      'description': instance.description,
      'status': _$ClubStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };

const _$ClubStatusEnumMap = {
  ClubStatus.pending: 'pending',
  ClubStatus.approved: 'approved',
  ClubStatus.rejected: 'rejected',
};
