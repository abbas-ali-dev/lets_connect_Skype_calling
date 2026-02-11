import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injections.config.dart';

// 🎯 DEPENDENCY INJECTION - Service Locator
// This is where all dependencies are registered and managed

// Global instance of GetIt (service locator)
final getIt = GetIt.instance;

// Initialize all dependencies
@InjectableInit()
Future<void> configureDependencies() async => getIt.init();