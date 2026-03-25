// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MemberNote _$MemberNoteFromJson(Map<String, dynamic> json) {
  return _MemberNote.fromJson(json);
}

/// @nodoc
mixin _$MemberNote {
  String get id => throw _privateConstructorUsedError; // Firestore document ID
  String get userId => throw _privateConstructorUsedError; // 메모 대상 순원의 userId
  String get content => throw _privateConstructorUsedError; // 메모 본문 (최대 500자)
  String get createdBy => throw _privateConstructorUsedError; // 메모 작성자 userId
  DateTime? get createdAt =>
      throw _privateConstructorUsedError; // serverTimestamp 대기 중 null 가능
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // serverTimestamp 대기 중 null 가능
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this MemberNote to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberNoteCopyWith<MemberNote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberNoteCopyWith<$Res> {
  factory $MemberNoteCopyWith(
    MemberNote value,
    $Res Function(MemberNote) then,
  ) = _$MemberNoteCopyWithImpl<$Res, MemberNote>;
  @useResult
  $Res call({
    String id,
    String userId,
    String content,
    String createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class _$MemberNoteCopyWithImpl<$Res, $Val extends MemberNote>
    implements $MemberNoteCopyWith<$Res> {
  _$MemberNoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? content = null,
    Object? createdBy = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            createdBy: null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
abstract class _$$MemberNoteImplCopyWith<$Res>
    implements $MemberNoteCopyWith<$Res> {
  factory _$$MemberNoteImplCopyWith(
    _$MemberNoteImpl value,
    $Res Function(_$MemberNoteImpl) then,
  ) = __$$MemberNoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String content,
    String createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  });
}

/// @nodoc
class __$$MemberNoteImplCopyWithImpl<$Res>
    extends _$MemberNoteCopyWithImpl<$Res, _$MemberNoteImpl>
    implements _$$MemberNoteImplCopyWith<$Res> {
  __$$MemberNoteImplCopyWithImpl(
    _$MemberNoteImpl _value,
    $Res Function(_$MemberNoteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MemberNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? content = null,
    Object? createdBy = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _$MemberNoteImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
class _$MemberNoteImpl implements _MemberNote {
  const _$MemberNoteImpl({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory _$MemberNoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberNoteImplFromJson(json);

  @override
  final String id;
  // Firestore document ID
  @override
  final String userId;
  // 메모 대상 순원의 userId
  @override
  final String content;
  // 메모 본문 (최대 500자)
  @override
  final String createdBy;
  // 메모 작성자 userId
  @override
  final DateTime? createdAt;
  // serverTimestamp 대기 중 null 가능
  @override
  final DateTime? updatedAt;
  // serverTimestamp 대기 중 null 가능
  @override
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'MemberNote(id: $id, userId: $userId, content: $content, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberNoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.content, content) || other.content == content) &&
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
    userId,
    content,
    createdBy,
    createdAt,
    updatedAt,
    deletedAt,
  );

  /// Create a copy of MemberNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberNoteImplCopyWith<_$MemberNoteImpl> get copyWith =>
      __$$MemberNoteImplCopyWithImpl<_$MemberNoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberNoteImplToJson(this);
  }
}

abstract class _MemberNote implements MemberNote {
  const factory _MemberNote({
    required final String id,
    required final String userId,
    required final String content,
    required final String createdBy,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final DateTime? deletedAt,
  }) = _$MemberNoteImpl;

  factory _MemberNote.fromJson(Map<String, dynamic> json) =
      _$MemberNoteImpl.fromJson;

  @override
  String get id; // Firestore document ID
  @override
  String get userId; // 메모 대상 순원의 userId
  @override
  String get content; // 메모 본문 (최대 500자)
  @override
  String get createdBy; // 메모 작성자 userId
  @override
  DateTime? get createdAt; // serverTimestamp 대기 중 null 가능
  @override
  DateTime? get updatedAt; // serverTimestamp 대기 중 null 가능
  @override
  DateTime? get deletedAt;

  /// Create a copy of MemberNote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberNoteImplCopyWith<_$MemberNoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
