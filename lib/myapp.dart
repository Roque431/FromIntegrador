import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/application/app_state.dart';
import 'core/router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_config.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appState.checkAuthStatus();
    });

    // Cargar colores desde .env y crear el tema
    final appColors = ThemeConfig.loadColorsFromEnv();
    final appTheme = AppTheme(appColors);
    final appRouter = AppRouter(appState: appState);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.router,
      theme: appTheme.lightTheme,
      darkTheme: appTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}