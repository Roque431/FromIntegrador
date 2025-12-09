import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/presentation/widgets/recent_consultation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../login/presentation/providers/login_notifier.dart';
import '../../../history/presentation/providers/historial_notifier.dart';
import '../providers/home_notifier.dart';
import '../../data/models/chat_session_model.dart';
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
              icon: Icons.add_comment,
              title: 'Nueva Conversación',
              color: colorScheme.primary,
              onTap: () {
                final homeNotifier = context.read<HomeNotifier>();
                Navigator.pop(context);
                homeNotifier.startNewConversation();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Text('Nueva conversación iniciada'),
                      ],
                    ),
                    duration: Duration(seconds: 2),
                  ),
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

            // Título de sesiones de chat
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Mis Conversaciones con LexIA',
                      style: theme.textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            // Lista de sesiones de chat
            Expanded(
              child: FutureBuilder<List<ChatSessionModel>>(
                future: context.read<HomeNotifier>().getChatSessions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
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
                              'Sin conversaciones previas',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Inicia una nueva conversación',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final sessions = snapshot.data!;
                  final homeNotifier = context.watch<HomeNotifier>();
                  final currentSessionId = homeNotifier.sessionId;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      final isActive = session.id == currentSessionId;

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        color: isActive
                            ? colorScheme.primaryContainer
                            : colorScheme.surface,
                        child: ListTile(
                          leading: Icon(
                            Icons.chat_bubble_outline,
                            color: isActive ? colorScheme.primary : colorScheme.onSurface,
                          ),
                          title: Text(
                            session.tituloDisplay,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              color: isActive ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 12,
                                color: isActive
                                    ? colorScheme.onPrimaryContainer.withValues(alpha: 0.7)
                                    : colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                session.fechaFormateada,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isActive
                                      ? colorScheme.onPrimaryContainer.withValues(alpha: 0.7)
                                      : colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.forum,
                                size: 12,
                                color: isActive
                                    ? colorScheme.onPrimaryContainer.withValues(alpha: 0.7)
                                    : colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${session.totalMensajes} msgs',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isActive
                                      ? colorScheme.onPrimaryContainer.withValues(alpha: 0.7)
                                      : colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red.shade400,
                              size: 20,
                            ),
                            onPressed: () => _confirmarEliminarSesion(context, session, homeNotifier),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            homeNotifier.loadSession(session.id);
                          },
                        ),
                      );
                    },
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

  void _confirmarEliminarSesion(
    BuildContext context,
    ChatSessionModel session,
    HomeNotifier homeNotifier,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 12),
            Expanded(
              child: Text('Eliminar Conversación'),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('¿Estás seguro de que deseas eliminar esta conversación?'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.red.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Esta acción no se puede deshacer',
                        style: TextStyle(fontSize: 12, color: Colors.red.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);

              // Mostrar loading
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      ),
                      SizedBox(width: 12),
                      Text('Eliminando conversación...'),
                    ],
                  ),
                  duration: Duration(seconds: 2),
                ),
              );

              final success = await homeNotifier.deleteSession(session.id);

              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 12),
                          Text('Conversación eliminada'),
                        ],
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Refrescar el drawer
                  setState(() {});
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.white),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(homeNotifier.errorMessage ?? 'Error al eliminar'),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}