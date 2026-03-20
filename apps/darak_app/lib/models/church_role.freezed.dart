// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'church_role.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChurchRole _$ChurchRoleFromJson(Map<String, dynamic> json) {
  return _ChurchRole.fromJson(json);
}

/// @nodoc
mixin _$ChurchRole {
  String get id => throw _privateConstructorUsedError;
  String get name =>
      throw _privateConstructorUsedError; // 표시 이름 (예: "순장", "셀 리더")
  int get level => throw _privateConstructorUsedError; // 권한 레벨 (1: 순원 ~ 4: 사역자)
  List<String> get permissions => throw _privateConstructorUsedError;
  bool get isDefault =>
      throw _privateConstructorUsedError; // true이면 삭제 불가, 이름 변경만 허용
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ChurchRole to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChurchRole
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChurchRoleCopyWith<ChurchRole> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChurchRoleCopyWith<$Res> {
  factory $ChurchRoleCopyWith(
    ChurchRole value,
    $Res Function(ChurchRole) then,
  ) = _$ChurchRoleCopyWithImpl<$Res, ChurchRole>;
  @useResult
  $Res call({
    String id,
    String name,
    int level,
    List<String> permissions,
    bool isDefault,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$ChurchRoleCopyWithImpl<$Res, $Val extends ChurchRole>
    implements $ChurchRoleCopyWith<$Res> {
  _$ChurchRoleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChurchRole
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? level = null,
    Object? permissions = null,
    Object? isDefault = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as int,
            permissions: null == permissions
                ? _value.permissions
                : permissions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isDefault: null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ChurchRoleImplCopyWith<$Res>
    implements $ChurchRoleCopyWith<$Res> {
  factory _$$ChurchRoleImplCopyWith(
    _$ChurchRoleImpl value,
    $Res Function(_$ChurchRoleImpl) then,
  ) = __$$ChurchRoleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    int level,
    List<String> permissions,
    bool isDefault,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$ChurchRoleImplCopyWithImpl<$Res>
    extends _$ChurchRoleCopyWithImpl<$Res, _$ChurchRoleImpl>
    implements _$$ChurchRoleImplCopyWith<$Res> {
  __$$ChurchRoleImplCopyWithImpl(
    _$ChurchRoleImpl _value,
    $Res Function(_$ChurchRoleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChurchRole
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? level = null,
    Object? permissions = null,
    Object? isDefault = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ChurchRoleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as int,
        permissions: null == permissions
            ? _value._permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isDefault: null == isDefault
            ? _value.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
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
class _$ChurchRoleImpl implements _ChurchRole {
  const _$ChurchRoleImpl({
    required this.id,
    required this.name,
    required this.level,
    required final List<String> permissions,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  }) : _permissions = permissions;

  factory _$ChurchRoleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChurchRoleImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  // 표시 이름 (예: "순장", "셀 리더")
  @override
  final int level;
  // 권한 레벨 (1: 순원 ~ 4: 사역자)
  final List<String> _permissions;
  // 권한 레벨 (1: 순원 ~ 4: 사역자)
  @override
  List<String> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  final bool isDefault;
  // true이면 삭제 불가, 이름 변경만 허용
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ChurchRole(id: $id, name: $name, level: $level, permissions: $permissions, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChurchRoleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.level, level) || other.level == level) &&
            const DeepCollectionEquality().equals(
              other._permissions,
              _permissions,
            ) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    level,
    const DeepCollectionEquality().hash(_permissions),
    isDefault,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ChurchRole
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChurchRoleImplCopyWith<_$ChurchRoleImpl> get copyWith =>
      __$$ChurchRoleImplCopyWithImpl<_$ChurchRoleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChurchRoleImplToJson(this);
  }
}

abstract class _ChurchRole implements ChurchRole {
  const factory _ChurchRole({
    required final String id,
    required final String name,
    required final int level,
    required final List<String> permissions,
    required final bool isDefault,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$ChurchRoleImpl;

  factory _ChurchRole.fromJson(Map<String, dynamic> json) =
      _$ChurchRoleImpl.fromJson;

  @override
  String get id;
  @override
  String get name; // 표시 이름 (예: "순장", "셀 리더")
  @override
  int get level; // 권한 레벨 (1: 순원 ~ 4: 사역자)
  @override
  List<String> get permissions;
  @override
  bool get isDefault; // true이면 삭제 불가, 이름 변경만 허용
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ChurchRole
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChurchRoleImplCopyWith<_$ChurchRoleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
