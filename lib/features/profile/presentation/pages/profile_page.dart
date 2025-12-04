import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/application/app_state.dart';
import '../../../../core/widgets/responsive_widgets.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../login/presentation/providers/login_notifier.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    
    final isWide = size.width > 600;
    final isDesktop = size.width > 900;
    
    final avatarSize = isDesktop ? 100.0 : (isWide ? 90.0 : 80.0);
    final titleSize = isDesktop ? 28.0 : (isWide ? 24.0 : 20.0);
    final cardPadding = isDesktop ? 28.0 : (isWide ? 24.0 : 20.0);
    final maxWidth = isDesktop ? 600.0 : (isWide ? 500.0 : double.infinity);
    
    // Obtener información del usuario
    final loginNotifier = context.watch<LoginNotifier>();
    final currentUser = loginNotifier.currentUser;
    
    final userName = currentUser?.fullName ?? 'Usuario';
    final userEmail = currentUser?.email ?? 'usuario@ejemplo.com';
    final userInitials = currentUser?.initials ?? 'U';
    final userPhone = currentUser?.phone ?? 'No disponible';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Mi Perfil',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
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
              child: Column(
                children: [
                  // Card de perfil principal
                  ResponsiveCard(
                    padding: EdgeInsets.all(cardPadding),
                    child: Column(
                      children: [
                        // Avatar
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
                        SizedBox(height: isWide ? 20 : 16),
                        
                        // Nombre
                        Text(
                          userName,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                            fontSize: titleSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        
                        // Email
                        Text(
                          userEmail,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isWide ? 24 : 20),
                        
                        // Botón editar perfil
                        ResponsiveButton(
                          text: 'Editar Perfil',
                          icon: Icon(Icons.edit_outlined, color: colorScheme.onPrimary, size: 20),
                          onPressed: () => context.push('/profile/edit'),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: isWide ? 24 : 16),
                  
                  // Card de información
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
                        const SizedBox(height: 16),
                        
                        _buildInfoTile(
                          context,
                          icon: Icons.email_outlined,
                          title: 'Correo Electrónico',
                          value: userEmail,
                        ),
                        _buildDivider(context),
                        
                        _buildInfoTile(
                          context,
                          icon: Icons.phone_outlined,
                          title: 'Teléfono',
                          value: userPhone,
                        ),
                        _buildDivider(context),
                        
                        _buildInfoTile(
                          context,
                          icon: Icons.security_outlined,
                          title: 'Seguridad',
                          value: 'Gestionar contraseña',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: isWide ? 24 : 16),
                  
                  // Card de opciones profesionales
                  ResponsiveCard(
                    padding: EdgeInsets.all(cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Si ya es abogado, mostrar estado activo
                        if (currentUser?.isLawyer == true) ...[
                          Row(
                            children: [
                              Text(
                                'Estado Profesional',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.verified, size: 16, color: Colors.green.shade700),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Activo',
                                      style: TextStyle(
                                        color: Colors.green.shade700,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildProfessionalOption(
                            context,
                            icon: Icons.dashboard,
                            iconColor: Colors.blue,
                            title: 'Mi Panel de Abogado',
                            subtitle: 'Gestiona tus consultas y clientes',
                            onTap: () => context.push('/lawyer'),
                          ),
                          const SizedBox(height: 12),
                          _buildProfessionalOption(
                            context,
                            icon: Icons.message_outlined,
                            iconColor: Colors.purple,
                            title: 'Solicitudes de Match',
                            subtitle: 'Ver solicitudes pendientes',
                            onTap: () => context.push('/conversations'),
                          ),
                        ] else ...[
                          // Si no es abogado, mostrar opciones para registrarse
                          Text(
                            '¿Eres Profesional?',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          _buildProfessionalOption(
                            context,
                            icon: Icons.gavel,
                            iconColor: Colors.blue,
                            title: 'Soy Abogado',
                            subtitle: 'Ofrece tus servicios legales',
                            onTap: () => context.push('/lawyer-verification'),
                          ),
                          const SizedBox(height: 12),
                          
                          _buildProfessionalOption(
                            context,
                            icon: Icons.business,
                            iconColor: Colors.green,
                            title: 'Tengo un Negocio',
                            subtitle: 'Anuncia tus servicios',
                            onTap: () => context.push('/business-registration'),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  SizedBox(height: isWide ? 24 : 16),
                  
                  // Card de más opciones
                  ResponsiveCard(
                    padding: EdgeInsets.all(cardPadding),
                    child: Column(
                      children: [
                        _buildInfoTile(
                          context,
                          icon: Icons.info_outline,
                          title: 'Acerca de',
                          value: 'Versión 2.0',
                          onTap: () {},
                        ),
                        _buildDivider(context),
                        
                        _buildInfoTile(
                          context,
                          icon: Icons.help_outline,
                          title: 'Ayuda',
                          value: 'Centro de ayuda',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: isWide ? 32 : 24),
                  
                  // Botón cerrar sesión
                  ResponsiveButton(
                    text: 'Cerrar Sesión',
                    isOutlined: true,
                    icon: Icon(Icons.logout, color: Colors.red.shade400, size: 20),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: BorderSide(color: Colors.red.shade400, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: Colors.red.shade400,
                    ),
                    onPressed: () => _showLogoutDialog(context),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: colorScheme.primary, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
      height: 1,
    );
  }

  Widget _buildProfessionalOption(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: colorScheme.onSurfaceVariant,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Cerrar Sesión',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        content: Text(
          '¿Estás seguro que deseas cerrar sesión?',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancelar',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              
              final loginNotifier = context.read<LoginNotifier>();
              final appState = context.read<AppState>();
              
              await loginNotifier.logout();
              appState.logout();
              
              if (context.mounted) {
                LexiaAlert.info(
                  context,
                  title: 'Sesión cerrada',
                  message: 'Has cerrado sesión correctamente',
                );
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