import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../login/presentation/providers/login_notifier.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/responsive_widgets.dart';
import '../../../../core/widgets/responsive_text_field.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    
    final isWide = size.width > 600;
    final isDesktop = size.width > 900;
    
    final avatarSize = isDesktop ? 100.0 : (isWide ? 90.0 : 80.0);
    final cardPadding = isDesktop ? 28.0 : (isWide ? 24.0 : 20.0);
    final maxWidth = isDesktop ? 550.0 : (isWide ? 480.0 : double.infinity);
    
    final loginNotifier = context.watch<LoginNotifier>();
    final currentUser = loginNotifier.currentUser;
    final userInitials = currentUser?.initials ?? 'U';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Editar Perfil',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: _isLoading ? null : _saveProfile,
              child: Text(
                'Guardar',
                style: TextStyle(
                  color: _isLoading ? colorScheme.onSurfaceVariant : colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.horizontalPadding(context),
              vertical: 16,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Card con avatar editable
                    ResponsiveCard(
                      padding: EdgeInsets.all(cardPadding),
                      child: Column(
                        children: [
                          // Avatar con botón de cámara
                          Stack(
                            children: [
                              Container(
                                width: avatarSize,
                                height: avatarSize,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      colorScheme.primary,
                                      colorScheme.secondary,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.primary.withValues(alpha: 0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    userInitials,
                                    style: TextStyle(
                                      fontSize: avatarSize * 0.4,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: colorScheme.surface,
                                      width: 3,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: colorScheme.onPrimary,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isWide ? 12 : 8),
                          Text(
                            'Cambiar foto',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: isWide ? 24 : 16),
                    
                    // Card con formulario
                    ResponsiveCard(
                      padding: EdgeInsets.all(cardPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Información Personal',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: isWide ? 24 : 20),
                          
                          // Campo nombre
                          ResponsiveTextField(
                            controller: _nameController,
                            hintText: 'Nombre completo',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: colorScheme.onSurfaceVariant,
                            ),
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
                          const SizedBox(height: 16),
                          
                          // Campo email
                          ResponsiveTextField(
                            controller: _emailController,
                            hintText: 'Correo electrónico',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: colorScheme.onSurfaceVariant,
                            ),
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
                          const SizedBox(height: 16),
                          
                          // Campo teléfono
                          ResponsiveTextField(
                            controller: _phoneController,
                            hintText: 'Número de teléfono',
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            validator: (value) {
                              if (value != null && value.trim().isNotEmpty) {
                                if (value.trim().length < 10) {
                                  return 'El teléfono debe tener al menos 10 dígitos';
                                }
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: isWide ? 32 : 24),
                    
                    // Botón guardar
                    ResponsiveButton(
                      text: 'Guardar Cambios',
                      isLoading: _isLoading,
                      onPressed: _saveProfile,
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
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
      
      final success = await loginNotifier.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      );

      if (mounted) {
        if (success) {
          LexiaAlert.success(
            context,
            title: '¡Perfil actualizado!',
            message: 'Tus cambios han sido guardados correctamente',
          );
          
          context.pop();
        } else {
          LexiaAlert.error(
            context,
            title: 'Error',
            message: loginNotifier.errorMessage ?? 'No se pudo actualizar el perfil',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        LexiaAlert.error(
          context,
          title: 'Error inesperado',
          message: 'Ocurrió un error al actualizar el perfil: $e',
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