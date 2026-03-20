// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChurchRoleImpl _$$ChurchRoleImplFromJson(Map<String, dynamic> json) =>
    _$ChurchRoleImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      level: (json['level'] as num).toInt(),
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isDefault: json['isDefault'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ChurchRoleImplToJson(_$ChurchRoleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'level': instance.level,
      'permissions': instance.permissions,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
