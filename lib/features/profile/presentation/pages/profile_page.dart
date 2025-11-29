import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/application/app_state.dart';
import '../../../login/presentation/providers/login_notifier.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;
    
    // Obtener información del usuario autenticado
    final loginNotifier = context.watch<LoginNotifier>();
    final currentUser = loginNotifier.currentUser;
    
    // DEBUG: Imprimir información del usuario
    print('🔍 DEBUG ProfilePage:');
    print('   LoginNotifier state: ${loginNotifier.state}');
    print('   Current user: $currentUser');
    print('   User name: ${currentUser?.name}');
    print('   User email: ${currentUser?.email}');
    
    // Datos por defecto si no hay usuario
    final userName = currentUser?.fullName ?? 'Usuario Sin Nombre';
    final userEmail = currentUser?.email ?? 'usuario@ejemplo.com';
    final userInitials = currentUser?.initials ?? 'U';
    final userPhone = currentUser?.phone ?? 'No disponible';

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
          'Configuración',
          style: TextStyle(
            color: colors.tertiary,
            fontWeight: FontWeight.w600,
            fontSize: isWeb ? 22 : null,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWeb ? 700 : double.infinity),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: isWeb ? 24 : 16),

                  // Header con avatar y nombre
                  ProfileHeader(
                    name: userName,
                    initials: userInitials,
                  ),

                  SizedBox(height: isWeb ? 16 : 12),

                  // Botón de editar perfil
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isWeb ? 32 : 24),
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/profile/edit'),
                      icon: Icon(
                        Icons.edit_outlined,
                        color: colors.secondary,
                        size: isWeb ? 20 : 18,
                      ),
                      label: Text(
                        'Editar Perfil',
                        style: TextStyle(
                          color: colors.secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: isWeb ? 16 : 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, isWeb ? 48 : 44),
                        side: BorderSide(
                          color: colors.secondary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(isWeb ? 12 : 10),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isWeb ? 24 : 16),

                  // Opciones del menú
                  ProfileMenuItem(
                    icon: Icons.email_outlined,
                    iconColor: colors.secondary,
                    title: 'Correo Electrónico',
                    subtitle: userEmail,
                    onTap: () {
                      context.push('/profile/edit');
                    },
                  ),

                  ProfileMenuItem(
                    icon: Icons.phone_outlined,
                    iconColor: colors.secondary,
                    title: 'Numero de Teléfono',
                    subtitle: userPhone,
                    onTap: () {
                      context.push('/profile/edit');
                    },
                  ),

                  ProfileMenuItem(
                    icon: Icons.security_outlined,
                    iconColor: colors.secondary,
                    title: 'Seguridad',
                    onTap: () {
                      // TODO: Navegar a configuración de seguridad
                    },
                  ),

                  // Sección "¿Eres Profesional?"
                  SizedBox(height: isWeb ? 32 : 24),
                  
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isWeb ? 32 : 24),
                    child: Text(
                      '¿Eres Profesional?',
                      style: TextStyle(
                        color: colors.tertiary,
                        fontSize: isWeb ? 18 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: isWeb ? 16 : 12),
                  
                  // Botón "Soy Abogado"
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isWeb ? 32 : 24),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/lawyer-verification');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: colors.primary,
                          elevation: 2,
                          minimumSize: Size(double.infinity, isWeb ? 56 : 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: colors.primary.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.gavel,
                                color: Colors.blue,
                                size: isWeb ? 24 : 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Soy Abogado',
                                    style: TextStyle(
                                      fontSize: isWeb ? 16 : 14,
                                      fontWeight: FontWeight.bold,
                                      color: colors.tertiary,
                                    ),
                                  ),
                                  Text(
                                    'Ofrece tus servicios legales',
                                    style: TextStyle(
                                      fontSize: isWeb ? 14 : 12,
                                      color: colors.tertiary.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: colors.tertiary.withValues(alpha: 0.4),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Botón "Tengo un Negocio"
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isWeb ? 32 : 24),
                    child: Container(
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/business-registration');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: colors.primary,
                          elevation: 2,
                          minimumSize: Size(double.infinity, isWeb ? 56 : 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: colors.primary.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.business,
                                color: Colors.green,
                                size: isWeb ? 24 : 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tengo un Negocio',
                                    style: TextStyle(
                                      fontSize: isWeb ? 16 : 14,
                                      fontWeight: FontWeight.bold,
                                      color: colors.tertiary,
                                    ),
                                  ),
                                  Text(
                                    'Anuncia tus servicios',
                                    style: TextStyle(
                                      fontSize: isWeb ? 14 : 12,
                                      color: colors.tertiary.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: colors.tertiary.withValues(alpha: 0.4),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isWeb ? 24 : 16),

                  ProfileMenuItem(
                    icon: Icons.info_outline,
                    iconColor: colors.secondary,
                    title: 'Acerca de',
                    onTap: () {
                      // TODO: Navegar a página "Acerca de"
                    },
                  ),

                  SizedBox(height: isWeb ? 40 : 32),

                  // Botón de cerrar sesión
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isWeb ? 32 : 24),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      icon: Icon(
                        Icons.logout,
                        color: Colors.red.shade400,
                        size: isWeb ? 22 : 20,
                      ),
                      label: Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                          color: Colors.red.shade400,
                          fontWeight: FontWeight.w600,
                          fontSize: isWeb ? 16 : null,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, isWeb ? 56 : 50),
                        side: BorderSide(
                          color: Colors.red.shade400,
                          width: isWeb ? 2 : 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(isWeb ? 14 : 12),
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
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              
              // Realizar logout real
              final loginNotifier = context.read<LoginNotifier>();
              final appState = context.read<AppState>();
              
              await loginNotifier.logout();
              appState.logout();
              
              // Navegar al login
              if (context.mounted) {
                context.go('/login');
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade400,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}