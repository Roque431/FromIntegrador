import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/application/app_state.dart';
import 'package:provider/provider.dart';
import '../presentation/providers/login_notifier.dart';
import '../widgets/login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

    return Scaffold(
      backgroundColor: colors.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: isWeb ? 40 : 24,
              horizontal: isWeb ? 24 : 16,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isWeb ? 450 : 380),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'lib/img/portada.png',
                    width: isWeb ? 110 : 90,
                    height: isWeb ? 110 : 90,
                  ),
                  SizedBox(height: isWeb ? 16 : 12),
                  Text(
                    'LexIA',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.tertiary,
                          fontSize: isWeb ? 28 : null,
                        ),
                  ),
                  SizedBox(height: isWeb ? 20 : 16),
                  Text(
                    'La justicia empieza con el conocimiento.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colors.tertiary.withValues(alpha: 0.85),
                          fontSize: isWeb ? 18 : null,
                        ),
                  ),
                  SizedBox(height: isWeb ? 32 : 24),

                  // Card contenedora
                  Material(
                    color: Colors.white,
                    elevation: isWeb ? 8 : 6,
                    borderRadius: BorderRadius.circular(isWeb ? 20 : 16),
                    child: Padding(
                      padding: EdgeInsets.all(isWeb ? 24.0 : 16.0),
                      child: Column(
                        children: [
                          LoginButton(
                            text: 'Continuar con Google',
                            onPressed: () async {
                              final loginNotifier = context.read<LoginNotifier>();
                              final ok = await loginNotifier.loginWithGoogle();
                              if (ok) {
                                // Actualizar estado de autenticación
                                final appState = context.read<AppState>();
                                appState.login();

                                // Redirigir según tipo de usuario
                                if (context.mounted) {
                                  final user = loginNotifier.currentUser;
                                  if (user != null && user.isLawyer) {
                                    context.go('/lawyer');
                                  } else {
                                    context.goNamed(AppRoutes.home);
                                  }
                                }
                              } else {
                                if (context.mounted) {
                                  final errorMessage = loginNotifier.errorMessage ?? 'No se pudo iniciar sesión con Google';
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(errorMessage),
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 4),
                                    ),
                                  );
                                }
                              }
                            },
                            backgroundColor: colors.secondary,
                            textColor: Colors.white,
                          ),
                          const SizedBox(height: 12),
                          Text('o', style: TextStyle(color: colors.tertiary.withValues(alpha: 0.6))),
                          const SizedBox(height: 12),
                          
                          // Campo Email
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Ingresa tu correo electrónico',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: colors.secondary, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Campo Contraseña
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Ingresa tu contraseña',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: colors.secondary, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Botón Login con Email
                          LoginButton(
                            text: 'Iniciar Sesión',
                            onPressed: () async {
                              // Validar campos
                              if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Por favor ingresa email y contraseña'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              // Intentar login
                              final loginNotifier = context.read<LoginNotifier>();
                              final success = await loginNotifier.login(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              );

                              if (context.mounted) {
                                if (success) {
                                  // Actualizar estado de autenticación
                                  final appState = context.read<AppState>();
                                  appState.login();

                                  // Redirigir según tipo de usuario
                                  final user = loginNotifier.currentUser;
                                  if (user != null && user.isLawyer) {
                                    context.go('/lawyer');
                                  } else {
                                    context.goNamed(AppRoutes.home);
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(loginNotifier.errorMessage ?? 'Error al iniciar sesión'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            backgroundColor: colors.secondary,
                            textColor: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Al continuar aceptas las Políticas de Privacidad.',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: colors.tertiary.withValues(alpha: 0.7)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),

                          // Botón de Registrar
                          OutlinedButton(
                            onPressed: () {
                              context.goNamed(AppRoutes.register);
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              side: BorderSide(color: colors.secondary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Registrar',
                              style: TextStyle(
                                color: colors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
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
}