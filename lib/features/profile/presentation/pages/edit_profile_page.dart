import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../login/presentation/providers/login_notifier.dart';
import '../widgets/profile_header.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    final loginNotifier = context.read<LoginNotifier>();
    final currentUser = loginNotifier.currentUser;
    
    _nameController = TextEditingController(text: currentUser?.fullName ?? '');
    _emailController = TextEditingController(text: currentUser?.email ?? '');
    _phoneController = TextEditingController(text: currentUser?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;
    
    final loginNotifier = context.watch<LoginNotifier>();
    final currentUser = loginNotifier.currentUser;
    final userInitials = currentUser?.initials ?? 'U';

    return Scaffold(
      backgroundColor: colors.primary,
      appBar: AppBar(
        backgroundColor: colors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colors.tertiary,
            size: isWeb ? 28 : 24,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Editar Perfil',
          style: TextStyle(
            color: colors.tertiary,
            fontWeight: FontWeight.w600,
            fontSize: isWeb ? 22 : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: Text(
              'Guardar',
              style: TextStyle(
                color: _isLoading ? colors.tertiary.withValues(alpha: 0.5) : colors.tertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWeb ? 700 : double.infinity),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: isWeb ? 32 : 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: isWeb ? 24 : 16),

                    // Header con avatar
                    ProfileHeader(
                      name: _nameController.text.isEmpty ? 'Usuario' : _nameController.text,
                      initials: userInitials,
                    ),

                    SizedBox(height: isWeb ? 32 : 24),

                    // Campo de nombre
                    _buildTextField(
                      controller: _nameController,
                      label: 'Nombre Completo',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El nombre es requerido';
                        }
                        if (value.trim().length < 2) {
                          return 'El nombre debe tener al menos 2 caracteres';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: isWeb ? 24 : 16),

                    // Campo de email
                    _buildTextField(
                      controller: _emailController,
                      label: 'Correo Electrónico',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El correo es requerido';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                          return 'Ingresa un correo válido';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: isWeb ? 24 : 16),

                    // Campo de teléfono
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Número de Teléfono',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          if (value.trim().length < 10) {
                            return 'El teléfono debe tener al menos 10 dígitos';
                          }
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: isWeb ? 40 : 32),

                    // Botón de guardar
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        style: FilledButton.styleFrom(
                          minimumSize: Size(double.infinity, isWeb ? 56 : 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(isWeb ? 14 : 12),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(colors.onPrimary),
                                ),
                              )
                            : Text(
                                'Guardar Cambios',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: isWeb ? 16 : null,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: isWeb ? 32 : 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        color: colors.tertiary,
        fontSize: isWeb ? 16 : null,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: colors.tertiary.withValues(alpha: 0.7),
          fontSize: isWeb ? 16 : null,
        ),
        prefixIcon: Icon(
          icon,
          color: colors.secondary,
          size: isWeb ? 24 : 20,
        ),
        filled: true,
        fillColor: colors.tertiary.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isWeb ? 14 : 12),
          borderSide: BorderSide(
            color: colors.tertiary.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isWeb ? 14 : 12),
          borderSide: BorderSide(
            color: colors.tertiary.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isWeb ? 14 : 12),
          borderSide: BorderSide(
            color: colors.secondary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isWeb ? 14 : 12),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isWeb ? 14 : 12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final loginNotifier = context.read<LoginNotifier>();
      
      // Actualizar el perfil usando el LoginNotifier
      final success = await loginNotifier.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perfil actualizado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
          
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loginNotifier.errorMessage ?? 'Error al actualizar el perfil'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar el perfil: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}