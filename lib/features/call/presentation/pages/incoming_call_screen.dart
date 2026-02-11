import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injections.dart';
import '../../../../core/services/ably_service.dart';
import '../../../../core/services/call_translation_service.dart';
import '../bloc/call_bloc.dart';
import '../../domain/usecases/initiate_call_usecase.dart';
import '../../domain/usecases/accept_call_usecase.dart';
import '../../domain/usecases/reject_call_usecase.dart';
import '../../domain/usecases/end_call_usecase.dart';
import '../../domain/usecases/join_call_usecase.dart';
import '../../domain/usecases/initialize_translation_usecase.dart';
import '../../domain/usecases/send_translation_usecase.dart';
import '../../domain/usecases/get_supported_languages_usecase.dart';
import 'active_call_screen.dart';

class IncomingCallScreen extends StatefulWidget {
  final String callId;
  final String callerId;
  final String callerName;
  final String type;
  final String currentUserId;
  final String? channel;

  const IncomingCallScreen({
    super.key,
    required this.callId,
    required this.callerId,
    required this.callerName,
    required this.type,
    required this.currentUserId,
    this.channel,
  });

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  StreamSubscription? _callEndedSubscription;
  StreamSubscription? _callRejectedSubscription;
  bool _isDismissed = false;

  @override
  void initState() {
    super.initState();
    _listenForCallEvents();
  }

  void _listenForCallEvents() {
    try {
      final ablyService = getIt<AblyService>();
      final channelName = 'call_${widget.callId}';
      
      // Listen for call-ended events (when caller ends the call)
      _callEndedSubscription = ablyService.onCallEvent(channelName, 'call-ended').listen((data) {
        print('🔴 Call ended by caller, dismissing incoming call screen');
        _dismissCall();
      });
      
      // Listen for call-rejected events (when another receiver rejects)
      _callRejectedSubscription = ablyService.onCallEvent(channelName, 'call-rejected').listen((data) {
        print('❌ Call rejected, dismissing incoming call screen');
        _dismissCall();
      });
      
      print('✅ Listening for call events on channel: $channelName');
    } catch (e) {
      print('⚠️ Error setting up call event listeners: $e');
    }
  }

  void _dismissCall() {
    if (_isDismissed) return;
    _isDismissed = true;
    
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _callEndedSubscription?.cancel();
    _callRejectedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 60),
            Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    widget.callerName.isNotEmpty ? widget.callerName[0].toUpperCase() : 'U',
                    style: const TextStyle(fontSize: 48, color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.callerName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Incoming ${widget.type == 'video' ? 'Video' : 'Audio'} Call',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.call_end,
                    label: 'Decline',
                    color: Colors.red,
                    onPressed: () async {
                      try {
                        context.read<CallBloc>().add(
                              RejectCallEvent(
                                callId: widget.callId,
                                receiverId: widget.currentUserId,
                              ),
                            );
                      } catch (e) {
                        // If CallBloc is closed, create a new one
                        print('CallBloc was closed, creating new instance: $e');
                        final callBloc = CallBloc(
                          initiateCallUseCase: getIt<InitiateCallUseCase>(),
                          acceptCallUseCase: getIt<AcceptCallUseCase>(),
                          rejectCallUseCase: getIt<RejectCallUseCase>(),
                          endCallUseCase: getIt<EndCallUseCase>(),
                          joinCallUseCase: getIt<JoinCallUseCase>(),
                          initializeTranslationUseCase: getIt<InitializeTranslationUseCase>(),
                          sendTranslationUseCase: getIt<SendTranslationUseCase>(),
                          getSupportedLanguagesUseCase: getIt<GetSupportedLanguagesUseCase>(),
                          callTranslationService: getIt<CallTranslationService>(),
                        );
                        callBloc.add(
                              RejectCallEvent(
                                callId: widget.callId,
                                receiverId: widget.currentUserId,
                              ),
                            );
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                  _buildActionButton(
                    icon: widget.type == 'video' ? Icons.videocam : Icons.call,
                    label: 'Accept',
                    color: Colors.green,
                    onPressed: () async {
                      try {
                        context.read<CallBloc>().add(
                              AcceptCallEvent(
                                callId: widget.callId,
                                receiverId: widget.currentUserId,
                              ),
                            );
                      } catch (e) {
                        // If CallBloc is closed, create a new one
                        print('CallBloc was closed, creating new instance: $e');
                        final callBloc = CallBloc(
                          initiateCallUseCase: getIt<InitiateCallUseCase>(),
                          acceptCallUseCase: getIt<AcceptCallUseCase>(),
                          rejectCallUseCase: getIt<RejectCallUseCase>(),
                          endCallUseCase: getIt<EndCallUseCase>(),
                          joinCallUseCase: getIt<JoinCallUseCase>(),
                          initializeTranslationUseCase: getIt<InitializeTranslationUseCase>(),
                          sendTranslationUseCase: getIt<SendTranslationUseCase>(),
                          getSupportedLanguagesUseCase: getIt<GetSupportedLanguagesUseCase>(),
                          callTranslationService: getIt<CallTranslationService>(),
                        );
                        callBloc.add(
                              AcceptCallEvent(
                                callId: widget.callId,
                                receiverId: widget.currentUserId,
                              ),
                            );
                      }
                      
                      // Wait a moment for the event to be processed
                      await Future.delayed(const Duration(milliseconds: 100));
                      
                      // Navigate to active call screen with proper arguments
                      if (mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => ActiveCallScreen(
                              callId: widget.callId,
                              userId: widget.currentUserId,
                              isVideoCall: widget.type == 'video',
                              isInitiator: false,
                              callerName: widget.callerName,
                              channel: widget.channel,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: color,
          heroTag: label,
          child: Icon(icon, size: 32),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
