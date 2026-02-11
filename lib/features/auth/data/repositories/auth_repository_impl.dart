import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repositories.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_datasource.dart';

// 🎯 AUTH REPOSITORY IMPLEMENTATION
// Connects remote and local data sources, handles errors

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      
      // Save user ID locally
      await localDataSource.saveUserId(userModel.id);
      
      // Save access token if available
      if (userModel.token != null) {
        await localDataSource.saveAccessToken(userModel.token!);
      }
      
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> signup(
    String email,
    String username,
    String phone,
    String password,
  ) async {
    try {
      final message = await remoteDataSource.signup(email, username, phone, password);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtp(String email, String otp) async {
    try {
      final userModel = await remoteDataSource.verifyOtp(email, otp);
      
      // Save user data and token locally
      await localDataSource.saveUserId(userModel.id);
      if (userModel.token != null) {
        await localDataSource.saveAccessToken(userModel.token!);
      }
      
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> forgetPassword(String email) async {
    try {
      final message = await remoteDataSource.forgetPassword(email);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    try {
      await remoteDataSource.resetPassword(email, otp, newPassword);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearAuthData();
      return const Right(null);
    } on ServerException {
      // Even if server logout fails, clear local data
      await localDataSource.clearAuthData();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final userId = await localDataSource.getUserId();
      return Right(userId != null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> checkAuthStatus() async {
    try {
      final userId = await localDataSource.getUserId();
      final accessToken = await localDataSource.getAccessToken();
      
      if (userId != null && accessToken != null) {
        // User has stored credentials, return basic user info
        return Right(User(
          id: userId,
          email: '', // We don't store email locally
          username: '', // We don't store username locally  
          phone: '', // We don't store phone locally
          token: accessToken,
        ));
      }
      
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAblyToken() async {
    try {
      final tokenData = await remoteDataSource.getAblyToken();
      return Right(tokenData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
