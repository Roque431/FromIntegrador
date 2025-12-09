import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import '../application/app_state.dart';
import '../services/google_sign_in_service.dart';

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
import '../../features/register/domain/usecase/send_verification_code_usecase.dart';
import '../../features/register/domain/usecase/verify_email_usecase.dart';
import '../../features/register/presentation/providers/register_notifier.dart';
import '../../features/register/presentation/providers/verify_email_notifier.dart';

// Home Feature
import '../../features/home/data/datasource/consultation_datasource.dart';
import '../../features/home/data/repository/consultation_repository_impl.dart';
import '../../features/home/domain/repository/consultation_repository.dart';
import '../../features/home/domain/usecase/send_message_usecase.dart';
import '../../features/home/domain/usecase/get_chat_history_usecase.dart';
import '../../features/home/presentation/providers/home_notifier.dart';

// Subscription Feature
import '../../features/subscription/data/datasource/transaction_datasource.dart';
import '../../features/subscription/data/repository/transaction_repository.dart';
import '../../features/subscription/domain/usecases/create_checkout_usecase.dart';
import '../../features/subscription/domain/usecases/get_user_transactions_usecase.dart';
import '../../features/subscription/presentation/providers/subscription_notifier.dart';

// Consultation Feature  
import '../../features/consultation/data/datasource/consultation_datasource.dart';
import '../../features/consultation/data/repository/consultation_repository.dart' as nlp;

// Legal Content Feature
import '../../features/legal_content/data/datasource/legal_content_datasource.dart';
import '../../features/legal_content/data/repository/legal_content_repository.dart';
import '../../features/legal_content/presentation/providers/legal_content_notifier.dart';

// Location Feature
import '../../features/location/data/datasources/location_datasource.dart';

// Forum Feature
import '../../features/forum/data/repository/foro_repository.dart';
import '../../features/forum/presentation/providers/foro_notifier.dart';

// History Feature
import '../../features/history/data/repository/historial_repository.dart';
import '../../features/history/presentation/providers/historial_notifier.dart';

// Chat Privado Feature
import '../../features/chat/data/repository/chat_privado_repository.dart';
import '../../features/chat/presentation/providers/chat_privado_notifier.dart';

// Admin Feature
import '../../features/admin/data/datasources/admin_datasource.dart';

// Security - Secure Storage
import '../storage/secure_token_repository.dart';

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

  // Application State
  sl.registerLazySingleton<AppState>(() => AppState());

  // Google Sign-In Service
  sl.registerLazySingleton<GoogleSignInService>(() => GoogleSignInService());

  // Secure Token Repository (MSTG-STORAGE compliance)
  sl.registerLazySingleton<SecureTokenRepository>(() => SecureTokenRepository());

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
      secureTokenRepository: sl(),
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
      googleSignInService: sl(),
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
      loginDataSource: sl(),
      sharedPreferences: sl(),
      secureTokenRepository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => RegisterUseCase(repository: sl()));
  sl.registerLazySingleton(() => SendVerificationCodeUseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));

  // Providers
  sl.registerFactory(
    () => RegisterNotifier(
      registerUseCase: sl(),
    ),
  );
  
  sl.registerFactory(
    () => VerifyEmailNotifier(
      sendVerificationCodeUseCase: sl(),
      verifyEmailUseCase: sl(),
    ),
  );

  // ============================================
  // Home Feature
  // ============================================

  // Data sources
  sl.registerLazySingleton<ConsultationDataSource>(
    () => ConsultationDataSourceImpl(
      apiClient: sl(),
      sharedPreferences: sl(),
      secureTokenRepository: sl(),
      loginRepository: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<ConsultationRepository>(
    () => ConsultationRepositoryImpl(
      dataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SendMessageUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetChatHistoryUseCase(repository: sl()));

  // Providers
  sl.registerFactory(
    () => HomeNotifier(
      sendMessageUseCase: sl(),
      getChatHistoryUseCase: sl(),
      loginRepository: sl(),
      apiClient: sl(),
      foroRepository: sl(),
    ),
  );

  // ============================================
  // Subscription Feature
  // ============================================

  // Data sources
  sl.registerLazySingleton<TransactionDatasource>(
    () => TransactionDatasource(sl()),
  );

  // Repository
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepository(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => CreateCheckoutUseCase(sl()));
  sl.registerLazySingleton(() => GetUserTransactionsUseCase(sl()));

  // Providers
  sl.registerFactory(
    () => SubscriptionNotifier(
      createCheckoutUseCase: sl(),
      getUserTransactionsUseCase: sl(),
    ),
  );

  // ============================================
  // Consultation Feature (NLP Chatbot)
  // ============================================

  // Data sources
  sl.registerLazySingleton<ConsultationDatasource>(
    () => ConsultationDatasource(sl()),
  );

  // Repository
  sl.registerLazySingleton<nlp.ConsultationRepository>(
    () => nlp.ConsultationRepository(sl()),
  );

  // ============================================
  // Legal Content Feature
  // ============================================

  // Data sources
  sl.registerLazySingleton<LegalContentDatasource>(
    () => LegalContentDatasource(sl()),
  );

  // Repository
  sl.registerLazySingleton<LegalContentRepository>(
    () => LegalContentRepository(sl()),
  );

  // Providers
  sl.registerFactory(
    () => LegalContentNotifier(repository: sl()),
  );

  // ============================================
  // Location Feature
  // ============================================

  // Data sources
  sl.registerLazySingleton<LocationDataSource>(
    () => LocationDataSourceImpl(apiClient: sl()),
  );

  // ============================================
  // Forum Feature
  // ============================================

  // Repository
  sl.registerLazySingleton<ForoRepository>(
    () => ForoRepository(apiClient: sl()),
  );

  // Provider - Factory para que obtenga userId del LoginRepository
  sl.registerFactoryParam<ForoNotifier, String?, void>(
    (userId, _) => ForoNotifier(
      repository: sl(),
      currentUserId: userId,
    ),
  );

  // ============================================
  // History Feature
  // ============================================

  // Repository
  sl.registerLazySingleton<HistorialRepository>(
    () => HistorialRepository(apiClient: sl()),
  );

  // Provider - Factory para que obtenga userId del LoginRepository
  sl.registerFactoryParam<HistorialNotifier, String?, void>(
    (userId, _) => HistorialNotifier(
      repository: sl(),
      currentUserId: userId,
    ),
  );

  // ============================================
  // Chat Privado Feature
  // ============================================

  // Repository
  sl.registerLazySingleton<ChatPrivadoRepository>(
    () => ChatPrivadoRepository(apiClient: sl()),
  );

  // Provider - Factory para que obtenga userId del LoginRepository
  sl.registerFactoryParam<ChatPrivadoNotifier, String?, void>(
    (userId, _) => ChatPrivadoNotifier(
      repository: sl(),
      currentUserId: userId,
    ),
  );

  // ============================================
  // Admin Feature
  // ============================================
  
  // Data sources
  sl.registerLazySingleton<AdminDataSource>(
    () => AdminDataSourceImpl(apiClient: sl()),
  );
}
