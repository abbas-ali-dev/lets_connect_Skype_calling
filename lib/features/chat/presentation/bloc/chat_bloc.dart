import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_logger.dart';
import '../../../../core/services/websocket_service.dart';
import '../../../../core/models/websocket_events.dart';
import '../../domain/usecases/search_user_usecase.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';
import '../../domain/usecases/create_room_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/group_usecases.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../data/models/message_model.dart';
import '../../data/models/chat_user_model.dart';
import 'chat_event.dart';
import 'chat_state.dart';

// 🎯 CHAT BLOC - Handles chat business logic and state

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SearchUserUseCase searchUserUseCase;
  final GetDashboardUseCase getDashboardUseCase;
  final CreateRoomUseCase createRoomUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final ChatRepository chatRepository;
  final WebSocketService _webSocketService;
  
  // Group use cases
  final CreateGroupUseCase createGroupUseCase;
  final GetGroupDetailsUseCase getGroupDetailsUseCase;
  final UpdateGroupInfoUseCase updateGroupInfoUseCase;
  final AddGroupMembersUseCase addGroupMembersUseCase;
  final RemoveGroupMemberUseCase removeGroupMemberUseCase;
  final LeaveGroupUseCase leaveGroupUseCase;
  final MakeAdminUseCase makeAdminUseCase;
  final RemoveAdminUseCase removeAdminUseCase;
  final SearchUsersUseCase searchUsersUseCase;
  
  StreamSubscription<Map<String, dynamic>>? _webSocketSubscription;

  ChatBloc({
    required this.searchUserUseCase,
    required this.getDashboardUseCase,
    required this.createRoomUseCase,
    required this.sendMessageUseCase,
    required this.getMessagesUseCase,
    required this.chatRepository,
    required this.createGroupUseCase,
    required this.getGroupDetailsUseCase,
    required this.updateGroupInfoUseCase,
    required this.addGroupMembersUseCase,
    required this.removeGroupMemberUseCase,
    required this.leaveGroupUseCase,
    required this.makeAdminUseCase,
    required this.removeAdminUseCase,
    required this.searchUsersUseCase,
  }) : _webSocketService = WebSocketService(),
       super(const ChatInitial()) {
    // Register event handlers
    on<LoadDashboardEvent>(_onLoadDashboard);
    on<RefreshDashboardEvent>(_onRefreshDashboard);
    on<SearchUserEvent>(_onSearchUser);
    on<CreateRoomEvent>(_onCreateRoom);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<SendMessageWithAttachmentsEvent>(_onSendMessageWithAttachments);
    on<UpdatePresenceEvent>(_onUpdatePresence);
    on<SendTypingIndicatorEvent>(_onSendTypingIndicator);
    on<MarkMessagesAsReadEvent>(_onMarkMessagesAsRead);
    on<ClearChatStateEvent>(_onClearChatState);
    
    // WebSocket event handlers
    on<ConnectWebSocketEvent>(_onConnectWebSocket);
    on<DisconnectWebSocketEvent>(_onDisconnectWebSocket);
    on<JoinRoomEvent>(_onJoinRoom);
    on<LeaveRoomEvent>(_onLeaveRoom);
    on<WebSocketMessageReceivedEvent>(_onWebSocketMessageReceived);
    
    // Group management event handlers
    on<CreateGroupEvent>(_onCreateGroup);
    on<GetGroupDetailsEvent>(_onGetGroupDetails);
    on<UpdateGroupInfoEvent>(_onUpdateGroupInfo);
    on<AddGroupMembersEvent>(_onAddGroupMembers);
    on<RemoveGroupMemberEvent>(_onRemoveGroupMember);
    on<LeaveGroupEvent>(_onLeaveGroup);
    on<MakeAdminEvent>(_onMakeAdmin);
    on<RemoveAdminEvent>(_onRemoveAdmin);
    on<SearchUsersEvent>(_onSearchUsers);
  }

  // Handle load dashboard event
  Future<void> _onLoadDashboard(LoadDashboardEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Loading dashboard for user: ${event.userId}');
    emit(const ChatLoading());

    final result = await getDashboardUseCase.call(event.userId);

    await result.fold(
      (failure) async {
        AppLogger.e('Load dashboard failed: ${failure.message}');
        if (!emit.isDone) {
          emit(ChatError(message: failure.message));
        }
      },
      (rooms) async {
        AppLogger.i('Dashboard loaded successfully with ${rooms.length} rooms');
        if (rooms.isEmpty) {
          AppLogger.w('No rooms found for user: ${event.userId}');
        } else {
          AppLogger.i('Rooms found: ${rooms.map((r) => '${r.id} - ${r.name}').join(', ')}');
        }
        
        // Also get unread counts
        final unreadResult = await chatRepository.getUnreadCounts(event.userId);
        final unreadCounts = unreadResult.fold(
          (failure) => <String, int>{},
          (counts) => counts,
        );
        
        if (!emit.isDone) {
          emit(ChatDashboardLoaded(rooms: rooms, unreadCounts: unreadCounts));
        }
      },
    );
  }

  // Handle refresh dashboard event (without loader)
  Future<void> _onRefreshDashboard(RefreshDashboardEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Refreshing dashboard for user: ${event.userId}');
    // Don't emit loading state - keep current state while refreshing

    final result = await getDashboardUseCase.call(event.userId);

    await result.fold(
      (failure) async {
        AppLogger.e('Refresh dashboard failed: ${failure.message}');
        // Don't emit error for refresh failures - just log them
      },
      (rooms) async {
        AppLogger.i('Dashboard refreshed successfully with ${rooms.length} rooms');
        
        // Also get unread counts
        final unreadResult = await chatRepository.getUnreadCounts(event.userId);
        final unreadCounts = unreadResult.fold(
          (failure) => <String, int>{},
          (counts) => counts,
        );
        
        if (!emit.isDone) {
          emit(ChatDashboardLoaded(rooms: rooms, unreadCounts: unreadCounts));
        }
      },
    );
  }

  // Handle search user event
  Future<void> _onSearchUser(SearchUserEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Searching user by email: ${event.email}');
    emit(const ChatLoading());

    final result = await searchUserUseCase.call(event.email);

    result.fold(
      (failure) {
        AppLogger.e('User search failed: ${failure.message}');
        if (!emit.isDone) {
          emit(ChatError(message: failure.message));
        }
      },
      (user) {
        AppLogger.i('User found: ${user.username}');
        if (!emit.isDone) {
          emit(ChatUserSearchResult(user: user));
        }
      },
    );
  }

  // Handle create room event
  Future<void> _onCreateRoom(CreateRoomEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Creating room: isGroup=${event.isGroup}');
    emit(const ChatLoading());

    final result = await createRoomUseCase.call(
      name: event.name,
      isGroup: event.isGroup,
      members: event.members,
      currentUserId: event.currentUserId,
    );

    result.fold(
      (failure) {
        AppLogger.e('Room creation failed: ${failure.message}');
        emit(ChatError(message: failure.message));
      },
      (room) {
        AppLogger.i('Room created successfully: ${room.id}');
        emit(ChatRoomCreated(room: room));
      },
    );
  }

  // Handle load messages event
  Future<void> _onLoadMessages(LoadMessagesEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Loading messages for room: ${event.roomId}');
    emit(const ChatLoading());

    final result = await getMessagesUseCase.call(event.roomId, event.userId);

    result.fold(
      (failure) {
        AppLogger.e('Load messages failed: ${failure.message}');
        emit(ChatError(message: failure.message));
      },
      (messages) {
        AppLogger.i('Messages loaded successfully: ${messages.length} messages');
        emit(ChatMessagesLoaded(roomId: event.roomId, messages: messages));
      },
    );
  }

  // Handle send message event
  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Sending message to room: ${event.roomId}');

    final result = await sendMessageUseCase.call(
      event.roomId,
      event.senderId,
      event.message,
    );

    result.fold(
      (failure) {
        AppLogger.e('Send message failed: ${failure.message}');
        emit(ChatError(message: failure.message));
      },
      (message) {
        AppLogger.i('Message sent successfully: ${message.id}');
        emit(ChatMessageSent(message: message));
      },
    );
  }

  // Handle send message with attachments event
  Future<void> _onSendMessageWithAttachments(
    SendMessageWithAttachmentsEvent event,
    Emitter<ChatState> emit,
  ) async {
    AppLogger.i('Sending message with attachments to room: ${event.roomId}');

    final result = await chatRepository.sendMessageWithAttachments(
      event.roomId,
      event.senderId,
      event.message,
      event.attachmentPaths,
    );

    result.fold(
      (failure) {
        AppLogger.e('Send message with attachments failed: ${failure.message}');
        emit(ChatError(message: failure.message));
      },
      (message) {
        AppLogger.i('Message with attachments sent successfully: ${message.id}');
        emit(ChatMessageSent(message: message));
      },
    );
  }

  // Handle update presence event
  Future<void> _onUpdatePresence(UpdatePresenceEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Updating presence for user: ${event.userId} to ${event.status}');

    final result = await chatRepository.updatePresence(event.userId, event.status);

    result.fold(
      (failure) {
        AppLogger.e('Update presence failed: ${failure.message}');
        emit(ChatError(message: failure.message));
      },
      (_) {
        AppLogger.i('Presence updated successfully');
        emit(ChatPresenceUpdated(userId: event.userId, status: event.status));
      },
    );
  }

  // Handle send typing indicator event
  Future<void> _onSendTypingIndicator(
    SendTypingIndicatorEvent event,
    Emitter<ChatState> emit,
  ) async {
    AppLogger.i('Sending typing indicator: ${event.isTyping}');

    final result = await chatRepository.sendTypingIndicator(
      event.userId,
      event.roomId,
      event.isTyping,
    );

    result.fold(
      (failure) {
        AppLogger.e('Send typing indicator failed: ${failure.message}');
        // Don't emit error for typing indicators as they're not critical
      },
      (_) {
        AppLogger.i('Typing indicator sent successfully');
        emit(ChatTypingIndicatorSent(
          userId: event.userId,
          roomId: event.roomId,
          isTyping: event.isTyping,
        ));
      },
    );
  }

  // Handle mark messages as read event
  Future<void> _onMarkMessagesAsRead(
    MarkMessagesAsReadEvent event,
    Emitter<ChatState> emit,
  ) async {
    AppLogger.i('Marking messages as read for room: ${event.roomId}');

    final result = await chatRepository.markMessagesAsRead(event.userId, event.roomId);

    result.fold(
      (failure) {
        AppLogger.e('Mark messages as read failed: ${failure.message}');
        emit(ChatError(message: failure.message));
      },
      (_) {
        AppLogger.i('Messages marked as read successfully');
        emit(ChatMessagesMarkedAsRead(userId: event.userId, roomId: event.roomId));
      },
    );
  }

  // Handle clear chat state event
  Future<void> _onClearChatState(ClearChatStateEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Clearing chat state');
    emit(const ChatInitial());
  }

  // WebSocket Event Handlers
  
  // Handle WebSocket connection
  Future<void> _onConnectWebSocket(ConnectWebSocketEvent event, Emitter<ChatState> emit) async {
    try {
      AppLogger.i('Connecting to WebSocket for user: ${event.userId}');
      
      // Connect to WebSocket
      await _webSocketService.connect(
        url: 'wss://lets-connect-sooty.vercel.app/ws', // Replace with your WebSocket URL
        token: event.token,
        userId: event.userId,
      );
      
      // Listen to WebSocket messages
      _webSocketSubscription = _webSocketService.messageStream.listen(
        (data) {
          add(WebSocketMessageReceivedEvent(data: data));
        },
        onError: (error) {
          AppLogger.e('WebSocket stream error', error);
          emit(ChatWebSocketError(message: error.toString()));
        },
      );
      
      emit(const ChatWebSocketConnected());
      AppLogger.i('WebSocket connected successfully');
      
    } catch (e) {
      AppLogger.e('WebSocket connection failed', e);
      emit(ChatWebSocketError(message: e.toString()));
    }
  }

  // Handle WebSocket disconnection
  Future<void> _onDisconnectWebSocket(DisconnectWebSocketEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Disconnecting WebSocket');
    
    await _webSocketSubscription?.cancel();
    _webSocketSubscription = null;
    
    _webSocketService.disconnect();
    emit(const ChatWebSocketDisconnected());
    
    AppLogger.i('WebSocket disconnected');
  }

  // Handle joining a room
  Future<void> _onJoinRoom(JoinRoomEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Joining room: ${event.roomId}');
    
    if (_webSocketService.isConnected) {
      _webSocketService.joinRoom(event.roomId);
      emit(ChatRoomJoined(roomId: event.roomId));
    } else {
      emit(const ChatWebSocketError(message: 'WebSocket not connected'));
    }
  }

  // Handle leaving a room
  Future<void> _onLeaveRoom(LeaveRoomEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Leaving room: ${event.roomId}');
    
    if (_webSocketService.isConnected) {
      _webSocketService.leaveRoom(event.roomId);
      emit(ChatRoomLeft(roomId: event.roomId));
    }
  }

  // Handle incoming WebSocket messages
  Future<void> _onWebSocketMessageReceived(WebSocketMessageReceivedEvent event, Emitter<ChatState> emit) async {
    try {
      final wsEvent = WebSocketEventFactory.fromWebSocketMessage(event.data);
      
      if (wsEvent is MessageReceivedEvent) {
        AppLogger.i('Real-time message received: ${wsEvent.message}');
        
        // Convert to domain Message entity
        final message = MessageModel(
          id: wsEvent.id,
          roomId: wsEvent.roomId,
          senderId: wsEvent.senderId,
          message: wsEvent.message,
          createdAt: wsEvent.createdAt,
          sender: wsEvent.sender != null ? ChatUserModel.fromJson(wsEvent.sender!) : null,
        ).toEntity();
        
        emit(ChatMessageReceived(message: message));
        
      } else if (wsEvent is TypingIndicatorEvent) {
        AppLogger.i('Typing indicator received: ${wsEvent.userId} is ${wsEvent.isTyping ? "typing" : "not typing"}');
        
        emit(ChatTypingIndicatorReceived(
          roomId: wsEvent.roomId,
          userId: wsEvent.userId,
          isTyping: wsEvent.isTyping,
          username: wsEvent.username,
        ));
        
      } else if (wsEvent is PresenceUpdateEvent) {
        AppLogger.i('Presence update received: ${wsEvent.userId} is ${wsEvent.isOnline ? "online" : "offline"}');
        
        emit(ChatPresenceReceived(
          userId: wsEvent.userId,
          isOnline: wsEvent.isOnline,
          lastSeen: wsEvent.lastSeen,
          username: wsEvent.username,
        ));
        
      } else if (wsEvent is ErrorEvent) {
        AppLogger.e('WebSocket error received: ${wsEvent.message}');
        emit(ChatWebSocketError(message: wsEvent.message));
      }
      
    } catch (e) {
      AppLogger.e('Failed to process WebSocket message', e);
      emit(ChatWebSocketError(message: 'Failed to process message: $e'));
    }
  }

  // ==================== GROUP MANAGEMENT EVENT HANDLERS ====================

  // Handle create group event
  Future<void> _onCreateGroup(CreateGroupEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Creating group: ${event.name}');
    emit(const GroupLoading());

    final result = await createGroupUseCase.call(
      name: event.name,
      memberIds: event.memberIds,
      creatorId: event.creatorId,
      description: event.description,
      imagePath: event.imagePath,
    );

    result.fold(
      (failure) {
        AppLogger.e('Group creation failed: ${failure.message}');
        emit(ChatError(message: failure.message));
      },
      (group) {
        AppLogger.i('Group created successfully: ${group.id}');
        emit(GroupCreated(group: group));
      },
    );
  }

  // Handle get group details event
  Future<void> _onGetGroupDetails(GetGroupDetailsEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Getting group details for room: ${event.roomId}');
    emit(const GroupLoading());

    final result = await getGroupDetailsUseCase.call(
      roomId: event.roomId,
      userId: event.userId,
    );

    result.fold(
      (failure) {
        AppLogger.e('Get group details failed: ${failure.message}');
        emit(ChatError(message: failure.message));
      },
      (group) {
        AppLogger.i('Group details loaded: ${group.name}');
        emit(GroupDetailsLoaded(group: group));
      },
    );
  }

  // Handle update group info event
  Future<void> _onUpdateGroupInfo(UpdateGroupInfoEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Updating group info for room: ${event.roomId}');
    emit(const GroupLoading());

    final result = await updateGroupInfoUseCase.call(
      roomId: event.roomId,
      userId: event.userId,
      name: event.name,
      description: event.description,
      imagePath: event.imagePath,
    );

    result.fold(
      (failure) {
        AppLogger.e('Update group info failed: ${failure.message}');
        emit(ChatError(message: failure.message));
      },
      (group) {
        AppLogger.i('Group info updated: ${group.name}');
        emit(GroupInfoUpdated(group: group));
      },
    );
  }

  // Handle add group members event
  Future<void> _onAddGroupMembers(AddGroupMembersEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Adding ${event.memberIds.length} members to group: ${event.roomId}');
    emit(const GroupLoading());

    final result = await addGroupMembersUseCase.call(
      roomId: event.roomId,
      userId: event.userId,
      memberIds: event.memberIds,
    );

    result.fold(
      (failure) {
        AppLogger.e('Add group members failed: ${failure.message}');
        emit(ChatError(message: failure.message));
      },
      (group) {
        AppLogger.i('Members added successfully');
        emit(GroupMembersAdded(group: group));
      },
    );
  }

  // Handle remove group member event
  Future<void> _onRemoveGroupMember(RemoveGroupMemberEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Removing member ${event.memberId} from group: ${event.roomId}');
    emit(const GroupLoading());

    final result = await removeGroupMemberUseCase.call(
      roomId: event.roomId,
      userId: event.userId,
      memberId: event.memberId,
    );

    result.fold(
      (failure) {
        AppLogger.e('Remove group member failed: ${failure.message}');
        emit(ChatError(message: failure.message));
      },
      (group) {
        AppLogger.i('Member removed successfully');
        emit(GroupMemberRemoved(group: group));
      },
    );
  }

  // Handle leave group event
  Future<void> _onLeaveGroup(LeaveGroupEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Leaving group: ${event.roomId}');
    emit(const GroupLoading());

    final result = await leaveGroupUseCase.call(
      roomId: event.roomId,
      userId: event.userId,
    );

    result.fold(
      (failure) {
        AppLogger.e('Leave group failed: ${failure.message}');
        emit(ChatError(message: failure.message));
      },
      (_) {
        AppLogger.i('Left group successfully');
        emit(GroupLeft(roomId: event.roomId));
      },
    );
  }

  // Handle make admin event
  Future<void> _onMakeAdmin(MakeAdminEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Making ${event.memberId} admin in group: ${event.roomId}');
    emit(const GroupLoading());

    final result = await makeAdminUseCase.call(
      roomId: event.roomId,
      userId: event.userId,
      memberId: event.memberId,
    );

    result.fold(
      (failure) {
        AppLogger.e('Make admin failed: ${failure.message}');
        emit(ChatError(message: failure.message));
      },
      (group) {
        AppLogger.i('Admin added successfully');
        emit(GroupAdminAdded(group: group));
      },
    );
  }

  // Handle remove admin event
  Future<void> _onRemoveAdmin(RemoveAdminEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Removing ${event.memberId} as admin in group: ${event.roomId}');
    emit(const GroupLoading());

    final result = await removeAdminUseCase.call(
      roomId: event.roomId,
      userId: event.userId,
      memberId: event.memberId,
    );

    result.fold(
      (failure) {
        AppLogger.e('Remove admin failed: ${failure.message}');
        emit(ChatError(message: failure.message));
      },
      (group) {
        AppLogger.i('Admin removed successfully');
        emit(GroupAdminRemoved(group: group));
      },
    );
  }

  // Handle search users event
  Future<void> _onSearchUsers(SearchUsersEvent event, Emitter<ChatState> emit) async {
    AppLogger.i('Searching users with query: ${event.query}');
    emit(const ChatLoading());

    final result = await searchUsersUseCase.call(event.query);

    result.fold(
      (failure) {
        AppLogger.e('Search users failed: ${failure.message}');
        emit(ChatError(message: failure.message));
      },
      (users) {
        AppLogger.i('Found ${users.length} users');
        emit(UsersSearchResult(users: users));
      },
    );
  }

  @override
  Future<void> close() {
    // Clean up WebSocket connection when bloc is closed
    _webSocketSubscription?.cancel();
    _webSocketService.disconnect();
    return super.close();
  }
}
