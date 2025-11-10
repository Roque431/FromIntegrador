import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import 'package:provider/provider.dart';
import '../presentation/providers/login_notifier.dart';
import '../widgets/login_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                              final ok = await context.read<LoginNotifier>().loginWithGoogle();
                              if (ok) {
                                if (context.mounted) context.goNamed(AppRoutes.welcome);
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('No se pudo iniciar sesión con Google')),
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
                          TextField(
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
                          LoginButton(
                            text: 'Continuar con correo electrónico',
                            onPressed: () {
                              // Aquí iría la navegación a la vista de login por correo
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