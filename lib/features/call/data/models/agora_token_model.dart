import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/agora_token.dart';

part 'agora_token_model.freezed.dart';
part 'agora_token_model.g.dart';

@freezed
class AgoraTokenModel with _$AgoraTokenModel {
  const factory AgoraTokenModel({
    required String token,
    required String channel,
    @JsonKey(name: 'channelName') String? channelName,
    required int uid,
    List<CallLanguageModel>? languages,
  }) = _AgoraTokenModel;

  factory AgoraTokenModel.fromJson(Map<String, dynamic> json) =>
      _$AgoraTokenModelFromJson(json);
}

@freezed
class CallLanguageModel with _$CallLanguageModel {
  const factory CallLanguageModel({
    @JsonKey(name: 'call_id') required String callId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'input_lang') required String inputLang,
    @JsonKey(name: 'output_lang') required String outputLang,
  }) = _CallLanguageModel;

  factory CallLanguageModel.fromJson(Map<String, dynamic> json) =>
      _$CallLanguageModelFromJson(json);
}

extension AgoraTokenModelX on AgoraTokenModel {
  AgoraToken toEntity() {
    return AgoraToken(
      token: token,
      channel: channelName ?? channel,
      uid: uid,
      languages: languages
          ?.map((l) => CallLanguage(
                callId: l.callId,
                userId: l.userId,
                inputLang: l.inputLang,
                outputLang: l.outputLang,
              ))
          .toList(),
    );
  }
}
