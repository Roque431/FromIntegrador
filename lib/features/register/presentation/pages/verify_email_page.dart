import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/verify_email_notifier.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;

  const VerifyEmailPage({
    super.key,
    required this.email,
  });

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final _codeController = TextEditingController();
  bool _codeSentOnce = false;

  @override
  void initState() {
    super.initState();
    // Enviar código automáticamente al entrar a la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendVerificationCode();
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _sendVerificationCode() async {
    final notifier = context.read<VerifyEmailNotifier>();
    final success = await notifier.sendVerificationCode(widget.email);
    
    if (success && mounted) {
      setState(() {
        _codeSentOnce = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(notifier.successMessage ?? 'Código enviado a tu correo'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(notifier.errorMessage ?? 'Error al enviar código'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _verifyCode() async {
    final code = _codeController.text.trim();
    
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa el código de verificación'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final notifier = context.read<VerifyEmailNotifier>();
    final success = await notifier.verifyEmail(widget.email, code);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(notifier.successMessage ?? 'Correo verificado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navegar a login después de verificar
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        context.go('/login');
      }
    } else if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(notifier.errorMessage ?? 'Código incorrecto'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.email_outlined,
                      size: 60,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Título
                  Text(
                    'Verifica tu correo',
                    style: TextStyle(
                      fontSize: isWeb ? 32 : 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Instrucciones
                  Text(
                    'Hemos enviado un código de verificación a:',
                    style: TextStyle(
                      fontSize: isWeb ? 16 : 14,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.email,
                    style: TextStyle(
                      fontSize: isWeb ? 18 : 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Campo de código
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _codeController,
                      decoration: const InputDecoration(
                        labelText: 'Código de verificación',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botón de verificar
                  Consumer<VerifyEmailNotifier>(
                    builder: (context, notifier, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: notifier.isLoading ? null : _verifyCode,
                          style: FilledButton.styleFrom(
                            backgroundColor: colors.secondary,
                            foregroundColor: colors.onSecondary,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: notifier.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text('Verificar código'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Botón de reenviar código
                  if (_codeSentOnce)
                    Consumer<VerifyEmailNotifier>(
                      builder: (context, notifier, child) {
                        return TextButton(
                          onPressed: notifier.isLoading ? null : _sendVerificationCode,
                          child: Text(
                            '¿No recibiste el código? Reenviar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isWeb ? 16 : 14,
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 16),

                  // Botón volver
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text(
                      'Volver al inicio de sesión',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isWeb ? 14 : 12,
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
