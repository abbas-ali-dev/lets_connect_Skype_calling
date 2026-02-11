import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/call.dart';
import '../../domain/entities/agora_token.dart';
import '../../domain/entities/group_call.dart';
import '../../domain/entities/translation.dart';
import '../../domain/repositories/call_repository.dart';
import '../datasources/call_remote_data_source.dart';
import '../models/call_model.dart';
import '../models/agora_token_model.dart';
import '../models/translation_model.dart';

@LazySingleton(as: CallRepository)
class CallRepositoryImpl implements CallRepository {
  final CallRemoteDataSource remoteDataSource;

  CallRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Call>> initiateCall({
    required String callerId,
    required String receiverId,
    required String type,
  }) async {
    try {
      final response = await remoteDataSource.initiateCall({
        'callerId': callerId,
        'receiverId': receiverId,
        'type': type,
      });

      if (response['success'] == true) {
        final callData = response['call'] as Map<String, dynamic>;
        final callModel = CallModel.fromJson(callData);
        return Right(callModel.toEntity());
      } else {
        return Left(ServerFailure(
          response['error'] ?? 'Failed to initiate call',
        ));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Call>> acceptCall({
    required String callId,
    required String receiverId,
  }) async {
    try {
      final response = await remoteDataSource.acceptCall({
        'callId': callId,
        'receiverId': receiverId,
      });

      if (response['success'] == true) {
        final callData = response['call'] as Map<String, dynamic>;
        final callModel = CallModel.fromJson(callData);
        return Right(callModel.toEntity());
      } else {
        return Left(ServerFailure(
          response['error'] ?? 'Failed to accept call',
        ));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Call>> rejectCall({
    required String callId,
    required String receiverId,
  }) async {
    try {
      final response = await remoteDataSource.rejectCall({
        'callId': callId,
        'receiverId': receiverId,
      });

      if (response['success'] == true) {
        final callData = response['call'] as Map<String, dynamic>;
        final callModel = CallModel.fromJson(callData);
        return Right(callModel.toEntity());
      } else {
        return Left(ServerFailure(
          response['error'] ?? 'Failed to reject call',
        ));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Call>> endCall({
    required String callId,
  }) async {
    try {
      final response = await remoteDataSource.endCall({
        'callId': callId,
      });

      if (response['success'] == true) {
        // End call response doesn't include call data, just success confirmation
        // Return a basic call entity with the callId
        return Right(Call(
          id: callId,
          callerId: '',  // Not available in end response
          receiverId: '', // Not available in end response
          type: 'audio',  // Default, not available in end response
          status: 'ended',
          channelName: '',   // Not available in end response
          createdAt: DateTime.now(), // Not available in end response
          acceptedAt: null,
          endedAt: DateTime.now(),
          duration: response['duration'] as int?,
        ));
      } else {
        return Left(ServerFailure(
          response['error'] ?? 'Failed to end call',
        ));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AgoraToken>> joinCall({
    required String callId,
    required String userId,
  }) async {
    try {
      final response = await remoteDataSource.joinCall({
        'callId': callId,
        'userId': userId,
      });

      if (response['success'] == true) {
        final tokenModel = AgoraTokenModel.fromJson(response);
        return Right(tokenModel.toEntity());
      } else {
        return Left(ServerFailure(
          response['error'] ?? 'Failed to join call',
        ));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setCallLanguage({
    required String callId,
    required String userId,
    required String inputLang,
    required String outputLang,
  }) async {
    try {
      final response = await remoteDataSource.setCallLanguage([
        {
          'callId': callId,
          'userId': userId,
          'inputLang': inputLang,
          'outputLang': outputLang,
        }
      ]);

      if (response['success'] == true) {
        return const Right(null);
      } else {
        return Left(ServerFailure(
          response['error'] ?? 'Failed to set call language',
        ));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> generateAgoraToken({
    required String channelName,
    required int uid,
  }) async {
    try {
      final response = await remoteDataSource.generateAgoraToken({
        'channelName': channelName,
        'uid': uid,
      });

      if (response['success'] == true) {
        return Right(response['token'] as String);
      } else {
        return Left(ServerFailure(
          response['error'] ?? 'Failed to generate token',
        ));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Group Call Methods
  @override
  Future<Either<Failure, GroupCall>> initiateGroupCall({
    required String hostId,
    required String roomId,
    required String type,
  }) async {
    try {
      final response = await remoteDataSource.initiateGroupCall({
        'callerId': hostId,
        'receiverId': roomId, // Use room ID as receiver for group calls
        'type': type,
        'isGroup': true,
        'roomId': roomId,
      });

      if (response['success'] == true) {
        final callData = response['call'] as Map<String, dynamic>;
        // Convert regular call to group call format
        final groupCall = GroupCall(
          id: callData['id'] as String,
          hostId: hostId,
          roomId: roomId,
          type: type,
          status: callData['status'] as String? ?? 'initiated',
          channelName: callData['channel'] as String? ?? 'call_${callData['id']}',
          createdAt: DateTime.parse(callData['created_at'] as String),
          participants: [], // Will be populated as users join
        );
        return Right(groupCall);
      } else {
        return Left(ServerFailure(
          response['error'] ?? 'Failed to initiate group call',
        ));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> joinGroupCall({
    required String callId,
    required String userId,
  }) async {
    try {
      final response = await remoteDataSource.joinGroupCall({
        'callId': callId,
        'userId': userId,
      });

      if (response['success'] == true) {
        return Right(response);
      } else {
        return Left(ServerFailure(
          response['error'] ?? 'Failed to join group call',
        ));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> leaveGroupCall({
    required String callId,
    required String userId,
  }) async {
    try {
      final response = await remoteDataSource.leaveGroupCall({
        'callId': callId,
        'userId': userId,
      });

      if (response['success'] == true) {
        return const Right(null);
      } else {
        return Left(ServerFailure(
          response['error'] ?? 'Failed to leave group call',
        ));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GroupCall>> getGroupCallInfo({
    required String callId,
  }) async {
    try {
      final response = await remoteDataSource.getGroupCallInfo(callId);

      if (response['success'] == true) {
        final groupCallData = response['groupCall'] as Map<String, dynamic>;
        final groupCall = _groupCallFromJson(groupCallData);
        return Right(groupCall);
      } else {
        return Left(ServerFailure(
          response['error'] ?? 'Failed to get group call info',
        ));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateParticipantStatus({
    required String callId,
    required String userId,
    required bool isMuted,
    required bool isVideoOn,
  }) async {
    try {
      final response = await remoteDataSource.updateParticipantStatus({
        'callId': callId,
        'userId': userId,
        'isMuted': isMuted,
        'isVideoOn': isVideoOn,
      });

      if (response['success'] == true) {
        return const Right(null);
      } else {
        return Left(ServerFailure(
          response['error'] ?? 'Failed to update participant status',
        ));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Helper method to convert JSON to GroupCall entity
  GroupCall _groupCallFromJson(Map<String, dynamic> json) {
    final participantsJson = json['participants'] as List<dynamic>? ?? [];
    final participants = participantsJson
        .map((p) => GroupCallParticipant(
              userId: p['user_id'] as String,
              username: p['username'] as String,
              avatar: p['avatar'] as String?,
              isActive: p['is_active'] as bool? ?? false,
              isMuted: p['is_muted'] as bool? ?? false,
              isVideoOn: p['is_video_on'] as bool? ?? false,
              joinedAt: p['joined_at'] != null 
                  ? DateTime.parse(p['joined_at'] as String)
                  : null,
              leftAt: p['left_at'] != null 
                  ? DateTime.parse(p['left_at'] as String)
                  : null,
            ))
        .toList();

    return GroupCall(
      id: json['id'] as String,
      hostId: json['host_id'] as String,
      roomId: json['room_id'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      channelName: json['channel_name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      startedAt: json['started_at'] != null 
          ? DateTime.parse(json['started_at'] as String)
          : null,
      endedAt: json['ended_at'] != null 
          ? DateTime.parse(json['ended_at'] as String)
          : null,
      duration: json['duration'] as int?,
      participants: participants,
      settings: json['settings'] as Map<String, dynamic>?,
    );
  }

  // Translation Methods
  @override
  Future<Either<Failure, CallTranslation>> sendTranslation({
    required String callId,
    required String userId,
    required String text,
  }) async {
    try {
      final response = await remoteDataSource.sendTranslation({
        'callId': callId,
        'userId': userId,
        'text': text,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      if (response['success'] == true) {
        final translationModel = CallTranslationModel.fromJson(response);
        return Right(translationModel.toEntity());
      } else {
        return Left(ServerFailure(
          response['error'] ?? 'Failed to send translation',
        ));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SupportedLanguage>>> getSupportedLanguages() async {
    try {
      final response = await remoteDataSource.getSupportedLanguages();

      if (response['success'] == true) {
        final languagesResponse = SupportedLanguagesResponse.fromJson(response);
        return Right(languagesResponse.toEntityList());
      } else {
        return Left(ServerFailure(
          response['error'] ?? 'Failed to get supported languages',
        ));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
