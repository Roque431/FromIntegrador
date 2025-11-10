import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/consultation/presentation/pages/consultation_detail_page.dart';
import 'package:flutter_application_1/features/forum/pages/forum_detail_page.dart';
import 'package:flutter_application_1/features/forum/pages/forum_page.dart';
import 'package:flutter_application_1/features/home/presentation/pages/home_page.dart';
import 'package:go_router/go_router.dart';
import '../../features/login/presentation/providers/login_notifier.dart';
import 'routes.dart';
import '../../features/login/pages/login_page.dart';
import '../../features/register/presentation/pages/register_page.dart';
import '../../features/welcome/presentation/pages/welcome_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/history/presentation/pages/history_page.dart';

class AppRouter {
  final LoginNotifier loginNotifier;

  AppRouter({required this.loginNotifier});

  late final router = GoRouter(
    refreshListenable: loginNotifier,
    
    // ⚠️ TEMPORAL: Cambiado a /home para desarrollo
    initialLocation: '/home',
    
    routes: [
      GoRoute(
        name: AppRoutes.login,
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: AppRoutes.home,
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        name: AppRoutes.register,
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        name: AppRoutes.welcome,
        path: '/welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      // 👇 NUEVA RUTA
      GoRoute(
        name: AppRoutes.profile,
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        name: AppRoutes.history,
        path: '/history',
        builder: (context, state) => const HistoryPage(),
      ),
      // 👇 NUEVA RUTA - DETALLE DE CONSULTA
      GoRoute(
        name: AppRoutes.consultationDetail,
        path: '/consultation/:id',
        builder: (context, state) {
          final consultationId = state.pathParameters['id'] ?? '';
          return ConsultationDetailPage(consultationId: consultationId);
        },
      ),
      GoRoute(
        name: AppRoutes.forum,
        path: '/forum',
        builder: (context, state) => const ForumPage(),
      ),
      GoRoute(
        name: AppRoutes.forumDetail,
        path: '/forum/:id',
        builder: (context, state) {
          final postId = state.pathParameters['id'] ?? '';
          return ForumDetailPage(postId: postId);
        },
      ),
    ],
    
    // ⚠️ TEMPORAL: Redirect comentado para desarrollo
    /*
    redirect: (context, state) {
      final isGoingToLogin = state.matchedLocation == '/login';
      if (loginNotifier.state == LoginState.loading) return null;
      if (!loginNotifier.isAuthenticated && !isGoingToLogin) {
        return '/login';
      }
      if (loginNotifier.isAuthenticated && isGoingToLogin) {
        return '/home';
      }
      return null;
    },
    */
    
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    ),
  );
}
