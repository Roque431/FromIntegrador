import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/routes.dart';
import '../../../login/widgets/login_button.dart';
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
                  SizedBox(height: isWeb ? 12 : 8),
                  Text(
                    'Register',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colors.tertiary.withValues(alpha: 0.85),
                          fontSize: isWeb ? 20 : null,
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
                          // Campo Nombre
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'Ingresa tu nombre',
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

                          // Campo Apellidos
                          TextField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              hintText: 'Ingresa tus apellidos',
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

                          // Campo Correo
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
                          const SizedBox(height: 16),

                          // Botón Registrar
                          LoginButton(
                            text: 'Register',
                            onPressed: () async {
                              final registerNotifier = context.read<RegisterNotifier>();

                              // Validar que los campos no estén vacíos
                              if (_nameController.text.isEmpty ||
                                  _emailController.text.isEmpty ||
                                  _passwordController.text.isEmpty) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Por favor completa todos los campos requeridos'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                                return;
                              }

                              // Llamar al registro
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
                                  // Obtener los datos del usuario registrado
                                  final registeredUser = registerNotifier.registeredUser;
                                  final token = registerNotifier.token;
                                  
                                  print('🔍 DEBUG Register Success:');
                                  print('   User: ${registeredUser?.name} ${registeredUser?.lastName}');
                                  print('   Email: ${registeredUser?.email}');
                                  print('   Token: ${token != null ? "Sí" : "No"}');
                                  
                                  // Navegar a la pantalla de verificación de email
                                  context.go('/verify-email?email=${Uri.encodeComponent(_emailController.text.trim())}');
                                } else {
                                  // Mostrar error
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        registerNotifier.errorMessage ?? 'Error al registrarse',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            backgroundColor: colors.secondary,
                            textColor: Colors.white,
                          ),
                          const SizedBox(height: 16),

                          // Botón Login (para ir a login)
                          OutlinedButton(
                            onPressed: () {
                              context.goNamed(AppRoutes.login);
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              side: BorderSide(color: colors.secondary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Login',
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
