// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'club.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Club _$ClubFromJson(Map<String, dynamic> json) {
  return _Club.fromJson(json);
}

/// @nodoc
mixin _$Club {
  String get id => throw _privateConstructorUsedError; // 고유 ID
  String get name => throw _privateConstructorUsedError; // 클럽 이름
  String? get clubLeaderId =>
      throw _privateConstructorUsedError; // 클럽 리더 ID (User 참조)
  List<String>? get clubMemberIds =>
      throw _privateConstructorUsedError; // 클럽 멤버 ID 리스트
  String? get description => throw _privateConstructorUsedError; // 클럽 설명
  ClubStatus get status =>
      throw _privateConstructorUsedError; // 승인 상태 (대기/승인/거부)
  DateTime get createdAt => throw _privateConstructorUsedError; // 생성일시
  DateTime get updatedAt => throw _privateConstructorUsedError; // 수정일시
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this Club to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Club
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClubCopyWith<Club> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClubCopyWith<$Res> {
  factory $ClubCopyWith(Club value, $Res Function(Club) then) =
      _$ClubCopyWithImpl<$Res, Club>;
  @useResult
  $Res call({
    String id,
    String name,
    String? clubLeaderId,
    List<String>? clubMemberIds,
    String? description,
    ClubStatus status,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class _$ClubCopyWithImpl<$Res, $Val extends Club>
    implements $ClubCopyWith<$Res> {
  _$ClubCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Club
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? clubLeaderId = freezed,
    Object? clubMemberIds = freezed,
    Object? description = freezed,
    Object? status = null,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            clubLeaderId: freezed == clubLeaderId
                ? _value.clubLeaderId
                : clubLeaderId // ignore: cast_nullable_to_non_nullable
                      as String?,
            clubMemberIds: freezed == clubMemberIds
                ? _value.clubMemberIds
                : clubMemberIds // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ClubStatus,
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
abstract class _$$ClubImplCopyWith<$Res> implements $ClubCopyWith<$Res> {
  factory _$$ClubImplCopyWith(
    _$ClubImpl value,
    $Res Function(_$ClubImpl) then,
  ) = __$$ClubImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? clubLeaderId,
    List<String>? clubMemberIds,
    String? description,
    ClubStatus status,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class __$$ClubImplCopyWithImpl<$Res>
    extends _$ClubCopyWithImpl<$Res, _$ClubImpl>
    implements _$$ClubImplCopyWith<$Res> {
  __$$ClubImplCopyWithImpl(_$ClubImpl _value, $Res Function(_$ClubImpl) _then)
    : super(_value, _then);

  /// Create a copy of Club
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? clubLeaderId = freezed,
    Object? clubMemberIds = freezed,
    Object? description = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _$ClubImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        clubLeaderId: freezed == clubLeaderId
            ? _value.clubLeaderId
            : clubLeaderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        clubMemberIds: freezed == clubMemberIds
            ? _value._clubMemberIds
            : clubMemberIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ClubStatus,
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
class _$ClubImpl implements _Club {
  const _$ClubImpl({
    required this.id,
    required this.name,
    this.clubLeaderId,
    final List<String>? clubMemberIds,
    this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  }) : _clubMemberIds = clubMemberIds;

  factory _$ClubImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClubImplFromJson(json);

  @override
  final String id;
  // 고유 ID
  @override
  final String name;
  // 클럽 이름
  @override
  final String? clubLeaderId;
  // 클럽 리더 ID (User 참조)
  final List<String>? _clubMemberIds;
  // 클럽 리더 ID (User 참조)
  @override
  List<String>? get clubMemberIds {
    final value = _clubMemberIds;
    if (value == null) return null;
    if (_clubMemberIds is EqualUnmodifiableListView) return _clubMemberIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  // 클럽 멤버 ID 리스트
  @override
  final String? description;
  // 클럽 설명
  @override
  final ClubStatus status;
  // 승인 상태 (대기/승인/거부)
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
    return 'Club(id: $id, name: $name, clubLeaderId: $clubLeaderId, clubMemberIds: $clubMemberIds, description: $description, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClubImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.clubLeaderId, clubLeaderId) ||
                other.clubLeaderId == clubLeaderId) &&
            const DeepCollectionEquality().equals(
              other._clubMemberIds,
              _clubMemberIds,
            ) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
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
    name,
    clubLeaderId,
    const DeepCollectionEquality().hash(_clubMemberIds),
    description,
    status,
    createdAt,
    updatedAt,
    deletedAt,
  );

  /// Create a copy of Club
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClubImplCopyWith<_$ClubImpl> get copyWith =>
      __$$ClubImplCopyWithImpl<_$ClubImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClubImplToJson(this);
  }
}

abstract class _Club implements Club {
  const factory _Club({
    required final String id,
    required final String name,
    final String? clubLeaderId,
    final List<String>? clubMemberIds,
    final String? description,
    required final ClubStatus status,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? deletedAt,
  }) = _$ClubImpl;

  factory _Club.fromJson(Map<String, dynamic> json) = _$ClubImpl.fromJson;

  @override
  String get id; // 고유 ID
  @override
  String get name; // 클럽 이름
  @override
  String? get clubLeaderId; // 클럽 리더 ID (User 참조)
  @override
  List<String>? get clubMemberIds; // 클럽 멤버 ID 리스트
  @override
  String? get description; // 클럽 설명
  @override
  ClubStatus get status; // 승인 상태 (대기/승인/거부)
  @override
  DateTime get createdAt; // 생성일시
  @override
  DateTime get updatedAt; // 수정일시
  @override
  DateTime? get deletedAt;

  /// Create a copy of Club
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClubImplCopyWith<_$ClubImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
