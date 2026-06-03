# Flutter Absolute Clean Architecture Training Project

# Project Name
TaskFlow

A Flutter training project built using:
- Absolute Clean Architecture
- SOLID principles
- Repository Pattern
- Dependency Injection
- Cubit (flutter_bloc)
- Remote API
- Local Cache
- Error Handling
- Offline Support
- Unit Testing

---

# Technologies

| Purpose | Package |
|---|---|
| State Management | flutter_bloc |
| Equality | equatable |
| Networking | dio |
| Dependency Injection | get_it |
| Local Storage | hive |
| Functional Error Handling | dartz |
| Connectivity | internet_connection_checker |
| Testing | mocktail |

---

# Final Project Features

# Authentication
- Login
- Register
- Logout
- Save token locally
- Auto login

# Tasks
- Get tasks
- Create task
- Update task
- Delete task
- Search tasks
- Filter completed tasks
- Pagination
- Pull to refresh

# Offline Support
- Cache tasks locally
- Read cached data without internet

# Settings
- Dark mode
- Language switch

---

# Final Folder Structure

```txt
lib/
│
├── core/
│   ├── constants/
│   ├── error/
│   ├── network/
│   ├── usecases/
│   ├── utils/
│   └── widgets/
│
├── features/
│   │
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   │
│   │   └── presentation/
│   │       ├── cubit/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   └── tasks/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       │
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       │
│       └── presentation/
│           ├── cubit/
│           ├── pages/
│           └── widgets/
│
├── injection_container.dart
└── main.dart
```

---

# Clean Architecture Rules

# Rule 1
Presentation never talks directly to APIs.

# Rule 2
Domain layer NEVER imports Flutter.

# Rule 3
Data layer implements contracts from domain.

# Rule 4
Dependencies only move inward.

```txt
Presentation
    ↓
Domain
    ↓
Data
```

---

# CORE LAYER

The core layer contains shared reusable code.

---

# core/error/

# exceptions.dart

```dart
class ServerException implements Exception {}

class CacheException implements Exception {}

class UnauthorizedException implements Exception {}
```

---

# failures.dart

```dart
abstract class Failure {}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class UnauthorizedFailure extends Failure {}
```

---

# core/network/

# network_info.dart

```dart
abstract class NetworkInfo {
  Future<bool> get isConnected;
}
```

```dart
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker checker;

  NetworkInfoImpl(this.checker);

  @override
  Future<bool> get isConnected async =>
      await checker.hasConnection;
}
```

---

# core/usecases/

# usecase.dart

```dart
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}
```

---

# AUTH FEATURE

# DOMAIN LAYER

The domain layer contains business logic.

---

# auth/domain/entities/user.dart

```dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String token;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  @override
  List<Object?> get props => [id, name, email, token];
}
```

---

# auth/domain/repositories/auth_repository.dart

```dart
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(
    String email,
    String password,
  );
}
```

---

# auth/domain/usecases/login_usecase.dart

```dart
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call(
    String email,
    String password,
  ) async {
    return await repository.login(email, password);
  }
}
```

---

# DATA LAYER

The data layer handles:
- APIs
- Local database
- Models
- Repository implementations

---

# auth/data/models/user_model.dart

```dart
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
    };
  }
}
```

---

# auth/data/datasources/auth_remote_data_source.dart

```dart
abstract class AuthRemoteDataSource {
  Future<UserModel> login(
    String email,
    String password,
  );
}
```

---

# auth/data/datasources/auth_remote_data_source_impl.dart

```dart
class AuthRemoteDataSourceImpl
    implements AuthRemoteDataSource {

  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login(
    String email,
    String password,
  ) async {

    final response = await dio.post(
      '/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return UserModel.fromJson(response.data);
  }
}
```

---

# auth/data/repositories/auth_repository_impl.dart

```dart
class AuthRepositoryImpl implements AuthRepository {

  final AuthRemoteDataSource remote;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remote,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login(
    String email,
    String password,
  ) async {

    if (await networkInfo.isConnected) {
      try {
        final result = await remote.login(
          email,
          password,
        );

        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(CacheFailure());
    }
  }
}
```

---

# PRESENTATION LAYER

The presentation layer contains:
- UI
- Cubits
- State classes

---

# auth/presentation/cubit/auth_state.dart

```dart
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
```

---

# auth/presentation/cubit/auth_cubit.dart

```dart
class AuthCubit extends Cubit<AuthState> {

  final LoginUseCase loginUseCase;

  AuthCubit(this.loginUseCase)
      : super(AuthInitial());

  Future<void> login(
    String email,
    String password,
  ) async {

    emit(AuthLoading());

    final result = await loginUseCase(
      email,
      password,
    );

    result.fold(
      (failure) {
        emit(AuthError('Login Failed'));
      },
      (user) {
        emit(AuthSuccess(user));
      },
    );
  }
}
```

---

# auth/presentation/pages/login_page.dart

```dart
class LoginPage extends StatelessWidget {

  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushNamed(context, '/tasks');
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              TextField(controller: emailController),
              TextField(controller: passwordController),

              ElevatedButton(
                onPressed: () {
                  context.read<AuthCubit>().login(
                    emailController.text,
                    passwordController.text,
                  );
                },
                child: const Text('Login'),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

---

# TASKS FEATURE

---

# tasks/domain/entities/task.dart

```dart
class Task extends Equatable {
  final int id;
  final String title;
  final bool completed;

  const Task({
    required this.id,
    required this.title,
    required this.completed,
  });

  @override
  List<Object?> get props => [id, title, completed];
}
```

---

# tasks/domain/repositories/task_repository.dart

```dart
abstract class TaskRepository {
  Future<List<Task>> getTasks();

  Future<void> createTask(Task task);

  Future<void> deleteTask(int id);
}
```

---

# tasks/domain/usecases/get_tasks_usecase.dart

```dart
class GetTasksUseCase {

  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  Future<List<Task>> call() async {
    return await repository.getTasks();
  }
}
```

---

# tasks/data/models/task_model.dart

```dart
class TaskModel extends Task {

  const TaskModel({
    required super.id,
    required super.title,
    required super.completed,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}
```

---

# tasks/data/datasources/task_remote_data_source.dart

```dart
abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
}
```

---

# tasks/data/datasources/task_remote_data_source_impl.dart

```dart
class TaskRemoteDataSourceImpl
    implements TaskRemoteDataSource {

  final Dio dio;

  TaskRemoteDataSourceImpl(this.dio);

  @override
  Future<List<TaskModel>> getTasks() async {

    final response = await dio.get('/todos');

    return (response.data as List)
        .map((e) => TaskModel.fromJson(e))
        .toList();
  }
}
```

---

# tasks/data/datasources/task_local_data_source.dart

```dart
abstract class TaskLocalDataSource {
  Future<void> cacheTasks(List<TaskModel> tasks);

  Future<List<TaskModel>> getCachedTasks();
}
```

---

# tasks/data/repositories/task_repository_impl.dart

```dart
class TaskRepositoryImpl implements TaskRepository {

  final TaskRemoteDataSource remote;
  final TaskLocalDataSource local;
  final NetworkInfo networkInfo;

  TaskRepositoryImpl({
    required this.remote,
    required this.local,
    required this.networkInfo,
  });

  @override
  Future<List<Task>> getTasks() async {

    if (await networkInfo.isConnected) {

      final remoteTasks = await remote.getTasks();

      await local.cacheTasks(remoteTasks);

      return remoteTasks;
    } else {

      return await local.getCachedTasks();
    }
  }

  @override
  Future<void> createTask(Task task) async {}

  @override
  Future<void> deleteTask(int id) async {}
}
```

---

# tasks/presentation/cubit/task_state.dart

```dart
abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;

  TaskLoaded(this.tasks);
}

class TaskError extends TaskState {
  final String message;

  TaskError(this.message);
}
```

---

# tasks/presentation/cubit/task_cubit.dart

```dart
class TaskCubit extends Cubit<TaskState> {

  final GetTasksUseCase getTasksUseCase;

  TaskCubit(this.getTasksUseCase)
      : super(TaskInitial());

  Future<void> getTasks() async {

    emit(TaskLoading());

    try {
      final tasks = await getTasksUseCase();

      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
```

---

# tasks/presentation/pages/tasks_page.dart

```dart
class TasksPage extends StatelessWidget {

  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {

          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is TaskLoaded) {
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {

                final task = state.tasks[index];

                return ListTile(
                  title: Text(task.title),
                  trailing: Checkbox(
                    value: task.completed,
                    onChanged: (_) {},
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
```

---

# Dependency Injection

# injection_container.dart

```dart
final sl = GetIt.instance;

Future<void> init() async {

  // Cubits
  sl.registerFactory(
    () => AuthCubit(sl()),
  );

  sl.registerFactory(
    () => TaskCubit(sl()),
  );

  // UseCases
  sl.registerLazySingleton(
    () => LoginUseCase(sl()),
  );

  sl.registerLazySingleton(
    () => GetTasksUseCase(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remote: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      remote: sl(),
      local: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  // External
  sl.registerLazySingleton(() => Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
    ),
  ));

  sl.registerLazySingleton(
    () => InternetConnectionChecker(),
  );
}
```

---

# main.dart

```dart
void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await init();

  runApp(const MyApp());
}
```

---

# How Data Flows

```txt
UI
↓
Cubit
↓
UseCase
↓
Repository Contract
↓
Repository Implementation
↓
Data Source
↓
API / Database
```

Response:

```txt
API
↓
Model
↓
Repository
↓
Entity
↓
Cubit
↓
UI
```

---

# Difference Between Entity And Model

# Entity
Business object.
Pure domain object.

```dart
Task
```

# Model
API/database representation.

```dart
TaskModel
```

Models can:
- parse JSON
- serialize JSON

Entities cannot.

---

# Why Repository Pattern Exists

Without repository:

```txt
UI → API
```

Hard to:
- test
- switch backend
- add cache
- maintain

With repository:

```txt
UI → Repository → API
```

Repository becomes the abstraction layer.

---

# Why UseCases Exist

UseCases isolate business logic.

Bad:

```dart
Cubit contains business rules
```

Good:

```dart
Cubit → UseCase
```

The cubit only manages UI state.

---

# Recommended Development Order

# Step 1
Build:
- Folder structure
- Dependency injection
- Network layer

# Step 2
Build authentication.

# Step 3
Build tasks CRUD.

# Step 4
Add offline cache.

# Step 5
Add search and filtering.

# Step 6
Add testing.

---

# Testing Structure

```txt
test/
│
├── features/
│   ├── auth/
│   └── tasks/
│
├── core/
└── helpers/
```

---

# Unit Test Example

```dart
void main() {

  late GetTasksUseCase usecase;
  late MockTaskRepository repository;

  setUp(() {
    repository = MockTaskRepository();
    usecase = GetTasksUseCase(repository);
  });

  test('should get tasks from repository', () async {

    when(() => repository.getTasks())
        .thenAnswer((_) async => []);

    final result = await usecase();

    expect(result, []);
  });
}
```

---

# Common Beginner Mistakes

# Mistake 1
Putting API calls inside UI.

Wrong:

```dart
onPressed() async {
  final response = await dio.get(...)
}
```

---

# Mistake 2
Using models everywhere.

Wrong:

```dart
TaskModel task
```

inside UI.

Use entities instead.

---

# Mistake 3
Business logic inside cubit.

Wrong:

```dart
if (user.role == 'admin')
```

inside UI/cubit.

Move to usecase.

---

# Mistake 4
Skipping domain layer.

Domain layer is the heart of clean architecture.

---

# Real Enterprise Additions Later

After mastering this project you can add:

- Firebase
- GraphQL
- WebSockets
- CI/CD
- Feature flags
- Micro frontends
- Modular architecture
- Localization
- Analytics
- Crash reporting
- Push notifications

---

# Final Mental Model

# Presentation Layer
"How it looks"

# Domain Layer
"What the app does"

# Data Layer
"Where data comes from"

---

# Final Architecture Summary

```txt
PRESENTATION
- Pages
- Widgets
- Cubits

DOMAIN
- Entities
- Repository Contracts
- UseCases

DATA
- Models
- Datasources
- Repository Implementations
```

---

# Best APIs For Practice

Use:
- https://jsonplaceholder.typicode.com
- https://reqres.in

---

# Final Goal

When you fully understand this project you will understand:

- Real clean architecture
- SOLID principles
- Enterprise Flutter structure
- State management correctly
- Dependency injection
- Offline-first apps
- Testable architecture
- Scalable project structure

This is the same foundation used in large production Flutter applications.

