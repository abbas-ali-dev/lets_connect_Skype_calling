import 'package:equatable/equatable.dart';

class AgoraToken extends Equatable {
  final String token;
  final String channel;
  final int uid;
  final List<CallLanguage>? languages;

  const AgoraToken({
    required this.token,
    required this.channel,
    required this.uid,
    this.languages,
  });

  @override
  List<Object?> get props => [token, channel, uid, languages];
}

class CallLanguage extends Equatable {
  final String callId;
  final String userId;
  final String inputLang;
  final String outputLang;

  const CallLanguage({
    required this.callId,
    required this.userId,
    required this.inputLang,
    required this.outputLang,
  });

  @override
  List<Object?> get props => [callId, userId, inputLang, outputLang];
}
