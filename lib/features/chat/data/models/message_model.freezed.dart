// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return _MessageModel.fromJson(json);
}

/// @nodoc
mixin _$MessageModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'room_id')
  String get roomId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sender_id')
  String get senderId => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  @UtcDateTimeConverter()
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_attachments')
  bool get hasAttachments => throw _privateConstructorUsedError;
  @JsonKey(name: 'message_attachments')
  List<AttachmentModel> get attachments => throw _privateConstructorUsedError;
  ChatUserModel? get sender =>
      throw _privateConstructorUsedError; // API returns sender info in 'sender' field
  bool get isRead => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageModelCopyWith<MessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageModelCopyWith<$Res> {
  factory $MessageModelCopyWith(
          MessageModel value, $Res Function(MessageModel) then) =
      _$MessageModelCopyWithImpl<$Res, MessageModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'room_id') String roomId,
      @JsonKey(name: 'sender_id') String senderId,
      String message,
      @UtcDateTimeConverter() @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'has_attachments') bool hasAttachments,
      @JsonKey(name: 'message_attachments') List<AttachmentModel> attachments,
      ChatUserModel? sender,
      bool isRead});

  $ChatUserModelCopyWith<$Res>? get sender;
}

/// @nodoc
class _$MessageModelCopyWithImpl<$Res, $Val extends MessageModel>
    implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? roomId = null,
    Object? senderId = null,
    Object? message = null,
    Object? createdAt = null,
    Object? hasAttachments = null,
    Object? attachments = null,
    Object? sender = freezed,
    Object? isRead = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      hasAttachments: null == hasAttachments
          ? _value.hasAttachments
          : hasAttachments // ignore: cast_nullable_to_non_nullable
              as bool,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<AttachmentModel>,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as ChatUserModel?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ChatUserModelCopyWith<$Res>? get sender {
    if (_value.sender == null) {
      return null;
    }

    return $ChatUserModelCopyWith<$Res>(_value.sender!, (value) {
      return _then(_value.copyWith(sender: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageModelImplCopyWith<$Res>
    implements $MessageModelCopyWith<$Res> {
  factory _$$MessageModelImplCopyWith(
          _$MessageModelImpl value, $Res Function(_$MessageModelImpl) then) =
      __$$MessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'room_id') String roomId,
      @JsonKey(name: 'sender_id') String senderId,
      String message,
      @UtcDateTimeConverter() @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'has_attachments') bool hasAttachments,
      @JsonKey(name: 'message_attachments') List<AttachmentModel> attachments,
      ChatUserModel? sender,
      bool isRead});

  @override
  $ChatUserModelCopyWith<$Res>? get sender;
}

/// @nodoc
class __$$MessageModelImplCopyWithImpl<$Res>
    extends _$MessageModelCopyWithImpl<$Res, _$MessageModelImpl>
    implements _$$MessageModelImplCopyWith<$Res> {
  __$$MessageModelImplCopyWithImpl(
      _$MessageModelImpl _value, $Res Function(_$MessageModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? roomId = null,
    Object? senderId = null,
    Object? message = null,
    Object? createdAt = null,
    Object? hasAttachments = null,
    Object? attachments = null,
    Object? sender = freezed,
    Object? isRead = null,
  }) {
    return _then(_$MessageModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      hasAttachments: null == hasAttachments
          ? _value.hasAttachments
          : hasAttachments // ignore: cast_nullable_to_non_nullable
              as bool,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<AttachmentModel>,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as ChatUserModel?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageModelImpl extends _MessageModel {
  const _$MessageModelImpl(
      {required this.id,
      @JsonKey(name: 'room_id') required this.roomId,
      @JsonKey(name: 'sender_id') required this.senderId,
      required this.message,
      @UtcDateTimeConverter()
      @JsonKey(name: 'created_at')
      required this.createdAt,
      @JsonKey(name: 'has_attachments') this.hasAttachments = false,
      @JsonKey(name: 'message_attachments')
      final List<AttachmentModel> attachments = const [],
      this.sender,
      this.isRead = false})
      : _attachments = attachments,
        super._();

  factory _$MessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'room_id')
  final String roomId;
  @override
  @JsonKey(name: 'sender_id')
  final String senderId;
  @override
  final String message;
  @override
  @UtcDateTimeConverter()
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'has_attachments')
  final bool hasAttachments;
  final List<AttachmentModel> _attachments;
  @override
  @JsonKey(name: 'message_attachments')
  List<AttachmentModel> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  final ChatUserModel? sender;
// API returns sender info in 'sender' field
  @override
  @JsonKey()
  final bool isRead;

  @override
  String toString() {
    return 'MessageModel(id: $id, roomId: $roomId, senderId: $senderId, message: $message, createdAt: $createdAt, hasAttachments: $hasAttachments, attachments: $attachments, sender: $sender, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.hasAttachments, hasAttachments) ||
                other.hasAttachments == hasAttachments) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.isRead, isRead) || other.isRead == isRead));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      roomId,
      senderId,
      message,
      createdAt,
      hasAttachments,
      const DeepCollectionEquality().hash(_attachments),
      sender,
      isRead);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      __$$MessageModelImplCopyWithImpl<_$MessageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageModelImplToJson(
      this,
    );
  }
}

abstract class _MessageModel extends MessageModel {
  const factory _MessageModel(
      {required final String id,
      @JsonKey(name: 'room_id') required final String roomId,
      @JsonKey(name: 'sender_id') required final String senderId,
      required final String message,
      @UtcDateTimeConverter()
      @JsonKey(name: 'created_at')
      required final DateTime createdAt,
      @JsonKey(name: 'has_attachments') final bool hasAttachments,
      @JsonKey(name: 'message_attachments')
      final List<AttachmentModel> attachments,
      final ChatUserModel? sender,
      final bool isRead}) = _$MessageModelImpl;
  const _MessageModel._() : super._();

  factory _MessageModel.fromJson(Map<String, dynamic> json) =
      _$MessageModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'room_id')
  String get roomId;
  @override
  @JsonKey(name: 'sender_id')
  String get senderId;
  @override
  String get message;
  @override
  @UtcDateTimeConverter()
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'has_attachments')
  bool get hasAttachments;
  @override
  @JsonKey(name: 'message_attachments')
  List<AttachmentModel> get attachments;
  @override
  ChatUserModel? get sender;
  @override // API returns sender info in 'sender' field
  bool get isRead;
  @override
  @JsonKey(ignore: true)
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
