import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';

// Login Feature
import '../../features/login/data/datasource/login_datasource.dart';
import '../../features/login/data/repository/login_repository_impl.dart';
import '../../features/login/domain/repository/login_repository.dart';
import '../../features/login/domain/usecase/login_usecase.dart';
import '../../features/login/domain/usecase/logout_usecase.dart';
import '../../features/login/presentation/providers/login_notifier.dart';

// Register Feature
import '../../features/register/data/datasource/register_datasource.dart';
import '../../features/register/data/repository/register_repository_impl.dart';
import '../../features/register/domain/repository/register_repository.dart';
import '../../features/register/domain/usecase/register_usecase.dart';
import '../../features/register/presentation/providers/register_notifier.dart';

final sl = GetIt.instance; // Service Locator

Future<void> initializeDependencies() async {
  // ============================================
  // External Dependencies
  // ============================================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  sl.registerLazySingleton<http.Client>(() => http.Client());

  // ============================================
  // Core
  // ============================================
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(httpClient: sl()),
  );

  // ============================================
  // Login Feature
  // ============================================

  // Data sources
  sl.registerLazySingleton<LoginDataSource>(
    () => LoginDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      dataSource: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(repository: sl()));

  // Providers
  sl.registerFactory(
    () => LoginNotifier(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      loginRepository: sl(),
    ),
  );

  // ============================================
  // Register Feature
  // ============================================

  // Data sources
  sl.registerLazySingleton<RegisterDataSource>(
    () => RegisterDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImpl(
      dataSource: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => RegisterUseCase(repository: sl()));

  // Providers
  sl.registerFactory(
    () => RegisterNotifier(
      registerUseCase: sl(),
    ),
  );
}
