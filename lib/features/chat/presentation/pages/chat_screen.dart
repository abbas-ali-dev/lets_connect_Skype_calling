import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../../../core/services/voice_player_service.dart';
import '../../../../core/services/call_event_manager.dart';
import '../../../../core/services/ably_service.dart';
import '../../../../core/di/injections.dart';
import '../../../call/presentation/pages/active_call_screen.dart';
import '../../../call/presentation/pages/group_call_screen.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/message.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/voice_message_recorder.dart';
import '../widgets/voice_message_bubble.dart';

// 🎯 CHAT SCREEN - Individual chat conversation
class ChatScreen extends StatefulWidget {
  final Room room;
  final String currentUserId;

  const ChatScreen({
    super.key,
    required this.room,
    required this.currentUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final VoicePlayerService _voicePlayerService = VoicePlayerService();
  List<Message> _messages = [];
  bool _isRecordingVoice = false;

  @override
  void initState() {
    super.initState();

    // Listen to text changes to toggle between mic and send button
    _messageController.addListener(() {
      setState(() {}); // Rebuild to show mic/send button
    });

    // Load messages and connect to WebSocket after the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMessages();
      _connectWebSocket();
      _joinRoom();
    });
  }

  void _connectWebSocket() {
    // WebSocket disabled for now - server doesn't support it yet
    // TODO: Enable when server supports WebSocket connections
    print('DEBUG: WebSocket disabled - using HTTP polling instead');
  }

  void _joinRoom() {
    // Room joining disabled until WebSocket is working
    print('DEBUG: Room joining disabled - WebSocket not available');
  }

  void _loadMessages() {
    print('DEBUG: Loading messages for room: ${widget.room.id}');
    try {
      final bloc = context.read<ChatBloc>();
      if (!bloc.isClosed) {
        bloc.add(
          LoadMessagesEvent(
            roomId: widget.room.id,
            userId: widget.currentUserId,
          ),
        );
        print('DEBUG: LoadMessagesEvent dispatched successfully');
      } else {
        print('DEBUG: Bloc is closed, cannot load messages');
      }
    } catch (e) {
      print('DEBUG: Error loading messages: $e');
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    print('DEBUG: Sending message: "$message"');
    if (message.isNotEmpty) {
      try {
        final bloc = context.read<ChatBloc>();
        if (!bloc.isClosed) {
          bloc.add(
            SendMessageEvent(
              roomId: widget.room.id,
              senderId: widget.currentUserId,
              message: message,
            ),
          );
          _messageController.clear();
          print('DEBUG: Message sent to bloc, input cleared');
        } else {
          print('DEBUG: Bloc is closed, cannot send message');
        }
      } catch (e) {
        print('DEBUG: Error sending message: $e');
      }
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    _messageController.dispose();
    _scrollController.dispose();
    _voicePlayerService.dispose();
    super.dispose();
  }

  void _startVoiceRecording() {
    if (kIsWeb) {
      // Show info message for web users
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Voice recording on web requires microphone permission. Allow when prompted.',
          ),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        ),
      );
    }
    setState(() => _isRecordingVoice = true);
  }

  void _cancelVoiceRecording() {
    setState(() => _isRecordingVoice = false);
  }

  void _sendVoiceMessage(String filePath) {
    setState(() => _isRecordingVoice = false);

    print('DEBUG: Sending voice file: $filePath');

    // Send voice message as attachment
    try {
      final bloc = context.read<ChatBloc>();
      if (!bloc.isClosed) {
        bloc.add(
          SendMessageWithAttachmentsEvent(
            roomId: widget.room.id,
            senderId: widget.currentUserId,
            message: '🎤 Voice message',
            attachmentPaths: [filePath],
          ),
        );
        print('DEBUG: Voice message sent');
      }
    } catch (e) {
      print('DEBUG: Error sending voice message: $e');
    }
  }

  Future<void> _initiateCall(String type) async {
    if (widget.room.isGroup) {
      // Initiate group call
      await _initiateGroupCall(type);
    } else {
      // Initiate one-to-one call
      await _initiateOneToOneCall(type);
    }
  }

  Future<void> _initiateOneToOneCall(String type) async {
    // Get the receiver from the room
    final otherUser = widget.room.getOtherUser(widget.currentUserId);

    if (otherUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot find user to call'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    print(
      'DEBUG: Initiating $type call to user: ${otherUser.id} (${otherUser.username})',
    );

    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${otherUser.username}...'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );

    // Make API call to initiate the call and notify receiver
    try {
      final dio = getIt<Dio>();
      final response = await dio.post(
        '/call/initiate',
        data: {
          'callerId': widget.currentUserId,
          'receiverId': otherUser.id,
          'type': type,
        },
      );

      if (response.data['success'] == true) {
        final callData = response.data['call'];
        final callId =
            callData['id'] ?? 'temp-${DateTime.now().millisecondsSinceEpoch}';
        final channelName = callData['channel'] ?? 'call_$callId';

        print(
          'DEBUG: Call initiated successfully with ID: $callId, channel: $channelName',
        );

        // Subscribe to call channel events (call-accepted, call-rejected, call-ended)
        final callEventManager = getIt<CallEventManager>();
        callEventManager.subscribeToCallChannel(
          callId,
          (data) => _handleCallResponse(
            data,
            callId,
            otherUser.username,
            type,
            'accepted',
          ),
          (data) => _handleCallResponse(
            data,
            callId,
            otherUser.username,
            type,
            'rejected',
          ),
          (data) => _handleCallResponse(
            data,
            callId,
            otherUser.username,
            type,
            'ended',
          ),
        );

        // Navigate to active call screen
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder:
                    (context) => ActiveCallScreen(
                      callId: callId,
                      userId: widget.currentUserId,
                      isVideoCall: type == 'video',
                      isInitiator: true,
                      receiverId: otherUser.id,
                      receiverName: otherUser.username,
                      channel: channelName,
                    ),
              ),
            )
            .then((_) {
              // Unsubscribe from call channel when returning
              callEventManager.unsubscribeFromCallChannel(callId);
            });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to initiate call: ${response.data['error'] ?? 'Unknown error'}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('DEBUG: Error initiating call: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to initiate call: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = widget.room.getDisplayName(widget.currentUserId);

    return Scaffold(
      appBar: AppBar(
        title: Text(displayName),
        backgroundColor: const Color(0xFF0078D4),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () => _initiateCall('video'),
            tooltip: 'Video Call',
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () => _initiateCall('audio'),
            tooltip: 'Audio Call',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show chat options
            },
          ),
        ],
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatMessagesLoaded) {
            print(
              'DEBUG: Messages loaded successfully: ${state.messages.length} messages',
            );

            // Debug attachments for loaded messages
            for (int i = 0; i < state.messages.length; i++) {
              final message = state.messages[i];
              if (message.hasAttachments && message.attachments.isNotEmpty) {
                print('DEBUG: Message $i has attachments:');
                for (int j = 0; j < message.attachments.length; j++) {
                  final attachment = message.attachments[j];
                  print(
                    '  Attachment $j - fileType: ${attachment.fileType}, isAudio: ${attachment.isAudio}, isVoiceMessage: ${attachment.isVoiceMessage}',
                  );
                  print('  Attachment $j - fileUrl: ${attachment.fileUrl}');
                }
              }
            }

            setState(() {
              _messages.addAll(state.messages);
            });
            _scrollToBottom();
          } else if (state is ChatMessageSent) {
            print('DEBUG: ChatMessageSent received: ${state.message.message}');
            print('DEBUG: hasAttachments: ${state.message.hasAttachments}');
            print(
              'DEBUG: attachments count: ${state.message.attachments.length}',
            );
            if (state.message.attachments.isNotEmpty) {
              print(
                'DEBUG: First attachment - fileType: ${state.message.attachments.first.fileType}, isAudio: ${state.message.attachments.first.isAudio}, isVoiceMessage: ${state.message.attachments.first.isVoiceMessage}',
              );
              print(
                'DEBUG: First attachment - fileUrl: ${state.message.attachments.first.fileUrl}',
              );
            }
            setState(() {
              _messages.add(state.message);
            });
            _scrollToBottom();
            // Don't reload messages to avoid UUID error - just show the sent message immediately
          } else if (state is ChatMessageReceived &&
              state.message.roomId == widget.room.id) {
            print(
              'DEBUG: Real-time message received: ${state.message.message}',
            );
            setState(() {
              _messages.add(state.message);
            });
            _scrollToBottom();
          } else if (state is ChatTypingIndicatorReceived &&
              state.roomId == widget.room.id) {
            print(
              'DEBUG: Typing indicator: ${state.username ?? state.userId} is ${state.isTyping ? "typing" : "not typing"}',
            );
            // TODO: Show typing indicator in UI
          } else if (state is ChatWebSocketConnected) {
            print('DEBUG: WebSocket connected');
          } else if (state is ChatWebSocketError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('WebSocket Error: ${state.message}'),
                backgroundColor: Colors.orange,
              ),
            );
          } else if (state is ChatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            // Messages list
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading && _messages.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (_messages.isEmpty) {
                    return const Center(
                      child: Text(
                        'No messages yet\nSend the first message!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(message);
                    },
                  );
                },
              ),
            ),

            // Message input or voice recorder
            if (_isRecordingVoice)
              VoiceMessageRecorder(
                onRecordingComplete: _sendVoiceMessage,
                onCancel: _cancelVoiceRecording,
              )
            else
              _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isMe = message.isSentByMe(widget.currentUserId);

    // Check if this is a voice message (by attachment or by message text pattern)
    final hasVoiceAttachment =
        message.hasAttachments &&
        message.attachments.any((a) => a.isAudio || a.isVoiceMessage);
    final isVoiceMessageText =
        message.message.contains('🎤') ||
        message.message.toLowerCase().contains('voice message');

    // Show voice message bubble if has audio attachment
    if (hasVoiceAttachment) {
      final voiceAttachment = message.attachments.firstWhere(
        (a) => a.isAudio || a.isVoiceMessage,
      );
      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: VoiceMessageBubble(
            audioUrl: voiceAttachment.fileUrl,
            isMe: isMe,
            time: message.getFormattedTime(),
            playerService: _voicePlayerService,
          ),
        ),
      );
    }

    // Show voice message indicator for text-only voice messages (upload failed or legacy)
    if (isVoiceMessageText) {
      // Show non-playable voice message indicator
      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isMe ? const Color(0xFF0078D4) : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.mic,
                color: isMe ? Colors.white : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Voice Message',
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    message.getFormattedTime(),
                    style: TextStyle(
                      color: isMe ? Colors.white70 : Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.play_circle_outline,
                color: isMe ? Colors.white70 : Colors.grey[400],
                size: 24,
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF0078D4) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.getFormattedTime(),
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              // TODO: Implement file attachment
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          // Voice message button (when text is empty) or Send button (when text exists)
          _messageController.text.isEmpty
              ? GestureDetector(
                onTap: _startVoiceRecording,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0078D4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mic, color: Colors.white, size: 20),
                ),
              )
              : FloatingActionButton(
                mini: true,
                onPressed: _sendMessage,
                backgroundColor: const Color(0xFF0078D4),
                child: const Icon(Icons.send, color: Colors.white),
              ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    // Use multiple post-frame callbacks to ensure UI is fully rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // First scroll attempt
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

        // Second scroll attempt after a short delay to handle voice message bubbles
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients && mounted) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  void _handleCallResponse(
    Map<String, dynamic> eventData,
    String callId,
    String username,
    String callType,
    String responseType,
  ) {
    print('DEBUG: Call $responseType for $callId - $username');

    switch (responseType) {
      case 'accepted':
        // Call was accepted, navigate to active call screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => ActiveCallScreen(
                  callId: callId,
                  userId: widget.currentUserId,
                  isVideoCall: callType == 'video',
                  isInitiator: true,
                  channel: 'call_$callId',
                ),
          ),
        );
        break;
      case 'rejected':
        // Call was rejected, show message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$username rejected the call'),
            backgroundColor: Colors.orange,
          ),
        );
        break;
      case 'ended':
        // Call ended, navigate back if in call screen
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        break;
    }
  }

  Future<void> _initiateGroupCall(String type) async {
    print('DEBUG: Initiating group $type call in room: ${widget.room.id}');

    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting group ${type} call...'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      final dio = getIt<Dio>();

      // For group calls, we need to get all members from the room
      final otherMembers =
          widget.room.members
              .where((m) => m.id != widget.currentUserId)
              .map((m) => m.id)
              .toList();

      if (otherMembers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No other members in this group to call'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Use the first member as receiver and include room ID for backend to handle group logic
      final response = await dio.post(
        '/call/initiate',
        data: {
          'callerId': widget.currentUserId,
          'receiverId': otherMembers.first, // Use first member as receiver
          'type': type,
          'roomId':
              widget
                  .room
                  .id, // Include room ID for backend to know it's a group call
        },
      );

      if (response.data['success'] == true) {
        final callData = response.data['call'];
        final callId =
            callData['id'] ?? 'temp-${DateTime.now().millisecondsSinceEpoch}';
        final channelName = callData['channel'] ?? 'call_$callId';

        print(
          'DEBUG: Group call initiated successfully with ID: $callId, channel: $channelName',
        );

        // Notify all other members about the group call via Ably
        try {
          final ablyService = getIt<AblyService>();

          // Initialize Ably if not already initialized
          try {
            const ablyApiKey =
                'ZliWLA.MV5xLg:m68RKqPnByrQQOFuqh_R7SdpiiZGDAJOsmRa6Xs_nGU';
            await ablyService.initialize(ablyApiKey);
            print('DEBUG: Ably initialized for group call notification');
          } catch (e) {
            // Ably might already be initialized, continue
            print(
              'DEBUG: Ably initialization skipped (may already be initialized): $e',
            );
          }

          final roomChannelName = 'room_${widget.room.id}';

          // Send group call invitation to all members
          // If Ably is not initialized, this will log a warning and return gracefully
          await ablyService
              .publishMessage(roomChannelName, 'group-call-initiated', {
                'callId': callId,
                'channel': channelName,
                'type': type,
                'hostId': widget.currentUserId,
                'hostName':
                    widget.room.members
                        .firstWhere((m) => m.id == widget.currentUserId)
                        .username,
                'roomId': widget.room.id,
                'roomName': widget.room.getDisplayName(widget.currentUserId),
                'timestamp': DateTime.now().toIso8601String(),
              });

          print(
            'DEBUG: Group call notification sent to all members in room: ${widget.room.id}',
          );
        } catch (e) {
          print('DEBUG: Error sending group call notification: $e');
          // Continue even if notification fails - backend should handle notifications
        }

        // Navigate to group call screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => GroupCallScreen(
                  callId: callId,
                  userId: widget.currentUserId,
                  username:
                      widget
                          .currentUserId, // You might want to get actual username
                  isVideoCall: type == 'video',
                  isHost: true,
                ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to start group call: ${response.data['error'] ?? 'Unknown error'}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('DEBUG: Error initiating group call: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start group call: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
