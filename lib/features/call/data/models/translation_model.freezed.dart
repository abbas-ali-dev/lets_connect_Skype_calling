// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'translation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TranslationModel _$TranslationModelFromJson(Map<String, dynamic> json) {
  return _TranslationModel.fromJson(json);
}

/// @nodoc
mixin _$TranslationModel {
  String get original => throw _privateConstructorUsedError;
  String get translated => throw _privateConstructorUsedError;
  String get source_language => throw _privateConstructorUsedError;
  String get target_language => throw _privateConstructorUsedError;
  String get provider => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TranslationModelCopyWith<TranslationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranslationModelCopyWith<$Res> {
  factory $TranslationModelCopyWith(
          TranslationModel value, $Res Function(TranslationModel) then) =
      _$TranslationModelCopyWithImpl<$Res, TranslationModel>;
  @useResult
  $Res call(
      {String original,
      String translated,
      String source_language,
      String target_language,
      String provider,
      int timestamp});
}

/// @nodoc
class _$TranslationModelCopyWithImpl<$Res, $Val extends TranslationModel>
    implements $TranslationModelCopyWith<$Res> {
  _$TranslationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? original = null,
    Object? translated = null,
    Object? source_language = null,
    Object? target_language = null,
    Object? provider = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      original: null == original
          ? _value.original
          : original // ignore: cast_nullable_to_non_nullable
              as String,
      translated: null == translated
          ? _value.translated
          : translated // ignore: cast_nullable_to_non_nullable
              as String,
      source_language: null == source_language
          ? _value.source_language
          : source_language // ignore: cast_nullable_to_non_nullable
              as String,
      target_language: null == target_language
          ? _value.target_language
          : target_language // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TranslationModelImplCopyWith<$Res>
    implements $TranslationModelCopyWith<$Res> {
  factory _$$TranslationModelImplCopyWith(_$TranslationModelImpl value,
          $Res Function(_$TranslationModelImpl) then) =
      __$$TranslationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String original,
      String translated,
      String source_language,
      String target_language,
      String provider,
      int timestamp});
}

/// @nodoc
class __$$TranslationModelImplCopyWithImpl<$Res>
    extends _$TranslationModelCopyWithImpl<$Res, _$TranslationModelImpl>
    implements _$$TranslationModelImplCopyWith<$Res> {
  __$$TranslationModelImplCopyWithImpl(_$TranslationModelImpl _value,
      $Res Function(_$TranslationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? original = null,
    Object? translated = null,
    Object? source_language = null,
    Object? target_language = null,
    Object? provider = null,
    Object? timestamp = null,
  }) {
    return _then(_$TranslationModelImpl(
      original: null == original
          ? _value.original
          : original // ignore: cast_nullable_to_non_nullable
              as String,
      translated: null == translated
          ? _value.translated
          : translated // ignore: cast_nullable_to_non_nullable
              as String,
      source_language: null == source_language
          ? _value.source_language
          : source_language // ignore: cast_nullable_to_non_nullable
              as String,
      target_language: null == target_language
          ? _value.target_language
          : target_language // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TranslationModelImpl implements _TranslationModel {
  const _$TranslationModelImpl(
      {required this.original,
      required this.translated,
      required this.source_language,
      required this.target_language,
      required this.provider,
      required this.timestamp});

  factory _$TranslationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TranslationModelImplFromJson(json);

  @override
  final String original;
  @override
  final String translated;
  @override
  final String source_language;
  @override
  final String target_language;
  @override
  final String provider;
  @override
  final int timestamp;

  @override
  String toString() {
    return 'TranslationModel(original: $original, translated: $translated, source_language: $source_language, target_language: $target_language, provider: $provider, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranslationModelImpl &&
            (identical(other.original, original) ||
                other.original == original) &&
            (identical(other.translated, translated) ||
                other.translated == translated) &&
            (identical(other.source_language, source_language) ||
                other.source_language == source_language) &&
            (identical(other.target_language, target_language) ||
                other.target_language == target_language) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, original, translated,
      source_language, target_language, provider, timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TranslationModelImplCopyWith<_$TranslationModelImpl> get copyWith =>
      __$$TranslationModelImplCopyWithImpl<_$TranslationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TranslationModelImplToJson(
      this,
    );
  }
}

abstract class _TranslationModel implements TranslationModel {
  const factory _TranslationModel(
      {required final String original,
      required final String translated,
      required final String source_language,
      required final String target_language,
      required final String provider,
      required final int timestamp}) = _$TranslationModelImpl;

  factory _TranslationModel.fromJson(Map<String, dynamic> json) =
      _$TranslationModelImpl.fromJson;

  @override
  String get original;
  @override
  String get translated;
  @override
  String get source_language;
  @override
  String get target_language;
  @override
  String get provider;
  @override
  int get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$TranslationModelImplCopyWith<_$TranslationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CallTranslationModel _$CallTranslationModelFromJson(Map<String, dynamic> json) {
  return _CallTranslationModel.fromJson(json);
}

/// @nodoc
mixin _$CallTranslationModel {
  String get callId => throw _privateConstructorUsedError;
  String get speakerId => throw _privateConstructorUsedError;
  String get original => throw _privateConstructorUsedError;
  Map<String, dynamic> get translations => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CallTranslationModelCopyWith<CallTranslationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CallTranslationModelCopyWith<$Res> {
  factory $CallTranslationModelCopyWith(CallTranslationModel value,
          $Res Function(CallTranslationModel) then) =
      _$CallTranslationModelCopyWithImpl<$Res, CallTranslationModel>;
  @useResult
  $Res call(
      {String callId,
      String speakerId,
      String original,
      Map<String, dynamic> translations,
      int timestamp});
}

/// @nodoc
class _$CallTranslationModelCopyWithImpl<$Res,
        $Val extends CallTranslationModel>
    implements $CallTranslationModelCopyWith<$Res> {
  _$CallTranslationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callId = null,
    Object? speakerId = null,
    Object? original = null,
    Object? translations = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      callId: null == callId
          ? _value.callId
          : callId // ignore: cast_nullable_to_non_nullable
              as String,
      speakerId: null == speakerId
          ? _value.speakerId
          : speakerId // ignore: cast_nullable_to_non_nullable
              as String,
      original: null == original
          ? _value.original
          : original // ignore: cast_nullable_to_non_nullable
              as String,
      translations: null == translations
          ? _value.translations
          : translations // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CallTranslationModelImplCopyWith<$Res>
    implements $CallTranslationModelCopyWith<$Res> {
  factory _$$CallTranslationModelImplCopyWith(_$CallTranslationModelImpl value,
          $Res Function(_$CallTranslationModelImpl) then) =
      __$$CallTranslationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String callId,
      String speakerId,
      String original,
      Map<String, dynamic> translations,
      int timestamp});
}

/// @nodoc
class __$$CallTranslationModelImplCopyWithImpl<$Res>
    extends _$CallTranslationModelCopyWithImpl<$Res, _$CallTranslationModelImpl>
    implements _$$CallTranslationModelImplCopyWith<$Res> {
  __$$CallTranslationModelImplCopyWithImpl(_$CallTranslationModelImpl _value,
      $Res Function(_$CallTranslationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callId = null,
    Object? speakerId = null,
    Object? original = null,
    Object? translations = null,
    Object? timestamp = null,
  }) {
    return _then(_$CallTranslationModelImpl(
      callId: null == callId
          ? _value.callId
          : callId // ignore: cast_nullable_to_non_nullable
              as String,
      speakerId: null == speakerId
          ? _value.speakerId
          : speakerId // ignore: cast_nullable_to_non_nullable
              as String,
      original: null == original
          ? _value.original
          : original // ignore: cast_nullable_to_non_nullable
              as String,
      translations: null == translations
          ? _value._translations
          : translations // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CallTranslationModelImpl implements _CallTranslationModel {
  const _$CallTranslationModelImpl(
      {required this.callId,
      required this.speakerId,
      required this.original,
      required final Map<String, dynamic> translations,
      required this.timestamp})
      : _translations = translations;

  factory _$CallTranslationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CallTranslationModelImplFromJson(json);

  @override
  final String callId;
  @override
  final String speakerId;
  @override
  final String original;
  final Map<String, dynamic> _translations;
  @override
  Map<String, dynamic> get translations {
    if (_translations is EqualUnmodifiableMapView) return _translations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_translations);
  }

  @override
  final int timestamp;

  @override
  String toString() {
    return 'CallTranslationModel(callId: $callId, speakerId: $speakerId, original: $original, translations: $translations, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CallTranslationModelImpl &&
            (identical(other.callId, callId) || other.callId == callId) &&
            (identical(other.speakerId, speakerId) ||
                other.speakerId == speakerId) &&
            (identical(other.original, original) ||
                other.original == original) &&
            const DeepCollectionEquality()
                .equals(other._translations, _translations) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, callId, speakerId, original,
      const DeepCollectionEquality().hash(_translations), timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CallTranslationModelImplCopyWith<_$CallTranslationModelImpl>
      get copyWith =>
          __$$CallTranslationModelImplCopyWithImpl<_$CallTranslationModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CallTranslationModelImplToJson(
      this,
    );
  }
}

abstract class _CallTranslationModel implements CallTranslationModel {
  const factory _CallTranslationModel(
      {required final String callId,
      required final String speakerId,
      required final String original,
      required final Map<String, dynamic> translations,
      required final int timestamp}) = _$CallTranslationModelImpl;

  factory _CallTranslationModel.fromJson(Map<String, dynamic> json) =
      _$CallTranslationModelImpl.fromJson;

  @override
  String get callId;
  @override
  String get speakerId;
  @override
  String get original;
  @override
  Map<String, dynamic> get translations;
  @override
  int get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$CallTranslationModelImplCopyWith<_$CallTranslationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

LanguagePreferenceModel _$LanguagePreferenceModelFromJson(
    Map<String, dynamic> json) {
  return _LanguagePreferenceModel.fromJson(json);
}

/// @nodoc
mixin _$LanguagePreferenceModel {
  String get callId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get inputLang => throw _privateConstructorUsedError;
  String get outputLang => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LanguagePreferenceModelCopyWith<LanguagePreferenceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LanguagePreferenceModelCopyWith<$Res> {
  factory $LanguagePreferenceModelCopyWith(LanguagePreferenceModel value,
          $Res Function(LanguagePreferenceModel) then) =
      _$LanguagePreferenceModelCopyWithImpl<$Res, LanguagePreferenceModel>;
  @useResult
  $Res call(
      {String callId, String userId, String inputLang, String outputLang});
}

/// @nodoc
class _$LanguagePreferenceModelCopyWithImpl<$Res,
        $Val extends LanguagePreferenceModel>
    implements $LanguagePreferenceModelCopyWith<$Res> {
  _$LanguagePreferenceModelCopyWithImpl(this._value, this._then);

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
abstract class _$$LanguagePreferenceModelImplCopyWith<$Res>
    implements $LanguagePreferenceModelCopyWith<$Res> {
  factory _$$LanguagePreferenceModelImplCopyWith(
          _$LanguagePreferenceModelImpl value,
          $Res Function(_$LanguagePreferenceModelImpl) then) =
      __$$LanguagePreferenceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String callId, String userId, String inputLang, String outputLang});
}

/// @nodoc
class __$$LanguagePreferenceModelImplCopyWithImpl<$Res>
    extends _$LanguagePreferenceModelCopyWithImpl<$Res,
        _$LanguagePreferenceModelImpl>
    implements _$$LanguagePreferenceModelImplCopyWith<$Res> {
  __$$LanguagePreferenceModelImplCopyWithImpl(
      _$LanguagePreferenceModelImpl _value,
      $Res Function(_$LanguagePreferenceModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callId = null,
    Object? userId = null,
    Object? inputLang = null,
    Object? outputLang = null,
  }) {
    return _then(_$LanguagePreferenceModelImpl(
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
class _$LanguagePreferenceModelImpl implements _LanguagePreferenceModel {
  const _$LanguagePreferenceModelImpl(
      {required this.callId,
      required this.userId,
      required this.inputLang,
      required this.outputLang});

  factory _$LanguagePreferenceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LanguagePreferenceModelImplFromJson(json);

  @override
  final String callId;
  @override
  final String userId;
  @override
  final String inputLang;
  @override
  final String outputLang;

  @override
  String toString() {
    return 'LanguagePreferenceModel(callId: $callId, userId: $userId, inputLang: $inputLang, outputLang: $outputLang)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LanguagePreferenceModelImpl &&
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
  _$$LanguagePreferenceModelImplCopyWith<_$LanguagePreferenceModelImpl>
      get copyWith => __$$LanguagePreferenceModelImplCopyWithImpl<
          _$LanguagePreferenceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LanguagePreferenceModelImplToJson(
      this,
    );
  }
}

abstract class _LanguagePreferenceModel implements LanguagePreferenceModel {
  const factory _LanguagePreferenceModel(
      {required final String callId,
      required final String userId,
      required final String inputLang,
      required final String outputLang}) = _$LanguagePreferenceModelImpl;

  factory _LanguagePreferenceModel.fromJson(Map<String, dynamic> json) =
      _$LanguagePreferenceModelImpl.fromJson;

  @override
  String get callId;
  @override
  String get userId;
  @override
  String get inputLang;
  @override
  String get outputLang;
  @override
  @JsonKey(ignore: true)
  _$$LanguagePreferenceModelImplCopyWith<_$LanguagePreferenceModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SupportedLanguagesResponse _$SupportedLanguagesResponseFromJson(
    Map<String, dynamic> json) {
  return _SupportedLanguagesResponse.fromJson(json);
}

/// @nodoc
mixin _$SupportedLanguagesResponse {
  bool get success => throw _privateConstructorUsedError;
  Map<String, String> get languages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SupportedLanguagesResponseCopyWith<SupportedLanguagesResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupportedLanguagesResponseCopyWith<$Res> {
  factory $SupportedLanguagesResponseCopyWith(SupportedLanguagesResponse value,
          $Res Function(SupportedLanguagesResponse) then) =
      _$SupportedLanguagesResponseCopyWithImpl<$Res,
          SupportedLanguagesResponse>;
  @useResult
  $Res call({bool success, Map<String, String> languages});
}

/// @nodoc
class _$SupportedLanguagesResponseCopyWithImpl<$Res,
        $Val extends SupportedLanguagesResponse>
    implements $SupportedLanguagesResponseCopyWith<$Res> {
  _$SupportedLanguagesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? languages = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      languages: null == languages
          ? _value.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SupportedLanguagesResponseImplCopyWith<$Res>
    implements $SupportedLanguagesResponseCopyWith<$Res> {
  factory _$$SupportedLanguagesResponseImplCopyWith(
          _$SupportedLanguagesResponseImpl value,
          $Res Function(_$SupportedLanguagesResponseImpl) then) =
      __$$SupportedLanguagesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, Map<String, String> languages});
}

/// @nodoc
class __$$SupportedLanguagesResponseImplCopyWithImpl<$Res>
    extends _$SupportedLanguagesResponseCopyWithImpl<$Res,
        _$SupportedLanguagesResponseImpl>
    implements _$$SupportedLanguagesResponseImplCopyWith<$Res> {
  __$$SupportedLanguagesResponseImplCopyWithImpl(
      _$SupportedLanguagesResponseImpl _value,
      $Res Function(_$SupportedLanguagesResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? languages = null,
  }) {
    return _then(_$SupportedLanguagesResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      languages: null == languages
          ? _value._languages
          : languages // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SupportedLanguagesResponseImpl implements _SupportedLanguagesResponse {
  const _$SupportedLanguagesResponseImpl(
      {required this.success, required final Map<String, String> languages})
      : _languages = languages;

  factory _$SupportedLanguagesResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SupportedLanguagesResponseImplFromJson(json);

  @override
  final bool success;
  final Map<String, String> _languages;
  @override
  Map<String, String> get languages {
    if (_languages is EqualUnmodifiableMapView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_languages);
  }

  @override
  String toString() {
    return 'SupportedLanguagesResponse(success: $success, languages: $languages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupportedLanguagesResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality()
                .equals(other._languages, _languages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, success, const DeepCollectionEquality().hash(_languages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SupportedLanguagesResponseImplCopyWith<_$SupportedLanguagesResponseImpl>
      get copyWith => __$$SupportedLanguagesResponseImplCopyWithImpl<
          _$SupportedLanguagesResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SupportedLanguagesResponseImplToJson(
      this,
    );
  }
}

abstract class _SupportedLanguagesResponse
    implements SupportedLanguagesResponse {
  const factory _SupportedLanguagesResponse(
          {required final bool success,
          required final Map<String, String> languages}) =
      _$SupportedLanguagesResponseImpl;

  factory _SupportedLanguagesResponse.fromJson(Map<String, dynamic> json) =
      _$SupportedLanguagesResponseImpl.fromJson;

  @override
  bool get success;
  @override
  Map<String, String> get languages;
  @override
  @JsonKey(ignore: true)
  _$$SupportedLanguagesResponseImplCopyWith<_$SupportedLanguagesResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
