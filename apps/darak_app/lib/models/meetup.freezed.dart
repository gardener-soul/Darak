// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meetup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MeetUp _$MeetUpFromJson(Map<String, dynamic> json) {
  return _MeetUp.fromJson(json);
}

/// @nodoc
mixin _$MeetUp {
  String get id => throw _privateConstructorUsedError; // 고유 ID
  String get name => throw _privateConstructorUsedError; // 모임 이름
  String get churchId => throw _privateConstructorUsedError; // 소속 교회 ID
  String get meetLeaderId =>
      throw _privateConstructorUsedError; // 모임 주최자 ID (User 참조)
  DateTime get createdAt => throw _privateConstructorUsedError; // 생성일시
  DateTime get updatedAt => throw _privateConstructorUsedError; // 수정일시
  List<String> get participantIds =>
      throw _privateConstructorUsedError; // 참여자 ID 리스트
  String? get description => throw _privateConstructorUsedError; // 모임 설명
  DateTime? get scheduledAt => throw _privateConstructorUsedError; // 모임 예정 일시
  int? get maxParticipants =>
      throw _privateConstructorUsedError; // 최대 참여 인원 (null = 무제한)
  List<String> get reportedBy =>
      throw _privateConstructorUsedError; // 신고한 사용자 ID 배열
  bool get notificationSent =>
      throw _privateConstructorUsedError; // 푸시 알림 발송 여부 (추후 확장용)
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this MeetUp to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MeetUp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MeetUpCopyWith<MeetUp> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeetUpCopyWith<$Res> {
  factory $MeetUpCopyWith(MeetUp value, $Res Function(MeetUp) then) =
      _$MeetUpCopyWithImpl<$Res, MeetUp>;
  @useResult
  $Res call({
    String id,
    String name,
    String churchId,
    String meetLeaderId,
    DateTime createdAt,
    DateTime updatedAt,
    List<String> participantIds,
    String? description,
    DateTime? scheduledAt,
    int? maxParticipants,
    List<String> reportedBy,
    bool notificationSent,
    DateTime? deletedAt,
  });
}

/// @nodoc
class _$MeetUpCopyWithImpl<$Res, $Val extends MeetUp>
    implements $MeetUpCopyWith<$Res> {
  _$MeetUpCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MeetUp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? churchId = null,
    Object? meetLeaderId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? participantIds = null,
    Object? description = freezed,
    Object? scheduledAt = freezed,
    Object? maxParticipants = freezed,
    Object? reportedBy = null,
    Object? notificationSent = null,
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
            churchId: null == churchId
                ? _value.churchId
                : churchId // ignore: cast_nullable_to_non_nullable
                      as String,
            meetLeaderId: null == meetLeaderId
                ? _value.meetLeaderId
                : meetLeaderId // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            participantIds: null == participantIds
                ? _value.participantIds
                : participantIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            scheduledAt: freezed == scheduledAt
                ? _value.scheduledAt
                : scheduledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            maxParticipants: freezed == maxParticipants
                ? _value.maxParticipants
                : maxParticipants // ignore: cast_nullable_to_non_nullable
                      as int?,
            reportedBy: null == reportedBy
                ? _value.reportedBy
                : reportedBy // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            notificationSent: null == notificationSent
                ? _value.notificationSent
                : notificationSent // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$MeetUpImplCopyWith<$Res> implements $MeetUpCopyWith<$Res> {
  factory _$$MeetUpImplCopyWith(
    _$MeetUpImpl value,
    $Res Function(_$MeetUpImpl) then,
  ) = __$$MeetUpImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String churchId,
    String meetLeaderId,
    DateTime createdAt,
    DateTime updatedAt,
    List<String> participantIds,
    String? description,
    DateTime? scheduledAt,
    int? maxParticipants,
    List<String> reportedBy,
    bool notificationSent,
    DateTime? deletedAt,
  });
}

/// @nodoc
class __$$MeetUpImplCopyWithImpl<$Res>
    extends _$MeetUpCopyWithImpl<$Res, _$MeetUpImpl>
    implements _$$MeetUpImplCopyWith<$Res> {
  __$$MeetUpImplCopyWithImpl(
    _$MeetUpImpl _value,
    $Res Function(_$MeetUpImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MeetUp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? churchId = null,
    Object? meetLeaderId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? participantIds = null,
    Object? description = freezed,
    Object? scheduledAt = freezed,
    Object? maxParticipants = freezed,
    Object? reportedBy = null,
    Object? notificationSent = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _$MeetUpImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        churchId: null == churchId
            ? _value.churchId
            : churchId // ignore: cast_nullable_to_non_nullable
                  as String,
        meetLeaderId: null == meetLeaderId
            ? _value.meetLeaderId
            : meetLeaderId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        participantIds: null == participantIds
            ? _value._participantIds
            : participantIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        scheduledAt: freezed == scheduledAt
            ? _value.scheduledAt
            : scheduledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        maxParticipants: freezed == maxParticipants
            ? _value.maxParticipants
            : maxParticipants // ignore: cast_nullable_to_non_nullable
                  as int?,
        reportedBy: null == reportedBy
            ? _value._reportedBy
            : reportedBy // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        notificationSent: null == notificationSent
            ? _value.notificationSent
            : notificationSent // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$MeetUpImpl implements _MeetUp {
  const _$MeetUpImpl({
    required this.id,
    required this.name,
    required this.churchId,
    required this.meetLeaderId,
    required this.createdAt,
    required this.updatedAt,
    final List<String> participantIds = const [],
    this.description,
    this.scheduledAt,
    this.maxParticipants,
    final List<String> reportedBy = const [],
    this.notificationSent = false,
    this.deletedAt,
  }) : _participantIds = participantIds,
       _reportedBy = reportedBy;

  factory _$MeetUpImpl.fromJson(Map<String, dynamic> json) =>
      _$$MeetUpImplFromJson(json);

  @override
  final String id;
  // 고유 ID
  @override
  final String name;
  // 모임 이름
  @override
  final String churchId;
  // 소속 교회 ID
  @override
  final String meetLeaderId;
  // 모임 주최자 ID (User 참조)
  @override
  final DateTime createdAt;
  // 생성일시
  @override
  final DateTime updatedAt;
  // 수정일시
  final List<String> _participantIds;
  // 수정일시
  @override
  @JsonKey()
  List<String> get participantIds {
    if (_participantIds is EqualUnmodifiableListView) return _participantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantIds);
  }

  // 참여자 ID 리스트
  @override
  final String? description;
  // 모임 설명
  @override
  final DateTime? scheduledAt;
  // 모임 예정 일시
  @override
  final int? maxParticipants;
  // 최대 참여 인원 (null = 무제한)
  final List<String> _reportedBy;
  // 최대 참여 인원 (null = 무제한)
  @override
  @JsonKey()
  List<String> get reportedBy {
    if (_reportedBy is EqualUnmodifiableListView) return _reportedBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reportedBy);
  }

  // 신고한 사용자 ID 배열
  @override
  @JsonKey()
  final bool notificationSent;
  // 푸시 알림 발송 여부 (추후 확장용)
  @override
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'MeetUp(id: $id, name: $name, churchId: $churchId, meetLeaderId: $meetLeaderId, createdAt: $createdAt, updatedAt: $updatedAt, participantIds: $participantIds, description: $description, scheduledAt: $scheduledAt, maxParticipants: $maxParticipants, reportedBy: $reportedBy, notificationSent: $notificationSent, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MeetUpImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.meetLeaderId, meetLeaderId) ||
                other.meetLeaderId == meetLeaderId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(
              other._participantIds,
              _participantIds,
            ) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.maxParticipants, maxParticipants) ||
                other.maxParticipants == maxParticipants) &&
            const DeepCollectionEquality().equals(
              other._reportedBy,
              _reportedBy,
            ) &&
            (identical(other.notificationSent, notificationSent) ||
                other.notificationSent == notificationSent) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    churchId,
    meetLeaderId,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_participantIds),
    description,
    scheduledAt,
    maxParticipants,
    const DeepCollectionEquality().hash(_reportedBy),
    notificationSent,
    deletedAt,
  );

  /// Create a copy of MeetUp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MeetUpImplCopyWith<_$MeetUpImpl> get copyWith =>
      __$$MeetUpImplCopyWithImpl<_$MeetUpImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MeetUpImplToJson(this);
  }
}

abstract class _MeetUp implements MeetUp {
  const factory _MeetUp({
    required final String id,
    required final String name,
    required final String churchId,
    required final String meetLeaderId,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final List<String> participantIds,
    final String? description,
    final DateTime? scheduledAt,
    final int? maxParticipants,
    final List<String> reportedBy,
    final bool notificationSent,
    final DateTime? deletedAt,
  }) = _$MeetUpImpl;

  factory _MeetUp.fromJson(Map<String, dynamic> json) = _$MeetUpImpl.fromJson;

  @override
  String get id; // 고유 ID
  @override
  String get name; // 모임 이름
  @override
  String get churchId; // 소속 교회 ID
  @override
  String get meetLeaderId; // 모임 주최자 ID (User 참조)
  @override
  DateTime get createdAt; // 생성일시
  @override
  DateTime get updatedAt; // 수정일시
  @override
  List<String> get participantIds; // 참여자 ID 리스트
  @override
  String? get description; // 모임 설명
  @override
  DateTime? get scheduledAt; // 모임 예정 일시
  @override
  int? get maxParticipants; // 최대 참여 인원 (null = 무제한)
  @override
  List<String> get reportedBy; // 신고한 사용자 ID 배열
  @override
  bool get notificationSent; // 푸시 알림 발송 여부 (추후 확장용)
  @override
  DateTime? get deletedAt;

  /// Create a copy of MeetUp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MeetUpImplCopyWith<_$MeetUpImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
