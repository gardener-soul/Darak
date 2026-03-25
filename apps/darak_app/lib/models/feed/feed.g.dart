// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeedImpl _$$FeedImplFromJson(Map<String, dynamic> json) => _$FeedImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  churchId: json['churchId'] as String,
  groupId: json['groupId'] as String?,
  contentType: const FeedContentTypeConverter().fromJson(
    json['contentType'] as String,
  ),
  text: json['text'] as String?,
  imageUrls:
      (json['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  linkedPrayerId: json['linkedPrayerId'] as String?,
  visibility: const FeedVisibilityConverter().fromJson(
    json['visibility'] as String,
  ),
  reactions:
      (json['reactions'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ) ??
      const {},
  encouragementCount: (json['encouragementCount'] as num?)?.toInt() ?? 0,
  reportedBy:
      (json['reportedBy'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$$FeedImplToJson(
  _$FeedImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'churchId': instance.churchId,
  'groupId': instance.groupId,
  'contentType': const FeedContentTypeConverter().toJson(instance.contentType),
  'text': instance.text,
  'imageUrls': instance.imageUrls,
  'linkedPrayerId': instance.linkedPrayerId,
  'visibility': const FeedVisibilityConverter().toJson(instance.visibility),
  'reactions': instance.reactions,
  'encouragementCount': instance.encouragementCount,
  'reportedBy': instance.reportedBy,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
};
