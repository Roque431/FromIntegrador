import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/forum/widgests/forum_expert_comment.dart';
import 'package:flutter_application_1/features/forum/widgests/forum_ia_response.dart';
import 'package:flutter_application_1/features/forum/widgests/forum_user_post.dart';
import 'package:go_router/go_router.dart';


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
  bool _isLiked = false;
  int _likes = 8;

  // TODO: Cargar datos reales desde la API
  final Map<String, dynamic> _postData = {
    'userName': 'Ramos Molina',
    'userInitials': 'RA',
    'date': '29/05/2025',
    'category': 'Laboral',
    'tags': ['Despido', 'Liquidacion'],
    'question': '¿Qué pasa si me despiden y no me pagan mi liquidación?',
  };

  final String _iaResponse = """**Respuesta Legal:**

Según el Artículo 50 de la Ley Federal del Trabajo de México:

**Tus Derechos:**

- Tienes derecho a recibir una indemnización de 3 meses de salario
- Pago de prima de antigüedad (12 días de salario por año trabajado)
- Salarios vencidos desde el despido hasta que se cubra la indemnización
- Prima vacacional proporcional - Aguinaldo proporcional

**Marco Legal:**

**Ley Federal del Trabajo - Artículo 50:**

"Si en el juicio correspondiente no comprueba el patrón las causas de la rescisión, el trabajador tendrá derecho, además, a que se le paguen los salarios vencidos desde la fecha del despido hasta por un período máximo de doce meses."
""";

  final List<Map<String, dynamic>> _expertComments = [
    {
      'userName': 'Tu',
      'userInitials': 'LT',
      'date': '29/05/2025',
      'comment': 'En esos casos debería acudir a tal y hacer lo siguiente...',
      'likes': 8,
      'replies': 4,
    },
    {
      'userName': 'Carlos',
      'userInitials': 'LT',
      'date': '29/05/2025',
      'comment': 'En esos casos debería acudir a tal y hacer lo siguiente...',
      'likes': 8,
      'replies': 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.primary,
      appBar: AppBar(
        backgroundColor: colors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.secondary),
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
            color: colors.tertiary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: colors.tertiary),
            onPressed: () => _showOptionsMenu(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Post original del usuario
              ForumUserPost(
                userName: _postData['userName'],
                userInitials: _postData['userInitials'],
                date: _postData['date'],
                category: _postData['category'],
                tags: List<String>.from(_postData['tags']),
                question: _postData['question'],
                likes: _likes,
                comments: _expertComments.length,
                isLiked: _isLiked,
                onLike: () {
                  setState(() {
                    _isLiked = !_isLiked;
                    _likes += _isLiked ? 1 : -1;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Respuesta de LexIA
              ForumIAResponse(response: _iaResponse),

              const SizedBox(height: 24),

              // Título de comentarios
              Text(
                'Comentarios de usuarios expertos',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.tertiary,
                    ),
              ),

              const SizedBox(height: 16),

              // Lista de comentarios de expertos
              ..._expertComments.map((comment) => ForumExpertComment(
                    userName: comment['userName'],
                    userInitials: comment['userInitials'],
                    date: comment['date'],
                    comment: comment['comment'],
                    likes: comment['likes'],
                    replies: comment['replies'],
                    onLike: () {
                      // TODO: Implementar like
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Like agregado')),
                      );
                    },
                  )),

              const SizedBox(height: 80), // Espacio para el botón flotante
            ],
          ),
        ),
      ),
      // Botón para agregar comentario
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCommentDialog(context),
        backgroundColor: colors.secondary,
        icon: const Icon(Icons.add_comment, color: Colors.white),
        label: const Text('Comentar', style: TextStyle(color: Colors.white)),
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

  void _showAddCommentDialog(BuildContext context) {
    final commentController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (commentController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                // TODO: Enviar comentario a la API
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Comentario agregado')),
                );
              }
            },
            child: const Text('Publicar'),
          ),
        ],
      ),
    );
  }
}