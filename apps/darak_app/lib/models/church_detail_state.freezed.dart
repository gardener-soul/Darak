// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'church_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ChurchDetailState {
  Church get church => throw _privateConstructorUsedError;
  ChurchMember? get currentMember =>
      throw _privateConstructorUsedError; // null이면 비멤버
  bool get isAdmin => throw _privateConstructorUsedError;

  /// Create a copy of ChurchDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChurchDetailStateCopyWith<ChurchDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChurchDetailStateCopyWith<$Res> {
  factory $ChurchDetailStateCopyWith(
    ChurchDetailState value,
    $Res Function(ChurchDetailState) then,
  ) = _$ChurchDetailStateCopyWithImpl<$Res, ChurchDetailState>;
  @useResult
  $Res call({Church church, ChurchMember? currentMember, bool isAdmin});

  $ChurchCopyWith<$Res> get church;
  $ChurchMemberCopyWith<$Res>? get currentMember;
}

/// @nodoc
class _$ChurchDetailStateCopyWithImpl<$Res, $Val extends ChurchDetailState>
    implements $ChurchDetailStateCopyWith<$Res> {
  _$ChurchDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChurchDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? church = null,
    Object? currentMember = freezed,
    Object? isAdmin = null,
  }) {
    return _then(
      _value.copyWith(
            church: null == church
                ? _value.church
                : church // ignore: cast_nullable_to_non_nullable
                      as Church,
            currentMember: freezed == currentMember
                ? _value.currentMember
                : currentMember // ignore: cast_nullable_to_non_nullable
                      as ChurchMember?,
            isAdmin: null == isAdmin
                ? _value.isAdmin
                : isAdmin // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of ChurchDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChurchCopyWith<$Res> get church {
    return $ChurchCopyWith<$Res>(_value.church, (value) {
      return _then(_value.copyWith(church: value) as $Val);
    });
  }

  /// Create a copy of ChurchDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChurchMemberCopyWith<$Res>? get currentMember {
    if (_value.currentMember == null) {
      return null;
    }

    return $ChurchMemberCopyWith<$Res>(_value.currentMember!, (value) {
      return _then(_value.copyWith(currentMember: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChurchDetailStateImplCopyWith<$Res>
    implements $ChurchDetailStateCopyWith<$Res> {
  factory _$$ChurchDetailStateImplCopyWith(
    _$ChurchDetailStateImpl value,
    $Res Function(_$ChurchDetailStateImpl) then,
  ) = __$$ChurchDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Church church, ChurchMember? currentMember, bool isAdmin});

  @override
  $ChurchCopyWith<$Res> get church;
  @override
  $ChurchMemberCopyWith<$Res>? get currentMember;
}

/// @nodoc
class __$$ChurchDetailStateImplCopyWithImpl<$Res>
    extends _$ChurchDetailStateCopyWithImpl<$Res, _$ChurchDetailStateImpl>
    implements _$$ChurchDetailStateImplCopyWith<$Res> {
  __$$ChurchDetailStateImplCopyWithImpl(
    _$ChurchDetailStateImpl _value,
    $Res Function(_$ChurchDetailStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChurchDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? church = null,
    Object? currentMember = freezed,
    Object? isAdmin = null,
  }) {
    return _then(
      _$ChurchDetailStateImpl(
        church: null == church
            ? _value.church
            : church // ignore: cast_nullable_to_non_nullable
                  as Church,
        currentMember: freezed == currentMember
            ? _value.currentMember
            : currentMember // ignore: cast_nullable_to_non_nullable
                  as ChurchMember?,
        isAdmin: null == isAdmin
            ? _value.isAdmin
            : isAdmin // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$ChurchDetailStateImpl implements _ChurchDetailState {
  const _$ChurchDetailStateImpl({
    required this.church,
    this.currentMember,
    required this.isAdmin,
  });

  @override
  final Church church;
  @override
  final ChurchMember? currentMember;
  // null이면 비멤버
  @override
  final bool isAdmin;

  @override
  String toString() {
    return 'ChurchDetailState(church: $church, currentMember: $currentMember, isAdmin: $isAdmin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChurchDetailStateImpl &&
            (identical(other.church, church) || other.church == church) &&
            (identical(other.currentMember, currentMember) ||
                other.currentMember == currentMember) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin));
  }

  @override
  int get hashCode => Object.hash(runtimeType, church, currentMember, isAdmin);

  /// Create a copy of ChurchDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChurchDetailStateImplCopyWith<_$ChurchDetailStateImpl> get copyWith =>
      __$$ChurchDetailStateImplCopyWithImpl<_$ChurchDetailStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ChurchDetailState implements ChurchDetailState {
  const factory _ChurchDetailState({
    required final Church church,
    final ChurchMember? currentMember,
    required final bool isAdmin,
  }) = _$ChurchDetailStateImpl;

  @override
  Church get church;
  @override
  ChurchMember? get currentMember; // null이면 비멤버
  @override
  bool get isAdmin;

  /// Create a copy of ChurchDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChurchDetailStateImplCopyWith<_$ChurchDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
