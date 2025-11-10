import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

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
                  const ProfileHeader(
                    name: 'Carlos Rafael',
                    initials: 'CR',
                  ),

                  SizedBox(height: isWeb ? 32 : 24),

                  // Opciones del menú
                  ProfileMenuItem(
                    icon: Icons.email_outlined,
                    iconColor: colors.secondary,
                    title: 'Correo Electrónico',
                    subtitle: 'Ranosdcarlos@gmail.com',
                    onTap: () {
                      // TODO: Navegar a editar email
                    },
                  ),

                  ProfileMenuItem(
                    icon: Icons.phone_outlined,
                    iconColor: colors.secondary,
                    title: 'Numero de Teléfono',
                    subtitle: '+52 9619999999',
                    onTap: () {
                      // TODO: Navegar a editar teléfono
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
                    title: 'Adquirir el plan Pro',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      context.push('/welcome');
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
            onPressed: () {
              Navigator.pop(context);
              // TODO: Llamar al logout del LoginNotifier
              // context.read<LoginNotifier>().logout();
              context.go('/login');
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