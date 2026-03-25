// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'church.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Church _$ChurchFromJson(Map<String, dynamic> json) {
  return _Church.fromJson(json);
}

/// @nodoc
mixin _$Church {
  String get id =>
      throw _privateConstructorUsedError; // 고유 ID (Firestore document ID)
  String get name => throw _privateConstructorUsedError; // 교회 이름
  String get address =>
      throw _privateConstructorUsedError; // 도로명 주소 (카카오 API 반환값)
  String? get addressDetail => throw _privateConstructorUsedError; // 상세 주소 (선택)
  double? get latitude => throw _privateConstructorUsedError; // 위도 (추후 지도 연동용)
  double? get longitude => throw _privateConstructorUsedError; // 경도
  String get seniorPastor => throw _privateConstructorUsedError; // 담임목사 성함
  String get denomination => throw _privateConstructorUsedError; // 교단
  String get requestMemo => throw _privateConstructorUsedError; // 신청 메모
  String get requestedBy => throw _privateConstructorUsedError; // 신청자 userId
  ChurchStatus get status =>
      throw _privateConstructorUsedError; // pending | approved | rejected
  String? get rejectionReason => throw _privateConstructorUsedError; // 거절 사유
  DateTime get createdAt => throw _privateConstructorUsedError; // 생성일시
  DateTime get updatedAt => throw _privateConstructorUsedError; // 수정일시
  DateTime? get approvedAt => throw _privateConstructorUsedError; // 승인일시
  List<String>? get adminIds =>
      throw _privateConstructorUsedError; // 관리자 userId 목록 (승인 전 null 허용)
  int get memberCount => throw _privateConstructorUsedError; // 총 교인 수 비정규화 캐시
  int get villageCount => throw _privateConstructorUsedError; // 마을 수 비정규화 캐시
  int get groupCount => throw _privateConstructorUsedError; // 다락방 수 비정규화 캐시
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this Church to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Church
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChurchCopyWith<Church> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChurchCopyWith<$Res> {
  factory $ChurchCopyWith(Church value, $Res Function(Church) then) =
      _$ChurchCopyWithImpl<$Res, Church>;
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    String? addressDetail,
    double? latitude,
    double? longitude,
    String seniorPastor,
    String denomination,
    String requestMemo,
    String requestedBy,
    ChurchStatus status,
    String? rejectionReason,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? approvedAt,
    List<String>? adminIds,
    int memberCount,
    int villageCount,
    int groupCount,
    String? imageUrl,
  });
}

/// @nodoc
class _$ChurchCopyWithImpl<$Res, $Val extends Church>
    implements $ChurchCopyWith<$Res> {
  _$ChurchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Church
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? addressDetail = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? seniorPastor = null,
    Object? denomination = null,
    Object? requestMemo = null,
    Object? requestedBy = null,
    Object? status = null,
    Object? rejectionReason = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? approvedAt = freezed,
    Object? adminIds = freezed,
    Object? memberCount = null,
    Object? villageCount = null,
    Object? groupCount = null,
    Object? imageUrl = freezed,
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
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            addressDetail: freezed == addressDetail
                ? _value.addressDetail
                : addressDetail // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            seniorPastor: null == seniorPastor
                ? _value.seniorPastor
                : seniorPastor // ignore: cast_nullable_to_non_nullable
                      as String,
            denomination: null == denomination
                ? _value.denomination
                : denomination // ignore: cast_nullable_to_non_nullable
                      as String,
            requestMemo: null == requestMemo
                ? _value.requestMemo
                : requestMemo // ignore: cast_nullable_to_non_nullable
                      as String,
            requestedBy: null == requestedBy
                ? _value.requestedBy
                : requestedBy // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ChurchStatus,
            rejectionReason: freezed == rejectionReason
                ? _value.rejectionReason
                : rejectionReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            approvedAt: freezed == approvedAt
                ? _value.approvedAt
                : approvedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            adminIds: freezed == adminIds
                ? _value.adminIds
                : adminIds // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            memberCount: null == memberCount
                ? _value.memberCount
                : memberCount // ignore: cast_nullable_to_non_nullable
                      as int,
            villageCount: null == villageCount
                ? _value.villageCount
                : villageCount // ignore: cast_nullable_to_non_nullable
                      as int,
            groupCount: null == groupCount
                ? _value.groupCount
                : groupCount // ignore: cast_nullable_to_non_nullable
                      as int,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChurchImplCopyWith<$Res> implements $ChurchCopyWith<$Res> {
  factory _$$ChurchImplCopyWith(
    _$ChurchImpl value,
    $Res Function(_$ChurchImpl) then,
  ) = __$$ChurchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    String? addressDetail,
    double? latitude,
    double? longitude,
    String seniorPastor,
    String denomination,
    String requestMemo,
    String requestedBy,
    ChurchStatus status,
    String? rejectionReason,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? approvedAt,
    List<String>? adminIds,
    int memberCount,
    int villageCount,
    int groupCount,
    String? imageUrl,
  });
}

/// @nodoc
class __$$ChurchImplCopyWithImpl<$Res>
    extends _$ChurchCopyWithImpl<$Res, _$ChurchImpl>
    implements _$$ChurchImplCopyWith<$Res> {
  __$$ChurchImplCopyWithImpl(
    _$ChurchImpl _value,
    $Res Function(_$ChurchImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Church
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? addressDetail = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? seniorPastor = null,
    Object? denomination = null,
    Object? requestMemo = null,
    Object? requestedBy = null,
    Object? status = null,
    Object? rejectionReason = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? approvedAt = freezed,
    Object? adminIds = freezed,
    Object? memberCount = null,
    Object? villageCount = null,
    Object? groupCount = null,
    Object? imageUrl = freezed,
  }) {
    return _then(
      _$ChurchImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        addressDetail: freezed == addressDetail
            ? _value.addressDetail
            : addressDetail // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        seniorPastor: null == seniorPastor
            ? _value.seniorPastor
            : seniorPastor // ignore: cast_nullable_to_non_nullable
                  as String,
        denomination: null == denomination
            ? _value.denomination
            : denomination // ignore: cast_nullable_to_non_nullable
                  as String,
        requestMemo: null == requestMemo
            ? _value.requestMemo
            : requestMemo // ignore: cast_nullable_to_non_nullable
                  as String,
        requestedBy: null == requestedBy
            ? _value.requestedBy
            : requestedBy // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ChurchStatus,
        rejectionReason: freezed == rejectionReason
            ? _value.rejectionReason
            : rejectionReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        approvedAt: freezed == approvedAt
            ? _value.approvedAt
            : approvedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        adminIds: freezed == adminIds
            ? _value._adminIds
            : adminIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        memberCount: null == memberCount
            ? _value.memberCount
            : memberCount // ignore: cast_nullable_to_non_nullable
                  as int,
        villageCount: null == villageCount
            ? _value.villageCount
            : villageCount // ignore: cast_nullable_to_non_nullable
                  as int,
        groupCount: null == groupCount
            ? _value.groupCount
            : groupCount // ignore: cast_nullable_to_non_nullable
                  as int,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChurchImpl implements _Church {
  const _$ChurchImpl({
    required this.id,
    required this.name,
    required this.address,
    this.addressDetail,
    this.latitude,
    this.longitude,
    required this.seniorPastor,
    required this.denomination,
    required this.requestMemo,
    required this.requestedBy,
    required this.status,
    this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
    this.approvedAt,
    final List<String>? adminIds,
    this.memberCount = 0,
    this.villageCount = 0,
    this.groupCount = 0,
    this.imageUrl,
  }) : _adminIds = adminIds;

  factory _$ChurchImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChurchImplFromJson(json);

  @override
  final String id;
  // 고유 ID (Firestore document ID)
  @override
  final String name;
  // 교회 이름
  @override
  final String address;
  // 도로명 주소 (카카오 API 반환값)
  @override
  final String? addressDetail;
  // 상세 주소 (선택)
  @override
  final double? latitude;
  // 위도 (추후 지도 연동용)
  @override
  final double? longitude;
  // 경도
  @override
  final String seniorPastor;
  // 담임목사 성함
  @override
  final String denomination;
  // 교단
  @override
  final String requestMemo;
  // 신청 메모
  @override
  final String requestedBy;
  // 신청자 userId
  @override
  final ChurchStatus status;
  // pending | approved | rejected
  @override
  final String? rejectionReason;
  // 거절 사유
  @override
  final DateTime createdAt;
  // 생성일시
  @override
  final DateTime updatedAt;
  // 수정일시
  @override
  final DateTime? approvedAt;
  // 승인일시
  final List<String>? _adminIds;
  // 승인일시
  @override
  List<String>? get adminIds {
    final value = _adminIds;
    if (value == null) return null;
    if (_adminIds is EqualUnmodifiableListView) return _adminIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  // 관리자 userId 목록 (승인 전 null 허용)
  @override
  @JsonKey()
  final int memberCount;
  // 총 교인 수 비정규화 캐시
  @override
  @JsonKey()
  final int villageCount;
  // 마을 수 비정규화 캐시
  @override
  @JsonKey()
  final int groupCount;
  // 다락방 수 비정규화 캐시
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'Church(id: $id, name: $name, address: $address, addressDetail: $addressDetail, latitude: $latitude, longitude: $longitude, seniorPastor: $seniorPastor, denomination: $denomination, requestMemo: $requestMemo, requestedBy: $requestedBy, status: $status, rejectionReason: $rejectionReason, createdAt: $createdAt, updatedAt: $updatedAt, approvedAt: $approvedAt, adminIds: $adminIds, memberCount: $memberCount, villageCount: $villageCount, groupCount: $groupCount, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChurchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.addressDetail, addressDetail) ||
                other.addressDetail == addressDetail) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.seniorPastor, seniorPastor) ||
                other.seniorPastor == seniorPastor) &&
            (identical(other.denomination, denomination) ||
                other.denomination == denomination) &&
            (identical(other.requestMemo, requestMemo) ||
                other.requestMemo == requestMemo) &&
            (identical(other.requestedBy, requestedBy) ||
                other.requestedBy == requestedBy) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            const DeepCollectionEquality().equals(other._adminIds, _adminIds) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.villageCount, villageCount) ||
                other.villageCount == villageCount) &&
            (identical(other.groupCount, groupCount) ||
                other.groupCount == groupCount) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    address,
    addressDetail,
    latitude,
    longitude,
    seniorPastor,
    denomination,
    requestMemo,
    requestedBy,
    status,
    rejectionReason,
    createdAt,
    updatedAt,
    approvedAt,
    const DeepCollectionEquality().hash(_adminIds),
    memberCount,
    villageCount,
    groupCount,
    imageUrl,
  ]);

  /// Create a copy of Church
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChurchImplCopyWith<_$ChurchImpl> get copyWith =>
      __$$ChurchImplCopyWithImpl<_$ChurchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChurchImplToJson(this);
  }
}

abstract class _Church implements Church {
  const factory _Church({
    required final String id,
    required final String name,
    required final String address,
    final String? addressDetail,
    final double? latitude,
    final double? longitude,
    required final String seniorPastor,
    required final String denomination,
    required final String requestMemo,
    required final String requestedBy,
    required final ChurchStatus status,
    final String? rejectionReason,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? approvedAt,
    final List<String>? adminIds,
    final int memberCount,
    final int villageCount,
    final int groupCount,
    final String? imageUrl,
  }) = _$ChurchImpl;

  factory _Church.fromJson(Map<String, dynamic> json) = _$ChurchImpl.fromJson;

  @override
  String get id; // 고유 ID (Firestore document ID)
  @override
  String get name; // 교회 이름
  @override
  String get address; // 도로명 주소 (카카오 API 반환값)
  @override
  String? get addressDetail; // 상세 주소 (선택)
  @override
  double? get latitude; // 위도 (추후 지도 연동용)
  @override
  double? get longitude; // 경도
  @override
  String get seniorPastor; // 담임목사 성함
  @override
  String get denomination; // 교단
  @override
  String get requestMemo; // 신청 메모
  @override
  String get requestedBy; // 신청자 userId
  @override
  ChurchStatus get status; // pending | approved | rejected
  @override
  String? get rejectionReason; // 거절 사유
  @override
  DateTime get createdAt; // 생성일시
  @override
  DateTime get updatedAt; // 수정일시
  @override
  DateTime? get approvedAt; // 승인일시
  @override
  List<String>? get adminIds; // 관리자 userId 목록 (승인 전 null 허용)
  @override
  int get memberCount; // 총 교인 수 비정규화 캐시
  @override
  int get villageCount; // 마을 수 비정규화 캐시
  @override
  int get groupCount; // 다락방 수 비정규화 캐시
  @override
  String? get imageUrl;

  /// Create a copy of Church
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChurchImplCopyWith<_$ChurchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
