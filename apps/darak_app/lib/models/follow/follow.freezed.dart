// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follow.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Follow _$FollowFromJson(Map<String, dynamic> json) {
  return _Follow.fromJson(json);
}

/// @nodoc
mixin _$Follow {
  String get id =>
      throw _privateConstructorUsedError; // 고유 ID: {followerId}_{followeeId}
  String get followerId => throw _privateConstructorUsedError; // 팔로우를 보낸 사용자 ID
  String get followeeId => throw _privateConstructorUsedError; // 팔로우를 받은 사용자 ID
  String get churchId => throw _privateConstructorUsedError; // 소속 교회 ID
  @FollowStatusConverter()
  FollowStatus get status => throw _privateConstructorUsedError; // 팔로우 상태
  DateTime get createdAt => throw _privateConstructorUsedError; // 팔로우 요청 생성일시
  DateTime? get acceptedAt => throw _privateConstructorUsedError; // 팔로우 수락일시
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Follow to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Follow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FollowCopyWith<Follow> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowCopyWith<$Res> {
  factory $FollowCopyWith(Follow value, $Res Function(Follow) then) =
      _$FollowCopyWithImpl<$Res, Follow>;
  @useResult
  $Res call({
    String id,
    String followerId,
    String followeeId,
    String churchId,
    @FollowStatusConverter() FollowStatus status,
    DateTime createdAt,
    DateTime? acceptedAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$FollowCopyWithImpl<$Res, $Val extends Follow>
    implements $FollowCopyWith<$Res> {
  _$FollowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Follow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? followerId = null,
    Object? followeeId = null,
    Object? churchId = null,
    Object? status = null,
    Object? createdAt = null,
    Object? acceptedAt = freezed,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            followerId: null == followerId
                ? _value.followerId
                : followerId // ignore: cast_nullable_to_non_nullable
                      as String,
            followeeId: null == followeeId
                ? _value.followeeId
                : followeeId // ignore: cast_nullable_to_non_nullable
                      as String,
            churchId: null == churchId
                ? _value.churchId
                : churchId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as FollowStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            acceptedAt: freezed == acceptedAt
                ? _value.acceptedAt
                : acceptedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FollowImplCopyWith<$Res> implements $FollowCopyWith<$Res> {
  factory _$$FollowImplCopyWith(
    _$FollowImpl value,
    $Res Function(_$FollowImpl) then,
  ) = __$$FollowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String followerId,
    String followeeId,
    String churchId,
    @FollowStatusConverter() FollowStatus status,
    DateTime createdAt,
    DateTime? acceptedAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$FollowImplCopyWithImpl<$Res>
    extends _$FollowCopyWithImpl<$Res, _$FollowImpl>
    implements _$$FollowImplCopyWith<$Res> {
  __$$FollowImplCopyWithImpl(
    _$FollowImpl _value,
    $Res Function(_$FollowImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Follow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? followerId = null,
    Object? followeeId = null,
    Object? churchId = null,
    Object? status = null,
    Object? createdAt = null,
    Object? acceptedAt = freezed,
    Object? updatedAt = null,
  }) {
    return _then(
      _$FollowImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        followerId: null == followerId
            ? _value.followerId
            : followerId // ignore: cast_nullable_to_non_nullable
                  as String,
        followeeId: null == followeeId
            ? _value.followeeId
            : followeeId // ignore: cast_nullable_to_non_nullable
                  as String,
        churchId: null == churchId
            ? _value.churchId
            : churchId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as FollowStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        acceptedAt: freezed == acceptedAt
            ? _value.acceptedAt
            : acceptedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FollowImpl implements _Follow {
  const _$FollowImpl({
    required this.id,
    required this.followerId,
    required this.followeeId,
    required this.churchId,
    @FollowStatusConverter() required this.status,
    required this.createdAt,
    this.acceptedAt,
    required this.updatedAt,
  });

  factory _$FollowImpl.fromJson(Map<String, dynamic> json) =>
      _$$FollowImplFromJson(json);

  @override
  final String id;
  // 고유 ID: {followerId}_{followeeId}
  @override
  final String followerId;
  // 팔로우를 보낸 사용자 ID
  @override
  final String followeeId;
  // 팔로우를 받은 사용자 ID
  @override
  final String churchId;
  // 소속 교회 ID
  @override
  @FollowStatusConverter()
  final FollowStatus status;
  // 팔로우 상태
  @override
  final DateTime createdAt;
  // 팔로우 요청 생성일시
  @override
  final DateTime? acceptedAt;
  // 팔로우 수락일시
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Follow(id: $id, followerId: $followerId, followeeId: $followeeId, churchId: $churchId, status: $status, createdAt: $createdAt, acceptedAt: $acceptedAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FollowImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.followerId, followerId) ||
                other.followerId == followerId) &&
            (identical(other.followeeId, followeeId) ||
                other.followeeId == followeeId) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    followerId,
    followeeId,
    churchId,
    status,
    createdAt,
    acceptedAt,
    updatedAt,
  );

  /// Create a copy of Follow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FollowImplCopyWith<_$FollowImpl> get copyWith =>
      __$$FollowImplCopyWithImpl<_$FollowImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FollowImplToJson(this);
  }
}

abstract class _Follow implements Follow {
  const factory _Follow({
    required final String id,
    required final String followerId,
    required final String followeeId,
    required final String churchId,
    @FollowStatusConverter() required final FollowStatus status,
    required final DateTime createdAt,
    final DateTime? acceptedAt,
    required final DateTime updatedAt,
  }) = _$FollowImpl;

  factory _Follow.fromJson(Map<String, dynamic> json) = _$FollowImpl.fromJson;

  @override
  String get id; // 고유 ID: {followerId}_{followeeId}
  @override
  String get followerId; // 팔로우를 보낸 사용자 ID
  @override
  String get followeeId; // 팔로우를 받은 사용자 ID
  @override
  String get churchId; // 소속 교회 ID
  @override
  @FollowStatusConverter()
  FollowStatus get status; // 팔로우 상태
  @override
  DateTime get createdAt; // 팔로우 요청 생성일시
  @override
  DateTime? get acceptedAt; // 팔로우 수락일시
  @override
  DateTime get updatedAt;

  /// Create a copy of Follow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FollowImplCopyWith<_$FollowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
