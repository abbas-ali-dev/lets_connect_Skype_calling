import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../network/dio_client.dart';
import '../network/network_info.dart';

// 🎯 CORE MODULE - Registers core dependencies
// These are the foundational services used throughout the app

@module
abstract class CoreModule {
  // Register DioClient as a lazy singleton
  @lazySingleton
  DioClient get dioClient => DioClient();

  // Register NetworkInfo as a lazy singleton
  @lazySingleton
  NetworkInfo get networkInfo => NetworkInfoImpl();

  // Register FlutterSecureStorage as a lazy singleton
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  // Register Dio instance from DioClient
  @lazySingleton
  Dio get dio => dioClient.dio;
}