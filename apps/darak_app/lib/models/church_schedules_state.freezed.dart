// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'church_schedules_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ChurchSchedulesState {
  List<ChurchSchedule> get schedules => throw _privateConstructorUsedError;
  ScheduleViewMode get viewMode => throw _privateConstructorUsedError;

  /// Create a copy of ChurchSchedulesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChurchSchedulesStateCopyWith<ChurchSchedulesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChurchSchedulesStateCopyWith<$Res> {
  factory $ChurchSchedulesStateCopyWith(
    ChurchSchedulesState value,
    $Res Function(ChurchSchedulesState) then,
  ) = _$ChurchSchedulesStateCopyWithImpl<$Res, ChurchSchedulesState>;
  @useResult
  $Res call({List<ChurchSchedule> schedules, ScheduleViewMode viewMode});
}

/// @nodoc
class _$ChurchSchedulesStateCopyWithImpl<
  $Res,
  $Val extends ChurchSchedulesState
>
    implements $ChurchSchedulesStateCopyWith<$Res> {
  _$ChurchSchedulesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChurchSchedulesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? schedules = null, Object? viewMode = null}) {
    return _then(
      _value.copyWith(
            schedules: null == schedules
                ? _value.schedules
                : schedules // ignore: cast_nullable_to_non_nullable
                      as List<ChurchSchedule>,
            viewMode: null == viewMode
                ? _value.viewMode
                : viewMode // ignore: cast_nullable_to_non_nullable
                      as ScheduleViewMode,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChurchSchedulesStateImplCopyWith<$Res>
    implements $ChurchSchedulesStateCopyWith<$Res> {
  factory _$$ChurchSchedulesStateImplCopyWith(
    _$ChurchSchedulesStateImpl value,
    $Res Function(_$ChurchSchedulesStateImpl) then,
  ) = __$$ChurchSchedulesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ChurchSchedule> schedules, ScheduleViewMode viewMode});
}

/// @nodoc
class __$$ChurchSchedulesStateImplCopyWithImpl<$Res>
    extends _$ChurchSchedulesStateCopyWithImpl<$Res, _$ChurchSchedulesStateImpl>
    implements _$$ChurchSchedulesStateImplCopyWith<$Res> {
  __$$ChurchSchedulesStateImplCopyWithImpl(
    _$ChurchSchedulesStateImpl _value,
    $Res Function(_$ChurchSchedulesStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChurchSchedulesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? schedules = null, Object? viewMode = null}) {
    return _then(
      _$ChurchSchedulesStateImpl(
        schedules: null == schedules
            ? _value._schedules
            : schedules // ignore: cast_nullable_to_non_nullable
                  as List<ChurchSchedule>,
        viewMode: null == viewMode
            ? _value.viewMode
            : viewMode // ignore: cast_nullable_to_non_nullable
                  as ScheduleViewMode,
      ),
    );
  }
}

/// @nodoc

class _$ChurchSchedulesStateImpl implements _ChurchSchedulesState {
  const _$ChurchSchedulesStateImpl({
    required final List<ChurchSchedule> schedules,
    this.viewMode = ScheduleViewMode.weekly,
  }) : _schedules = schedules;

  final List<ChurchSchedule> _schedules;
  @override
  List<ChurchSchedule> get schedules {
    if (_schedules is EqualUnmodifiableListView) return _schedules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_schedules);
  }

  @override
  @JsonKey()
  final ScheduleViewMode viewMode;

  @override
  String toString() {
    return 'ChurchSchedulesState(schedules: $schedules, viewMode: $viewMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChurchSchedulesStateImpl &&
            const DeepCollectionEquality().equals(
              other._schedules,
              _schedules,
            ) &&
            (identical(other.viewMode, viewMode) ||
                other.viewMode == viewMode));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_schedules),
    viewMode,
  );

  /// Create a copy of ChurchSchedulesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChurchSchedulesStateImplCopyWith<_$ChurchSchedulesStateImpl>
  get copyWith =>
      __$$ChurchSchedulesStateImplCopyWithImpl<_$ChurchSchedulesStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ChurchSchedulesState implements ChurchSchedulesState {
  const factory _ChurchSchedulesState({
    required final List<ChurchSchedule> schedules,
    final ScheduleViewMode viewMode,
  }) = _$ChurchSchedulesStateImpl;

  @override
  List<ChurchSchedule> get schedules;
  @override
  ScheduleViewMode get viewMode;

  /// Create a copy of ChurchSchedulesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChurchSchedulesStateImplCopyWith<_$ChurchSchedulesStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
