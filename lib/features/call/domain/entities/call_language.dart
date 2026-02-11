import 'package:equatable/equatable.dart';

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
