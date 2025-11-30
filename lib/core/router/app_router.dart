import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/consultation/presentation/pages/consultation_detail_page.dart';
import 'package:flutter_application_1/features/forum/pages/forum_detail_page.dart';
import 'package:flutter_application_1/features/forum/pages/forum_page.dart';
import 'package:flutter_application_1/features/home/presentation/pages/home_page.dart';
import 'package:flutter_application_1/features/legal_content/presentation/pages/legal_content_search_page.dart';
import 'package:flutter_application_1/features/legal_content/presentation/pages/content_detail_page.dart';
import 'package:flutter_application_1/features/location/presentation/pages/legal_map_page.dart';
import 'package:flutter_application_1/features/lawyer/presentation/pages/lawyer_home_page.dart';
import 'package:flutter_application_1/features/lawyer/presentation/pages/lawyer_profile_page.dart';
import 'package:flutter_application_1/features/lawyer/presentation/pages/my_consultations_page.dart';
import 'package:flutter_application_1/features/lawyer/presentation/pages/lawyer_subscription_page.dart';
import 'package:flutter_application_1/features/lawyer/presentation/pages/lawyer_forum_page.dart';
import 'package:flutter_application_1/features/profile/presentation/pages/lawyer_verification_page.dart';
import 'package:flutter_application_1/features/business/presentation/pages/business_registration_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../application/app_state.dart';
import 'routes.dart';
import '../../features/login/pages/login_page.dart';
import '../../features/login/presentation/providers/login_notifier.dart';
import '../../features/register/presentation/pages/register_page.dart';
import '../../features/register/presentation/pages/verify_email_page.dart';
import '../../features/welcome/presentation/pages/welcome_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/subscription/presentation/pages/subscription_screen.dart';
import '../../features/history/presentation/pages/history_page.dart';

class AppRouter {
  final AppState appState;

  AppRouter({required this.appState});

  late final router = GoRouter(
    refreshListenable: appState,
    
    // Cambiar a login como inicial para que el redirect funcione
    initialLocation: '/login',
    
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
        name: AppRoutes.verifyEmail,
        path: '/verify-email',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return VerifyEmailPage(email: email);
        },
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
        name: AppRoutes.editProfile,
        path: '/profile/edit',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        name: AppRoutes.subscription,
        path: '/subscription',
        builder: (context, state) => const SubscriptionScreen(),
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
      GoRoute(
        name: AppRoutes.legalContent,
        path: '/legal-content',
        builder: (context, state) => const LegalContentSearchPage(),
      ),
      GoRoute(
        name: AppRoutes.contentDetail,
        path: '/legal-content/:id',
        builder: (context, state) {
          final contentId = state.pathParameters['id'] ?? '0';
          return ContentDetailPage(contentId: contentId);
        },
      ),
      GoRoute(
        name: AppRoutes.legalMap,
        path: '/legal-map',
        builder: (context, state) => const LegalMapPage(),
      ),
      // Rutas del abogado
      GoRoute(
        name: AppRoutes.lawyerHome,
        path: '/lawyer',
        builder: (context, state) => const LawyerHomePage(),
      ),
      GoRoute(
        name: AppRoutes.lawyerProfile,
        path: '/lawyer/profile',
        builder: (context, state) => const LawyerProfilePage(),
      ),
      GoRoute(
        name: AppRoutes.lawyerConsultations,
        path: '/lawyer/consultations',
        builder: (context, state) => const MyConsultationsPage(),
      ),
      GoRoute(
        name: AppRoutes.lawyerSubscription,
        path: '/lawyer/subscription',
        builder: (context, state) => const LawyerSubscriptionPage(),
      ),
      GoRoute(
        name: AppRoutes.lawyerForum,
        path: '/lawyer/forum',
        builder: (context, state) => const LawyerForumPage(),
      ),
      
      // Rutas de verificación profesional
      GoRoute(
        name: AppRoutes.lawyerVerification,
        path: '/lawyer-verification',
        builder: (context, state) => const LawyerVerificationPage(),
      ),
      GoRoute(
        name: AppRoutes.businessRegistration,
        path: '/business-registration',
        builder: (context, state) => const BusinessRegistrationPage(),
      ),
    ],
    
    // Habilitar redirect para manejar autenticación
    redirect: (context, state) {
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToRegister = state.matchedLocation == '/register';
      final isGoingToVerifyEmail = state.matchedLocation.startsWith('/verify-email');

      if (appState.authStatus == AuthStatus.checking) return null;

      if (!appState.isAuthenticated && !isGoingToLogin && !isGoingToRegister && !isGoingToVerifyEmail) {
        return '/login';
      }

      // Redirigir según tipo de usuario al hacer login
      if (appState.isAuthenticated && isGoingToLogin) {
        // Obtener el LoginNotifier para saber el tipo de usuario
        final loginNotifier = context.read<LoginNotifier>();
        final user = loginNotifier.currentUser;

        if (user != null && user.isLawyer) {
          return '/lawyer';
        }
        return '/home';
      }

      return null;
    },
    
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
