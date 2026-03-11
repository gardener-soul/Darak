// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  email: json['email'] as String?,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  birthDate: json['birthDate'] == null
      ? null
      : DateTime.parse(json['birthDate'] as String),
  registerDate: json['registerDate'] == null
      ? null
      : DateTime.parse(json['registerDate'] as String),
  groupId: json['groupId'] as String?,
  groupName: json['groupName'] as String?,
  groupImageUrl: json['groupImageUrl'] as String?,
  clubIds: (json['clubIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  profileImageUrl: json['profileImageUrl'] as String?,
  bio: json['bio'] as String?,
  prayerRequests: (json['prayerRequests'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  attendanceStats: json['attendanceStats'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'role': _$UserRoleEnumMap[instance.role]!,
      'birthDate': instance.birthDate?.toIso8601String(),
      'registerDate': instance.registerDate?.toIso8601String(),
      'groupId': instance.groupId,
      'groupName': instance.groupName,
      'groupImageUrl': instance.groupImageUrl,
      'clubIds': instance.clubIds,
      'profileImageUrl': instance.profileImageUrl,
      'bio': instance.bio,
      'prayerRequests': instance.prayerRequests,
      'attendanceStats': instance.attendanceStats,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.member: 'member',
  UserRole.darakLeader: 'darak_leader',
  UserRole.villageLeader: 'village_leader',
  UserRole.evangelist: 'evangelist',
  UserRole.preacher: 'preacher',
  UserRole.pastor: 'pastor',
  UserRole.admin: 'admin',
};
