import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../core/di/injections.dart';
import '../../../../core/services/ably_service.dart';
import '../../../../core/services/call_event_manager.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../services/fcm_service.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state/auth_state.dart';
import '../bloc/auth_event.dart';
import '../../../chat/presentation/bloc/chat_bloc.dart';
import '../../../chat/presentation/bloc/chat_event.dart';
import '../../../chat/presentation/bloc/chat_state.dart';
import '../../../chat/domain/entities/room.dart';
import '../../../chat/presentation/pages/chat_screen.dart';
import '../../../chat/presentation/pages/new_chat_screen.dart';
import '../../../chat/presentation/pages/create_group_screen.dart';
import '../../../call/presentation/pages/incoming_call_screen.dart';
import '../../../call/presentation/bloc/call_bloc.dart';
import 'login_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  Timer? _refreshTimer;
  String? _currentUserId;
  bool _dashboardLoaded = false;
  bool _servicesInitialized = false;
  ChatBloc? _chatBloc;
  AblyService? _ablyService;
  FCMService? _fcmService;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _chatBloc = context.read<ChatBloc>();
    // Don't initialize services here - wait for user ID to be available
  }

  void _initializeServices() {
    if (_servicesInitialized) {
      print('DEBUG: Services already initialized, skipping...');
      return;
    }
    
    print('DEBUG: Initializing services for user: $_currentUserId');
    _initializeFCM(_currentUserId!);
    _initializeAblyWithBackendToken(_currentUserId!);
    _servicesInitialized = true;
    print('DEBUG: Services initialization completed');
  }

  Future<void> _initializeFCM(String userId) async {
    try {
      print('DEBUG FCM: Starting FCM initialization for user: $userId');
      
      // Use the new singleton FCM service
      _fcmService = FCMService();
      await _fcmService!.initialize(userId);
      
      print('DEBUG: FCM initialized successfully for user: $userId');
    } catch (e, stackTrace) {
      print('DEBUG: Failed to initialize FCM: $e');
      print('DEBUG: Stack trace: $stackTrace');
    }
  }

  Future<void> _initializeAblyWithBackendToken(String userId) async {
    try {
      // Use Ably API key directly
      const ablyApiKey = 'ZliWLA.MV5xLg:m68RKqPnByrQQOFuqh_R7SdpiiZGDAJOsmRa6Xs_nGU';
      print('DEBUG: Using Ably API key directly for user: $userId');
      
      // Initialize Ably with API key
      _ablyService = AblyService();
      await _ablyService!.initialize(ablyApiKey);
      
      // Subscribe to user channel for incoming calls
      await _ablyService!.subscribeToUserChannel(userId);
      print('DEBUG: Subscribed to user channel for: user:$userId');
      
      // Listen for incoming calls on user:{userId} channel
      _ablyService!.onIncomingCall(userId).listen((callData) async {
        print('DEBUG: Incoming call received: $callData');
        
        // Get caller name from callerId if not provided
        String callerName = callData['callerName'] ?? 'Unknown';
        final callerId = callData['callerId'] ?? '';
        
        // Use default caller name if not provided
        if (callerName == 'Unknown' || callerName.isEmpty) {
          callerName = 'Caller';
        }
        
        // Show incoming call screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => getIt<CallBloc>(),
              child: IncomingCallScreen(
                callId: callData['callId'] ?? '',
                callerId: callerId,
                callerName: callerName,
                type: callData['type'] ?? 'audio',
                currentUserId: userId,
                channel: callData['channel'],
              ),
            ),
          ),
        );
      });
      
      // Set AblyService in CallEventManager for global access
      final callEventManager = getIt<CallEventManager>();
      callEventManager.setAblyService(_ablyService!);
      
      print('DEBUG: Ably initialized with backend token for user: $userId');
    } catch (e) {
      print('DEBUG: Failed to initialize Ably with backend token: $e');
    }
  }

  void _startPeriodicRefresh() {
    // Cancel any existing timer
    _refreshTimer?.cancel();
    
    // Refresh dashboard every 30 seconds for real-time updates, but only when app is in foreground
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_currentUserId != null && mounted && _chatBloc != null) {
        print('DEBUG: Periodic dashboard refresh (foreground only)');
        _chatBloc!.add(RefreshDashboardEvent(userId: _currentUserId!));
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print('DEBUG: App resumed - starting periodic refresh');
      _startPeriodicRefresh();
    } else if (state == AppLifecycleState.paused) {
      print('DEBUG: App paused - stopping periodic refresh');
      _refreshTimer?.cancel();
    }
  }

  void _loadDashboard(BuildContext context) {
    if (_currentUserId != null && !_dashboardLoaded) {
      print('DEBUG: Loading dashboard for user: $_currentUserId');
      _dashboardLoaded = true;
      
      // Initialize services now that we have the user ID
      _initializeServices();
      
      context.read<ChatBloc>().add(LoadDashboardEvent(userId: _currentUserId!));
    } else {
      print('DEBUG: Dashboard not loaded - userId: $_currentUserId, already loaded: $_dashboardLoaded');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 900;
    final isTablet = size.width > 600 && size.width <= 900;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        // Get current user ID from auth state and set auth token
        if (authState is AuthAuthenticated) {
          final userId = authState.user.id;
          if (_currentUserId != userId) {
            _currentUserId = userId;
            // Set auth token for API requests
            if (authState.user.token != null) {
              getIt<DioClient>().setAuthToken(authState.user.token!);
            }
            // Initialize FCM for push notifications
            _initializeFCM(userId);
            // Initialize Ably with backend token for incoming calls
            _initializeAblyWithBackendToken(userId);
          }
        } else {
          // If not authenticated, redirect to login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return BlocProvider(
          create: (context) => getIt<ChatBloc>(),
          child: Builder(
            builder: (context) {
              // Store ChatBloc reference and start timer after provider is created
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_chatBloc == null) {
                  _chatBloc = context.read<ChatBloc>();
                  _startPeriodicRefresh();
                }
                _loadDashboard(context);
              });
              
              return BlocListener<ChatBloc, ChatState>(
                listener: (context, state) {
                  if (state is ChatError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: Row(
                    children: [
                      // Sidebar (always visible on web, drawer on mobile)
                      if (isWeb || isTablet) _buildSidebar(isWeb),
                      
                      // Main content area
                      Expanded(
                        child: Column(
                          children: [
                            _buildAppBar(context, isWeb),
                            Expanded(
                              child: (isWeb || isTablet) ? _buildContent(isWeb) : _buildSidebar(false),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Bottom navigation for mobile
                  bottomNavigationBar: (!isWeb && !isTablet) ? _buildBottomNav() : null,
                  // Floating action button for mobile - Skype style with options
                  floatingActionButton: (!isWeb && !isTablet)
                      ? FloatingActionButton(
                          onPressed: () => _showNewChatOptions(context),
                          backgroundColor: const Color(0xFF0078D4),
                          child: const Icon(Icons.add),
                        )
                      : null,
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Sidebar for web/tablet
  Widget _buildSidebar(bool isWeb) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600 && size.width <= 900;
    
    return Container(
      width: (isWeb || isTablet) ? (isWeb ? 280 : 240) : double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        border: Border(
          right: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0078D4), Color(0xFF00A4EF)],
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF0078D4),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      final username = authState is AuthAuthenticated 
                          ? authState.user.username 
                          : 'User';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text(
                            'Online',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by email',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () => _showNewChatOptions(context),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (email) {
                if (email.isNotEmpty) {
                  context.read<ChatBloc>().add(SearchUserEvent(email: email));
                }
              },
            ),
          ),
          
          // Chat list
          Expanded(
            child: BlocListener<ChatBloc, ChatState>(
              listener: (context, state) {
                // Refresh dashboard when messages are marked as read
                if (state is ChatMessagesMarkedAsRead) {
                  print('DEBUG: Messages marked as read, refreshing dashboard');
                  context.read<ChatBloc>().add(RefreshDashboardEvent(userId: _currentUserId!));
                }
                // Refresh dashboard when a message is sent to update order
                else if (state is ChatMessageSent) {
                  print('DEBUG: Message sent, refreshing dashboard to update order');
                  context.read<ChatBloc>().add(RefreshDashboardEvent(userId: _currentUserId!));
                }
                // Refresh dashboard when a message is received to update order
                else if (state is ChatMessageReceived) {
                  print('DEBUG: Message received, refreshing dashboard to update order');
                  context.read<ChatBloc>().add(RefreshDashboardEvent(userId: _currentUserId!));
                }
              },
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatDashboardLoaded) {
                  final size = MediaQuery.of(context).size;
                  final currentIsWeb = size.width > 900;
                  final currentIsTablet = size.width > 600 && size.width <= 900;
                  print('DEBUG: Dashboard loaded with ${state.rooms.length} rooms');
                  print('DEBUG: Platform - isWeb: $currentIsWeb, isTablet: $currentIsTablet, width: ${size.width}');
                  print('DEBUG: Rooms: ${state.rooms.map((r) => r.name).join(', ')}');
                  if (state.rooms.isEmpty) {
                    print('DEBUG: No rooms found, showing empty state');
                    return const Center(
                      child: Text(
                        'No chats yet\nStart a new conversation!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  // Sort rooms by last message time (latest first)
                  final sortedRooms = List.from(state.rooms)
                    ..sort((a, b) {
                      final aTime = a.lastMessage?.createdAt ?? a.createdAt;
                      final bTime = b.lastMessage?.createdAt ?? b.createdAt;
                      return bTime.compareTo(aTime); // Latest first
                    });
                  
                  // Debug logging for mobile
                  print('DEBUG DASHBOARD: Sorted ${sortedRooms.length} rooms');
                  for (var room in sortedRooms.take(3)) {
                    final unread = state.unreadCounts[room.id] ?? 0;
                    print('DEBUG DASHBOARD: ${room.name} - unread: $unread, lastMsg: ${room.lastMessage?.createdAt}');
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 4),
                    itemCount: sortedRooms.length,
                    itemBuilder: (context, index) {
                      final room = sortedRooms[index];
                      final unreadCount = state.unreadCounts[room.id] ?? 0;
                      return _buildChatItem(
                        room: room,
                        unreadCount: unreadCount,
                        currentUserId: _currentUserId ?? '',
                        context: context,
                      );
                    },
                  );
                } else {
                  return ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return _buildPlaceholderChatItem();
                    },
                  );
                }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Chat item in sidebar
  Widget _buildChatItem({
    required Room room,
    required int unreadCount,
    required String currentUserId,
    required BuildContext context,
  }) {
    final displayName = room.getDisplayName(currentUserId);
    final lastMessage = room.lastMessage?.message ?? 'No messages yet';
    final time = room.lastMessage?.getFormattedTime() ?? '';
    final isUnread = unreadCount > 0;
    final otherUser = room.getOtherUser(currentUserId);
    final isOnline = otherUser?.isOnline ?? false;
    final isGroup = room.isGroup;
    final memberCount = room.members.length;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isUnread 
            ? Colors.blue.withOpacity(0.08) 
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnread 
              ? const Color(0xFF0078D4).withOpacity(0.2)
              : Colors.grey.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        onTap: () {
          // Capture the ChatBloc before navigation
          final chatBloc = context.read<ChatBloc>();
          
          // Mark messages as read when entering chat
          if (unreadCount > 0) {
            chatBloc.add(MarkMessagesAsReadEvent(userId: currentUserId, roomId: room.id));
          }
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: chatBloc,
                child: ChatScreen(
                  room: room,
                  currentUserId: currentUserId,
                ),
              ),
            ),
          ).then((_) {
            // Refresh the dashboard when returning from ChatScreen (without loader)
            chatBloc.add(RefreshDashboardEvent(userId: _currentUserId!));
          });
        },
        leading: Stack(
          children: [
            // Group avatar or user avatar
            CircleAvatar(
              backgroundColor: isGroup 
                  ? const Color(0xFF00A4EF).withOpacity(0.2)
                  : const Color(0xFF0078D4).withOpacity(0.2),
              child: isGroup
                  ? const Icon(
                      Icons.group,
                      color: Color(0xFF00A4EF),
                      size: 20,
                    )
                  : Text(
                      displayName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF0078D4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            // Online indicator (only for 1-to-1 chats)
            if (!isGroup && isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                displayName,
                style: TextStyle(
                  fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Member count badge for groups
            if (isGroup) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$memberCount',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 11,
                color: isUnread ? const Color(0xFF0078D4) : Colors.grey,
              ),
            ),
            if (isUnread) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFF0078D4),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Placeholder chat item for loading state
  Widget _buildPlaceholderChatItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.withOpacity(0.3),
        ),
        title: Container(
          height: 14,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        subtitle: Container(
          height: 12,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  // Show Skype-style bottom sheet with New Chat and New Group options
  void _showNewChatOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Start a conversation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // New Chat option
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0078D4).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    color: Color(0xFF0078D4),
                  ),
                ),
                title: const Text(
                  'New Chat',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'Start a one-on-one conversation',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _navigateToNewChat(context);
                },
              ),
              // New Group option
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0078D4).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.group_add,
                    color: Color(0xFF0078D4),
                  ),
                ),
                title: const Text(
                  'New Group',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'Create a group chat with multiple people',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _navigateToCreateGroup(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Navigate to new chat screen
  void _navigateToNewChat(BuildContext context) {
    if (_currentUserId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (navContext) => BlocProvider(
            create: (navContext) => getIt<ChatBloc>(),
            child: NewChatScreen(currentUserId: _currentUserId!),
          ),
        ),
      ).then((_) {
        // Refresh the dashboard when returning from NewChatScreen
        if (mounted) {
          context.read<ChatBloc>().add(LoadDashboardEvent(userId: _currentUserId!));
        }
      });
    }
  }

  // Navigate to create group screen
  void _navigateToCreateGroup(BuildContext context) {
    if (_currentUserId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (navContext) => BlocProvider(
            create: (navContext) => getIt<ChatBloc>(),
            child: CreateGroupScreen(currentUserId: _currentUserId!),
          ),
        ),
      ).then((_) {
        // Refresh the dashboard when returning from CreateGroupScreen
        if (mounted) {
          context.read<ChatBloc>().add(LoadDashboardEvent(userId: _currentUserId!));
        }
      });
    }
  }

  // App bar
  Widget _buildAppBar(BuildContext context, bool isWeb) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          if (!isWeb)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          const Expanded(
            child: Text(
              'Chats',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality can be added here
            },
          ),
          // Debug FCM refresh button
          if (_currentUserId != null)
            IconButton(
              icon: const Icon(Icons.refresh, size: 20),
              onPressed: () async {
                print('🔄 Manual FCM token refresh triggered');
                await _fcmService?.refreshToken();
              },
              tooltip: 'Refresh FCM Token',
            ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  // Main content
  Widget _buildContent(bool isWeb) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: isWeb ? 120 : 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            'Select a chat to start messaging',
            style: TextStyle(
              fontSize: isWeb ? 20 : 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  // Bottom navigation for mobile
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF0078D4),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'Contacts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Cleanup FCM before logout
              if (_fcmService != null) {
                await _fcmService!.cleanup();
              }
              
              // Trigger logout event
              if (mounted) {
                context.read<AuthBloc>().add(const LogoutEvent());
              }
              
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0078D4),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}