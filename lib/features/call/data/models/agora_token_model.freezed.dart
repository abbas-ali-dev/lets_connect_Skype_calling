// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agora_token_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AgoraTokenModel _$AgoraTokenModelFromJson(Map<String, dynamic> json) {
  return _AgoraTokenModel.fromJson(json);
}

/// @nodoc
mixin _$AgoraTokenModel {
  String get token => throw _privateConstructorUsedError;
  String get channel => throw _privateConstructorUsedError;
  @JsonKey(name: 'channelName')
  String? get channelName => throw _privateConstructorUsedError;
  int get uid => throw _privateConstructorUsedError;
  List<CallLanguageModel>? get languages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AgoraTokenModelCopyWith<AgoraTokenModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgoraTokenModelCopyWith<$Res> {
  factory $AgoraTokenModelCopyWith(
          AgoraTokenModel value, $Res Function(AgoraTokenModel) then) =
      _$AgoraTokenModelCopyWithImpl<$Res, AgoraTokenModel>;
  @useResult
  $Res call(
      {String token,
      String channel,
      @JsonKey(name: 'channelName') String? channelName,
      int uid,
      List<CallLanguageModel>? languages});
}

/// @nodoc
class _$AgoraTokenModelCopyWithImpl<$Res, $Val extends AgoraTokenModel>
    implements $AgoraTokenModelCopyWith<$Res> {
  _$AgoraTokenModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? channel = null,
    Object? channelName = freezed,
    Object? uid = null,
    Object? languages = freezed,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String,
      channelName: freezed == channelName
          ? _value.channelName
          : channelName // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as int,
      languages: freezed == languages
          ? _value.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<CallLanguageModel>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AgoraTokenModelImplCopyWith<$Res>
    implements $AgoraTokenModelCopyWith<$Res> {
  factory _$$AgoraTokenModelImplCopyWith(_$AgoraTokenModelImpl value,
          $Res Function(_$AgoraTokenModelImpl) then) =
      __$$AgoraTokenModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String token,
      String channel,
      @JsonKey(name: 'channelName') String? channelName,
      int uid,
      List<CallLanguageModel>? languages});
}

/// @nodoc
class __$$AgoraTokenModelImplCopyWithImpl<$Res>
    extends _$AgoraTokenModelCopyWithImpl<$Res, _$AgoraTokenModelImpl>
    implements _$$AgoraTokenModelImplCopyWith<$Res> {
  __$$AgoraTokenModelImplCopyWithImpl(
      _$AgoraTokenModelImpl _value, $Res Function(_$AgoraTokenModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? channel = null,
    Object? channelName = freezed,
    Object? uid = null,
    Object? languages = freezed,
  }) {
    return _then(_$AgoraTokenModelImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String,
      channelName: freezed == channelName
          ? _value.channelName
          : channelName // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as int,
      languages: freezed == languages
          ? _value._languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<CallLanguageModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AgoraTokenModelImpl implements _AgoraTokenModel {
  const _$AgoraTokenModelImpl(
      {required this.token,
      required this.channel,
      @JsonKey(name: 'channelName') this.channelName,
      required this.uid,
      final List<CallLanguageModel>? languages})
      : _languages = languages;

  factory _$AgoraTokenModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AgoraTokenModelImplFromJson(json);

  @override
  final String token;
  @override
  final String channel;
  @override
  @JsonKey(name: 'channelName')
  final String? channelName;
  @override
  final int uid;
  final List<CallLanguageModel>? _languages;
  @override
  List<CallLanguageModel>? get languages {
    final value = _languages;
    if (value == null) return null;
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'AgoraTokenModel(token: $token, channel: $channel, channelName: $channelName, uid: $uid, languages: $languages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgoraTokenModelImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.channelName, channelName) ||
                other.channelName == channelName) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            const DeepCollectionEquality()
                .equals(other._languages, _languages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, token, channel, channelName, uid,
      const DeepCollectionEquality().hash(_languages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AgoraTokenModelImplCopyWith<_$AgoraTokenModelImpl> get copyWith =>
      __$$AgoraTokenModelImplCopyWithImpl<_$AgoraTokenModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AgoraTokenModelImplToJson(
      this,
    );
  }
}

abstract class _AgoraTokenModel implements AgoraTokenModel {
  const factory _AgoraTokenModel(
      {required final String token,
      required final String channel,
      @JsonKey(name: 'channelName') final String? channelName,
      required final int uid,
      final List<CallLanguageModel>? languages}) = _$AgoraTokenModelImpl;

  factory _AgoraTokenModel.fromJson(Map<String, dynamic> json) =
      _$AgoraTokenModelImpl.fromJson;

  @override
  String get token;
  @override
  String get channel;
  @override
  @JsonKey(name: 'channelName')
  String? get channelName;
  @override
  int get uid;
  @override
  List<CallLanguageModel>? get languages;
  @override
  @JsonKey(ignore: true)
  _$$AgoraTokenModelImplCopyWith<_$AgoraTokenModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CallLanguageModel _$CallLanguageModelFromJson(Map<String, dynamic> json) {
  return _CallLanguageModel.fromJson(json);
}

/// @nodoc
mixin _$CallLanguageModel {
  @JsonKey(name: 'call_id')
  String get callId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'input_lang')
  String get inputLang => throw _privateConstructorUsedError;
  @JsonKey(name: 'output_lang')
  String get outputLang => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CallLanguageModelCopyWith<CallLanguageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CallLanguageModelCopyWith<$Res> {
  factory $CallLanguageModelCopyWith(
          CallLanguageModel value, $Res Function(CallLanguageModel) then) =
      _$CallLanguageModelCopyWithImpl<$Res, CallLanguageModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'call_id') String callId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'input_lang') String inputLang,
      @JsonKey(name: 'output_lang') String outputLang});
}

/// @nodoc
class _$CallLanguageModelCopyWithImpl<$Res, $Val extends CallLanguageModel>
    implements $CallLanguageModelCopyWith<$Res> {
  _$CallLanguageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callId = null,
    Object? userId = null,
    Object? inputLang = null,
    Object? outputLang = null,
  }) {
    return _then(_value.copyWith(
      callId: null == callId
          ? _value.callId
          : callId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      inputLang: null == inputLang
          ? _value.inputLang
          : inputLang // ignore: cast_nullable_to_non_nullable
              as String,
      outputLang: null == outputLang
          ? _value.outputLang
          : outputLang // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CallLanguageModelImplCopyWith<$Res>
    implements $CallLanguageModelCopyWith<$Res> {
  factory _$$CallLanguageModelImplCopyWith(_$CallLanguageModelImpl value,
          $Res Function(_$CallLanguageModelImpl) then) =
      __$$CallLanguageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'call_id') String callId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'input_lang') String inputLang,
      @JsonKey(name: 'output_lang') String outputLang});
}

/// @nodoc
class __$$CallLanguageModelImplCopyWithImpl<$Res>
    extends _$CallLanguageModelCopyWithImpl<$Res, _$CallLanguageModelImpl>
    implements _$$CallLanguageModelImplCopyWith<$Res> {
  __$$CallLanguageModelImplCopyWithImpl(_$CallLanguageModelImpl _value,
      $Res Function(_$CallLanguageModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callId = null,
    Object? userId = null,
    Object? inputLang = null,
    Object? outputLang = null,
  }) {
    return _then(_$CallLanguageModelImpl(
      callId: null == callId
          ? _value.callId
          : callId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      inputLang: null == inputLang
          ? _value.inputLang
          : inputLang // ignore: cast_nullable_to_non_nullable
              as String,
      outputLang: null == outputLang
          ? _value.outputLang
          : outputLang // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CallLanguageModelImpl implements _CallLanguageModel {
  const _$CallLanguageModelImpl(
      {@JsonKey(name: 'call_id') required this.callId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'input_lang') required this.inputLang,
      @JsonKey(name: 'output_lang') required this.outputLang});

  factory _$CallLanguageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CallLanguageModelImplFromJson(json);

  @override
  @JsonKey(name: 'call_id')
  final String callId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'input_lang')
  final String inputLang;
  @override
  @JsonKey(name: 'output_lang')
  final String outputLang;

  @override
  String toString() {
    return 'CallLanguageModel(callId: $callId, userId: $userId, inputLang: $inputLang, outputLang: $outputLang)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CallLanguageModelImpl &&
            (identical(other.callId, callId) || other.callId == callId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.inputLang, inputLang) ||
                other.inputLang == inputLang) &&
            (identical(other.outputLang, outputLang) ||
                other.outputLang == outputLang));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, callId, userId, inputLang, outputLang);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CallLanguageModelImplCopyWith<_$CallLanguageModelImpl> get copyWith =>
      __$$CallLanguageModelImplCopyWithImpl<_$CallLanguageModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CallLanguageModelImplToJson(
      this,
    );
  }
}

abstract class _CallLanguageModel implements CallLanguageModel {
  const factory _CallLanguageModel(
          {@JsonKey(name: 'call_id') required final String callId,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'input_lang') required final String inputLang,
          @JsonKey(name: 'output_lang') required final String outputLang}) =
      _$CallLanguageModelImpl;

  factory _CallLanguageModel.fromJson(Map<String, dynamic> json) =
      _$CallLanguageModelImpl.fromJson;

  @override
  @JsonKey(name: 'call_id')
  String get callId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'input_lang')
  String get inputLang;
  @override
  @JsonKey(name: 'output_lang')
  String get outputLang;
  @override
  @JsonKey(ignore: true)
  _$$CallLanguageModelImplCopyWith<_$CallLanguageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
