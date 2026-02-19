// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id =>
      throw _privateConstructorUsedError; // 고유 ID (Firestore document ID)
  String get name => throw _privateConstructorUsedError; // 이름
  String get phone => throw _privateConstructorUsedError; // 핸드폰 번호
  String? get email => throw _privateConstructorUsedError; // 이메일 (선택)
  UserRole get role => throw _privateConstructorUsedError; // 역할 (순원, 순장, 마을장 등)
  DateTime? get birthDate => throw _privateConstructorUsedError; // 생년월일
  DateTime? get registerDate => throw _privateConstructorUsedError; // 교회 등록일
  String? get groupId => throw _privateConstructorUsedError; // 소속 다락방 ID
  List<String>? get clubIds =>
      throw _privateConstructorUsedError; // 소속 클럽/동아리 ID 리스트 (여러 개 가능)
  String? get profileImageUrl =>
      throw _privateConstructorUsedError; // 프로필 이미지 URL
  String? get bio => throw _privateConstructorUsedError; // 상태 메시지 (마이페이지)
  DateTime get createdAt => throw _privateConstructorUsedError; // 생성일시
  DateTime get updatedAt => throw _privateConstructorUsedError; // 수정일시
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call({
    String id,
    String name,
    String phone,
    String? email,
    UserRole role,
    DateTime? birthDate,
    DateTime? registerDate,
    String? groupId,
    List<String>? clubIds,
    String? profileImageUrl,
    String? bio,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = null,
    Object? email = freezed,
    Object? role = null,
    Object? birthDate = freezed,
    Object? registerDate = freezed,
    Object? groupId = freezed,
    Object? clubIds = freezed,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
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
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as UserRole,
            birthDate: freezed == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            registerDate: freezed == registerDate
                ? _value.registerDate
                : registerDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            groupId: freezed == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as String?,
            clubIds: freezed == clubIds
                ? _value.clubIds
                : clubIds // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            profileImageUrl: freezed == profileImageUrl
                ? _value.profileImageUrl
                : profileImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
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
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
    _$UserImpl value,
    $Res Function(_$UserImpl) then,
  ) = __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String phone,
    String? email,
    UserRole role,
    DateTime? birthDate,
    DateTime? registerDate,
    String? groupId,
    List<String>? clubIds,
    String? profileImageUrl,
    String? bio,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
    : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? phone = null,
    Object? email = freezed,
    Object? role = null,
    Object? birthDate = freezed,
    Object? registerDate = freezed,
    Object? groupId = freezed,
    Object? clubIds = freezed,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _$UserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as UserRole,
        birthDate: freezed == birthDate
            ? _value.birthDate
            : birthDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        registerDate: freezed == registerDate
            ? _value.registerDate
            : registerDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        groupId: freezed == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String?,
        clubIds: freezed == clubIds
            ? _value._clubIds
            : clubIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        profileImageUrl: freezed == profileImageUrl
            ? _value.profileImageUrl
            : profileImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
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
class _$UserImpl implements _User {
  const _$UserImpl({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.role,
    this.birthDate,
    this.registerDate,
    this.groupId,
    final List<String>? clubIds,
    this.profileImageUrl,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  }) : _clubIds = clubIds;

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  // 고유 ID (Firestore document ID)
  @override
  final String name;
  // 이름
  @override
  final String phone;
  // 핸드폰 번호
  @override
  final String? email;
  // 이메일 (선택)
  @override
  final UserRole role;
  // 역할 (순원, 순장, 마을장 등)
  @override
  final DateTime? birthDate;
  // 생년월일
  @override
  final DateTime? registerDate;
  // 교회 등록일
  @override
  final String? groupId;
  // 소속 다락방 ID
  final List<String>? _clubIds;
  // 소속 다락방 ID
  @override
  List<String>? get clubIds {
    final value = _clubIds;
    if (value == null) return null;
    if (_clubIds is EqualUnmodifiableListView) return _clubIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  // 소속 클럽/동아리 ID 리스트 (여러 개 가능)
  @override
  final String? profileImageUrl;
  // 프로필 이미지 URL
  @override
  final String? bio;
  // 상태 메시지 (마이페이지)
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
    return 'User(id: $id, name: $name, phone: $phone, email: $email, role: $role, birthDate: $birthDate, registerDate: $registerDate, groupId: $groupId, clubIds: $clubIds, profileImageUrl: $profileImageUrl, bio: $bio, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.registerDate, registerDate) ||
                other.registerDate == registerDate) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            const DeepCollectionEquality().equals(other._clubIds, _clubIds) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
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
    phone,
    email,
    role,
    birthDate,
    registerDate,
    groupId,
    const DeepCollectionEquality().hash(_clubIds),
    profileImageUrl,
    bio,
    createdAt,
    updatedAt,
    deletedAt,
  );

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(this);
  }
}

abstract class _User implements User {
  const factory _User({
    required final String id,
    required final String name,
    required final String phone,
    final String? email,
    required final UserRole role,
    final DateTime? birthDate,
    final DateTime? registerDate,
    final String? groupId,
    final List<String>? clubIds,
    final String? profileImageUrl,
    final String? bio,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? deletedAt,
  }) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id; // 고유 ID (Firestore document ID)
  @override
  String get name; // 이름
  @override
  String get phone; // 핸드폰 번호
  @override
  String? get email; // 이메일 (선택)
  @override
  UserRole get role; // 역할 (순원, 순장, 마을장 등)
  @override
  DateTime? get birthDate; // 생년월일
  @override
  DateTime? get registerDate; // 교회 등록일
  @override
  String? get groupId; // 소속 다락방 ID
  @override
  List<String>? get clubIds; // 소속 클럽/동아리 ID 리스트 (여러 개 가능)
  @override
  String? get profileImageUrl; // 프로필 이미지 URL
  @override
  String? get bio; // 상태 메시지 (마이페이지)
  @override
  DateTime get createdAt; // 생성일시
  @override
  DateTime get updatedAt; // 수정일시
  @override
  DateTime? get deletedAt;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
