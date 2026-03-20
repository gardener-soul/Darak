// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'church_members_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ChurchMembersState {
  List<ChurchMemberProfile> get members => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  String? get filterRoleId => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;

  /// Create a copy of ChurchMembersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChurchMembersStateCopyWith<ChurchMembersState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChurchMembersStateCopyWith<$Res> {
  factory $ChurchMembersStateCopyWith(
    ChurchMembersState value,
    $Res Function(ChurchMembersState) then,
  ) = _$ChurchMembersStateCopyWithImpl<$Res, ChurchMembersState>;
  @useResult
  $Res call({
    List<ChurchMemberProfile> members,
    bool hasMore,
    String? filterRoleId,
    String searchQuery,
  });
}

/// @nodoc
class _$ChurchMembersStateCopyWithImpl<$Res, $Val extends ChurchMembersState>
    implements $ChurchMembersStateCopyWith<$Res> {
  _$ChurchMembersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChurchMembersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? members = null,
    Object? hasMore = null,
    Object? filterRoleId = freezed,
    Object? searchQuery = null,
  }) {
    return _then(
      _value.copyWith(
            members: null == members
                ? _value.members
                : members // ignore: cast_nullable_to_non_nullable
                      as List<ChurchMemberProfile>,
            hasMore: null == hasMore
                ? _value.hasMore
                : hasMore // ignore: cast_nullable_to_non_nullable
                      as bool,
            filterRoleId: freezed == filterRoleId
                ? _value.filterRoleId
                : filterRoleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            searchQuery: null == searchQuery
                ? _value.searchQuery
                : searchQuery // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChurchMembersStateImplCopyWith<$Res>
    implements $ChurchMembersStateCopyWith<$Res> {
  factory _$$ChurchMembersStateImplCopyWith(
    _$ChurchMembersStateImpl value,
    $Res Function(_$ChurchMembersStateImpl) then,
  ) = __$$ChurchMembersStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<ChurchMemberProfile> members,
    bool hasMore,
    String? filterRoleId,
    String searchQuery,
  });
}

/// @nodoc
class __$$ChurchMembersStateImplCopyWithImpl<$Res>
    extends _$ChurchMembersStateCopyWithImpl<$Res, _$ChurchMembersStateImpl>
    implements _$$ChurchMembersStateImplCopyWith<$Res> {
  __$$ChurchMembersStateImplCopyWithImpl(
    _$ChurchMembersStateImpl _value,
    $Res Function(_$ChurchMembersStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChurchMembersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? members = null,
    Object? hasMore = null,
    Object? filterRoleId = freezed,
    Object? searchQuery = null,
  }) {
    return _then(
      _$ChurchMembersStateImpl(
        members: null == members
            ? _value._members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<ChurchMemberProfile>,
        hasMore: null == hasMore
            ? _value.hasMore
            : hasMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        filterRoleId: freezed == filterRoleId
            ? _value.filterRoleId
            : filterRoleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ChurchMembersStateImpl implements _ChurchMembersState {
  const _$ChurchMembersStateImpl({
    required final List<ChurchMemberProfile> members,
    required this.hasMore,
    this.filterRoleId = null,
    this.searchQuery = '',
  }) : _members = members;

  final List<ChurchMemberProfile> _members;
  @override
  List<ChurchMemberProfile> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  final bool hasMore;
  @override
  @JsonKey()
  final String? filterRoleId;
  @override
  @JsonKey()
  final String searchQuery;

  @override
  String toString() {
    return 'ChurchMembersState(members: $members, hasMore: $hasMore, filterRoleId: $filterRoleId, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChurchMembersStateImpl &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.filterRoleId, filterRoleId) ||
                other.filterRoleId == filterRoleId) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_members),
    hasMore,
    filterRoleId,
    searchQuery,
  );

  /// Create a copy of ChurchMembersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChurchMembersStateImplCopyWith<_$ChurchMembersStateImpl> get copyWith =>
      __$$ChurchMembersStateImplCopyWithImpl<_$ChurchMembersStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ChurchMembersState implements ChurchMembersState {
  const factory _ChurchMembersState({
    required final List<ChurchMemberProfile> members,
    required final bool hasMore,
    final String? filterRoleId,
    final String searchQuery,
  }) = _$ChurchMembersStateImpl;

  @override
  List<ChurchMemberProfile> get members;
  @override
  bool get hasMore;
  @override
  String? get filterRoleId;
  @override
  String get searchQuery;

  /// Create a copy of ChurchMembersState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChurchMembersStateImplCopyWith<_$ChurchMembersStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
