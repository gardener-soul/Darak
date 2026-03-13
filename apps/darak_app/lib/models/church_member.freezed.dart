// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'church_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChurchMember _$ChurchMemberFromJson(Map<String, dynamic> json) {
  return _ChurchMember.fromJson(json);
}

/// @nodoc
mixin _$ChurchMember {
  String get userId => throw _privateConstructorUsedError;
  String get roleId =>
      throw _privateConstructorUsedError; // 교회 내 역할 ID (ChurchRole 참조)
  String? get villageId => throw _privateConstructorUsedError;
  String? get groupId => throw _privateConstructorUsedError;
  DateTime get joinedAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ChurchMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChurchMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChurchMemberCopyWith<ChurchMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChurchMemberCopyWith<$Res> {
  factory $ChurchMemberCopyWith(
    ChurchMember value,
    $Res Function(ChurchMember) then,
  ) = _$ChurchMemberCopyWithImpl<$Res, ChurchMember>;
  @useResult
  $Res call({
    String userId,
    String roleId,
    String? villageId,
    String? groupId,
    DateTime joinedAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$ChurchMemberCopyWithImpl<$Res, $Val extends ChurchMember>
    implements $ChurchMemberCopyWith<$Res> {
  _$ChurchMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChurchMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? roleId = null,
    Object? villageId = freezed,
    Object? groupId = freezed,
    Object? joinedAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            roleId: null == roleId
                ? _value.roleId
                : roleId // ignore: cast_nullable_to_non_nullable
                      as String,
            villageId: freezed == villageId
                ? _value.villageId
                : villageId // ignore: cast_nullable_to_non_nullable
                      as String?,
            groupId: freezed == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as String?,
            joinedAt: null == joinedAt
                ? _value.joinedAt
                : joinedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
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
abstract class _$$ChurchMemberImplCopyWith<$Res>
    implements $ChurchMemberCopyWith<$Res> {
  factory _$$ChurchMemberImplCopyWith(
    _$ChurchMemberImpl value,
    $Res Function(_$ChurchMemberImpl) then,
  ) = __$$ChurchMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String roleId,
    String? villageId,
    String? groupId,
    DateTime joinedAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$ChurchMemberImplCopyWithImpl<$Res>
    extends _$ChurchMemberCopyWithImpl<$Res, _$ChurchMemberImpl>
    implements _$$ChurchMemberImplCopyWith<$Res> {
  __$$ChurchMemberImplCopyWithImpl(
    _$ChurchMemberImpl _value,
    $Res Function(_$ChurchMemberImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChurchMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? roleId = null,
    Object? villageId = freezed,
    Object? groupId = freezed,
    Object? joinedAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ChurchMemberImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        roleId: null == roleId
            ? _value.roleId
            : roleId // ignore: cast_nullable_to_non_nullable
                  as String,
        villageId: freezed == villageId
            ? _value.villageId
            : villageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        groupId: freezed == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String?,
        joinedAt: null == joinedAt
            ? _value.joinedAt
            : joinedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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
class _$ChurchMemberImpl implements _ChurchMember {
  const _$ChurchMemberImpl({
    required this.userId,
    required this.roleId,
    this.villageId,
    this.groupId,
    required this.joinedAt,
    required this.updatedAt,
  });

  factory _$ChurchMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChurchMemberImplFromJson(json);

  @override
  final String userId;
  @override
  final String roleId;
  // 교회 내 역할 ID (ChurchRole 참조)
  @override
  final String? villageId;
  @override
  final String? groupId;
  @override
  final DateTime joinedAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ChurchMember(userId: $userId, roleId: $roleId, villageId: $villageId, groupId: $groupId, joinedAt: $joinedAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChurchMemberImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.roleId, roleId) || other.roleId == roleId) &&
            (identical(other.villageId, villageId) ||
                other.villageId == villageId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    roleId,
    villageId,
    groupId,
    joinedAt,
    updatedAt,
  );

  /// Create a copy of ChurchMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChurchMemberImplCopyWith<_$ChurchMemberImpl> get copyWith =>
      __$$ChurchMemberImplCopyWithImpl<_$ChurchMemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChurchMemberImplToJson(this);
  }
}

abstract class _ChurchMember implements ChurchMember {
  const factory _ChurchMember({
    required final String userId,
    required final String roleId,
    final String? villageId,
    final String? groupId,
    required final DateTime joinedAt,
    required final DateTime updatedAt,
  }) = _$ChurchMemberImpl;

  factory _ChurchMember.fromJson(Map<String, dynamic> json) =
      _$ChurchMemberImpl.fromJson;

  @override
  String get userId;
  @override
  String get roleId; // 교회 내 역할 ID (ChurchRole 참조)
  @override
  String? get villageId;
  @override
  String? get groupId;
  @override
  DateTime get joinedAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ChurchMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChurchMemberImplCopyWith<_$ChurchMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
