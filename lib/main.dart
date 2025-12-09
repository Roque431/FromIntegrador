import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'core/di/injection_container.dart' as di;
import 'core/application/app_state.dart'; 
import 'features/login/presentation/providers/login_notifier.dart';
import 'features/register/presentation/providers/register_notifier.dart';
import 'features/register/presentation/providers/verify_email_notifier.dart';
import 'features/home/presentation/providers/home_notifier.dart';
import 'features/subscription/presentation/providers/subscription_notifier.dart';
import 'features/forum/presentation/providers/foro_notifier.dart';
import 'features/forum/data/repository/foro_repository.dart';
import 'features/history/presentation/providers/historial_notifier.dart';
import 'features/history/data/repository/historial_repository.dart';
import 'features/chat/presentation/providers/chat_privado_notifier.dart';
import 'features/chat/data/repository/chat_privado_repository.dart';
import 'features/admin/presentation/providers/simple_admin_notifier.dart';
import 'features/admin/presentation/providers/simple_profile_validation_notifier.dart';
import 'features/moderation/presentation/providers/simple_moderation_notifier.dart';
import 'features/user_management/presentation/providers/simple_user_management_notifier.dart';
import 'myapp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase solo en móvil
  if (!kIsWeb) {
    try {
      await Firebase.initializeApp();
      print('✅ Firebase inicializado (móvil)');
    } catch (e) {
      print('⚠️ Firebase no disponible: $e');
    }
  } else {
    print('ℹ️ Web: Firebase omitido, usando Google Sign-In directo');
  }
  
  await dotenv.load(fileName: ".env");

  // Inicializar dependencias (Dependency Injection)
  await di.initializeDependencies();

  runApp(
    MultiProvider(
      providers: [
        // Application State
        ChangeNotifierProvider(create: (_) => di.sl<AppState>()),
        
        // Login - usando GetIt para inyección de dependencias
        ChangeNotifierProvider(create: (_) => di.sl<LoginNotifier>()),

        // Register
        ChangeNotifierProvider(create: (_) => di.sl<RegisterNotifier>()),
        
        // Verify Email
        ChangeNotifierProvider(create: (_) => di.sl<VerifyEmailNotifier>()),

        // Home (Consultas)
        ChangeNotifierProvider(create: (_) => di.sl<HomeNotifier>()),
        
        // Subscription (Transacciones y pagos)
        ChangeNotifierProvider(create: (_) => di.sl<SubscriptionNotifier>()),

        // Forum - ProxyProvider que obtiene userId del LoginRepository
        ChangeNotifierProxyProvider<LoginNotifier, ForoNotifier>(
          create: (_) => ForoNotifier(
            repository: di.sl<ForoRepository>(),
            currentUserId: null,
          ),
          update: (_, loginNotifier, previous) {
            // Obtener userId asíncronamente y crear nuevo notifier
            return ForoNotifier(
              repository: di.sl<ForoRepository>(),
              currentUserId: loginNotifier.currentUserId,
            );
          },
        ),

        // History - ProxyProvider que obtiene userId del LoginRepository
        ChangeNotifierProxyProvider<LoginNotifier, HistorialNotifier>(
          create: (_) => HistorialNotifier(
            repository: di.sl<HistorialRepository>(),
            currentUserId: null,
          ),
          update: (_, loginNotifier, previous) {
            return HistorialNotifier(
              repository: di.sl<HistorialRepository>(),
              currentUserId: loginNotifier.currentUserId,
            );
          },
        ),

        // Chat Privado - ProxyProvider que obtiene userId del LoginRepository
        ChangeNotifierProxyProvider<LoginNotifier, ChatPrivadoNotifier>(
          create: (_) => ChatPrivadoNotifier(
            repository: di.sl<ChatPrivadoRepository>(),
            currentUserId: null,
          ),
          update: (_, loginNotifier, previous) {
            // Reusar la instancia anterior para no perder el estado
            if (previous != null) {
              previous.setCurrentUserId(loginNotifier.currentUserId ?? '');
              return previous;
            }
            return ChatPrivadoNotifier(
              repository: di.sl<ChatPrivadoRepository>(),
              currentUserId: loginNotifier.currentUserId,
            );
          },
        ),

        // Admin - Conectado con datasource real
        ChangeNotifierProvider(create: (_) => SimpleAdminNotifier(
          adminDataSource: di.sl(),
        )),

        // Profile Validation - Versión simplificada para testing
        ChangeNotifierProvider(create: (_) => SimpleProfileValidationNotifier()),

        // Moderation - Versión simplificada para testing
        ChangeNotifierProvider(create: (_) => SimpleModerationNotifier()),

        // User Management - Versión simplificada para testing
        ChangeNotifierProvider(create: (_) => SimpleUserManagementNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}