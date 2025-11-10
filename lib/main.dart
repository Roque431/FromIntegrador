import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'core/di/injection_container.dart' as di;
import 'features/login/presentation/providers/login_notifier.dart';
import 'features/register/presentation/providers/register_notifier.dart';

import 'myapp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno
  await dotenv.load(fileName: ".env");

  // Inicializar dependencias (Dependency Injection)
  await di.initializeDependencies();

  runApp(
    MultiProvider(
      providers: [
        // Login - usando GetIt para inyección de dependencias
        ChangeNotifierProvider(create: (_) => di.sl<LoginNotifier>()),

        // Register
        ChangeNotifierProvider(create: (_) => di.sl<RegisterNotifier>()),

        // Aquí agregarás más providers cuando integres otras features:
        // ChangeNotifierProvider(create: (_) => di.sl<HomeNotifier>()),
      ],
      child: const MyApp(),
    ),
  );
}