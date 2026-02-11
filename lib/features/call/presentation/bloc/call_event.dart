part of 'call_bloc.dart';

abstract class CallEvent extends Equatable {
  const CallEvent();

  @override
  List<Object?> get props => [];
}

class InitiateCallEvent extends CallEvent {
  final String callerId;
  final String receiverId;
  final String type;

  const InitiateCallEvent({
    required this.callerId,
    required this.receiverId,
    required this.type,
  });

  @override
  List<Object?> get props => [callerId, receiverId, type];
}

class AcceptCallEvent extends CallEvent {
  final String callId;
  final String receiverId;

  const AcceptCallEvent({
    required this.callId,
    required this.receiverId,
  });

  @override
  List<Object?> get props => [callId, receiverId];
}

class RejectCallEvent extends CallEvent {
  final String callId;
  final String receiverId;

  const RejectCallEvent({
    required this.callId,
    required this.receiverId,
  });

  @override
  List<Object?> get props => [callId, receiverId];
}

class EndCallEvent extends CallEvent {
  final String callId;

  const EndCallEvent({required this.callId});

  @override
  List<Object?> get props => [callId];
}

class JoinCallEvent extends CallEvent {
  final String callId;
  final String userId;

  const JoinCallEvent({
    required this.callId,
    required this.userId,
  });

  @override
  List<Object?> get props => [callId, userId];
}

class IncomingCallEvent extends CallEvent {
  final String callId;
  final String callerId;
  final String callerName;
  final String type;
  final String channelName;

  const IncomingCallEvent({
    required this.callId,
    required this.callerId,
    required this.callerName,
    required this.type,
    required this.channelName,
  });

  @override
  List<Object?> get props => [callId, callerId, callerName, type, channelName];
}

class CallAcceptedEvent extends CallEvent {
  final String callId;

  const CallAcceptedEvent({required this.callId});

  @override
  List<Object?> get props => [callId];
}

class CallRejectedEvent extends CallEvent {
  final String callId;

  const CallRejectedEvent({required this.callId});

  @override
  List<Object?> get props => [callId];
}

class CallEndedEvent extends CallEvent {
  final String callId;
  final int? duration;

  const CallEndedEvent({
    required this.callId,
    this.duration,
  });

  @override
  List<Object?> get props => [callId, duration];
}

// Translation Events
class InitializeTranslationEvent extends CallEvent {
  final String callId;
  final String userId;
  final String inputLang;
  final String outputLang;
  final String ablyKey;

  const InitializeTranslationEvent({
    required this.callId,
    required this.userId,
    required this.inputLang,
    required this.outputLang,
    required this.ablyKey,
  });

  @override
  List<Object?> get props => [callId, userId, inputLang, outputLang, ablyKey];
}

class SendTranslationEvent extends CallEvent {
  final String callId;
  final String userId;
  final String text;

  const SendTranslationEvent({
    required this.callId,
    required this.userId,
    required this.text,
  });

  @override
  List<Object?> get props => [callId, userId, text];
}

class ToggleTranslationEvent extends CallEvent {
  final bool enabled;

  const ToggleTranslationEvent({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

class ToggleTranslationAudioEvent extends CallEvent {
  final bool enabled;

  const ToggleTranslationAudioEvent({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

class GetSupportedLanguagesEvent extends CallEvent {
  const GetSupportedLanguagesEvent();

  @override
  List<Object?> get props => [];
}
