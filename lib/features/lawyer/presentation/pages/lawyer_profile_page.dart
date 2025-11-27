import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/application/app_state.dart';
import '../../../login/presentation/providers/login_notifier.dart';
import '../../../profile/presentation/widgets/profile_header.dart';
import '../../../profile/presentation/widgets/profile_menu_item.dart';

class LawyerProfilePage extends StatelessWidget {
  const LawyerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

    // Obtener información del usuario autenticado
    final loginNotifier = context.watch<LoginNotifier>();
    final currentUser = loginNotifier.currentUser;

    // Datos por defecto si no hay usuario
    final userName = currentUser?.fullName ?? 'Abogado Sin Nombre';
    final userEmail = currentUser?.email ?? 'abogado@ejemplo.com';
    final userInitials = currentUser?.initials ?? 'A';
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
                    imageUrl: currentUser?.profileImageUrl,
                  ),

                  SizedBox(height: isWeb ? 16 : 12),

                  // Botón de editar perfil
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isWeb ? 32 : 24),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implementar edición de perfil para abogado
                      },
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

                  // Información Profesional del Abogado
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isWeb ? 32 : 24),
                    child: Text(
                      'Información Profesional',
                      style: TextStyle(
                        fontSize: isWeb ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: colors.tertiary,
                      ),
                    ),
                  ),

                  SizedBox(height: isWeb ? 12 : 8),

                  // Cédula Profesional (solo lectura)
                  ProfileMenuItem(
                    icon: Icons.badge_outlined,
                    iconColor: colors.secondary,
                    title: 'Cédula profesional',
                    subtitle: currentUser?.cedulaProfesional ?? 'No especificada',
                    onTap: () {
                      // No hace nada, solo lectura
                    },
                  ),

                  // Descripción Profesional
                  ProfileMenuItem(
                    icon: Icons.description_outlined,
                    iconColor: colors.secondary,
                    title: 'Descripción',
                    subtitle: currentUser?.descripcionProfesional ?? 'Sin descripción',
                    onTap: () {
                      // TODO: Navegar a editar perfil
                    },
                  ),

                  SizedBox(height: isWeb ? 24 : 16),

                  // Información de Contacto
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isWeb ? 32 : 24),
                    child: Text(
                      'Información de Contacto',
                      style: TextStyle(
                        fontSize: isWeb ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: colors.tertiary,
                      ),
                    ),
                  ),

                  SizedBox(height: isWeb ? 12 : 8),

                  // Opciones del menú
                  ProfileMenuItem(
                    icon: Icons.email_outlined,
                    iconColor: colors.secondary,
                    title: 'Correo Electrónico',
                    subtitle: userEmail,
                    onTap: () {
                      // TODO: Navegar a editar perfil
                    },
                  ),

                  ProfileMenuItem(
                    icon: Icons.phone_outlined,
                    iconColor: colors.secondary,
                    title: 'Numero de Teléfono',
                    subtitle: userPhone,
                    onTap: () {
                      // TODO: Navegar a editar perfil
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

                  ProfileMenuItem(
                    icon: Icons.workspace_premium_outlined,
                    iconColor: Colors.amber,
                    title: 'Mi Suscripción',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'ACTIVO',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      context.push('/lawyer/subscription');
                    },
                  ),

                  ProfileMenuItem(
                    icon: Icons.bar_chart_outlined,
                    iconColor: colors.secondary,
                    title: 'Estadísticas Avanzadas',
                    onTap: () {
                      // TODO: Navegar a estadísticas
                    },
                  ),

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
