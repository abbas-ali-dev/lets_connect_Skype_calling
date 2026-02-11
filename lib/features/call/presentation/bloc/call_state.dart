part of 'call_bloc.dart';

abstract class CallState extends Equatable {
  const CallState();

  @override
  List<Object?> get props => [];
}

class CallInitial extends CallState {}

class CallLoading extends CallState {}

class CallInitiated extends CallState {
  final Call call;

  const CallInitiated({required this.call});

  @override
  List<Object?> get props => [call];
}

class CallAccepted extends CallState {
  final Call call;

  const CallAccepted({required this.call});

  @override
  List<Object?> get props => [call];
}

class CallRejected extends CallState {
  final Call call;

  const CallRejected({required this.call});

  @override
  List<Object?> get props => [call];
}

class CallEnded extends CallState {
  final Call call;

  const CallEnded({required this.call});

  @override
  List<Object?> get props => [call];
}

class CallJoined extends CallState {
  final AgoraToken token;

  const CallJoined({required this.token});

  @override
  List<Object?> get props => [token];
}

class IncomingCall extends CallState {
  final String callId;
  final String callerId;
  final String callerName;
  final String type;
  final String channelName;

  const IncomingCall({
    required this.callId,
    required this.callerId,
    required this.callerName,
    required this.type,
    required this.channelName,
  });

  @override
  List<Object?> get props => [callId, callerId, callerName, type, channelName];
}

class CallAcceptedByRemote extends CallState {
  final String callId;

  const CallAcceptedByRemote({required this.callId});

  @override
  List<Object?> get props => [callId];
}

class CallRejectedByRemote extends CallState {
  final String callId;

  const CallRejectedByRemote({required this.callId});

  @override
  List<Object?> get props => [callId];
}

class CallEndedByRemote extends CallState {
  final String callId;
  final int? duration;

  const CallEndedByRemote({
    required this.callId,
    this.duration,
  });

  @override
  List<Object?> get props => [callId, duration];
}

class CallError extends CallState {
  final String message;

  const CallError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Translation States
class TranslationInitialized extends CallState {
  final String callId;
  final String inputLang;
  final String outputLang;

  const TranslationInitialized({
    required this.callId,
    required this.inputLang,
    required this.outputLang,
  });

  @override
  List<Object?> get props => [callId, inputLang, outputLang];
}

class TranslationSent extends CallState {
  final String callId;
  final String originalText;

  const TranslationSent({
    required this.callId,
    required this.originalText,
  });

  @override
  List<Object?> get props => [callId, originalText];
}

class TranslationReceived extends CallState {
  final String callId;
  final String speakerId;
  final String translatedText;

  const TranslationReceived({
    required this.callId,
    required this.speakerId,
    required this.translatedText,
  });

  @override
  List<Object?> get props => [callId, speakerId, translatedText];
}

class TranslationToggled extends CallState {
  final bool enabled;

  const TranslationToggled({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

class TranslationAudioToggled extends CallState {
  final bool enabled;

  const TranslationAudioToggled({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

class SupportedLanguagesLoaded extends CallState {
  final List<SupportedLanguage> languages;

  const SupportedLanguagesLoaded({required this.languages});

  @override
  List<Object?> get props => [languages];
}
