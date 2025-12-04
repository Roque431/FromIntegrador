import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/recent_consultation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../login/presentation/providers/login_notifier.dart';
import '../../../history/presentation/providers/historial_notifier.dart';
import 'drawer_menu_item.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  void initState() {
    super.initState();
    // Cargar consultas recientes al abrir el drawer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecentConsultations();
    });
  }

  void _loadRecentConsultations() {
    final historialNotifier = context.read<HistorialNotifier>();
    if (historialNotifier.conversaciones.isEmpty) {
      historialNotifier.loadConversaciones();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    
    // Obtener información del usuario logeado
    final loginNotifier = context.watch<LoginNotifier>();
    final currentUser = loginNotifier.currentUser;
    final userName = currentUser?.fullName ?? 'Usuario';
    final userInitials = currentUser?.initials ?? 'U';
    final userPlan = currentUser?.isPro == true ? 'Pro' : 'Free';
    
    // Obtener consultas recientes
    final historialNotifier = context.watch<HistorialNotifier>();
    final recentConsultations = historialNotifier.conversaciones.take(5).toList();

    return Drawer(
      backgroundColor: colorScheme.surfaceContainerHighest,
      child: SafeArea(
        child: Column(
          children: [
            // Buscador
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar consulta',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  prefixIcon: Icon(
                    Icons.search, 
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  filled: true,
                  fillColor: isDark 
                      ? colorScheme.surface.withValues(alpha: 0.5)
                      : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                style: TextStyle(color: colorScheme.onSurface),
              ),
            ),

            // ==========================================
            // OPCIONES DEL MENÚ - TODAS CON NAVEGACIÓN
            // ==========================================
            DrawerMenuItem(
              icon: Icons.chat_bubble_outline,
              title: 'Nueva Consulta',
              color: colorScheme.primary,
              onTap: () {
                Navigator.pop(context);
                // TODO: Navegar a nueva consulta o limpiar el chat actual
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nueva Consulta - TODO')),
                );
              },
            ),
            
            // 👇 HISTORIAL
            DrawerMenuItem(
              icon: Icons.history,
              title: 'Historial de Consultas',
              color: colorScheme.primary,
              onTap: () {
                Navigator.pop(context);
                context.push('/history'); // ✅ Apila la ruta para poder regresar
              },
            ),
            
            DrawerMenuItem(
              icon: Icons.map_outlined,
              title: 'Mapa Legal',
              color: colorScheme.primary,
              onTap: () {
                Navigator.pop(context);
                context.push('/legal-map');
              },
            ),
            
            // 👇 FORO DE LA COMUNIDAD
            DrawerMenuItem(
              icon: Icons.forum_outlined,
              title: 'Foro de la comunidad',
              color: colorScheme.primary,
              onTap: () {
                Navigator.pop(context);
                context.push('/forum'); // ✅ Apila la ruta para poder regresar
              },
            ),
            
            // 👇 CHAT PRIVADO - Mensajes 1:1
            DrawerMenuItem(
              icon: Icons.message_outlined,
              title: 'Mis Conversaciones',
              color: colorScheme.primary,
              onTap: () {
                Navigator.pop(context);
                context.push('/conversations'); // ✅ Chat privado con profesionistas
              },
            ),

            const SizedBox(height: 8),
            Divider(color: colorScheme.outline),
            
            // Título de consultas recientes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Consultas Recientes',
                      style: theme.textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            // Lista de consultas recientes
            Expanded(
              child: historialNotifier.isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : recentConsultations.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 48,
                                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Sin consultas recientes',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Inicia una nueva consulta',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: recentConsultations.length,
                          itemBuilder: (context, index) {
                            final consulta = recentConsultations[index];
                            return RecentConsultationItem(
                              category: consulta.clusterDescripcion,
                              title: consulta.titulo ?? 'Consulta sin título',
                              subtitle: consulta.ultimoMensaje ?? 'Sin mensajes',
                              date: consulta.fechaFormateada,
                              consultationId: consulta.id,
                            );
                          },
                        ),
            ),

            // Perfil del usuario
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: colorScheme.outline),
                ),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  context.push('/profile'); // ✅ Apila la ruta para poder regresar
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: colorScheme.primary,
                        child: Text(
                          userInitials, 
                          style: TextStyle(color: colorScheme.onPrimary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              userName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: currentUser?.isPro == true 
                                    ? Colors.amber.withValues(alpha: 0.2)
                                    : colorScheme.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                userPlan,
                                style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: currentUser?.isPro == true 
                                          ? Colors.amber.shade700
                                          : colorScheme.primary,
                                      fontSize: 10,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: colorScheme.onSurface),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}