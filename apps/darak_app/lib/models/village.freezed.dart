// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'village.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Village _$VillageFromJson(Map<String, dynamic> json) {
  return _Village.fromJson(json);
}

/// @nodoc
mixin _$Village {
  String get id => throw _privateConstructorUsedError; // 고유 ID
  String get name => throw _privateConstructorUsedError; // 마을 이름
  String? get leaderId =>
      throw _privateConstructorUsedError; // 마을장 ID (User 참조)
  List<String>? get darakLeaderIds =>
      throw _privateConstructorUsedError; // 마을 소속 다락방 리더 ID 리스트
  List<String>? get memberIds =>
      throw _privateConstructorUsedError; // 마을 소속 순원 ID 리스트
  String? get description => throw _privateConstructorUsedError; // 마을 설명
  String? get churchId =>
      throw _privateConstructorUsedError; // 소속 교회 ID (마이그레이션 기간 동안 null 허용)
  DateTime get createdAt => throw _privateConstructorUsedError; // 생성일시
  DateTime get updatedAt => throw _privateConstructorUsedError; // 수정일시
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this Village to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Village
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VillageCopyWith<Village> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VillageCopyWith<$Res> {
  factory $VillageCopyWith(Village value, $Res Function(Village) then) =
      _$VillageCopyWithImpl<$Res, Village>;
  @useResult
  $Res call({
    String id,
    String name,
    String? leaderId,
    List<String>? darakLeaderIds,
    List<String>? memberIds,
    String? description,
    String? churchId,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class _$VillageCopyWithImpl<$Res, $Val extends Village>
    implements $VillageCopyWith<$Res> {
  _$VillageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Village
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? leaderId = freezed,
    Object? darakLeaderIds = freezed,
    Object? memberIds = freezed,
    Object? description = freezed,
    Object? churchId = freezed,
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
            leaderId: freezed == leaderId
                ? _value.leaderId
                : leaderId // ignore: cast_nullable_to_non_nullable
                      as String?,
            darakLeaderIds: freezed == darakLeaderIds
                ? _value.darakLeaderIds
                : darakLeaderIds // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            memberIds: freezed == memberIds
                ? _value.memberIds
                : memberIds // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            churchId: freezed == churchId
                ? _value.churchId
                : churchId // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$VillageImplCopyWith<$Res> implements $VillageCopyWith<$Res> {
  factory _$$VillageImplCopyWith(
    _$VillageImpl value,
    $Res Function(_$VillageImpl) then,
  ) = __$$VillageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? leaderId,
    List<String>? darakLeaderIds,
    List<String>? memberIds,
    String? description,
    String? churchId,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class __$$VillageImplCopyWithImpl<$Res>
    extends _$VillageCopyWithImpl<$Res, _$VillageImpl>
    implements _$$VillageImplCopyWith<$Res> {
  __$$VillageImplCopyWithImpl(
    _$VillageImpl _value,
    $Res Function(_$VillageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Village
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? leaderId = freezed,
    Object? darakLeaderIds = freezed,
    Object? memberIds = freezed,
    Object? description = freezed,
    Object? churchId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _$VillageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        leaderId: freezed == leaderId
            ? _value.leaderId
            : leaderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        darakLeaderIds: freezed == darakLeaderIds
            ? _value._darakLeaderIds
            : darakLeaderIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        memberIds: freezed == memberIds
            ? _value._memberIds
            : memberIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        churchId: freezed == churchId
            ? _value.churchId
            : churchId // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$VillageImpl implements _Village {
  const _$VillageImpl({
    required this.id,
    required this.name,
    this.leaderId,
    final List<String>? darakLeaderIds,
    final List<String>? memberIds,
    this.description,
    this.churchId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  }) : _darakLeaderIds = darakLeaderIds,
       _memberIds = memberIds;

  factory _$VillageImpl.fromJson(Map<String, dynamic> json) =>
      _$$VillageImplFromJson(json);

  @override
  final String id;
  // 고유 ID
  @override
  final String name;
  // 마을 이름
  @override
  final String? leaderId;
  // 마을장 ID (User 참조)
  final List<String>? _darakLeaderIds;
  // 마을장 ID (User 참조)
  @override
  List<String>? get darakLeaderIds {
    final value = _darakLeaderIds;
    if (value == null) return null;
    if (_darakLeaderIds is EqualUnmodifiableListView) return _darakLeaderIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  // 마을 소속 다락방 리더 ID 리스트
  final List<String>? _memberIds;
  // 마을 소속 다락방 리더 ID 리스트
  @override
  List<String>? get memberIds {
    final value = _memberIds;
    if (value == null) return null;
    if (_memberIds is EqualUnmodifiableListView) return _memberIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  // 마을 소속 순원 ID 리스트
  @override
  final String? description;
  // 마을 설명
  @override
  final String? churchId;
  // 소속 교회 ID (마이그레이션 기간 동안 null 허용)
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
    return 'Village(id: $id, name: $name, leaderId: $leaderId, darakLeaderIds: $darakLeaderIds, memberIds: $memberIds, description: $description, churchId: $churchId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VillageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.leaderId, leaderId) ||
                other.leaderId == leaderId) &&
            const DeepCollectionEquality().equals(
              other._darakLeaderIds,
              _darakLeaderIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._memberIds,
              _memberIds,
            ) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
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
    leaderId,
    const DeepCollectionEquality().hash(_darakLeaderIds),
    const DeepCollectionEquality().hash(_memberIds),
    description,
    churchId,
    createdAt,
    updatedAt,
    deletedAt,
  );

  /// Create a copy of Village
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VillageImplCopyWith<_$VillageImpl> get copyWith =>
      __$$VillageImplCopyWithImpl<_$VillageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VillageImplToJson(this);
  }
}

abstract class _Village implements Village {
  const factory _Village({
    required final String id,
    required final String name,
    final String? leaderId,
    final List<String>? darakLeaderIds,
    final List<String>? memberIds,
    final String? description,
    final String? churchId,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? deletedAt,
  }) = _$VillageImpl;

  factory _Village.fromJson(Map<String, dynamic> json) = _$VillageImpl.fromJson;

  @override
  String get id; // 고유 ID
  @override
  String get name; // 마을 이름
  @override
  String? get leaderId; // 마을장 ID (User 참조)
  @override
  List<String>? get darakLeaderIds; // 마을 소속 다락방 리더 ID 리스트
  @override
  List<String>? get memberIds; // 마을 소속 순원 ID 리스트
  @override
  String? get description; // 마을 설명
  @override
  String? get churchId; // 소속 교회 ID (마이그레이션 기간 동안 null 허용)
  @override
  DateTime get createdAt; // 생성일시
  @override
  DateTime get updatedAt; // 수정일시
  @override
  DateTime? get deletedAt;

  /// Create a copy of Village
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VillageImplCopyWith<_$VillageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
