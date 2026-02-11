import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_logger.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/chat_user_model.dart';
import '../models/room_model.dart';
import '../models/message_model.dart';

// 🎯 CHAT REMOTE DATA SOURCE - API calls
// Handles all chat-related network requests

abstract class ChatRemoteDataSource {
  // User search
  Future<ChatUserModel> searchUserByEmail(String email);
  
  // Presence
  Future<Map<String, dynamic>> updatePresence(String userId, String status);
  
  // Typing indicator
  Future<Map<String, dynamic>> sendTypingIndicator(String userId, String roomId, bool isTyping);
  
  // Rooms
  Future<RoomModel> createRoom({
    String? name,
    required bool isGroup,
    required List<String> members,
    required String currentUserId,
  });
  Future<List<RoomModel>> getRoomsForUser(String userId);
  
  // Group Management (Skype-style)
  Future<RoomModel> createGroup({
    required String name,
    required List<String> memberIds,
    required String creatorId,
    String? description,
    String? imagePath,
  });
  Future<RoomModel> getGroupDetails(String roomId, String userId);
  Future<RoomModel> updateGroupInfo({
    required String roomId,
    required String userId,
    String? name,
    String? description,
    String? imagePath,
  });
  Future<RoomModel> addGroupMembers({
    required String roomId,
    required String userId,
    required List<String> memberIds,
  });
  Future<RoomModel> removeGroupMember({
    required String roomId,
    required String userId,
    required String memberId,
  });
  Future<void> leaveGroup({
    required String roomId,
    required String userId,
  });
  Future<RoomModel> makeAdmin({
    required String roomId,
    required String userId,
    required String memberId,
  });
  Future<RoomModel> removeAdmin({
    required String roomId,
    required String userId,
    required String memberId,
  });
  Future<List<ChatUserModel>> searchUsers(String query);
  
  // Messages
  Future<MessageModel> sendMessage(String roomId, String senderId, String message);
  Future<MessageModel> sendMessageWithAttachments(
    String roomId,
    String senderId,
    String message,
    List<String> attachmentPaths,
  );
  Future<List<MessageModel>> getMessagesForRoom(String roomId, String userId);
  
  // Dashboard
  Future<List<RoomModel>> getDashboard(String userId);
  
  // Unread counts
  Future<Map<String, int>> getUnreadCounts(String userId);
  Future<void> markMessagesAsRead(String userId, String roomId);
  
  // File download
  Future<String> getDownloadUrl(String fileUrl);
}

@LazySingleton(as: ChatRemoteDataSource)
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final DioClient dioClient;

  ChatRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ChatUserModel> searchUserByEmail(String email) async {
    try {
      AppLogger.i('Searching user by email: $email');
      
      final response = await dioClient.dio.get(
        '/user/search',
        queryParameters: {'email': email},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['userFound'] == true && data['user'] != null) {
          AppLogger.i('User found successfully');
          return ChatUserModel.fromJson(data['user']);
        } else {
          AppLogger.i('User not found: ${data['message']}');
          throw ServerException(
            data['message'] ?? 'User not found',
            statusCode: 404,
          );
        }
      } else {
        throw ServerException(
          'User search failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('User search error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      // Re-throw ServerException as-is (like "User not found")
      if (e is ServerException) {
        rethrow;
      }
      // Only log truly unexpected errors
      AppLogger.e('Unexpected user search error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> updatePresence(String userId, String status) async {
    try {
      AppLogger.i('Updating presence for user: $userId to $status');
      
      final response = await dioClient.dio.post(
        '/chat/presence',
        data: {
          'userId': userId,
          'status': status,
        },
      );

      if (response.statusCode == 200) {
        AppLogger.i('Presence updated successfully');
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerException(
          'Presence update failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Presence update error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected presence update error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> sendTypingIndicator(String userId, String roomId, bool isTyping) async {
    try {
      AppLogger.i('Sending typing indicator for user: $userId in room: $roomId');
      
      final response = await dioClient.dio.post(
        '/chat/typing',
        data: {
          'userId': userId,
          'roomId': roomId,
          'isTyping': isTyping,
        },
      );

      if (response.statusCode == 200) {
        AppLogger.i('Typing indicator sent successfully');
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerException(
          'Typing indicator failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Typing indicator error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected typing indicator error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RoomModel> createRoom({
    String? name,
    required bool isGroup,
    required List<String> members,
    required String currentUserId,
  }) async {
    try {
      AppLogger.i('Creating room: isGroup=$isGroup, members=${members.length}');
      
      final response = await dioClient.dio.post(
        '/chat/rooms',
        data: {
          'name': name,
          'isGroup': isGroup,
          'members': members,
          'currentUserId': currentUserId,
        },
      );

      if (response.statusCode == 200) {
        AppLogger.i('Room created successfully');
        
        // Handle different response structures for group vs 1-to-1
        final roomData = response.data['room'] as Map<String, dynamic>?;
        final otherUser = response.data['otherUser'] as Map<String, dynamic>?;
        
        if (roomData == null) {
          throw ServerException('Room data is missing from response');
        }
        
        // Create members list
        List<ChatUserModel> memberModels = [];
        if (otherUser != null) {
          try {
            memberModels.add(ChatUserModel.fromJson(otherUser));
          } catch (e) {
            AppLogger.w('Failed to parse otherUser data: $e');
          }
        }
        
        // Safely extract room data with null checks
        final roomId = roomData['id'] as String?;
        if (roomId == null) {
          throw ServerException('Room ID is missing from response');
        }
        
        return RoomModel(
          id: roomId,
          name: roomData['name'] as String?,
          isGroup: roomData['is_group'] as bool? ?? isGroup,
          members: memberModels,
          createdAt: roomData['created_at'] != null 
            ? DateTime.parse(roomData['created_at'] as String)
            : DateTime.now(), // Use current time if created_at is missing
        );
      } else {
        throw ServerException(
          'Room creation failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Room creation error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected room creation error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<RoomModel>> getRoomsForUser(String userId) async {
    try {
      AppLogger.i('Getting rooms for user: $userId');
      
      final response = await dioClient.dio.get('/chat/rooms/$userId');

      if (response.statusCode == 200) {
        AppLogger.i('Rooms retrieved successfully');
        final roomsData = response.data['rooms'] as List;
        return roomsData.map((room) => RoomModel.fromJson(room)).toList();
      } else {
        throw ServerException(
          'Get rooms failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Get rooms error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected get rooms error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MessageModel> sendMessage(String roomId, String senderId, String message) async {
    try {
      AppLogger.i('Sending message to room: $roomId');
      
      final response = await dioClient.dio.post(
        '/chat/rooms/$roomId/message',
        data: {
          'senderId': senderId,
          'type': 'text',
          'message': message,
        },
      );

      if (response.statusCode == 200) {
        AppLogger.i('Message sent successfully');
        
        // Transform API response to match MessageModel structure
        final messageData = Map<String, dynamic>.from(response.data['data']);
        AppLogger.i('Message data: $messageData');
        
        return MessageModel.fromJson(messageData);
      } else {
        throw ServerException(
          'Send message failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Send message error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected send message error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MessageModel> sendMessageWithAttachments(
    String roomId,
    String senderId,
    String message,
    List<String> attachmentPaths,
  ) async {
    try {
      AppLogger.i('Sending message with attachments to room: $roomId');
      
      // Check if running on web
      if (kIsWeb) {
        // On web, we need to handle blob URLs differently
        // For now, send as regular message with attachment info
        // The web recording returns a blob URL that can't be uploaded as file
        AppLogger.w('Web platform: Attachments not fully supported, sending as text message');
        
        final response = await dioClient.dio.post(
          '/chat/rooms/$roomId/message',
          data: {
            'senderId': senderId,
            'type': 'text',
            'message': message,
            'filesMeta': [],
            'replyTo': null,
            'location_lat': null,
            'location_lng': null,
            'location_address': null,
            'contactId': null,
          },
        );

        if (response.statusCode == 200) {
          AppLogger.i('Message sent successfully (web fallback)');
          
          // Transform API response to match MessageModel structure
          final messageData = Map<String, dynamic>.from(response.data['data']);
          return MessageModel.fromJson(messageData);
        } else {
          throw ServerException(
            'Send message failed',
            statusCode: response.statusCode,
          );
        }
      }
      
      // Native platforms - send file as multipart/form-data
      AppLogger.i('Sending message with ${attachmentPaths.length} file(s) as attachments');
      AppLogger.i('Request data - senderId: $senderId, message: $message');
      
      // Determine message type based on attachments
      final messageType = attachmentPaths.isNotEmpty ? 'audio' : 'text';
      
      // Create FormData for multipart upload
      final formData = FormData();
      
      // Add text fields
      formData.fields.addAll([
        MapEntry('roomId', roomId),
        MapEntry('senderId', senderId),
        MapEntry('message', message),
        MapEntry('type', messageType),
      ]);
      
      // Add file attachments
      for (final path in attachmentPaths) {
        final fileName = path.split('/').last;
        AppLogger.i('Adding file: $fileName from path: $path');
        
        final file = await MultipartFile.fromFile(
          path,
          filename: fileName,
        );
        
        formData.files.add(MapEntry('attachments', file));
      }
      
      final response = await dioClient.dio.post(
        '/chat/rooms/$roomId/message',
        data: formData,
      );

      if (response.statusCode == 200) {
        AppLogger.i('Message with attachments sent successfully');
        
        // Transform API response to match MessageModel structure
        final messageData = Map<String, dynamic>.from(response.data['data']);
        AppLogger.i('Message data: $messageData');
        
        return MessageModel.fromJson(messageData);
      } else {
        throw ServerException(
          'Send message with attachments failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Send message with attachments error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected send message with attachments error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MessageModel>> getMessagesForRoom(String roomId, String userId) async {
    try {
      AppLogger.i('Getting messages for room: $roomId, userId: $userId');
      
      // Add validation to ensure roomId and userId are not null or empty
      if (roomId.isEmpty || roomId == 'null' || roomId == 'undefined') {
        throw ServerException('Invalid room ID: $roomId');
      }
      
      if (userId.isEmpty || userId == 'null' || userId == 'undefined') {
        throw ServerException('Invalid user ID: $userId');
      }
      
      // Include userId as query parameter
      final url = '/chat/rooms/$roomId/messages';
      AppLogger.i('Making request to: $url');
      AppLogger.i('Room ID being sent: "$roomId" (type: ${roomId.runtimeType})');
      AppLogger.i('User ID being sent: "$userId" (type: ${userId.runtimeType})');
      
      final response = await dioClient.dio.get(
        url,
        queryParameters: {'userId': userId},
      );

      if (response.statusCode == 200) {
        AppLogger.i('Messages retrieved successfully');
        final messagesData = response.data['messages'] as List;
        return messagesData.map((message) => MessageModel.fromJson(message)).toList();
      } else {
        throw ServerException(
          'Get messages failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Get messages error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected get messages error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<RoomModel>> getDashboard(String userId) async {
    try {
      AppLogger.i('Getting dashboard for user: $userId');
      
      final response = await dioClient.dio.get(
        '/dashboard',
        queryParameters: {'userId': userId},
      );

      if (response.statusCode == 200) {
        AppLogger.i('Dashboard retrieved successfully');
        AppLogger.i('Dashboard response: ${response.data}');
        final chatsData = response.data['chats'] as List;
        AppLogger.i('Found ${chatsData.length} chats in response');
        return chatsData.map((chat) {
          try {
            // Handle missing required fields in chat data
            final chatData = Map<String, dynamic>.from(chat);
            
            // Add missing created_at field if not present (required by RoomModel)
            if (chatData['created_at'] == null) {
              chatData['created_at'] = DateTime.now().toIso8601String();
            }
            
            // Transform last_message from dashboard format to MessageModel format
            if (chatData['last_message'] != null) {
              final lastMsg = Map<String, dynamic>.from(chatData['last_message'] as Map<String, dynamic>);
              // Dashboard API returns 'text' but MessageModel expects 'message'
              if (lastMsg['text'] != null) {
                lastMsg['message'] = lastMsg['text'];
                lastMsg.remove('text');
              }
              // Add room_id from parent chat
              lastMsg['room_id'] = chatData['id'];
              // Add sender_id from sender object
              if (lastMsg['sender'] != null && lastMsg['sender']['id'] != null) {
                lastMsg['sender_id'] = lastMsg['sender']['id'];
              }
              // Transform sender to profiles for MessageModel
              if (lastMsg['sender'] != null) {
                lastMsg['profiles'] = lastMsg['sender'];
                lastMsg.remove('sender');
              }
              // Set defaults for optional fields
              lastMsg['has_attachments'] = lastMsg['has_attachments'] ?? false;
              lastMsg['attachments'] = lastMsg['attachments'] ?? [];
              
              chatData['last_message'] = lastMsg;
            }
            
            return RoomModel.fromJson(chatData);
          } catch (e) {
            AppLogger.e('Error parsing chat data: $chat', e);
            rethrow;
          }
        }).toList();
      } else {
        throw ServerException(
          'Get dashboard failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Get dashboard error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected get dashboard error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, int>> getUnreadCounts(String userId) async {
    try {
      AppLogger.i('Getting unread counts for user: $userId');
      
      final response = await dioClient.dio.get(
        '/chat/getUnreadCounts',
        queryParameters: {'userId': userId},
      );

      if (response.statusCode == 200) {
        AppLogger.i('Unread counts retrieved successfully');
        final unreadData = response.data['unreadCounts'] as Map<String, dynamic>;
        return unreadData.map((key, value) => MapEntry(key, value as int));
      } else {
        throw ServerException(
          'Get unread counts failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Get unread counts error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected get unread counts error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> markMessagesAsRead(String userId, String roomId) async {
    try {
      AppLogger.i('Marking messages as read for user: $userId in room: $roomId');
      
      final response = await dioClient.dio.post(
        '/chat/markAsRead',
        data: {
          'userId': userId,
          'roomId': roomId,
        },
      );

      if (response.statusCode == 200) {
        AppLogger.i('Messages marked as read successfully');
      } else {
        throw ServerException(
          'Mark as read failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Mark as read error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected mark as read error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> getDownloadUrl(String fileUrl) async {
    try {
      AppLogger.i('Getting download URL for file: $fileUrl');
      
      final response = await dioClient.dio.get(
        '/chat/download',
        queryParameters: {'fileUrl': fileUrl},
      );

      if (response.statusCode == 200) {
        AppLogger.i('Download URL retrieved successfully');
        return response.data['downloadUrl'] as String;
      } else {
        throw ServerException(
          'Get download URL failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Get download URL error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected get download URL error', e);
      throw ServerException(e.toString());
    }
  }

  // ==================== GROUP MANAGEMENT METHODS ====================

  @override
  Future<RoomModel> createGroup({
    required String name,
    required List<String> memberIds,
    required String creatorId,
    String? description,
    String? imagePath,
  }) async {
    try {
      AppLogger.i('Creating group: $name with ${memberIds.length} members');
      
      // Use the existing /chat/rooms endpoint with isGroup: true
      // The backend uses the same endpoint for both 1-to-1 and group chats
      final response = await dioClient.dio.post(
        '/chat/rooms',
        data: {
          'name': name,
          'isGroup': true,
          'members': memberIds,
          'currentUserId': creatorId,
          'description': description,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.i('Group created successfully');
        
        // Handle response structure from /chat/rooms endpoint
        final roomData = response.data['room'] as Map<String, dynamic>?;
        
        if (roomData == null) {
          throw ServerException('Room data is missing from response');
        }
        
        final roomId = roomData['id'] as String?;
        if (roomId == null) {
          throw ServerException('Room ID is missing from response');
        }
        
        // Parse members if available
        List<ChatUserModel> memberModels = [];
        if (roomData['members'] != null) {
          final membersData = roomData['members'] as List;
          memberModels = membersData
              .map((m) => ChatUserModel.fromJson(m as Map<String, dynamic>))
              .toList();
        }
        
        return RoomModel(
          id: roomId,
          name: roomData['name'] as String? ?? name,
          isGroup: true,
          members: memberModels,
          description: roomData['description'] as String? ?? description,
          createdBy: creatorId,
          adminIds: [creatorId], // Creator is admin by default
          createdAt: roomData['created_at'] != null 
            ? DateTime.parse(roomData['created_at'] as String)
            : DateTime.now(),
        );
      } else {
        throw ServerException(
          'Group creation failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Group creation error', e);
      if (e.response != null) {
        final errorData = e.response?.data;
        String errorMessage = 'Server error';
        if (errorData is Map) {
          errorMessage = errorData['error']?.toString() ?? errorData['message']?.toString() ?? 'Server error';
        }
        throw ServerException(
          errorMessage,
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected group creation error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RoomModel> getGroupDetails(String roomId, String userId) async {
    try {
      AppLogger.i('Getting group details for room: $roomId');
      
      final response = await dioClient.dio.get(
        '/chat/groups/$roomId',
        queryParameters: {'userId': userId},
      );

      if (response.statusCode == 200) {
        AppLogger.i('Group details retrieved successfully');
        return RoomModel.fromJson(response.data['group']);
      } else {
        throw ServerException(
          'Get group details failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Get group details error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected get group details error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RoomModel> updateGroupInfo({
    required String roomId,
    required String userId,
    String? name,
    String? description,
    String? imagePath,
  }) async {
    try {
      AppLogger.i('Updating group info for room: $roomId');
      
      FormData? formData;
      Map<String, dynamic>? jsonData;
      
      if (imagePath != null) {
        formData = FormData();
        formData.fields.add(MapEntry('userId', userId));
        if (name != null) formData.fields.add(MapEntry('name', name));
        if (description != null) formData.fields.add(MapEntry('description', description));
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(imagePath),
        ));
      } else {
        jsonData = {
          'userId': userId,
          if (name != null) 'name': name,
          if (description != null) 'description': description,
        };
      }
      
      final response = await dioClient.dio.patch(
        '/chat/groups/$roomId',
        data: formData ?? jsonData,
        options: imagePath != null ? Options(headers: {'Content-Type': 'multipart/form-data'}) : null,
      );

      if (response.statusCode == 200) {
        AppLogger.i('Group info updated successfully');
        return RoomModel.fromJson(response.data['group']);
      } else {
        throw ServerException(
          'Update group info failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Update group info error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected update group info error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RoomModel> addGroupMembers({
    required String roomId,
    required String userId,
    required List<String> memberIds,
  }) async {
    try {
      AppLogger.i('Adding ${memberIds.length} members to group: $roomId');
      
      final response = await dioClient.dio.post(
        '/chat/groups/$roomId/members',
        data: {
          'userId': userId,
          'memberIds': memberIds,
        },
      );

      if (response.statusCode == 200) {
        AppLogger.i('Members added successfully');
        return RoomModel.fromJson(response.data['group']);
      } else {
        throw ServerException(
          'Add members failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Add members error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected add members error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RoomModel> removeGroupMember({
    required String roomId,
    required String userId,
    required String memberId,
  }) async {
    try {
      AppLogger.i('Removing member $memberId from group: $roomId');
      
      final response = await dioClient.dio.delete(
        '/chat/groups/$roomId/members/$memberId',
        data: {'userId': userId},
      );

      if (response.statusCode == 200) {
        AppLogger.i('Member removed successfully');
        return RoomModel.fromJson(response.data['group']);
      } else {
        throw ServerException(
          'Remove member failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Remove member error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected remove member error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> leaveGroup({
    required String roomId,
    required String userId,
  }) async {
    try {
      AppLogger.i('User $userId leaving group: $roomId');
      
      final response = await dioClient.dio.post(
        '/chat/groups/$roomId/leave',
        data: {'userId': userId},
      );

      if (response.statusCode == 200) {
        AppLogger.i('Left group successfully');
      } else {
        throw ServerException(
          'Leave group failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Leave group error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected leave group error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RoomModel> makeAdmin({
    required String roomId,
    required String userId,
    required String memberId,
  }) async {
    try {
      AppLogger.i('Making $memberId admin in group: $roomId');
      
      final response = await dioClient.dio.post(
        '/chat/groups/$roomId/admins',
        data: {
          'userId': userId,
          'memberId': memberId,
        },
      );

      if (response.statusCode == 200) {
        AppLogger.i('Admin added successfully');
        return RoomModel.fromJson(response.data['group']);
      } else {
        throw ServerException(
          'Make admin failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Make admin error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected make admin error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RoomModel> removeAdmin({
    required String roomId,
    required String userId,
    required String memberId,
  }) async {
    try {
      AppLogger.i('Removing $memberId as admin in group: $roomId');
      
      final response = await dioClient.dio.delete(
        '/chat/groups/$roomId/admins/$memberId',
        data: {'userId': userId},
      );

      if (response.statusCode == 200) {
        AppLogger.i('Admin removed successfully');
        return RoomModel.fromJson(response.data['group']);
      } else {
        throw ServerException(
          'Remove admin failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Remove admin error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected remove admin error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ChatUserModel>> searchUsers(String query) async {
    try {
      AppLogger.i('Searching users with query: $query');
      
      final response = await dioClient.dio.get(
        '/user/search',
        queryParameters: {'email': query},
      );

      if (response.statusCode == 200) {
        AppLogger.i('Users search completed');
        
        // API returns single user with userFound flag, not a list
        final userFound = response.data['userFound'] as bool? ?? false;
        if (userFound && response.data['user'] != null) {
          final user = ChatUserModel.fromJson(response.data['user']);
          AppLogger.i('Found user: ${user.username}');
          return [user];
        }
        
        // Also handle if API returns users array (for future compatibility)
        final usersData = response.data['users'] as List?;
        if (usersData != null && usersData.isNotEmpty) {
          return usersData.map((user) => ChatUserModel.fromJson(user)).toList();
        }
        
        return [];
      } else {
        throw ServerException(
          'Search users failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      AppLogger.e('Search users error', e);
      if (e.response != null) {
        throw ServerException(
          e.response?.data['error'] ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkException('No internet connection');
      }
    } catch (e) {
      AppLogger.e('Unexpected search users error', e);
      throw ServerException(e.toString());
    }
  }
}
