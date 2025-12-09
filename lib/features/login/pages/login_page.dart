import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/application/app_state.dart';
import '../../../core/widgets/responsive_text_field.dart';
import '../../../core/widgets/responsive_widgets.dart';
import '../../../core/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';
import '../presentation/providers/login_notifier.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    
    // Detectar si es tablet/desktop o móvil
    final isWide = size.width > 600;
    final isDesktop = size.width > 900;
    
    // Calcular tamaños responsivos
    final logoSize = isDesktop ? 120.0 : (isWide ? 100.0 : 80.0);
    final titleSize = isDesktop ? 32.0 : (isWide ? 28.0 : 24.0);
    final subtitleSize = isDesktop ? 18.0 : (isWide ? 16.0 : 14.0);
    final cardPadding = isDesktop ? 32.0 : (isWide ? 24.0 : 20.0);
    final maxWidth = isDesktop ? 480.0 : (isWide ? 420.0 : 380.0);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveSize.verticalPadding(context),
              horizontal: ResponsiveSize.horizontalPadding(context),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'lib/img/portada.png',
                    width: logoSize,
                    height: logoSize,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.gavel,
                      size: logoSize,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: isWide ? 16 : 12),
                  
                  // Título
                  Text(
                    'LexIA',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                      fontSize: titleSize,
                    ),
                  ),
                  SizedBox(height: isWide ? 12 : 8),
                  
                  // Subtítulo
                  Text(
                    'La justicia empieza con el conocimiento.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: subtitleSize,
                    ),
                  ),
                  SizedBox(height: isWide ? 32 : 24),

                  // Card contenedora
                  ResponsiveCard(
                    padding: EdgeInsets.all(cardPadding),
                    child: Column(
                      children: [
                        // Botón Google
                        ResponsiveButton(
                          text: 'Continuar con Google',
                          icon: Icon(
                            Icons.g_mobiledata,
                            size: 24,
                            color: colorScheme.onPrimary,
                          ),
                          isLoading: _isLoading,
                          onPressed: () => _handleGoogleLogin(context),
                        ),
                        const SizedBox(height: 16),
                        
                        // Divider con "o"
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: colorScheme.outline.withValues(alpha: 0.5),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'o',
                                style: TextStyle(
                                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: colorScheme.outline.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Campo Email
                        ResponsiveTextField(
                          controller: _emailController,
                          hintText: 'Ingresa tu correo electrónico',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Campo Contraseña con toggle de visibilidad
                        PasswordTextField(
                          controller: _passwordController,
                          hintText: 'Ingresa tu contraseña',
                        ),
                        const SizedBox(height: 20),
                        
                        // Botón Login
                        ResponsiveButton(
                          text: 'Iniciar Sesión',
                          isLoading: _isLoading,
                          onPressed: () => _handleEmailLogin(context),
                        ),
                        const SizedBox(height: 12),
                        
                        // Texto de políticas
                        Text(
                          'Al continuar aceptas las Políticas de Privacidad.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // Botón de Registrar
                        ResponsiveButton(
                          text: 'Crear cuenta nueva',
                          isOutlined: true,
                          onPressed: () {
                            context.goNamed(AppRoutes.register);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleLogin(BuildContext context) async {
    setState(() => _isLoading = true);
    
    try {
      final loginNotifier = context.read<LoginNotifier>();
      final ok = await loginNotifier.loginWithGoogle();
      
      if (ok && context.mounted) {
        final appState = context.read<AppState>();
        appState.login();

        // Mostrar alerta de éxito
        LexiaAlert.success(
          context,
          title: '¡Bienvenido de nuevo!',
          message: 'Has iniciado sesión correctamente con Google',
        );

        final user = loginNotifier.currentUser;
        if (user != null) {
          final email = user.email.toLowerCase();
          if (email == 'admin@lexia.local') {
            context.go('/admin');
            return;
          }
          if (user.isLawyer) {
            context.go('/lawyer');
            return;
          }
        }
        context.goNamed(AppRoutes.home);
      } else if (context.mounted) {
        final errorMessage = loginNotifier.errorMessage ?? 'No se pudo iniciar sesión con Google';
        LexiaAlert.error(
          context,
          title: 'Error de autenticación',
          message: errorMessage,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleEmailLogin(BuildContext context) async {
    // Validar campos
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      LexiaAlert.warning(
        context,
        title: 'Campos incompletos',
        message: 'Por favor ingresa tu email y contraseña',
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final loginNotifier = context.read<LoginNotifier>();
      final success = await loginNotifier.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (context.mounted) {
        if (success) {
          final appState = context.read<AppState>();
          appState.login();

          // Mostrar alerta de éxito
          LexiaAlert.success(
            context,
            title: '¡Inicio de sesión exitoso!',
            message: 'Bienvenido a LexIA',
          );

          final user = loginNotifier.currentUser;
          if (user != null) {
            final email = user.email.toLowerCase();
            if (email == 'admin@lexia.local') {
              context.go('/admin');
              return;
            }
            if (user.isLawyer) {
              context.go('/lawyer');
              return;
            }
          }
          context.goNamed(AppRoutes.home);
        } else {
          LexiaAlert.error(
            context,
            title: 'Error al iniciar sesión',
            message: loginNotifier.errorMessage ?? 'Verifica tus credenciales',
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(BuildContext context, String message) {
    LexiaAlert.error(
      context,
      title: 'Error',
      message: message,
    );
  }
}