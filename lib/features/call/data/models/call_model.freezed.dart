// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CallModel _$CallModelFromJson(Map<String, dynamic> json) {
  return _CallModel.fromJson(json);
}

/// @nodoc
mixin _$CallModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'callerId')
  String get callerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiverId')
  String get receiverId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'channelName')
  String get channelName => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'accepted_at')
  String? get acceptedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ended_at')
  String? get endedAt => throw _privateConstructorUsedError;
  int? get duration => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CallModelCopyWith<CallModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CallModelCopyWith<$Res> {
  factory $CallModelCopyWith(CallModel value, $Res Function(CallModel) then) =
      _$CallModelCopyWithImpl<$Res, CallModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'callerId') String callerId,
      @JsonKey(name: 'receiverId') String receiverId,
      String type,
      String status,
      @JsonKey(name: 'channelName') String channelName,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'accepted_at') String? acceptedAt,
      @JsonKey(name: 'ended_at') String? endedAt,
      int? duration});
}

/// @nodoc
class _$CallModelCopyWithImpl<$Res, $Val extends CallModel>
    implements $CallModelCopyWith<$Res> {
  _$CallModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? callerId = null,
    Object? receiverId = null,
    Object? type = null,
    Object? status = null,
    Object? channelName = null,
    Object? createdAt = null,
    Object? acceptedAt = freezed,
    Object? endedAt = freezed,
    Object? duration = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      callerId: null == callerId
          ? _value.callerId
          : callerId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      channelName: null == channelName
          ? _value.channelName
          : channelName // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CallModelImplCopyWith<$Res>
    implements $CallModelCopyWith<$Res> {
  factory _$$CallModelImplCopyWith(
          _$CallModelImpl value, $Res Function(_$CallModelImpl) then) =
      __$$CallModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'callerId') String callerId,
      @JsonKey(name: 'receiverId') String receiverId,
      String type,
      String status,
      @JsonKey(name: 'channelName') String channelName,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'accepted_at') String? acceptedAt,
      @JsonKey(name: 'ended_at') String? endedAt,
      int? duration});
}

/// @nodoc
class __$$CallModelImplCopyWithImpl<$Res>
    extends _$CallModelCopyWithImpl<$Res, _$CallModelImpl>
    implements _$$CallModelImplCopyWith<$Res> {
  __$$CallModelImplCopyWithImpl(
      _$CallModelImpl _value, $Res Function(_$CallModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? callerId = null,
    Object? receiverId = null,
    Object? type = null,
    Object? status = null,
    Object? channelName = null,
    Object? createdAt = null,
    Object? acceptedAt = freezed,
    Object? endedAt = freezed,
    Object? duration = freezed,
  }) {
    return _then(_$CallModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      callerId: null == callerId
          ? _value.callerId
          : callerId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      channelName: null == channelName
          ? _value.channelName
          : channelName // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CallModelImpl implements _CallModel {
  const _$CallModelImpl(
      {required this.id,
      @JsonKey(name: 'callerId') required this.callerId,
      @JsonKey(name: 'receiverId') required this.receiverId,
      required this.type,
      required this.status,
      @JsonKey(name: 'channelName') required this.channelName,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'accepted_at') this.acceptedAt,
      @JsonKey(name: 'ended_at') this.endedAt,
      this.duration});

  factory _$CallModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CallModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'callerId')
  final String callerId;
  @override
  @JsonKey(name: 'receiverId')
  final String receiverId;
  @override
  final String type;
  @override
  final String status;
  @override
  @JsonKey(name: 'channelName')
  final String channelName;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'accepted_at')
  final String? acceptedAt;
  @override
  @JsonKey(name: 'ended_at')
  final String? endedAt;
  @override
  final int? duration;

  @override
  String toString() {
    return 'CallModel(id: $id, callerId: $callerId, receiverId: $receiverId, type: $type, status: $status, channelName: $channelName, createdAt: $createdAt, acceptedAt: $acceptedAt, endedAt: $endedAt, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CallModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.callerId, callerId) ||
                other.callerId == callerId) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.channelName, channelName) ||
                other.channelName == channelName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, callerId, receiverId, type,
      status, channelName, createdAt, acceptedAt, endedAt, duration);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CallModelImplCopyWith<_$CallModelImpl> get copyWith =>
      __$$CallModelImplCopyWithImpl<_$CallModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CallModelImplToJson(
      this,
    );
  }
}

abstract class _CallModel implements CallModel {
  const factory _CallModel(
      {required final String id,
      @JsonKey(name: 'callerId') required final String callerId,
      @JsonKey(name: 'receiverId') required final String receiverId,
      required final String type,
      required final String status,
      @JsonKey(name: 'channelName') required final String channelName,
      @JsonKey(name: 'created_at') required final String createdAt,
      @JsonKey(name: 'accepted_at') final String? acceptedAt,
      @JsonKey(name: 'ended_at') final String? endedAt,
      final int? duration}) = _$CallModelImpl;

  factory _CallModel.fromJson(Map<String, dynamic> json) =
      _$CallModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'callerId')
  String get callerId;
  @override
  @JsonKey(name: 'receiverId')
  String get receiverId;
  @override
  String get type;
  @override
  String get status;
  @override
  @JsonKey(name: 'channelName')
  String get channelName;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'accepted_at')
  String? get acceptedAt;
  @override
  @JsonKey(name: 'ended_at')
  String? get endedAt;
  @override
  int? get duration;
  @override
  @JsonKey(ignore: true)
  _$$CallModelImplCopyWith<_$CallModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
