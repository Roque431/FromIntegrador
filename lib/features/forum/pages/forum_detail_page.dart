import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/forum/widgests/forum_expert_comment.dart';
import 'package:flutter_application_1/features/forum/widgests/forum_user_post.dart';
import 'package:flutter_application_1/features/forum/widgests/group_members_dialog.dart';
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
  // Local in-memory replies map: parentCommentId -> list of replies
  final Map<String, List<ComentarioModel>> _localReplies = {};
  final Set<String> _expandedComments = {};
  // Local dislike state per publicación (optimistic UI)
  final Map<String, bool> _localDisliked = {};
  final Map<String, int> _localNoUtilCount = {};
  // Local comment like state
  final Map<String, bool> _localCommentLiked = {};
  final Map<String, int> _localCommentLikes = {};
  @override
  void initState() {
    super.initState();
    // Cargar publicación al entrar
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ForoNotifier>().loadPublicacion(widget.postId);
      // Process replies after loading: group comments by parentId
      _groupReplies();

      // Initialize local optimistic maps based on server values
      final publicacion = context.read<ForoNotifier>().publicacionActual;
      if (publicacion != null) {
        _localDisliked[publicacion.id] = publicacion.yaMarcoNoUtil;
        _localNoUtilCount[publicacion.id] = 0; // use delta for optimistic changes
      }

      final comentarios = context.read<ForoNotifier>().comentariosActuales;
      for (final c in comentarios) {
        _localCommentLiked[c.id] = c.yaLeDioLike;
        _localCommentLikes[c.id] = 0;
      }
      if (mounted) setState(() {});
    });
  }

  /// Agrupar respuestas anidadas basadas en parentId
  void _groupReplies() {
    final comentarios = context.read<ForoNotifier>().comentariosActuales;
    _localReplies.clear();
    
    for (final comment in comentarios) {
      if (comment.parentId != null && comment.parentId!.isNotEmpty) {
        final parentId = comment.parentId!;
        _localReplies.putIfAbsent(parentId, () => []).add(comment);
      }
    }
  }

  void _showGroupMembers(BuildContext context, PublicacionModel publicacion) {
    final notifier = context.read<ForoNotifier>();
    
    // Cargar miembros desde el backend
    notifier.getCategoryMembers(publicacion.categoriaId).then((members) {
      if (!context.mounted) return;
      
      // Convertir respuesta a GroupMember
      final groupMembers = members
          .map((m) => GroupMember(
                id: m['id'],
                name: m['name'],
                initials: _getInitials(m['name']),
                participations: m['participations'] ?? 0,
                isActive: m['isActive'] ?? true,
              ))
          .toList();

      showDialog(
        context: context,
        builder: (ctx) => GroupMembersDialog(
          groupName: publicacion.categoriaNombre,
          totalMembers: groupMembers.length,
          members: groupMembers,
        ),
      );
    });
  }

  /// Obtener iniciales de un nombre
  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  void _showAddCommentDialog(BuildContext context, {String? parentId}) {
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
              if (commentController.text.trim().isEmpty) return;
              Navigator.pop(ctx);

              // Both top-level and replies are sent to backend
              // The backend will handle the parentId to maintain the thread structure
              final result = await notifier.agregarComentario(
                publicacionId: widget.postId,
                contenido: commentController.text.trim(),
                parentId: parentId,
              );
              
              if (result != null && mounted) {
                // Add to local map for immediate UI update
                if (parentId != null) {
                  setState(() {
                    _localReplies.putIfAbsent(parentId, () => []).add(result);
                    _expandedComments.add(parentId);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Respuesta agregada')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Comentario agregado')),
                  );
                }
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(notifier.errorMessage ?? 'Error al comentar')),
                );
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
              // Count only top-level comments (no replies)
              comments: comentarios.where((c) => c.parentId == null || c.parentId!.isEmpty).length,
              isLiked: publicacion.yaLeDioLike,
              isDisliked: _localDisliked[publicacion.id] ?? publicacion.yaMarcoNoUtil,
              noUtilCount: (publicacion.noUtilCount) + (_localNoUtilCount[publicacion.id] ?? 0),
              onLike: () {
                notifier.toggleLike(publicacion.id);
              },
              onDislike: () async {
                if (context.read<ForoNotifier>().currentUserId == null) return;

                // Optimistic UI: toggle disliked state locally (delta)
                setState(() {
                  final currently = _localDisliked[publicacion.id] ?? publicacion.yaMarcoNoUtil;
                  _localDisliked[publicacion.id] = !currently;
                  final currentDelta = _localNoUtilCount[publicacion.id] ?? 0;
                  _localNoUtilCount[publicacion.id] = currently ? (currentDelta - 1).clamp(0, 9999) : (currentDelta + 1);
                });

                try {
                  await notifier.toggleNoUtil(publicacion.id);
                  // server updated models; clear optimistic delta to avoid double counting
                  setState(() {
                    _localNoUtilCount[publicacion.id] = 0;
                    _localDisliked[publicacion.id] = notifier.publicacionActual?.yaMarcoNoUtil ?? (_localDisliked[publicacion.id] ?? false);
                  });
                } catch (e) {
                  // revert optimistic change
                  setState(() {
                    final currently = _localDisliked[publicacion.id] ?? false;
                    _localDisliked[publicacion.id] = !currently;
                    final currentDelta = _localNoUtilCount[publicacion.id] ?? 0;
                    _localNoUtilCount[publicacion.id] = currently ? (currentDelta - 1).clamp(0, 9999) : (currentDelta + 1);
                  });
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(notifier.errorMessage ?? 'Error al marcar no útil')),
                    );
                  }
                }
              },
              onGroupTap: () => _showGroupMembers(context, publicacion),
              onReplyTap: () {
                _showAddCommentDialog(context);
              },
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

            // "Mis comentarios" removed per UX request

            // Título de comentarios
            Text(
              'Comentarios (${comentarios.where((c) => c.parentId == null || c.parentId!.isEmpty).length})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
            ),

            const SizedBox(height: 16),

            // Lista de comentarios (con soporte de respuestas anidadas)
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
              // Filter only top-level comments (no parentId)
              ...comentarios
                  .where((c) => c.parentId == null || c.parentId!.isEmpty)
                  .map((comment) {
                final replies = _localReplies[comment.id] ?? [];
                final isExpanded = _expandedComments.contains(comment.id);
                // Build like state for this comment
                final commentIsLiked = _localCommentLiked[comment.id] ?? false;
                final commentLikes = (comment.likes ?? 0) + (_localCommentLikes[comment.id] ?? 0);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ForumExpertComment(
                      userName: comment.autorNombre,
                      userInitials: comment.autorInitials,
                      date: comment.fechaFormateada,
                      comment: comment.contenido,
                      likes: commentLikes,
                      isLiked: commentIsLiked,
                      replies: replies.length,
                      onLike: () async {
                        if (context.read<ForoNotifier>().currentUserId == null) return;

                        // optimistic
                        setState(() {
                          final current = _localCommentLiked[comment.id] ?? comment.yaLeDioLike;
                          _localCommentLiked[comment.id] = !current;
                          final delta = current ? -1 : 1;
                          _localCommentLikes[comment.id] = (_localCommentLikes[comment.id] ?? 0) + delta;
                        });

                        try {
                          await notifier.toggleLikeComentario(comment.id);
                          // server updated models; reset optimistic delta
                          setState(() {
                            _localCommentLikes[comment.id] = 0;
                            _localCommentLiked[comment.id] = notifier.comentariosActuales.firstWhere((c) => c.id == comment.id).yaLeDioLike;
                          });
                        } catch (e) {
                          // revert optimistic
                          setState(() {
                            final current = _localCommentLiked[comment.id] ?? comment.yaLeDioLike;
                            _localCommentLiked[comment.id] = !current;
                            final delta = current ? -1 : 1;
                            _localCommentLikes[comment.id] = (_localCommentLikes[comment.id] ?? 0) + delta;
                          });
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(notifier.errorMessage ?? 'Error al dar like al comentario')),
                            );
                          }
                        }
                      },
                      onReply: () {
                        _showAddCommentDialog(context, parentId: comment.id);
                      },
                    ),
                    if (replies.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 40, top: 8, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  if (isExpanded) _expandedComments.remove(comment.id);
                                  else _expandedComments.add(comment.id);
                                });
                              },
                              child: Text(
                                isExpanded ? 'Ocultar respuestas (${replies.length})' : 'Ver respuestas (${replies.length})',
                                style: TextStyle(color: colorScheme.onSurfaceVariant),
                              ),
                            ),
                            if (isExpanded)
                              Column(
                                children: replies.map((r) => Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: colorScheme.surfaceVariant,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 12,
                                              backgroundColor: colorScheme.secondary,
                                              child: Text(r.autorInitials, style: TextStyle(color: colorScheme.onSecondary, fontSize: 12)),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(r.autorNombre, style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
                                            const SizedBox(width: 8),
                                            Text(r.fechaFormateada, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12)),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(r.contenido, style: TextStyle(color: colorScheme.onSurface)),
                                      ],
                                    ),
                                  ),
                                )).toList(),
                              ),
                          ],
                        ),
                      ),
                  ],
                );
              }),

            const SizedBox(height: 24),

            // Espacio para el botón flotante
            const SizedBox(height: 80),
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