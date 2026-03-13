// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChurchMemberImpl _$$ChurchMemberImplFromJson(Map<String, dynamic> json) =>
    _$ChurchMemberImpl(
      userId: json['userId'] as String,
      roleId: json['roleId'] as String,
      villageId: json['villageId'] as String?,
      groupId: json['groupId'] as String?,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ChurchMemberImplToJson(_$ChurchMemberImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'roleId': instance.roleId,
      'villageId': instance.villageId,
      'groupId': instance.groupId,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
