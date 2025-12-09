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
import 'package:flutter_application_1/features/chat/presentation/pages/conversaciones_page.dart';
import 'package:flutter_application_1/features/chat/presentation/pages/chat_privado_page.dart';
import 'package:flutter_application_1/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:flutter_application_1/features/admin/presentation/pages/profile_validation_page.dart';
import 'package:flutter_application_1/features/moderation/presentation/pages/moderation_page.dart';
import 'package:flutter_application_1/features/user_management/presentation/pages/user_management_page.dart';
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
import '../../features/profile/presentation/pages/about_page.dart';
import '../../features/profile/presentation/pages/help_center_page.dart';
import '../../features/profile/presentation/pages/password_recovery_page.dart' as pwd_recovery;
import '../../features/subscription/presentation/pages/subscription_screen.dart';
import '../../features/history/presentation/pages/history_page.dart';

class AppRouter {
  final AppState appState;

  AppRouter({required this.appState});

  late final router = GoRouter(
    refreshListenable: appState,
    
    // Iniciar en login para autenticación
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
        name: AppRoutes.aboutApp,
        path: '/profile/about',
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        name: AppRoutes.helpCenter,
        path: '/profile/help',
        builder: (context, state) => const HelpCenterPage(),
      ),
      GoRoute(
        name: AppRoutes.passwordRecovery,
        path: '/profile/password-recovery',
        builder: (context, state) => const pwd_recovery.PasswordRecoveryPage(),
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
      
      // Rutas de chat privado
      GoRoute(
        name: AppRoutes.conversations,
        path: '/conversations',
        builder: (context, state) => const ConversacionesPage(),
      ),
      GoRoute(
        name: AppRoutes.chatPrivado,
        path: '/chat/:ciudadanoId/:abogadoId',
        builder: (context, state) {
          final ciudadanoId = state.pathParameters['ciudadanoId'] ?? '';
          final abogadoId = state.pathParameters['abogadoId'] ?? '';
          return ChatPrivadoPage(ciudadanoId: ciudadanoId, abogadoId: abogadoId);
        },
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
      
      // Rutas de administración
      GoRoute(
        name: AppRoutes.admin,
        path: '/admin',
        builder: (context, state) => const AdminDashboardPage(),
      ),
      GoRoute(
        name: AppRoutes.moderation,
        path: '/moderation',
        builder: (context, state) => const ModerationPage(),
      ),
      GoRoute(
        name: AppRoutes.profileValidation,
        path: '/profile-validation',
        builder: (context, state) => const ProfileValidationPage(),
      ),
      GoRoute(
        name: AppRoutes.userManagement,
        path: '/user-management',
        builder: (context, state) => const UserManagementPage(),
      ),
    ],
    
    // Redirect para manejar autenticación y rutas protegidas
    redirect: (context, state) {
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToRegister = state.matchedLocation == '/register';
      final isGoingToVerifyEmail = state.matchedLocation.startsWith('/verify-email');
      final isGoingToLegalMap = state.matchedLocation == '/legal-map';
      
      // Rutas de administración - PROTEGIDAS
      final isGoingToAdmin = state.matchedLocation.startsWith('/admin');
      final isGoingToModeration = state.matchedLocation.startsWith('/moderation');
      final isGoingToProfileValidation = state.matchedLocation.startsWith('/profile-validation');
      final isGoingToUserManagement = state.matchedLocation.startsWith('/user-management');

      // Si aún estamos verificando el estado de autenticación, no redirigir
      if (appState.authStatus == AuthStatus.checking) return null;

      // Permitir acceso al mapa legal (público) sin autenticación
      if (isGoingToLegalMap) return null;

      // PROTEGER rutas de admin - requieren autenticación Y ser admin
      if (isGoingToAdmin || isGoingToModeration || isGoingToProfileValidation || isGoingToUserManagement) {
        if (!appState.isAuthenticated) {
          return '/login';
        }
        // Aquí puedes agregar validación de rol de admin si tienes esa funcionalidad
        // Por ahora permitimos el acceso si está autenticado
        return null;
      }

      // Si no está autenticado y no va a páginas públicas, redirigir a login
      if (!appState.isAuthenticated && !isGoingToLogin && !isGoingToRegister && !isGoingToVerifyEmail) {
        return '/login';
      }

      // Si está autenticado y va a login, redirigir según tipo de usuario
      if (appState.isAuthenticated && isGoingToLogin) {
        final loginNotifier = context.read<LoginNotifier>();
        final user = loginNotifier.currentUser;

        if (user != null) {
          final email = user.email.toLowerCase();
          if (email == 'admin@lexia.local') {
            return '/admin';
          }
          if (user.isLawyer) {
            return '/lawyer';
          }
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
