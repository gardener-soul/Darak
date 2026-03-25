// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Feed _$FeedFromJson(Map<String, dynamic> json) {
  return _Feed.fromJson(json);
}

/// @nodoc
mixin _$Feed {
  String get id =>
      throw _privateConstructorUsedError; // 고유 ID (Firestore document ID)
  String get userId => throw _privateConstructorUsedError; // 작성자 ID
  String get churchId => throw _privateConstructorUsedError; // 소속 교회 ID
  String? get groupId => throw _privateConstructorUsedError; // 소속 다락방 ID
  @FeedContentTypeConverter()
  FeedContentType get contentType => throw _privateConstructorUsedError; // 콘텐츠 유형
  String? get text => throw _privateConstructorUsedError; // 본문 텍스트 (최대 500자)
  List<String> get imageUrls =>
      throw _privateConstructorUsedError; // 첨부 사진 URL (v2)
  String? get linkedPrayerId =>
      throw _privateConstructorUsedError; // 연결된 기도제목 ID
  @FeedVisibilityConverter()
  FeedVisibility get visibility => throw _privateConstructorUsedError; // 공개 범위
  // reactions: Map<반응타입, userId 배열> — Firestore에서 직접 Map으로 저장
  Map<String, List<String>> get reactions => throw _privateConstructorUsedError;
  int get encouragementCount =>
      throw _privateConstructorUsedError; // 격려 메시지 수 (비정규화 캐시)
  List<String> get reportedBy =>
      throw _privateConstructorUsedError; // 신고한 사용자 ID 배열
  DateTime get createdAt => throw _privateConstructorUsedError; // 생성일시
  DateTime get updatedAt => throw _privateConstructorUsedError; // 수정일시
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this Feed to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Feed
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedCopyWith<Feed> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedCopyWith<$Res> {
  factory $FeedCopyWith(Feed value, $Res Function(Feed) then) =
      _$FeedCopyWithImpl<$Res, Feed>;
  @useResult
  $Res call({
    String id,
    String userId,
    String churchId,
    String? groupId,
    @FeedContentTypeConverter() FeedContentType contentType,
    String? text,
    List<String> imageUrls,
    String? linkedPrayerId,
    @FeedVisibilityConverter() FeedVisibility visibility,
    Map<String, List<String>> reactions,
    int encouragementCount,
    List<String> reportedBy,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class _$FeedCopyWithImpl<$Res, $Val extends Feed>
    implements $FeedCopyWith<$Res> {
  _$FeedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Feed
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? churchId = null,
    Object? groupId = freezed,
    Object? contentType = null,
    Object? text = freezed,
    Object? imageUrls = null,
    Object? linkedPrayerId = freezed,
    Object? visibility = null,
    Object? reactions = null,
    Object? encouragementCount = null,
    Object? reportedBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            churchId: null == churchId
                ? _value.churchId
                : churchId // ignore: cast_nullable_to_non_nullable
                      as String,
            groupId: freezed == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as String?,
            contentType: null == contentType
                ? _value.contentType
                : contentType // ignore: cast_nullable_to_non_nullable
                      as FeedContentType,
            text: freezed == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrls: null == imageUrls
                ? _value.imageUrls
                : imageUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            linkedPrayerId: freezed == linkedPrayerId
                ? _value.linkedPrayerId
                : linkedPrayerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            visibility: null == visibility
                ? _value.visibility
                : visibility // ignore: cast_nullable_to_non_nullable
                      as FeedVisibility,
            reactions: null == reactions
                ? _value.reactions
                : reactions // ignore: cast_nullable_to_non_nullable
                      as Map<String, List<String>>,
            encouragementCount: null == encouragementCount
                ? _value.encouragementCount
                : encouragementCount // ignore: cast_nullable_to_non_nullable
                      as int,
            reportedBy: null == reportedBy
                ? _value.reportedBy
                : reportedBy // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            deletedAt: freezed == deletedAt
                ? _value.deletedAt
                : deletedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeedImplCopyWith<$Res> implements $FeedCopyWith<$Res> {
  factory _$$FeedImplCopyWith(
    _$FeedImpl value,
    $Res Function(_$FeedImpl) then,
  ) = __$$FeedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String churchId,
    String? groupId,
    @FeedContentTypeConverter() FeedContentType contentType,
    String? text,
    List<String> imageUrls,
    String? linkedPrayerId,
    @FeedVisibilityConverter() FeedVisibility visibility,
    Map<String, List<String>> reactions,
    int encouragementCount,
    List<String> reportedBy,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class __$$FeedImplCopyWithImpl<$Res>
    extends _$FeedCopyWithImpl<$Res, _$FeedImpl>
    implements _$$FeedImplCopyWith<$Res> {
  __$$FeedImplCopyWithImpl(_$FeedImpl _value, $Res Function(_$FeedImpl) _then)
    : super(_value, _then);

  /// Create a copy of Feed
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? churchId = null,
    Object? groupId = freezed,
    Object? contentType = null,
    Object? text = freezed,
    Object? imageUrls = null,
    Object? linkedPrayerId = freezed,
    Object? visibility = null,
    Object? reactions = null,
    Object? encouragementCount = null,
    Object? reportedBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _$FeedImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        churchId: null == churchId
            ? _value.churchId
            : churchId // ignore: cast_nullable_to_non_nullable
                  as String,
        groupId: freezed == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String?,
        contentType: null == contentType
            ? _value.contentType
            : contentType // ignore: cast_nullable_to_non_nullable
                  as FeedContentType,
        text: freezed == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrls: null == imageUrls
            ? _value._imageUrls
            : imageUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        linkedPrayerId: freezed == linkedPrayerId
            ? _value.linkedPrayerId
            : linkedPrayerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        visibility: null == visibility
            ? _value.visibility
            : visibility // ignore: cast_nullable_to_non_nullable
                  as FeedVisibility,
        reactions: null == reactions
            ? _value._reactions
            : reactions // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<String>>,
        encouragementCount: null == encouragementCount
            ? _value.encouragementCount
            : encouragementCount // ignore: cast_nullable_to_non_nullable
                  as int,
        reportedBy: null == reportedBy
            ? _value._reportedBy
            : reportedBy // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        deletedAt: freezed == deletedAt
            ? _value.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedImpl implements _Feed {
  const _$FeedImpl({
    required this.id,
    required this.userId,
    required this.churchId,
    this.groupId,
    @FeedContentTypeConverter() required this.contentType,
    this.text,
    final List<String> imageUrls = const [],
    this.linkedPrayerId,
    @FeedVisibilityConverter() required this.visibility,
    final Map<String, List<String>> reactions = const {},
    this.encouragementCount = 0,
    final List<String> reportedBy = const [],
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  }) : _imageUrls = imageUrls,
       _reactions = reactions,
       _reportedBy = reportedBy;

  factory _$FeedImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedImplFromJson(json);

  @override
  final String id;
  // 고유 ID (Firestore document ID)
  @override
  final String userId;
  // 작성자 ID
  @override
  final String churchId;
  // 소속 교회 ID
  @override
  final String? groupId;
  // 소속 다락방 ID
  @override
  @FeedContentTypeConverter()
  final FeedContentType contentType;
  // 콘텐츠 유형
  @override
  final String? text;
  // 본문 텍스트 (최대 500자)
  final List<String> _imageUrls;
  // 본문 텍스트 (최대 500자)
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  // 첨부 사진 URL (v2)
  @override
  final String? linkedPrayerId;
  // 연결된 기도제목 ID
  @override
  @FeedVisibilityConverter()
  final FeedVisibility visibility;
  // 공개 범위
  // reactions: Map<반응타입, userId 배열> — Firestore에서 직접 Map으로 저장
  final Map<String, List<String>> _reactions;
  // 공개 범위
  // reactions: Map<반응타입, userId 배열> — Firestore에서 직접 Map으로 저장
  @override
  @JsonKey()
  Map<String, List<String>> get reactions {
    if (_reactions is EqualUnmodifiableMapView) return _reactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_reactions);
  }

  @override
  @JsonKey()
  final int encouragementCount;
  // 격려 메시지 수 (비정규화 캐시)
  final List<String> _reportedBy;
  // 격려 메시지 수 (비정규화 캐시)
  @override
  @JsonKey()
  List<String> get reportedBy {
    if (_reportedBy is EqualUnmodifiableListView) return _reportedBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reportedBy);
  }

  // 신고한 사용자 ID 배열
  @override
  final DateTime createdAt;
  // 생성일시
  @override
  final DateTime updatedAt;
  // 수정일시
  @override
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'Feed(id: $id, userId: $userId, churchId: $churchId, groupId: $groupId, contentType: $contentType, text: $text, imageUrls: $imageUrls, linkedPrayerId: $linkedPrayerId, visibility: $visibility, reactions: $reactions, encouragementCount: $encouragementCount, reportedBy: $reportedBy, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(
              other._imageUrls,
              _imageUrls,
            ) &&
            (identical(other.linkedPrayerId, linkedPrayerId) ||
                other.linkedPrayerId == linkedPrayerId) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            const DeepCollectionEquality().equals(
              other._reactions,
              _reactions,
            ) &&
            (identical(other.encouragementCount, encouragementCount) ||
                other.encouragementCount == encouragementCount) &&
            const DeepCollectionEquality().equals(
              other._reportedBy,
              _reportedBy,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    churchId,
    groupId,
    contentType,
    text,
    const DeepCollectionEquality().hash(_imageUrls),
    linkedPrayerId,
    visibility,
    const DeepCollectionEquality().hash(_reactions),
    encouragementCount,
    const DeepCollectionEquality().hash(_reportedBy),
    createdAt,
    updatedAt,
    deletedAt,
  );

  /// Create a copy of Feed
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedImplCopyWith<_$FeedImpl> get copyWith =>
      __$$FeedImplCopyWithImpl<_$FeedImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedImplToJson(this);
  }
}

abstract class _Feed implements Feed {
  const factory _Feed({
    required final String id,
    required final String userId,
    required final String churchId,
    final String? groupId,
    @FeedContentTypeConverter() required final FeedContentType contentType,
    final String? text,
    final List<String> imageUrls,
    final String? linkedPrayerId,
    @FeedVisibilityConverter() required final FeedVisibility visibility,
    final Map<String, List<String>> reactions,
    final int encouragementCount,
    final List<String> reportedBy,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? deletedAt,
  }) = _$FeedImpl;

  factory _Feed.fromJson(Map<String, dynamic> json) = _$FeedImpl.fromJson;

  @override
  String get id; // 고유 ID (Firestore document ID)
  @override
  String get userId; // 작성자 ID
  @override
  String get churchId; // 소속 교회 ID
  @override
  String? get groupId; // 소속 다락방 ID
  @override
  @FeedContentTypeConverter()
  FeedContentType get contentType; // 콘텐츠 유형
  @override
  String? get text; // 본문 텍스트 (최대 500자)
  @override
  List<String> get imageUrls; // 첨부 사진 URL (v2)
  @override
  String? get linkedPrayerId; // 연결된 기도제목 ID
  @override
  @FeedVisibilityConverter()
  FeedVisibility get visibility; // 공개 범위
  // reactions: Map<반응타입, userId 배열> — Firestore에서 직접 Map으로 저장
  @override
  Map<String, List<String>> get reactions;
  @override
  int get encouragementCount; // 격려 메시지 수 (비정규화 캐시)
  @override
  List<String> get reportedBy; // 신고한 사용자 ID 배열
  @override
  DateTime get createdAt; // 생성일시
  @override
  DateTime get updatedAt; // 수정일시
  @override
  DateTime? get deletedAt;

  /// Create a copy of Feed
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedImplCopyWith<_$FeedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
