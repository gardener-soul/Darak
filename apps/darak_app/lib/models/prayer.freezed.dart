// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prayer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Prayer _$PrayerFromJson(Map<String, dynamic> json) {
  return _Prayer.fromJson(json);
}

/// @nodoc
mixin _$Prayer {
  String get id =>
      throw _privateConstructorUsedError; // 고유 ID (Firestore document ID)
  String get userId => throw _privateConstructorUsedError; // 작성자 ID
  String get churchId => throw _privateConstructorUsedError; // 소속 교회 ID
  String? get groupId => throw _privateConstructorUsedError; // 소속 다락방 ID
  String get content =>
      throw _privateConstructorUsedError; // 기도 제목 본문 (최대 200자)
  @PrayerVisibilityConverter()
  PrayerVisibility get visibility => throw _privateConstructorUsedError; // 공개 범위
  @PrayerStatusConverter()
  PrayerStatus get status => throw _privateConstructorUsedError; // 상태
  @PrayerPeriodTypeConverter()
  PrayerPeriodType get periodType => throw _privateConstructorUsedError; // 기간 유형
  DateTime get startDate => throw _privateConstructorUsedError; // 기도 시작일
  DateTime? get endDate =>
      throw _privateConstructorUsedError; // 기도 종료일 (indefinite의 경우 null)
  DateTime? get answeredAt =>
      throw _privateConstructorUsedError; // 응답됨 상태로 변경된 일시
  DateTime get createdAt => throw _privateConstructorUsedError; // 생성일시
  DateTime get updatedAt => throw _privateConstructorUsedError; // 수정일시
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this Prayer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Prayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrayerCopyWith<Prayer> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrayerCopyWith<$Res> {
  factory $PrayerCopyWith(Prayer value, $Res Function(Prayer) then) =
      _$PrayerCopyWithImpl<$Res, Prayer>;
  @useResult
  $Res call({
    String id,
    String userId,
    String churchId,
    String? groupId,
    String content,
    @PrayerVisibilityConverter() PrayerVisibility visibility,
    @PrayerStatusConverter() PrayerStatus status,
    @PrayerPeriodTypeConverter() PrayerPeriodType periodType,
    DateTime startDate,
    DateTime? endDate,
    DateTime? answeredAt,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class _$PrayerCopyWithImpl<$Res, $Val extends Prayer>
    implements $PrayerCopyWith<$Res> {
  _$PrayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Prayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? churchId = null,
    Object? groupId = freezed,
    Object? content = null,
    Object? visibility = null,
    Object? status = null,
    Object? periodType = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? answeredAt = freezed,
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
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            visibility: null == visibility
                ? _value.visibility
                : visibility // ignore: cast_nullable_to_non_nullable
                      as PrayerVisibility,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PrayerStatus,
            periodType: null == periodType
                ? _value.periodType
                : periodType // ignore: cast_nullable_to_non_nullable
                      as PrayerPeriodType,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            answeredAt: freezed == answeredAt
                ? _value.answeredAt
                : answeredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
abstract class _$$PrayerImplCopyWith<$Res> implements $PrayerCopyWith<$Res> {
  factory _$$PrayerImplCopyWith(
    _$PrayerImpl value,
    $Res Function(_$PrayerImpl) then,
  ) = __$$PrayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String churchId,
    String? groupId,
    String content,
    @PrayerVisibilityConverter() PrayerVisibility visibility,
    @PrayerStatusConverter() PrayerStatus status,
    @PrayerPeriodTypeConverter() PrayerPeriodType periodType,
    DateTime startDate,
    DateTime? endDate,
    DateTime? answeredAt,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class __$$PrayerImplCopyWithImpl<$Res>
    extends _$PrayerCopyWithImpl<$Res, _$PrayerImpl>
    implements _$$PrayerImplCopyWith<$Res> {
  __$$PrayerImplCopyWithImpl(
    _$PrayerImpl _value,
    $Res Function(_$PrayerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Prayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? churchId = null,
    Object? groupId = freezed,
    Object? content = null,
    Object? visibility = null,
    Object? status = null,
    Object? periodType = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? answeredAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _$PrayerImpl(
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
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        visibility: null == visibility
            ? _value.visibility
            : visibility // ignore: cast_nullable_to_non_nullable
                  as PrayerVisibility,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PrayerStatus,
        periodType: null == periodType
            ? _value.periodType
            : periodType // ignore: cast_nullable_to_non_nullable
                  as PrayerPeriodType,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        answeredAt: freezed == answeredAt
            ? _value.answeredAt
            : answeredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
class _$PrayerImpl implements _Prayer {
  const _$PrayerImpl({
    required this.id,
    required this.userId,
    required this.churchId,
    this.groupId,
    required this.content,
    @PrayerVisibilityConverter() required this.visibility,
    @PrayerStatusConverter() required this.status,
    @PrayerPeriodTypeConverter() required this.periodType,
    required this.startDate,
    this.endDate,
    this.answeredAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory _$PrayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrayerImplFromJson(json);

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
  final String content;
  // 기도 제목 본문 (최대 200자)
  @override
  @PrayerVisibilityConverter()
  final PrayerVisibility visibility;
  // 공개 범위
  @override
  @PrayerStatusConverter()
  final PrayerStatus status;
  // 상태
  @override
  @PrayerPeriodTypeConverter()
  final PrayerPeriodType periodType;
  // 기간 유형
  @override
  final DateTime startDate;
  // 기도 시작일
  @override
  final DateTime? endDate;
  // 기도 종료일 (indefinite의 경우 null)
  @override
  final DateTime? answeredAt;
  // 응답됨 상태로 변경된 일시
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
    return 'Prayer(id: $id, userId: $userId, churchId: $churchId, groupId: $groupId, content: $content, visibility: $visibility, status: $status, periodType: $periodType, startDate: $startDate, endDate: $endDate, answeredAt: $answeredAt, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrayerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.periodType, periodType) ||
                other.periodType == periodType) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.answeredAt, answeredAt) ||
                other.answeredAt == answeredAt) &&
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
    content,
    visibility,
    status,
    periodType,
    startDate,
    endDate,
    answeredAt,
    createdAt,
    updatedAt,
    deletedAt,
  );

  /// Create a copy of Prayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrayerImplCopyWith<_$PrayerImpl> get copyWith =>
      __$$PrayerImplCopyWithImpl<_$PrayerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrayerImplToJson(this);
  }
}

abstract class _Prayer implements Prayer {
  const factory _Prayer({
    required final String id,
    required final String userId,
    required final String churchId,
    final String? groupId,
    required final String content,
    @PrayerVisibilityConverter() required final PrayerVisibility visibility,
    @PrayerStatusConverter() required final PrayerStatus status,
    @PrayerPeriodTypeConverter() required final PrayerPeriodType periodType,
    required final DateTime startDate,
    final DateTime? endDate,
    final DateTime? answeredAt,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? deletedAt,
  }) = _$PrayerImpl;

  factory _Prayer.fromJson(Map<String, dynamic> json) = _$PrayerImpl.fromJson;

  @override
  String get id; // 고유 ID (Firestore document ID)
  @override
  String get userId; // 작성자 ID
  @override
  String get churchId; // 소속 교회 ID
  @override
  String? get groupId; // 소속 다락방 ID
  @override
  String get content; // 기도 제목 본문 (최대 200자)
  @override
  @PrayerVisibilityConverter()
  PrayerVisibility get visibility; // 공개 범위
  @override
  @PrayerStatusConverter()
  PrayerStatus get status; // 상태
  @override
  @PrayerPeriodTypeConverter()
  PrayerPeriodType get periodType; // 기간 유형
  @override
  DateTime get startDate; // 기도 시작일
  @override
  DateTime? get endDate; // 기도 종료일 (indefinite의 경우 null)
  @override
  DateTime? get answeredAt; // 응답됨 상태로 변경된 일시
  @override
  DateTime get createdAt; // 생성일시
  @override
  DateTime get updatedAt; // 수정일시
  @override
  DateTime? get deletedAt;

  /// Create a copy of Prayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrayerImplCopyWith<_$PrayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
