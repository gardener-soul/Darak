// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'village_with_groups.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$VillageWithGroups {
  Village get village => throw _privateConstructorUsedError;
  List<Group> get groups => throw _privateConstructorUsedError;

  /// Create a copy of VillageWithGroups
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VillageWithGroupsCopyWith<VillageWithGroups> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VillageWithGroupsCopyWith<$Res> {
  factory $VillageWithGroupsCopyWith(
    VillageWithGroups value,
    $Res Function(VillageWithGroups) then,
  ) = _$VillageWithGroupsCopyWithImpl<$Res, VillageWithGroups>;
  @useResult
  $Res call({Village village, List<Group> groups});

  $VillageCopyWith<$Res> get village;
}

/// @nodoc
class _$VillageWithGroupsCopyWithImpl<$Res, $Val extends VillageWithGroups>
    implements $VillageWithGroupsCopyWith<$Res> {
  _$VillageWithGroupsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VillageWithGroups
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? village = null, Object? groups = null}) {
    return _then(
      _value.copyWith(
            village: null == village
                ? _value.village
                : village // ignore: cast_nullable_to_non_nullable
                      as Village,
            groups: null == groups
                ? _value.groups
                : groups // ignore: cast_nullable_to_non_nullable
                      as List<Group>,
          )
          as $Val,
    );
  }

  /// Create a copy of VillageWithGroups
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VillageCopyWith<$Res> get village {
    return $VillageCopyWith<$Res>(_value.village, (value) {
      return _then(_value.copyWith(village: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VillageWithGroupsImplCopyWith<$Res>
    implements $VillageWithGroupsCopyWith<$Res> {
  factory _$$VillageWithGroupsImplCopyWith(
    _$VillageWithGroupsImpl value,
    $Res Function(_$VillageWithGroupsImpl) then,
  ) = __$$VillageWithGroupsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Village village, List<Group> groups});

  @override
  $VillageCopyWith<$Res> get village;
}

/// @nodoc
class __$$VillageWithGroupsImplCopyWithImpl<$Res>
    extends _$VillageWithGroupsCopyWithImpl<$Res, _$VillageWithGroupsImpl>
    implements _$$VillageWithGroupsImplCopyWith<$Res> {
  __$$VillageWithGroupsImplCopyWithImpl(
    _$VillageWithGroupsImpl _value,
    $Res Function(_$VillageWithGroupsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VillageWithGroups
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? village = null, Object? groups = null}) {
    return _then(
      _$VillageWithGroupsImpl(
        village: null == village
            ? _value.village
            : village // ignore: cast_nullable_to_non_nullable
                  as Village,
        groups: null == groups
            ? _value._groups
            : groups // ignore: cast_nullable_to_non_nullable
                  as List<Group>,
      ),
    );
  }
}

/// @nodoc

class _$VillageWithGroupsImpl implements _VillageWithGroups {
  const _$VillageWithGroupsImpl({
    required this.village,
    required final List<Group> groups,
  }) : _groups = groups;

  @override
  final Village village;
  final List<Group> _groups;
  @override
  List<Group> get groups {
    if (_groups is EqualUnmodifiableListView) return _groups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_groups);
  }

  @override
  String toString() {
    return 'VillageWithGroups(village: $village, groups: $groups)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VillageWithGroupsImpl &&
            (identical(other.village, village) || other.village == village) &&
            const DeepCollectionEquality().equals(other._groups, _groups));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    village,
    const DeepCollectionEquality().hash(_groups),
  );

  /// Create a copy of VillageWithGroups
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VillageWithGroupsImplCopyWith<_$VillageWithGroupsImpl> get copyWith =>
      __$$VillageWithGroupsImplCopyWithImpl<_$VillageWithGroupsImpl>(
        this,
        _$identity,
      );
}

abstract class _VillageWithGroups implements VillageWithGroups {
  const factory _VillageWithGroups({
    required final Village village,
    required final List<Group> groups,
  }) = _$VillageWithGroupsImpl;

  @override
  Village get village;
  @override
  List<Group> get groups;

  /// Create a copy of VillageWithGroups
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VillageWithGroupsImplCopyWith<_$VillageWithGroupsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
