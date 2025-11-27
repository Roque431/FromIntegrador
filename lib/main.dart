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
      ],
      child: const MyApp(),
    ),
  );
}