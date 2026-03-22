// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemberNoteImpl _$$MemberNoteImplFromJson(Map<String, dynamic> json) =>
    _$MemberNoteImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$$MemberNoteImplToJson(_$MemberNoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'content': instance.content,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
