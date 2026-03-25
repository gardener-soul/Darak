// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FollowImpl _$$FollowImplFromJson(Map<String, dynamic> json) => _$FollowImpl(
  id: json['id'] as String,
  followerId: json['followerId'] as String,
  followeeId: json['followeeId'] as String,
  churchId: json['churchId'] as String,
  status: const FollowStatusConverter().fromJson(json['status'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  acceptedAt: json['acceptedAt'] == null
      ? null
      : DateTime.parse(json['acceptedAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$FollowImplToJson(_$FollowImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'followerId': instance.followerId,
      'followeeId': instance.followeeId,
      'churchId': instance.churchId,
      'status': const FollowStatusConverter().toJson(instance.status),
      'createdAt': instance.createdAt.toIso8601String(),
      'acceptedAt': instance.acceptedAt?.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
