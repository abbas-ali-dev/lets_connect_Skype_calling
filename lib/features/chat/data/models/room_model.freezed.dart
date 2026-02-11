// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RoomModel _$RoomModelFromJson(Map<String, dynamic> json) {
  return _RoomModel.fromJson(json);
}

/// @nodoc
mixin _$RoomModel {
  String get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_group')
  bool get isGroup => throw _privateConstructorUsedError;
  List<ChatUserModel> get members => throw _privateConstructorUsedError;
  @MessageModelConverter()
  @JsonKey(name: 'last_message')
  MessageModel? get lastMessage => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get unreadCount =>
      throw _privateConstructorUsedError; // Group-specific fields
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  String? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'admin_ids')
  List<String> get adminIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_members')
  int? get maxMembers => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoomModelCopyWith<RoomModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomModelCopyWith<$Res> {
  factory $RoomModelCopyWith(RoomModel value, $Res Function(RoomModel) then) =
      _$RoomModelCopyWithImpl<$Res, RoomModel>;
  @useResult
  $Res call(
      {String id,
      String? name,
      @JsonKey(name: 'is_group') bool isGroup,
      List<ChatUserModel> members,
      @MessageModelConverter()
      @JsonKey(name: 'last_message')
      MessageModel? lastMessage,
      @JsonKey(name: 'created_at') DateTime createdAt,
      int unreadCount,
      String? description,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'admin_ids') List<String> adminIds,
      @JsonKey(name: 'max_members') int? maxMembers});

  $MessageModelCopyWith<$Res>? get lastMessage;
}

/// @nodoc
class _$RoomModelCopyWithImpl<$Res, $Val extends RoomModel>
    implements $RoomModelCopyWith<$Res> {
  _$RoomModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? isGroup = null,
    Object? members = null,
    Object? lastMessage = freezed,
    Object? createdAt = null,
    Object? unreadCount = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? createdBy = freezed,
    Object? adminIds = null,
    Object? maxMembers = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      isGroup: null == isGroup
          ? _value.isGroup
          : isGroup // ignore: cast_nullable_to_non_nullable
              as bool,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ChatUserModel>,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as MessageModel?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      adminIds: null == adminIds
          ? _value.adminIds
          : adminIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      maxMembers: freezed == maxMembers
          ? _value.maxMembers
          : maxMembers // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MessageModelCopyWith<$Res>? get lastMessage {
    if (_value.lastMessage == null) {
      return null;
    }

    return $MessageModelCopyWith<$Res>(_value.lastMessage!, (value) {
      return _then(_value.copyWith(lastMessage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RoomModelImplCopyWith<$Res>
    implements $RoomModelCopyWith<$Res> {
  factory _$$RoomModelImplCopyWith(
          _$RoomModelImpl value, $Res Function(_$RoomModelImpl) then) =
      __$$RoomModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? name,
      @JsonKey(name: 'is_group') bool isGroup,
      List<ChatUserModel> members,
      @MessageModelConverter()
      @JsonKey(name: 'last_message')
      MessageModel? lastMessage,
      @JsonKey(name: 'created_at') DateTime createdAt,
      int unreadCount,
      String? description,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'admin_ids') List<String> adminIds,
      @JsonKey(name: 'max_members') int? maxMembers});

  @override
  $MessageModelCopyWith<$Res>? get lastMessage;
}

/// @nodoc
class __$$RoomModelImplCopyWithImpl<$Res>
    extends _$RoomModelCopyWithImpl<$Res, _$RoomModelImpl>
    implements _$$RoomModelImplCopyWith<$Res> {
  __$$RoomModelImplCopyWithImpl(
      _$RoomModelImpl _value, $Res Function(_$RoomModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? isGroup = null,
    Object? members = null,
    Object? lastMessage = freezed,
    Object? createdAt = null,
    Object? unreadCount = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? createdBy = freezed,
    Object? adminIds = null,
    Object? maxMembers = freezed,
  }) {
    return _then(_$RoomModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      isGroup: null == isGroup
          ? _value.isGroup
          : isGroup // ignore: cast_nullable_to_non_nullable
              as bool,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ChatUserModel>,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as MessageModel?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      adminIds: null == adminIds
          ? _value._adminIds
          : adminIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      maxMembers: freezed == maxMembers
          ? _value.maxMembers
          : maxMembers // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoomModelImpl extends _RoomModel {
  const _$RoomModelImpl(
      {required this.id,
      this.name,
      @JsonKey(name: 'is_group') required this.isGroup,
      final List<ChatUserModel> members = const [],
      @MessageModelConverter() @JsonKey(name: 'last_message') this.lastMessage,
      @JsonKey(name: 'created_at') required this.createdAt,
      this.unreadCount = 0,
      this.description,
      @JsonKey(name: 'image_url') this.imageUrl,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'admin_ids') final List<String> adminIds = const [],
      @JsonKey(name: 'max_members') this.maxMembers})
      : _members = members,
        _adminIds = adminIds,
        super._();

  factory _$RoomModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoomModelImplFromJson(json);

  @override
  final String id;
  @override
  final String? name;
  @override
  @JsonKey(name: 'is_group')
  final bool isGroup;
  final List<ChatUserModel> _members;
  @override
  @JsonKey()
  List<ChatUserModel> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  @MessageModelConverter()
  @JsonKey(name: 'last_message')
  final MessageModel? lastMessage;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey()
  final int unreadCount;
// Group-specific fields
  @override
  final String? description;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'created_by')
  final String? createdBy;
  final List<String> _adminIds;
  @override
  @JsonKey(name: 'admin_ids')
  List<String> get adminIds {
    if (_adminIds is EqualUnmodifiableListView) return _adminIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_adminIds);
  }

  @override
  @JsonKey(name: 'max_members')
  final int? maxMembers;

  @override
  String toString() {
    return 'RoomModel(id: $id, name: $name, isGroup: $isGroup, members: $members, lastMessage: $lastMessage, createdAt: $createdAt, unreadCount: $unreadCount, description: $description, imageUrl: $imageUrl, createdBy: $createdBy, adminIds: $adminIds, maxMembers: $maxMembers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isGroup, isGroup) || other.isGroup == isGroup) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            const DeepCollectionEquality().equals(other._adminIds, _adminIds) &&
            (identical(other.maxMembers, maxMembers) ||
                other.maxMembers == maxMembers));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      isGroup,
      const DeepCollectionEquality().hash(_members),
      lastMessage,
      createdAt,
      unreadCount,
      description,
      imageUrl,
      createdBy,
      const DeepCollectionEquality().hash(_adminIds),
      maxMembers);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoomModelImplCopyWith<_$RoomModelImpl> get copyWith =>
      __$$RoomModelImplCopyWithImpl<_$RoomModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoomModelImplToJson(
      this,
    );
  }
}

abstract class _RoomModel extends RoomModel {
  const factory _RoomModel(
      {required final String id,
      final String? name,
      @JsonKey(name: 'is_group') required final bool isGroup,
      final List<ChatUserModel> members,
      @MessageModelConverter()
      @JsonKey(name: 'last_message')
      final MessageModel? lastMessage,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      final int unreadCount,
      final String? description,
      @JsonKey(name: 'image_url') final String? imageUrl,
      @JsonKey(name: 'created_by') final String? createdBy,
      @JsonKey(name: 'admin_ids') final List<String> adminIds,
      @JsonKey(name: 'max_members') final int? maxMembers}) = _$RoomModelImpl;
  const _RoomModel._() : super._();

  factory _RoomModel.fromJson(Map<String, dynamic> json) =
      _$RoomModelImpl.fromJson;

  @override
  String get id;
  @override
  String? get name;
  @override
  @JsonKey(name: 'is_group')
  bool get isGroup;
  @override
  List<ChatUserModel> get members;
  @override
  @MessageModelConverter()
  @JsonKey(name: 'last_message')
  MessageModel? get lastMessage;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  int get unreadCount;
  @override // Group-specific fields
  String? get description;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'created_by')
  String? get createdBy;
  @override
  @JsonKey(name: 'admin_ids')
  List<String> get adminIds;
  @override
  @JsonKey(name: 'max_members')
  int? get maxMembers;
  @override
  @JsonKey(ignore: true)
  _$$RoomModelImplCopyWith<_$RoomModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
