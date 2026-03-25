// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'encouragement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Encouragement _$EncouragementFromJson(Map<String, dynamic> json) {
  return _Encouragement.fromJson(json);
}

/// @nodoc
mixin _$Encouragement {
  String get id => throw _privateConstructorUsedError; // 고유 ID
  String get userId => throw _privateConstructorUsedError; // 작성자 ID
  String get text => throw _privateConstructorUsedError; // 격려 메시지 (최대 100자)
  DateTime get createdAt => throw _privateConstructorUsedError; // 작성일시
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this Encouragement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Encouragement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EncouragementCopyWith<Encouragement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EncouragementCopyWith<$Res> {
  factory $EncouragementCopyWith(
    Encouragement value,
    $Res Function(Encouragement) then,
  ) = _$EncouragementCopyWithImpl<$Res, Encouragement>;
  @useResult
  $Res call({
    String id,
    String userId,
    String text,
    DateTime createdAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class _$EncouragementCopyWithImpl<$Res, $Val extends Encouragement>
    implements $EncouragementCopyWith<$Res> {
  _$EncouragementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Encouragement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? text = null,
    Object? createdAt = null,
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
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
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
abstract class _$$EncouragementImplCopyWith<$Res>
    implements $EncouragementCopyWith<$Res> {
  factory _$$EncouragementImplCopyWith(
    _$EncouragementImpl value,
    $Res Function(_$EncouragementImpl) then,
  ) = __$$EncouragementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String text,
    DateTime createdAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class __$$EncouragementImplCopyWithImpl<$Res>
    extends _$EncouragementCopyWithImpl<$Res, _$EncouragementImpl>
    implements _$$EncouragementImplCopyWith<$Res> {
  __$$EncouragementImplCopyWithImpl(
    _$EncouragementImpl _value,
    $Res Function(_$EncouragementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Encouragement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? text = null,
    Object? createdAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _$EncouragementImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
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
class _$EncouragementImpl implements _Encouragement {
  const _$EncouragementImpl({
    required this.id,
    required this.userId,
    required this.text,
    required this.createdAt,
    this.deletedAt,
  });

  factory _$EncouragementImpl.fromJson(Map<String, dynamic> json) =>
      _$$EncouragementImplFromJson(json);

  @override
  final String id;
  // 고유 ID
  @override
  final String userId;
  // 작성자 ID
  @override
  final String text;
  // 격려 메시지 (최대 100자)
  @override
  final DateTime createdAt;
  // 작성일시
  @override
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'Encouragement(id: $id, userId: $userId, text: $text, createdAt: $createdAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EncouragementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, text, createdAt, deletedAt);

  /// Create a copy of Encouragement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EncouragementImplCopyWith<_$EncouragementImpl> get copyWith =>
      __$$EncouragementImplCopyWithImpl<_$EncouragementImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EncouragementImplToJson(this);
  }
}

abstract class _Encouragement implements Encouragement {
  const factory _Encouragement({
    required final String id,
    required final String userId,
    required final String text,
    required final DateTime createdAt,
    final DateTime? deletedAt,
  }) = _$EncouragementImpl;

  factory _Encouragement.fromJson(Map<String, dynamic> json) =
      _$EncouragementImpl.fromJson;

  @override
  String get id; // 고유 ID
  @override
  String get userId; // 작성자 ID
  @override
  String get text; // 격려 메시지 (최대 100자)
  @override
  DateTime get createdAt; // 작성일시
  @override
  DateTime? get deletedAt;

  /// Create a copy of Encouragement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EncouragementImplCopyWith<_$EncouragementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
