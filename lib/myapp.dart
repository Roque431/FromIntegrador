import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/login/presentation/providers/login_notifier.dart';
import 'core/router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_config.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final loginNotifier = Provider.of<LoginNotifier>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginNotifier.checkAuthStatus();
    });

    // Cargar colores desde .env y crear el tema
    final appColors = ThemeConfig.loadColorsFromEnv();
    final appTheme = AppTheme(appColors);
    final appRouter = AppRouter(loginNotifier: loginNotifier);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.router,
      theme: appTheme.lightTheme,
      darkTheme: appTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}