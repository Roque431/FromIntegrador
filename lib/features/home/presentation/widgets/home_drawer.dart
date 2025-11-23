import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/recent_consultation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../login/presentation/providers/login_notifier.dart';
import 'drawer_menu_item.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    // Obtener información del usuario logeado
    final loginNotifier = context.watch<LoginNotifier>();
    final currentUser = loginNotifier.currentUser;
    final userName = currentUser?.fullName ?? 'Usuario';
    final userInitials = currentUser?.initials ?? 'U';
    final userPlan = currentUser?.isPro == true ? 'Pro' : 'Free';

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Buscador
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar consulta',
                  prefixIcon: Icon(Icons.search, color: colors.tertiary.withOpacity(0.5)),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),

            // ==========================================
            // OPCIONES DEL MENÚ - TODAS CON NAVEGACIÓN
            // ==========================================
            DrawerMenuItem(
              icon: Icons.chat_bubble_outline,
              title: 'Nueva Consulta',
              color: colors.secondary,
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
              color: colors.secondary,
              onTap: () {
                Navigator.pop(context);
                context.push('/history'); // ✅ Apila la ruta para poder regresar
              },
            ),
            
            DrawerMenuItem(
              icon: Icons.map_outlined,
              title: 'Mapa Legal',
              color: colors.secondary,
              onTap: () {
                Navigator.pop(context);
                context.push('/legal-map');
              },
            ),
            
            // 👇 FORO DE LA COMUNIDAD
            DrawerMenuItem(
              icon: Icons.forum_outlined,
              title: 'Foro de la comunidad',
              color: colors.secondary,
              onTap: () {
                Navigator.pop(context);
                context.push('/forum'); // ✅ Apila la ruta para poder regresar
              },
            ),

            const SizedBox(height: 8),
            Divider(color: colors.outline),
            
            // Título de consultas recientes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Consultas Recientes',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: colors.tertiary.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            // Lista de consultas recientes
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: const [
                  RecentConsultationItem(
                    category: 'Laboral',
                    title: '¿Qué pasa si me despiden y no me pagan mi liquidación?',
                    subtitle: 'LexIA: Según el artículo 50 de la ley federal...',
                    date: '21 de octubre de 2025',
                    consultationId: 'consulta_1', // ID de ejemplo
                  ),
                  RecentConsultationItem(
                    category: 'Laboral',
                    title: '¿Qué pasa si me despiden y no me pagan mi liquidación?',
                    subtitle: 'LexIA: Según el artículo 50 de la ley federal...',
                    date: '21 de octubre de 2025',
                    consultationId: 'consulta_2',
                  ),
                  RecentConsultationItem(
                    category: 'Laboral',
                    title: '¿Qué pasa si me despiden y no me pagan mi liquidación?',
                    subtitle: 'LexIA: Según el artículo 50 de la ley federal...',
                    date: '21 de octubre de 2025',
                    consultationId: 'consulta_3',
                  ),
                ],
              ),
            ),

            // Perfil del usuario
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: colors.outline),
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
                        backgroundColor: colors.secondary,
                        child: Text(userInitials, style: const TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              userName,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colors.tertiary,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: currentUser?.isPro == true 
                                    ? Colors.amber.withValues(alpha: 0.2)
                                    : colors.secondary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                userPlan,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: currentUser?.isPro == true 
                                          ? Colors.amber.shade700
                                          : colors.secondary,
                                      fontSize: 10,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: colors.tertiary),
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