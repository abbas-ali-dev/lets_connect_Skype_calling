// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AttachmentModel _$AttachmentModelFromJson(Map<String, dynamic> json) {
  return _AttachmentModel.fromJson(json);
}

/// @nodoc
mixin _$AttachmentModel {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'message_id')
  String? get messageId => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_name')
  String? get fileName => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_type')
  String? get fileType => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_size')
  int? get fileSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_url')
  String? get fileUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AttachmentModelCopyWith<AttachmentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttachmentModelCopyWith<$Res> {
  factory $AttachmentModelCopyWith(
          AttachmentModel value, $Res Function(AttachmentModel) then) =
      _$AttachmentModelCopyWithImpl<$Res, AttachmentModel>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'message_id') String? messageId,
      @JsonKey(name: 'file_name') String? fileName,
      @JsonKey(name: 'file_type') String? fileType,
      @JsonKey(name: 'file_size') int? fileSize,
      @JsonKey(name: 'file_url') String? fileUrl,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class _$AttachmentModelCopyWithImpl<$Res, $Val extends AttachmentModel>
    implements $AttachmentModelCopyWith<$Res> {
  _$AttachmentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? messageId = freezed,
    Object? fileName = freezed,
    Object? fileType = freezed,
    Object? fileSize = freezed,
    Object? fileUrl = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      messageId: freezed == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      fileType: freezed == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AttachmentModelImplCopyWith<$Res>
    implements $AttachmentModelCopyWith<$Res> {
  factory _$$AttachmentModelImplCopyWith(_$AttachmentModelImpl value,
          $Res Function(_$AttachmentModelImpl) then) =
      __$$AttachmentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'message_id') String? messageId,
      @JsonKey(name: 'file_name') String? fileName,
      @JsonKey(name: 'file_type') String? fileType,
      @JsonKey(name: 'file_size') int? fileSize,
      @JsonKey(name: 'file_url') String? fileUrl,
      @JsonKey(name: 'created_at') String? createdAt});
}

/// @nodoc
class __$$AttachmentModelImplCopyWithImpl<$Res>
    extends _$AttachmentModelCopyWithImpl<$Res, _$AttachmentModelImpl>
    implements _$$AttachmentModelImplCopyWith<$Res> {
  __$$AttachmentModelImplCopyWithImpl(
      _$AttachmentModelImpl _value, $Res Function(_$AttachmentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? messageId = freezed,
    Object? fileName = freezed,
    Object? fileType = freezed,
    Object? fileSize = freezed,
    Object? fileUrl = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$AttachmentModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      messageId: freezed == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      fileType: freezed == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AttachmentModelImpl extends _AttachmentModel {
  const _$AttachmentModelImpl(
      {this.id,
      @JsonKey(name: 'message_id') this.messageId,
      @JsonKey(name: 'file_name') this.fileName,
      @JsonKey(name: 'file_type') this.fileType,
      @JsonKey(name: 'file_size') this.fileSize,
      @JsonKey(name: 'file_url') this.fileUrl,
      @JsonKey(name: 'created_at') this.createdAt})
      : super._();

  factory _$AttachmentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttachmentModelImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'message_id')
  final String? messageId;
  @override
  @JsonKey(name: 'file_name')
  final String? fileName;
  @override
  @JsonKey(name: 'file_type')
  final String? fileType;
  @override
  @JsonKey(name: 'file_size')
  final int? fileSize;
  @override
  @JsonKey(name: 'file_url')
  final String? fileUrl;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'AttachmentModel(id: $id, messageId: $messageId, fileName: $fileName, fileType: $fileType, fileSize: $fileSize, fileUrl: $fileUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttachmentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileType, fileType) ||
                other.fileType == fileType) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, messageId, fileName,
      fileType, fileSize, fileUrl, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AttachmentModelImplCopyWith<_$AttachmentModelImpl> get copyWith =>
      __$$AttachmentModelImplCopyWithImpl<_$AttachmentModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttachmentModelImplToJson(
      this,
    );
  }
}

abstract class _AttachmentModel extends AttachmentModel {
  const factory _AttachmentModel(
          {final String? id,
          @JsonKey(name: 'message_id') final String? messageId,
          @JsonKey(name: 'file_name') final String? fileName,
          @JsonKey(name: 'file_type') final String? fileType,
          @JsonKey(name: 'file_size') final int? fileSize,
          @JsonKey(name: 'file_url') final String? fileUrl,
          @JsonKey(name: 'created_at') final String? createdAt}) =
      _$AttachmentModelImpl;
  const _AttachmentModel._() : super._();

  factory _AttachmentModel.fromJson(Map<String, dynamic> json) =
      _$AttachmentModelImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'message_id')
  String? get messageId;
  @override
  @JsonKey(name: 'file_name')
  String? get fileName;
  @override
  @JsonKey(name: 'file_type')
  String? get fileType;
  @override
  @JsonKey(name: 'file_size')
  int? get fileSize;
  @override
  @JsonKey(name: 'file_url')
  String? get fileUrl;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$AttachmentModelImplCopyWith<_$AttachmentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
