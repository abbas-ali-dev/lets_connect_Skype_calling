// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:lets_connect/core/di/core_module.dart' as _i406;
import 'package:lets_connect/core/network/dio_client.dart' as _i277;
import 'package:lets_connect/core/network/network_info.dart' as _i744;
import 'package:lets_connect/core/services/ably_service.dart' as _i723;
import 'package:lets_connect/core/services/agora_service.dart' as _i1044;
import 'package:lets_connect/core/services/call_event_manager.dart' as _i382;
import 'package:lets_connect/core/services/call_translation_service.dart'
    as _i597;
import 'package:lets_connect/core/services/fcm_remote_data_source.dart'
    as _i718;
import 'package:lets_connect/core/services/fcm_service.dart' as _i117;
import 'package:lets_connect/core/services/tts_service.dart' as _i353;
import 'package:lets_connect/features/auth/data/datasources/auth_local_data_source.dart'
    as _i707;
import 'package:lets_connect/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i602;
import 'package:lets_connect/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i423;
import 'package:lets_connect/features/auth/data/repositories/auth_repository_impl.dart'
    as _i293;
import 'package:lets_connect/features/auth/domain/repositories/auth_repositories.dart'
    as _i273;
import 'package:lets_connect/features/auth/domain/usecases/check_auth_status_usecase.dart'
    as _i927;
import 'package:lets_connect/features/auth/domain/usecases/forget_password_usecase.dart'
    as _i761;
import 'package:lets_connect/features/auth/domain/usecases/login_usecases.dart'
    as _i442;
import 'package:lets_connect/features/auth/domain/usecases/logoutusecase.dart'
    as _i883;
import 'package:lets_connect/features/auth/domain/usecases/register_usecases.dart'
    as _i720;
import 'package:lets_connect/features/auth/domain/usecases/reset_password_usecase.dart'
    as _i734;
import 'package:lets_connect/features/auth/domain/usecases/verify_otp_usecase.dart'
    as _i456;
import 'package:lets_connect/features/auth/presentation/bloc/auth_bloc.dart'
    as _i142;
import 'package:lets_connect/features/call/data/datasources/ably_auth_remote_data_source.dart'
    as _i760;
import 'package:lets_connect/features/call/data/datasources/call_remote_data_source.dart'
    as _i182;
import 'package:lets_connect/features/call/data/repositories/call_repository_impl.dart'
    as _i583;
import 'package:lets_connect/features/call/domain/repositories/call_repository.dart'
    as _i1020;
import 'package:lets_connect/features/call/domain/usecases/accept_call_usecase.dart'
    as _i284;
import 'package:lets_connect/features/call/domain/usecases/end_call_usecase.dart'
    as _i836;
import 'package:lets_connect/features/call/domain/usecases/get_supported_languages_usecase.dart'
    as _i277;
import 'package:lets_connect/features/call/domain/usecases/group_call_usecases.dart'
    as _i630;
import 'package:lets_connect/features/call/domain/usecases/initialize_translation_usecase.dart'
    as _i1044;
import 'package:lets_connect/features/call/domain/usecases/initiate_call_usecase.dart'
    as _i342;
import 'package:lets_connect/features/call/domain/usecases/join_call_usecase.dart'
    as _i793;
import 'package:lets_connect/features/call/domain/usecases/reject_call_usecase.dart'
    as _i842;
import 'package:lets_connect/features/call/domain/usecases/send_translation_usecase.dart'
    as _i585;
import 'package:lets_connect/features/call/presentation/bloc/call_bloc.dart'
    as _i468;
import 'package:lets_connect/features/chat/data/datasources/chat_remote_data_source.dart'
    as _i120;
import 'package:lets_connect/features/chat/data/repositories/chat_repository_impl.dart'
    as _i918;
import 'package:lets_connect/features/chat/domain/repositories/chat_repository.dart'
    as _i900;
import 'package:lets_connect/features/chat/domain/usecases/create_room_usecase.dart'
    as _i806;
import 'package:lets_connect/features/chat/domain/usecases/get_dashboard_usecase.dart'
    as _i625;
import 'package:lets_connect/features/chat/domain/usecases/get_messages_usecase.dart'
    as _i1018;
import 'package:lets_connect/features/chat/domain/usecases/group_usecases.dart'
    as _i449;
import 'package:lets_connect/features/chat/domain/usecases/search_user_usecase.dart'
    as _i578;
import 'package:lets_connect/features/chat/domain/usecases/send_message_usecase.dart'
    as _i842;
import 'package:lets_connect/features/chat/presentation/bloc/chat_bloc.dart'
    as _i545;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final coreModule = _$CoreModule();
    gh.lazySingleton<_i277.DioClient>(() => coreModule.dioClient);
    gh.lazySingleton<_i744.NetworkInfo>(() => coreModule.networkInfo);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => coreModule.secureStorage);
    gh.lazySingleton<_i361.Dio>(() => coreModule.dio);
    gh.lazySingleton<_i1044.AgoraService>(() => _i1044.AgoraService());
    gh.lazySingleton<_i723.AblyService>(() => _i723.AblyService());
    gh.lazySingleton<_i382.CallEventManager>(() => _i382.CallEventManager());
    gh.lazySingleton<_i353.TTSService>(() => _i353.TTSService());
    gh.lazySingleton<_i707.AuthLocalDataSource>(
        () => _i707.AuthLocalDataSourceImpl(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i597.CallTranslationService>(
        () => _i597.CallTranslationService(gh<_i353.TTSService>()));
    gh.lazySingleton<_i718.FCMRemoteDataSource>(
        () => _i718.FCMRemoteDataSource(gh<_i361.Dio>()));
    gh.lazySingleton<_i182.CallRemoteDataSource>(
        () => _i182.CallRemoteDataSource(gh<_i361.Dio>()));
    gh.lazySingleton<_i760.AblyAuthRemoteDataSource>(
        () => _i760.AblyAuthRemoteDataSource(gh<_i361.Dio>()));
    gh.lazySingleton<_i1020.CallRepository>(() => _i583.CallRepositoryImpl(
        remoteDataSource: gh<_i182.CallRemoteDataSource>()));
    gh.lazySingleton<_i120.ChatRemoteDataSource>(
        () => _i120.ChatRemoteDataSourceImpl(gh<_i277.DioClient>()));
    gh.lazySingleton<_i900.ChatRepository>(() => _i918.ChatRepositoryImpl(
        remoteDataSource: gh<_i120.ChatRemoteDataSource>()));
    gh.lazySingleton<_i602.AuthRemoteDataSource>(
        () => _i602.AuthRemoteDataSourceImpl(gh<_i277.DioClient>()));
    gh.lazySingleton<_i117.FCMService>(
        () => _i117.FCMService(gh<_i718.FCMRemoteDataSource>()));
    gh.lazySingleton<_i449.CreateGroupUseCase>(
        () => _i449.CreateGroupUseCase(gh<_i900.ChatRepository>()));
    gh.lazySingleton<_i449.GetGroupDetailsUseCase>(
        () => _i449.GetGroupDetailsUseCase(gh<_i900.ChatRepository>()));
    gh.lazySingleton<_i449.UpdateGroupInfoUseCase>(
        () => _i449.UpdateGroupInfoUseCase(gh<_i900.ChatRepository>()));
    gh.lazySingleton<_i449.AddGroupMembersUseCase>(
        () => _i449.AddGroupMembersUseCase(gh<_i900.ChatRepository>()));
    gh.lazySingleton<_i449.RemoveGroupMemberUseCase>(
        () => _i449.RemoveGroupMemberUseCase(gh<_i900.ChatRepository>()));
    gh.lazySingleton<_i449.LeaveGroupUseCase>(
        () => _i449.LeaveGroupUseCase(gh<_i900.ChatRepository>()));
    gh.lazySingleton<_i449.MakeAdminUseCase>(
        () => _i449.MakeAdminUseCase(gh<_i900.ChatRepository>()));
    gh.lazySingleton<_i449.RemoveAdminUseCase>(
        () => _i449.RemoveAdminUseCase(gh<_i900.ChatRepository>()));
    gh.lazySingleton<_i449.SearchUsersUseCase>(
        () => _i449.SearchUsersUseCase(gh<_i900.ChatRepository>()));
    gh.lazySingleton<_i578.SearchUserUseCase>(
        () => _i578.SearchUserUseCase(gh<_i900.ChatRepository>()));
    gh.lazySingleton<_i1018.GetMessagesUseCase>(
        () => _i1018.GetMessagesUseCase(gh<_i900.ChatRepository>()));
    gh.lazySingleton<_i806.CreateRoomUseCase>(
        () => _i806.CreateRoomUseCase(gh<_i900.ChatRepository>()));
    gh.lazySingleton<_i625.GetDashboardUseCase>(
        () => _i625.GetDashboardUseCase(gh<_i900.ChatRepository>()));
    gh.lazySingleton<_i842.SendMessageUseCase>(
        () => _i842.SendMessageUseCase(gh<_i900.ChatRepository>()));
    gh.lazySingleton<_i423.AuthRemoteDataSource>(
        () => _i423.AuthRemoteDataSourceImpl(gh<_i277.DioClient>()));
    gh.lazySingleton<_i277.GetSupportedLanguagesUseCase>(
        () => _i277.GetSupportedLanguagesUseCase(gh<_i1020.CallRepository>()));
    gh.lazySingleton<_i1044.InitializeTranslationUseCase>(
        () => _i1044.InitializeTranslationUseCase(gh<_i1020.CallRepository>()));
    gh.lazySingleton<_i585.SendTranslationUseCase>(
        () => _i585.SendTranslationUseCase(gh<_i1020.CallRepository>()));
    gh.lazySingleton<_i842.RejectCallUseCase>(
        () => _i842.RejectCallUseCase(repository: gh<_i1020.CallRepository>()));
    gh.lazySingleton<_i836.EndCallUseCase>(
        () => _i836.EndCallUseCase(repository: gh<_i1020.CallRepository>()));
    gh.lazySingleton<_i793.JoinCallUseCase>(
        () => _i793.JoinCallUseCase(repository: gh<_i1020.CallRepository>()));
    gh.lazySingleton<_i342.InitiateCallUseCase>(() =>
        _i342.InitiateCallUseCase(repository: gh<_i1020.CallRepository>()));
    gh.lazySingleton<_i284.AcceptCallUseCase>(
        () => _i284.AcceptCallUseCase(repository: gh<_i1020.CallRepository>()));
    gh.lazySingleton<_i630.InitiateGroupCallUseCase>(() =>
        _i630.InitiateGroupCallUseCase(
            repository: gh<_i1020.CallRepository>()));
    gh.lazySingleton<_i630.JoinGroupCallUseCase>(() =>
        _i630.JoinGroupCallUseCase(repository: gh<_i1020.CallRepository>()));
    gh.lazySingleton<_i630.LeaveGroupCallUseCase>(() =>
        _i630.LeaveGroupCallUseCase(repository: gh<_i1020.CallRepository>()));
    gh.lazySingleton<_i630.GetGroupCallInfoUseCase>(() =>
        _i630.GetGroupCallInfoUseCase(repository: gh<_i1020.CallRepository>()));
    gh.lazySingleton<_i630.UpdateParticipantStatusUseCase>(() =>
        _i630.UpdateParticipantStatusUseCase(
            repository: gh<_i1020.CallRepository>()));
    gh.factory<_i545.ChatBloc>(() => _i545.ChatBloc(
          searchUserUseCase: gh<_i578.SearchUserUseCase>(),
          getDashboardUseCase: gh<_i625.GetDashboardUseCase>(),
          createRoomUseCase: gh<_i806.CreateRoomUseCase>(),
          sendMessageUseCase: gh<_i842.SendMessageUseCase>(),
          getMessagesUseCase: gh<_i1018.GetMessagesUseCase>(),
          chatRepository: gh<_i900.ChatRepository>(),
          createGroupUseCase: gh<_i449.CreateGroupUseCase>(),
          getGroupDetailsUseCase: gh<_i449.GetGroupDetailsUseCase>(),
          updateGroupInfoUseCase: gh<_i449.UpdateGroupInfoUseCase>(),
          addGroupMembersUseCase: gh<_i449.AddGroupMembersUseCase>(),
          removeGroupMemberUseCase: gh<_i449.RemoveGroupMemberUseCase>(),
          leaveGroupUseCase: gh<_i449.LeaveGroupUseCase>(),
          makeAdminUseCase: gh<_i449.MakeAdminUseCase>(),
          removeAdminUseCase: gh<_i449.RemoveAdminUseCase>(),
          searchUsersUseCase: gh<_i449.SearchUsersUseCase>(),
        ));
    gh.lazySingleton<_i273.AuthRepository>(() => _i293.AuthRepositoryImpl(
          remoteDataSource: gh<_i423.AuthRemoteDataSource>(),
          localDataSource: gh<_i707.AuthLocalDataSource>(),
        ));
    gh.lazySingleton<_i761.ForgetPasswordUseCase>(
        () => _i761.ForgetPasswordUseCase(gh<_i273.AuthRepository>()));
    gh.lazySingleton<_i442.LoginUseCase>(
        () => _i442.LoginUseCase(gh<_i273.AuthRepository>()));
    gh.lazySingleton<_i883.LogoutUseCase>(
        () => _i883.LogoutUseCase(gh<_i273.AuthRepository>()));
    gh.lazySingleton<_i734.ResetPasswordUseCase>(
        () => _i734.ResetPasswordUseCase(gh<_i273.AuthRepository>()));
    gh.lazySingleton<_i720.SignupUseCase>(
        () => _i720.SignupUseCase(gh<_i273.AuthRepository>()));
    gh.lazySingleton<_i456.VerifyOtpUseCase>(
        () => _i456.VerifyOtpUseCase(gh<_i273.AuthRepository>()));
    gh.factory<_i927.CheckAuthStatusUseCase>(
        () => _i927.CheckAuthStatusUseCase(gh<_i273.AuthRepository>()));
    gh.lazySingleton<_i468.CallBloc>(() => _i468.CallBloc(
          initiateCallUseCase: gh<_i342.InitiateCallUseCase>(),
          acceptCallUseCase: gh<_i284.AcceptCallUseCase>(),
          rejectCallUseCase: gh<_i842.RejectCallUseCase>(),
          endCallUseCase: gh<_i836.EndCallUseCase>(),
          joinCallUseCase: gh<_i793.JoinCallUseCase>(),
          initializeTranslationUseCase:
              gh<_i1044.InitializeTranslationUseCase>(),
          sendTranslationUseCase: gh<_i585.SendTranslationUseCase>(),
          getSupportedLanguagesUseCase:
              gh<_i277.GetSupportedLanguagesUseCase>(),
          callTranslationService: gh<_i597.CallTranslationService>(),
        ));
    gh.factory<_i142.AuthBloc>(() => _i142.AuthBloc(
          loginUseCase: gh<_i442.LoginUseCase>(),
          signupUseCase: gh<_i720.SignupUseCase>(),
          verifyOtpUseCase: gh<_i456.VerifyOtpUseCase>(),
          forgetPasswordUseCase: gh<_i761.ForgetPasswordUseCase>(),
          resetPasswordUseCase: gh<_i734.ResetPasswordUseCase>(),
          logoutUseCase: gh<_i883.LogoutUseCase>(),
          checkAuthStatusUseCase: gh<_i927.CheckAuthStatusUseCase>(),
        ));
    return this;
  }
}

class _$CoreModule extends _i406.CoreModule {}
