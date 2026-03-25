// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encouragement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EncouragementImpl _$$EncouragementImplFromJson(Map<String, dynamic> json) =>
    _$EncouragementImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$$EncouragementImplToJson(_$EncouragementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'text': instance.text,
      'createdAt': instance.createdAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
