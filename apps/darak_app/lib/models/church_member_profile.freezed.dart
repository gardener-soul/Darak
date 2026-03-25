// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'church_member_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ChurchMemberProfile {
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  String get roleId => throw _privateConstructorUsedError;
  String get roleName =>
      throw _privateConstructorUsedError; // ChurchRole.name (UI 표시용)
  int get roleLevel =>
      throw _privateConstructorUsedError; // ChurchRole.level (권한 비교용)
  String? get villageId => throw _privateConstructorUsedError;
  String? get villageName => throw _privateConstructorUsedError;
  String? get groupId => throw _privateConstructorUsedError;
  String? get groupName => throw _privateConstructorUsedError;
  DateTime get joinedAt => throw _privateConstructorUsedError;

  /// Create a copy of ChurchMemberProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChurchMemberProfileCopyWith<ChurchMemberProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChurchMemberProfileCopyWith<$Res> {
  factory $ChurchMemberProfileCopyWith(
    ChurchMemberProfile value,
    $Res Function(ChurchMemberProfile) then,
  ) = _$ChurchMemberProfileCopyWithImpl<$Res, ChurchMemberProfile>;
  @useResult
  $Res call({
    String userId,
    String name,
    String? profileImageUrl,
    String roleId,
    String roleName,
    int roleLevel,
    String? villageId,
    String? villageName,
    String? groupId,
    String? groupName,
    DateTime joinedAt,
  });
}

/// @nodoc
class _$ChurchMemberProfileCopyWithImpl<$Res, $Val extends ChurchMemberProfile>
    implements $ChurchMemberProfileCopyWith<$Res> {
  _$ChurchMemberProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChurchMemberProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? name = null,
    Object? profileImageUrl = freezed,
    Object? roleId = null,
    Object? roleName = null,
    Object? roleLevel = null,
    Object? villageId = freezed,
    Object? villageName = freezed,
    Object? groupId = freezed,
    Object? groupName = freezed,
    Object? joinedAt = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            profileImageUrl: freezed == profileImageUrl
                ? _value.profileImageUrl
                : profileImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            roleId: null == roleId
                ? _value.roleId
                : roleId // ignore: cast_nullable_to_non_nullable
                      as String,
            roleName: null == roleName
                ? _value.roleName
                : roleName // ignore: cast_nullable_to_non_nullable
                      as String,
            roleLevel: null == roleLevel
                ? _value.roleLevel
                : roleLevel // ignore: cast_nullable_to_non_nullable
                      as int,
            villageId: freezed == villageId
                ? _value.villageId
                : villageId // ignore: cast_nullable_to_non_nullable
                      as String?,
            villageName: freezed == villageName
                ? _value.villageName
                : villageName // ignore: cast_nullable_to_non_nullable
                      as String?,
            groupId: freezed == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as String?,
            groupName: freezed == groupName
                ? _value.groupName
                : groupName // ignore: cast_nullable_to_non_nullable
                      as String?,
            joinedAt: null == joinedAt
                ? _value.joinedAt
                : joinedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChurchMemberProfileImplCopyWith<$Res>
    implements $ChurchMemberProfileCopyWith<$Res> {
  factory _$$ChurchMemberProfileImplCopyWith(
    _$ChurchMemberProfileImpl value,
    $Res Function(_$ChurchMemberProfileImpl) then,
  ) = __$$ChurchMemberProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String name,
    String? profileImageUrl,
    String roleId,
    String roleName,
    int roleLevel,
    String? villageId,
    String? villageName,
    String? groupId,
    String? groupName,
    DateTime joinedAt,
  });
}

/// @nodoc
class __$$ChurchMemberProfileImplCopyWithImpl<$Res>
    extends _$ChurchMemberProfileCopyWithImpl<$Res, _$ChurchMemberProfileImpl>
    implements _$$ChurchMemberProfileImplCopyWith<$Res> {
  __$$ChurchMemberProfileImplCopyWithImpl(
    _$ChurchMemberProfileImpl _value,
    $Res Function(_$ChurchMemberProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChurchMemberProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? name = null,
    Object? profileImageUrl = freezed,
    Object? roleId = null,
    Object? roleName = null,
    Object? roleLevel = null,
    Object? villageId = freezed,
    Object? villageName = freezed,
    Object? groupId = freezed,
    Object? groupName = freezed,
    Object? joinedAt = null,
  }) {
    return _then(
      _$ChurchMemberProfileImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        profileImageUrl: freezed == profileImageUrl
            ? _value.profileImageUrl
            : profileImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        roleId: null == roleId
            ? _value.roleId
            : roleId // ignore: cast_nullable_to_non_nullable
                  as String,
        roleName: null == roleName
            ? _value.roleName
            : roleName // ignore: cast_nullable_to_non_nullable
                  as String,
        roleLevel: null == roleLevel
            ? _value.roleLevel
            : roleLevel // ignore: cast_nullable_to_non_nullable
                  as int,
        villageId: freezed == villageId
            ? _value.villageId
            : villageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        villageName: freezed == villageName
            ? _value.villageName
            : villageName // ignore: cast_nullable_to_non_nullable
                  as String?,
        groupId: freezed == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String?,
        groupName: freezed == groupName
            ? _value.groupName
            : groupName // ignore: cast_nullable_to_non_nullable
                  as String?,
        joinedAt: null == joinedAt
            ? _value.joinedAt
            : joinedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$ChurchMemberProfileImpl implements _ChurchMemberProfile {
  const _$ChurchMemberProfileImpl({
    required this.userId,
    required this.name,
    this.profileImageUrl,
    required this.roleId,
    required this.roleName,
    required this.roleLevel,
    this.villageId,
    this.villageName,
    this.groupId,
    this.groupName,
    required this.joinedAt,
  });

  @override
  final String userId;
  @override
  final String name;
  @override
  final String? profileImageUrl;
  @override
  final String roleId;
  @override
  final String roleName;
  // ChurchRole.name (UI 표시용)
  @override
  final int roleLevel;
  // ChurchRole.level (권한 비교용)
  @override
  final String? villageId;
  @override
  final String? villageName;
  @override
  final String? groupId;
  @override
  final String? groupName;
  @override
  final DateTime joinedAt;

  @override
  String toString() {
    return 'ChurchMemberProfile(userId: $userId, name: $name, profileImageUrl: $profileImageUrl, roleId: $roleId, roleName: $roleName, roleLevel: $roleLevel, villageId: $villageId, villageName: $villageName, groupId: $groupId, groupName: $groupName, joinedAt: $joinedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChurchMemberProfileImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.roleId, roleId) || other.roleId == roleId) &&
            (identical(other.roleName, roleName) ||
                other.roleName == roleName) &&
            (identical(other.roleLevel, roleLevel) ||
                other.roleLevel == roleLevel) &&
            (identical(other.villageId, villageId) ||
                other.villageId == villageId) &&
            (identical(other.villageName, villageName) ||
                other.villageName == villageName) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    name,
    profileImageUrl,
    roleId,
    roleName,
    roleLevel,
    villageId,
    villageName,
    groupId,
    groupName,
    joinedAt,
  );

  /// Create a copy of ChurchMemberProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChurchMemberProfileImplCopyWith<_$ChurchMemberProfileImpl> get copyWith =>
      __$$ChurchMemberProfileImplCopyWithImpl<_$ChurchMemberProfileImpl>(
        this,
        _$identity,
      );
}

abstract class _ChurchMemberProfile implements ChurchMemberProfile {
  const factory _ChurchMemberProfile({
    required final String userId,
    required final String name,
    final String? profileImageUrl,
    required final String roleId,
    required final String roleName,
    required final int roleLevel,
    final String? villageId,
    final String? villageName,
    final String? groupId,
    final String? groupName,
    required final DateTime joinedAt,
  }) = _$ChurchMemberProfileImpl;

  @override
  String get userId;
  @override
  String get name;
  @override
  String? get profileImageUrl;
  @override
  String get roleId;
  @override
  String get roleName; // ChurchRole.name (UI 표시용)
  @override
  int get roleLevel; // ChurchRole.level (권한 비교용)
  @override
  String? get villageId;
  @override
  String? get villageName;
  @override
  String? get groupId;
  @override
  String? get groupName;
  @override
  DateTime get joinedAt;

  /// Create a copy of ChurchMemberProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChurchMemberProfileImplCopyWith<_$ChurchMemberProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
