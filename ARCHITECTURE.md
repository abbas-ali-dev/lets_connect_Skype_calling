# Let's Connect - MVVM + BLoC Architecture

## 📁 Project Structure

```
lib/
├── core/                          # Core functionality
│   ├── constants/                 # App-wide constants
│   │   └── app_constants.dart
│   ├── di/                        # Dependency Injection
│   │   ├── injection.dart
│   │   ├── injection.config.dart  # Generated
│   │   └── core_module.dart
│   ├── error/                     # Error handling
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/                   # Network configuration
│   │   ├── dio_client.dart
│   │   └── network_info.dart
│   └── utils/                     # Utilities
│       └── logger.dart
│
├── features/                      # Feature modules
│   └── auth/                      # Authentication feature
│       ├── data/                  # Data layer
│       │   ├── datasources/       # Remote & Local data sources
│       │   │   ├── auth_remote_data_source.dart
│       │   │   └── auth_local_data_source.dart
│       │   ├── models/            # Data models (JSON serializable)
│       │   │   ├── user_model.dart
│       │   │   ├── user_model.freezed.dart  # Generated
│       │   │   └── user_model.g.dart        # Generated
│       │   └── repositories/      # Repository implementations
│       │       └── auth_repository_impl.dart
│       │
│       ├── domain/                # Domain layer (Business Logic)
│       │   ├── entities/          # Business entities
│       │   │   └── user.dart
│       │   ├── repositories/      # Repository interfaces
│       │   │   └── auth_repository.dart
│       │   └── usecases/          # Use cases
│       │       ├── login_usecase.dart
│       │       ├── register_usecase.dart
│       │       └── logout_usecase.dart
│       │
│       └── presentation/          # Presentation layer (UI)
│           ├── bloc/              # BLoC (State Management)
│           │   ├── auth_bloc.dart
│           │   ├── auth_event.dart
│           │   └── auth_state.dart
│           ├── pages/             # Full screen pages
│           │   └── login_page.dart
│           └── widgets/           # Reusable widgets
│
└── main.dart                      # App entry point
```

## 🏗️ Architecture Layers

### 1. **Presentation Layer** (UI + BLoC)
- **Pages**: Full screen UI components
- **Widgets**: Reusable UI components
- **BLoC**: State management
  - **Events**: User actions
  - **States**: UI states
  - **Bloc**: Business logic coordinator

### 2. **Domain Layer** (Business Logic)
- **Entities**: Pure Dart business objects
- **Repositories**: Abstract interfaces
- **Use Cases**: Single responsibility business operations

### 3. **Data Layer** (Data Management)
- **Models**: JSON serializable data classes
- **Data Sources**: 
  - Remote (API calls)
  - Local (Cache/Storage)
- **Repository Implementations**: Concrete repository classes

## 🔄 Data Flow

```
UI (Widget)
    ↓ dispatch event
BLoC (Business Logic)
    ↓ call
UseCase (Domain Logic)
    ↓ call
Repository Interface (Domain)
    ↓ implements
Repository Implementation (Data)
    ↓ uses
DataSource (Remote/Local)
    ↓ returns
Model → Entity → State
    ↓ emit
BLoC → UI Update
```

## 🎯 Key Principles

### MVVM (Model-View-ViewModel)
- **Model**: Domain entities + Data models
- **View**: UI widgets and pages
- **ViewModel**: BLoC (manages state and business logic)

### Clean Architecture
- **Separation of Concerns**: Each layer has a specific responsibility
- **Dependency Rule**: Dependencies point inward (Presentation → Domain ← Data)
- **Testability**: Each layer can be tested independently

### SOLID Principles
- **Single Responsibility**: Each class has one reason to change
- **Open/Closed**: Open for extension, closed for modification
- **Liskov Substitution**: Subtypes must be substitutable
- **Interface Segregation**: Many specific interfaces over one general
- **Dependency Inversion**: Depend on abstractions, not concretions

## 🔧 Dependency Injection

Using **get_it** + **injectable**:

```dart
// Register dependencies
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  
  AuthBloc({required this.loginUseCase});
}

// Use in UI
BlocProvider(
  create: (_) => getIt<AuthBloc>(),
  child: LoginView(),
)
```

## 📦 Code Generation

Run these commands to generate code:

```bash
# Install dependencies
flutter pub get

# Generate code (one-time)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes (development)
flutter pub run build_runner watch --delete-conflicting-outputs
```

Generated files:
- `*.freezed.dart` - Immutable models with copyWith
- `*.g.dart` - JSON serialization
- `injection.config.dart` - Dependency injection configuration

## 🚀 Adding New Features

### Step 1: Create Feature Folder
```
features/
└── new_feature/
    ├── data/
    ├── domain/
    └── presentation/
```

### Step 2: Domain Layer
1. Create entity in `domain/entities/`
2. Create repository interface in `domain/repositories/`
3. Create use cases in `domain/usecases/`

### Step 3: Data Layer
1. Create model in `data/models/` with `@freezed`
2. Create data sources in `data/datasources/`
3. Implement repository in `data/repositories/`

### Step 4: Presentation Layer
1. Create BLoC (events, states, bloc) in `presentation/bloc/`
2. Create pages in `presentation/pages/`
3. Create widgets in `presentation/widgets/`

### Step 5: Register Dependencies
Add `@injectable` or `@lazySingleton` annotations

### Step 6: Generate Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🧪 Testing Strategy

```
test/
├── core/
├── features/
│   └── auth/
│       ├── data/
│       │   ├── models/
│       │   ├── datasources/
│       │   └── repositories/
│       ├── domain/
│       │   └── usecases/
│       └── presentation/
│           └── bloc/
```

- **Unit Tests**: Use cases, repositories, data sources
- **Widget Tests**: UI components
- **Integration Tests**: Full feature flows
- **BLoC Tests**: State transitions

## 📚 Dependencies

### State Management
- `flutter_bloc` - BLoC pattern implementation
- `equatable` - Value equality

### Dependency Injection
- `get_it` - Service locator
- `injectable` - Code generation for DI

### Network
- `dio` - HTTP client
- `retrofit` - Type-safe REST client
- `pretty_dio_logger` - Network logging

### Local Storage
- `shared_preferences` - Key-value storage
- `flutter_secure_storage` - Secure storage

### Functional Programming
- `dartz` - Either, Option types for error handling

### Code Generation
- `freezed` - Immutable models
- `json_serializable` - JSON serialization
- `build_runner` - Code generation runner

## 🎨 Best Practices

1. **Keep layers independent** - Domain layer should have no dependencies
2. **Use dependency injection** - Never use `new` or direct instantiation
3. **Handle errors properly** - Use `Either<Failure, Success>` pattern
4. **Write tests** - Aim for high coverage
5. **Keep BLoCs thin** - Business logic in use cases
6. **Use const constructors** - For better performance
7. **Follow naming conventions** - Clear and consistent names
8. **Document complex logic** - Add comments where needed

## 🔐 Error Handling

```dart
// Use Either for operations that can fail
Future<Either<Failure, User>> login(String email, String password) async {
  try {
    final user = await remoteDataSource.login(email, password);
    return Right(user);
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  }
}
```

## 🎯 Next Steps

1. Run `flutter pub get`
2. Run `flutter pub run build_runner build --delete-conflicting-outputs`
3. Start building your features!

For a Skype-like app, consider adding these features:
- **Calling**: WebRTC integration (agora_rtc_engine or webrtc_flutter)
- **Messaging**: Real-time chat with WebSocket
- **Contacts**: User management
- **Media**: File upload/download
- **Notifications**: Push notifications
