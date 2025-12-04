import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/responsive_text_field.dart';
import '../../../../core/widgets/responsive_widgets.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../providers/register_notifier.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
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
    final logoSize = isDesktop ? 100.0 : (isWide ? 90.0 : 70.0);
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
                  SizedBox(height: isWide ? 8 : 6),
                  
                  // Subtítulo
                  Text(
                    'Crear cuenta',
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
                        // Campo Nombre
                        ResponsiveTextField(
                          controller: _nameController,
                          hintText: 'Ingresa tu nombre',
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Campo Apellidos
                        ResponsiveTextField(
                          controller: _lastNameController,
                          hintText: 'Ingresa tus apellidos (opcional)',
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Campo Correo
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

                        // Botón Registrar
                        ResponsiveButton(
                          text: 'Crear cuenta',
                          isLoading: _isLoading,
                          onPressed: () => _handleRegister(context),
                        ),
                        const SizedBox(height: 16),

                        // Divider
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
                                '¿Ya tienes cuenta?',
                                style: TextStyle(
                                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                                  fontSize: 13,
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

                        // Botón Login
                        ResponsiveButton(
                          text: 'Iniciar sesión',
                          isOutlined: true,
                          onPressed: () {
                            context.goNamed(AppRoutes.login);
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

  Future<void> _handleRegister(BuildContext context) async {
    final registerNotifier = context.read<RegisterNotifier>();

    // Validar que los campos no estén vacíos
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      LexiaAlert.warning(
        context,
        title: 'Campos incompletos',
        message: 'Por favor completa todos los campos requeridos',
      );
      return;
    }

    // Validar formato de email
    if (!_emailController.text.contains('@')) {
      LexiaAlert.warning(
        context,
        title: 'Email inválido',
        message: 'Por favor ingresa un correo electrónico válido',
      );
      return;
    }

    // Validar longitud de contraseña
    if (_passwordController.text.length < 6) {
      LexiaAlert.warning(
        context,
        title: 'Contraseña muy corta',
        message: 'La contraseña debe tener al menos 6 caracteres',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await registerNotifier.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        lastName: _lastNameController.text.trim().isNotEmpty
            ? _lastNameController.text.trim()
            : null,
      );

      if (context.mounted) {
        if (success) {
          // Mostrar alerta de éxito
          LexiaAlert.success(
            context,
            title: '¡Cuenta creada exitosamente!',
            message: 'Te hemos enviado un correo de verificación',
          );
          
          // Navegar a la pantalla de verificación de email
          await Future.delayed(const Duration(milliseconds: 500));
          if (context.mounted) {
            context.go('/verify-email?email=${Uri.encodeComponent(_emailController.text.trim())}');
          }
        } else {
          LexiaAlert.error(
            context,
            title: 'Error al registrarse',
            message: registerNotifier.errorMessage ?? 'Inténtalo de nuevo más tarde',
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
