import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/call.dart';
import '../../domain/entities/agora_token.dart';
import '../../domain/entities/translation.dart';
import '../../domain/usecases/initiate_call_usecase.dart';
import '../../domain/usecases/accept_call_usecase.dart';
import '../../domain/usecases/reject_call_usecase.dart';
import '../../domain/usecases/end_call_usecase.dart';
import '../../domain/usecases/join_call_usecase.dart';
import '../../domain/usecases/initialize_translation_usecase.dart';
import '../../domain/usecases/send_translation_usecase.dart';
import '../../domain/usecases/get_supported_languages_usecase.dart';
import '../../../../core/services/call_translation_service.dart';

part 'call_event.dart';
part 'call_state.dart';

@LazySingleton()
class CallBloc extends Bloc<CallEvent, CallState> {
  final InitiateCallUseCase initiateCallUseCase;
  final AcceptCallUseCase acceptCallUseCase;
  final RejectCallUseCase rejectCallUseCase;
  final EndCallUseCase endCallUseCase;
  final JoinCallUseCase joinCallUseCase;
  final InitializeTranslationUseCase initializeTranslationUseCase;
  final SendTranslationUseCase sendTranslationUseCase;
  final GetSupportedLanguagesUseCase getSupportedLanguagesUseCase;
  final CallTranslationService callTranslationService;

  CallBloc({
    required this.initiateCallUseCase,
    required this.acceptCallUseCase,
    required this.rejectCallUseCase,
    required this.endCallUseCase,
    required this.joinCallUseCase,
    required this.initializeTranslationUseCase,
    required this.sendTranslationUseCase,
    required this.getSupportedLanguagesUseCase,
    required this.callTranslationService,
  }) : super(CallInitial()) {
    on<InitiateCallEvent>(_onInitiateCall);
    on<AcceptCallEvent>(_onAcceptCall);
    on<RejectCallEvent>(_onRejectCall);
    on<EndCallEvent>(_onEndCall);
    on<JoinCallEvent>(_onJoinCall);
    on<IncomingCallEvent>(_onIncomingCall);
    on<CallAcceptedEvent>(_onCallAccepted);
    on<CallRejectedEvent>(_onCallRejected);
    on<CallEndedEvent>(_onCallEnded);
    
    // Translation events
    on<InitializeTranslationEvent>(_onInitializeTranslation);
    on<SendTranslationEvent>(_onSendTranslation);
    on<ToggleTranslationEvent>(_onToggleTranslation);
    on<ToggleTranslationAudioEvent>(_onToggleTranslationAudio);
    on<GetSupportedLanguagesEvent>(_onGetSupportedLanguages);
  }

  Future<void> _onInitiateCall(
    InitiateCallEvent event,
    Emitter<CallState> emit,
  ) async {
    emit(CallLoading());
    
    final result = await initiateCallUseCase.call(
      callerId: event.callerId,
      receiverId: event.receiverId,
      type: event.type,
    );

    result.fold(
      (failure) => emit(CallError(message: failure.message)),
      (call) => emit(CallInitiated(call: call)),
    );
  }

  Future<void> _onAcceptCall(
    AcceptCallEvent event,
    Emitter<CallState> emit,
  ) async {
    emit(CallLoading());
    
    final result = await acceptCallUseCase.call(
      callId: event.callId,
      receiverId: event.receiverId,
    );

    result.fold(
      (failure) => emit(CallError(message: failure.message)),
      (call) => emit(CallAccepted(call: call)),
    );
  }

  Future<void> _onRejectCall(
    RejectCallEvent event,
    Emitter<CallState> emit,
  ) async {
    final result = await rejectCallUseCase.call(
      callId: event.callId,
      receiverId: event.receiverId,
    );

    result.fold(
      (failure) => emit(CallError(message: failure.message)),
      (call) => emit(CallRejected(call: call)),
    );
  }

  Future<void> _onEndCall(
    EndCallEvent event,
    Emitter<CallState> emit,
  ) async {
    final result = await endCallUseCase.call(callId: event.callId);

    result.fold(
      (failure) => emit(CallError(message: failure.message)),
      (call) => emit(CallEnded(call: call)),
    );
  }

  Future<void> _onJoinCall(
    JoinCallEvent event,
    Emitter<CallState> emit,
  ) async {
    emit(CallLoading());
    
    final result = await joinCallUseCase.call(
      callId: event.callId,
      userId: event.userId,
    );

    result.fold(
      (failure) => emit(CallError(message: failure.message)),
      (token) => emit(CallJoined(token: token)),
    );
  }

  void _onIncomingCall(
    IncomingCallEvent event,
    Emitter<CallState> emit,
  ) {
    emit(IncomingCall(
      callId: event.callId,
      callerId: event.callerId,
      callerName: event.callerName,
      type: event.type,
      channelName: event.channelName,
    ));
  }

  void _onCallAccepted(
    CallAcceptedEvent event,
    Emitter<CallState> emit,
  ) {
    emit(CallAcceptedByRemote(callId: event.callId));
  }

  void _onCallRejected(
    CallRejectedEvent event,
    Emitter<CallState> emit,
  ) {
    emit(CallRejectedByRemote(callId: event.callId));
  }

  void _onCallEnded(
    CallEndedEvent event,
    Emitter<CallState> emit,
  ) {
    emit(CallEndedByRemote(callId: event.callId, duration: event.duration));
  }

  // Translation Event Handlers
  Future<void> _onInitializeTranslation(
    InitializeTranslationEvent event,
    Emitter<CallState> emit,
  ) async {
    try {
      await callTranslationService.initializeForCall(
        callId: event.callId,
        userId: event.userId,
        inputLang: event.inputLang,
        outputLang: event.outputLang,
        ablyKey: event.ablyKey,
      );
      
      emit(TranslationInitialized(
        callId: event.callId,
        inputLang: event.inputLang,
        outputLang: event.outputLang,
      ));
    } catch (e) {
      emit(CallError(message: 'Failed to initialize translation: $e'));
    }
  }

  Future<void> _onSendTranslation(
    SendTranslationEvent event,
    Emitter<CallState> emit,
  ) async {
    try {
      await callTranslationService.sendTranslation(event.text);
      
      emit(TranslationSent(
        callId: event.callId,
        originalText: event.text,
      ));
    } catch (e) {
      emit(CallError(message: 'Failed to send translation: $e'));
    }
  }

  void _onToggleTranslation(
    ToggleTranslationEvent event,
    Emitter<CallState> emit,
  ) {
    callTranslationService.setTranslationEnabled(event.enabled);
    emit(TranslationToggled(enabled: event.enabled));
  }

  void _onToggleTranslationAudio(
    ToggleTranslationAudioEvent event,
    Emitter<CallState> emit,
  ) {
    callTranslationService.setAudioEnabled(event.enabled);
    emit(TranslationAudioToggled(enabled: event.enabled));
  }

  Future<void> _onGetSupportedLanguages(
    GetSupportedLanguagesEvent event,
    Emitter<CallState> emit,
  ) async {
    try {
      final languages = await callTranslationService.getSupportedLanguages();
      emit(SupportedLanguagesLoaded(languages: languages));
    } catch (e) {
      emit(CallError(message: 'Failed to get supported languages: $e'));
    }
  }
}
