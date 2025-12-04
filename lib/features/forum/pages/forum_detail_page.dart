import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/forum/widgests/forum_expert_comment.dart';
import 'package:flutter_application_1/features/forum/widgests/forum_user_post.dart';
import 'package:flutter_application_1/features/forum/widgests/forum_post_card.dart';
import '../data/models/models.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../presentation/providers/foro_notifier.dart';

class ForumDetailPage extends StatefulWidget {
  final String postId;

  const ForumDetailPage({
    super.key,
    required this.postId,
  });

  @override
  State<ForumDetailPage> createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  @override
  void initState() {
    super.initState();
    // Cargar publicación al entrar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ForoNotifier>().loadPublicacion(widget.postId);
    });
  }

  void _showAddCommentDialog(BuildContext context) {
    final notifier = context.read<ForoNotifier>();
    final commentController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Agregar comentario'),
        content: TextField(
          controller: commentController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Escribe tu comentario aquí...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              if (commentController.text.trim().isNotEmpty) {
                Navigator.pop(ctx);
                final result = await notifier.agregarComentario(
                  publicacionId: widget.postId,
                  contenido: commentController.text.trim(),
                );
                if (result != null && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Comentario agregado')),
                  );
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(notifier.errorMessage ?? 'Error al comentar')),
                  );
                }
              }
            },
            child: const Text('Publicar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final notifier = context.watch<ForoNotifier>();
    final publicacion = notifier.publicacionActual;
    final comentarios = notifier.comentariosActuales;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/forum');
            }
          },
        ),
        title: Text(
          'Volver al foro comunitario',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
            onPressed: () => _showOptionsMenu(context),
          ),
        ],
      ),
      body: _buildBody(context, notifier, publicacion, comentarios, colorScheme),
      // Botón para agregar comentario
      floatingActionButton: publicacion != null
          ? FloatingActionButton.extended(
              onPressed: () => _showAddCommentDialog(context),
              backgroundColor: colorScheme.primary,
              icon: const Icon(Icons.add_comment, color: Colors.white),
              label: const Text('Comentar', style: TextStyle(color: Colors.white)),
            )
          : null,
    );
  }

  Widget _buildBody(BuildContext context, ForoNotifier notifier, PublicacionModel? publicacion, List comentarios, ColorScheme colorScheme) {
    if (notifier.isLoading) {
      return Center(child: CircularProgressIndicator(color: colorScheme.primary));
    }

    if (notifier.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              notifier.errorMessage ?? 'Error al cargar',
              style: TextStyle(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => notifier.loadPublicacion(widget.postId),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (publicacion == null) {
      return Center(
        child: Text(
          'Publicación no encontrada',
          style: TextStyle(color: colorScheme.onSurface),
        ),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Post original del usuario
            ForumUserPost(
              userName: publicacion.autorNombre,
              userInitials: publicacion.autorInitials,
              date: publicacion.fechaFormateada,
              category: publicacion.categoriaNombre,
              tags: const [],
              question: publicacion.titulo,
              likes: publicacion.likes,
              comments: comentarios.length,
              isLiked: publicacion.yaLeDioLike,
              onLike: () {
                notifier.toggleLike(publicacion.id);
              },
              onDislike: () => notifier.reportUtilidad(publicacion.id, false),
            ),

            const SizedBox(height: 16),

            // Contenido completo de la publicación
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Descripción',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    publicacion.contenido,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Título de comentarios
            Text(
              'Comentarios (${comentarios.length})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
            ),

            const SizedBox(height: 16),

            // Lista de comentarios
            if (comentarios.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'No hay comentarios aún.\n¡Sé el primero en comentar!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
              )
            else
              ...comentarios.map((comment) => ForumExpertComment(
                    userName: comment.autorNombre,
                    userInitials: comment.autorInitials,
                    date: comment.fechaFormateada,
                    comment: comment.contenido,
                    likes: comment.likes,
                    replies: 0,
                    onLike: () {
                      // TODO: Like a comentario
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Función próximamente')),
                      );
                    },
                  )),

            const SizedBox(height: 24),

            // Mis publicaciones (si la publicación es del usuario actual)
            if (publicacion.usuarioId == notifier.currentUserId)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mis publicaciones',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<List<PublicacionModel>>(
                    future: notifier.fetchMisPublicaciones(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(height: 72, child: Center(child: CircularProgressIndicator()));
                      }

                      final items = snapshot.data ?? [];
                      final others = items.where((p) => p.id != publicacion.id).toList();

                      if (others.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('No tienes otras publicaciones.', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                        );
                      }

                      return SizedBox(
                        height: 160,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: others.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final p = others[index];
                            return SizedBox(
                              width: 300,
                              child: ForumPostCard(
                                userName: p.autorNombre,
                                userInitials: p.autorInitials,
                                date: p.fechaFormateada,
                                category: p.categoriaNombre,
                                tags: const [],
                                question: p.titulo,
                                excerpt: p.contenido.length > 120 ? '${p.contenido.substring(0, 120)}...' : p.contenido,
                                likes: p.likes,
                                comments: p.comentarios,
                                onTap: () => context.pushNamed('forumDetail', pathParameters: {'id': p.id}),
                                onLike: () {},
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),

            const SizedBox(height: 80), // Espacio para el botón flotante
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Compartir publicación'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementar compartir
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_outlined),
              title: const Text('Reportar publicación'),
              onTap: () {
                Navigator.pop(context);
                _showReportDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reportar publicación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¿Por qué deseas reportar esta publicación?'),
            const SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Describe el motivo...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reporte enviado')),
              );
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}