// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'church_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChurchSchedule _$ChurchScheduleFromJson(Map<String, dynamic> json) {
  return _ChurchSchedule.fromJson(json);
}

/// @nodoc
mixin _$ChurchSchedule {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  ScheduleCategory get category => throw _privateConstructorUsedError;
  DateTime get startAt => throw _privateConstructorUsedError;
  DateTime? get endAt => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  bool get isRecurring => throw _privateConstructorUsedError;
  String? get recurringRule =>
      throw _privateConstructorUsedError; // "WEEKLY" 등. isRecurring == true이면 필수.
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this ChurchSchedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChurchSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChurchScheduleCopyWith<ChurchSchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChurchScheduleCopyWith<$Res> {
  factory $ChurchScheduleCopyWith(
    ChurchSchedule value,
    $Res Function(ChurchSchedule) then,
  ) = _$ChurchScheduleCopyWithImpl<$Res, ChurchSchedule>;
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    ScheduleCategory category,
    DateTime startAt,
    DateTime? endAt,
    String? location,
    bool isRecurring,
    String? recurringRule,
    String createdBy,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class _$ChurchScheduleCopyWithImpl<$Res, $Val extends ChurchSchedule>
    implements $ChurchScheduleCopyWith<$Res> {
  _$ChurchScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChurchSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? category = null,
    Object? startAt = null,
    Object? endAt = freezed,
    Object? location = freezed,
    Object? isRecurring = null,
    Object? recurringRule = freezed,
    Object? createdBy = null,
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
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as ScheduleCategory,
            startAt: null == startAt
                ? _value.startAt
                : startAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endAt: freezed == endAt
                ? _value.endAt
                : endAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            isRecurring: null == isRecurring
                ? _value.isRecurring
                : isRecurring // ignore: cast_nullable_to_non_nullable
                      as bool,
            recurringRule: freezed == recurringRule
                ? _value.recurringRule
                : recurringRule // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdBy: null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$ChurchScheduleImplCopyWith<$Res>
    implements $ChurchScheduleCopyWith<$Res> {
  factory _$$ChurchScheduleImplCopyWith(
    _$ChurchScheduleImpl value,
    $Res Function(_$ChurchScheduleImpl) then,
  ) = __$$ChurchScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    ScheduleCategory category,
    DateTime startAt,
    DateTime? endAt,
    String? location,
    bool isRecurring,
    String? recurringRule,
    String createdBy,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class __$$ChurchScheduleImplCopyWithImpl<$Res>
    extends _$ChurchScheduleCopyWithImpl<$Res, _$ChurchScheduleImpl>
    implements _$$ChurchScheduleImplCopyWith<$Res> {
  __$$ChurchScheduleImplCopyWithImpl(
    _$ChurchScheduleImpl _value,
    $Res Function(_$ChurchScheduleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChurchSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? category = null,
    Object? startAt = null,
    Object? endAt = freezed,
    Object? location = freezed,
    Object? isRecurring = null,
    Object? recurringRule = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _$ChurchScheduleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as ScheduleCategory,
        startAt: null == startAt
            ? _value.startAt
            : startAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endAt: freezed == endAt
            ? _value.endAt
            : endAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        isRecurring: null == isRecurring
            ? _value.isRecurring
            : isRecurring // ignore: cast_nullable_to_non_nullable
                  as bool,
        recurringRule: freezed == recurringRule
            ? _value.recurringRule
            : recurringRule // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$ChurchScheduleImpl implements _ChurchSchedule {
  const _$ChurchScheduleImpl({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.startAt,
    this.endAt,
    this.location,
    required this.isRecurring,
    this.recurringRule,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory _$ChurchScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChurchScheduleImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final ScheduleCategory category;
  @override
  final DateTime startAt;
  @override
  final DateTime? endAt;
  @override
  final String? location;
  @override
  final bool isRecurring;
  @override
  final String? recurringRule;
  // "WEEKLY" 등. isRecurring == true이면 필수.
  @override
  final String createdBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'ChurchSchedule(id: $id, title: $title, description: $description, category: $category, startAt: $startAt, endAt: $endAt, location: $location, isRecurring: $isRecurring, recurringRule: $recurringRule, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChurchScheduleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            (identical(other.recurringRule, recurringRule) ||
                other.recurringRule == recurringRule) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
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
    title,
    description,
    category,
    startAt,
    endAt,
    location,
    isRecurring,
    recurringRule,
    createdBy,
    createdAt,
    updatedAt,
    deletedAt,
  );

  /// Create a copy of ChurchSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChurchScheduleImplCopyWith<_$ChurchScheduleImpl> get copyWith =>
      __$$ChurchScheduleImplCopyWithImpl<_$ChurchScheduleImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChurchScheduleImplToJson(this);
  }
}

abstract class _ChurchSchedule implements ChurchSchedule {
  const factory _ChurchSchedule({
    required final String id,
    required final String title,
    final String? description,
    required final ScheduleCategory category,
    required final DateTime startAt,
    final DateTime? endAt,
    final String? location,
    required final bool isRecurring,
    final String? recurringRule,
    required final String createdBy,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? deletedAt,
  }) = _$ChurchScheduleImpl;

  factory _ChurchSchedule.fromJson(Map<String, dynamic> json) =
      _$ChurchScheduleImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  ScheduleCategory get category;
  @override
  DateTime get startAt;
  @override
  DateTime? get endAt;
  @override
  String? get location;
  @override
  bool get isRecurring;
  @override
  String? get recurringRule; // "WEEKLY" 등. isRecurring == true이면 필수.
  @override
  String get createdBy;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get deletedAt;

  /// Create a copy of ChurchSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChurchScheduleImplCopyWith<_$ChurchScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
