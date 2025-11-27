import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LawyerForumPage extends StatefulWidget {
  const LawyerForumPage({super.key});

  @override
  State<LawyerForumPage> createState() => _LawyerForumPageState();
}

class _LawyerForumPageState extends State<LawyerForumPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          'Foro Comunitario',
          style: TextStyle(
            color: colors.tertiary,
            fontWeight: FontWeight.w600,
            fontSize: isWeb ? 22 : null,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: colors.secondary,
          unselectedLabelColor: colors.tertiary.withValues(alpha: 0.6),
          indicatorColor: colors.secondary,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isWeb ? 15 : 14,
          ),
          tabs: const [
            Tab(text: 'Sin Responder'),
            Tab(text: 'Mis Respuestas'),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWeb ? 900 : double.infinity),
            child: Column(
              children: [
                // Banner informativo
                Container(
                  margin: EdgeInsets.all(isWeb ? 16 : 12),
                  padding: EdgeInsets.all(isWeb ? 16 : 14),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(isWeb ? 14 : 12),
                    border: Border.all(
                      color: Colors.blue.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.blue.shade700,
                        size: isWeb ? 26 : 24,
                      ),
                      SizedBox(width: isWeb ? 12 : 10),
                      Expanded(
                        child: Text(
                          'Responder en el foro aumenta tu reputación. Este mes: 45/50 respuestas',
                          style: TextStyle(
                            fontSize: isWeb ? 14 : 13,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Barra de búsqueda
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isWeb ? 16 : 12),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar publicaciones...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: isWeb ? 15 : 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[600],
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(isWeb ? 12 : 10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: isWeb ? 16 : 14,
                        vertical: isWeb ? 14 : 12,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: isWeb ? 16 : 12),

                // Tabs content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildUnrespondedTab(isWeb),
                      _buildMyResponsesTab(isWeb),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnrespondedTab(bool isWeb) {
    final posts = _getUnrespondedPosts();

    return ListView.builder(
      padding: EdgeInsets.all(isWeb ? 16 : 12),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return _buildForumPostCard(post, isWeb, isResponded: false);
      },
    );
  }

  Widget _buildMyResponsesTab(bool isWeb) {
    final posts = _getMyResponsesPosts();

    return ListView.builder(
      padding: EdgeInsets.all(isWeb ? 16 : 12),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return _buildForumPostCard(post, isWeb, isResponded: true);
      },
    );
  }

  Widget _buildForumPostCard(
    ForumPost post,
    bool isWeb, {
    required bool isResponded,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.only(bottom: isWeb ? 14 : 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isWeb ? 14 : 12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isWeb ? 18 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con usuario y estado
            Row(
              children: [
                CircleAvatar(
                  radius: isWeb ? 22 : 20,
                  backgroundColor: _getAvatarColor(post.userName),
                  child: Text(
                    post.userInitials,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isWeb ? 15 : 14,
                    ),
                  ),
                ),
                SizedBox(width: isWeb ? 12 : 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: TextStyle(
                          fontSize: isWeb ? 16 : 15,
                          fontWeight: FontWeight.w600,
                          color: colors.tertiary,
                        ),
                      ),
                      Text(
                        post.timeAgo,
                        style: TextStyle(
                          fontSize: isWeb ? 13 : 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isResponded)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 10 : 8,
                      vertical: isWeb ? 6 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Sin Responder',
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontSize: isWeb ? 12 : 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 10 : 8,
                      vertical: isWeb ? 6 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Respondido por ti',
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontSize: isWeb ? 12 : 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: isWeb ? 14 : 12),

            // Título de la pregunta
            Text(
              post.question,
              style: TextStyle(
                fontSize: isWeb ? 17 : 16,
                fontWeight: FontWeight.bold,
                color: colors.tertiary,
              ),
            ),

            SizedBox(height: isWeb ? 10 : 8),

            // Preview del contenido
            Text(
              post.preview,
              style: TextStyle(
                fontSize: isWeb ? 14 : 13,
                color: Colors.grey[700],
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Si hay respuesta del abogado
            if (isResponded && post.lawyerResponse != null) ...[
              SizedBox(height: isWeb ? 14 : 12),
              Container(
                padding: EdgeInsets.all(isWeb ? 14 : 12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(isWeb ? 10 : 8),
                  border: Border.all(
                    color: Colors.green.shade200,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tu respuesta:',
                      style: TextStyle(
                        fontSize: isWeb ? 13 : 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                    SizedBox(height: isWeb ? 6 : 4),
                    Text(
                      post.lawyerResponse!,
                      style: TextStyle(
                        fontSize: isWeb ? 14 : 13,
                        color: Colors.green.shade900,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],

            // Estadísticas y botón
            SizedBox(height: isWeb ? 14 : 12),

            Row(
              children: [
                if (isResponded) ...[
                  Icon(
                    Icons.thumb_up_outlined,
                    size: isWeb ? 18 : 16,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: isWeb ? 6 : 4),
                  Text(
                    '${post.likes} útiles',
                    style: TextStyle(
                      fontSize: isWeb ? 13 : 12,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(width: isWeb ? 16 : 14),
                  Icon(
                    Icons.comment_outlined,
                    size: isWeb ? 18 : 16,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: isWeb ? 6 : 4),
                  Text(
                    '${post.comments} comentarios',
                    style: TextStyle(
                      fontSize: isWeb ? 13 : 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
                const Spacer(),
                if (!isResponded)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showResponseDialog(context, post);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB8907D),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: isWeb ? 12 : 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Responder',
                        style: TextStyle(
                          fontSize: isWeb ? 15 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getAvatarColor(String name) {
    final colors = [
      const Color(0xFFB8907D),
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.orange,
    ];
    return colors[name.hashCode % colors.length];
  }

  void _showResponseDialog(BuildContext context, ForumPost post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Responder en el Foro'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.question,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Esta función estará disponible próximamente para escribir tu respuesta profesional.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  // Datos de demostración - Solo temas de tránsito/choque
  List<ForumPost> _getUnrespondedPosts() {
    return [
      ForumPost(
        userName: 'Luis Pérez',
        userInitials: 'LP',
        question: '¿Qué hago si me detienen en un retén?',
        preview: 'Me detuvieron en un retén y me pidieron documentos...',
        timeAgo: 'Hace 1 hora',
        likes: 0,
        comments: 0,
      ),
      ForumPost(
        userName: 'María González',
        userInitials: 'MG',
        question: 'Accidente sin seguro del otro conductor',
        preview: 'Tuve un choque y el otro conductor no tiene seguro. ¿Qué puedo hacer para recuperar los daños de mi vehículo?',
        timeAgo: 'Hace 3 horas',
        likes: 0,
        comments: 0,
      ),
      ForumPost(
        userName: 'Roberto Sánchez',
        userInitials: 'RS',
        question: 'Multa por exceso de velocidad injusta',
        preview: 'Me pusieron una multa por exceso de velocidad pero no creo que haya sido correcta...',
        timeAgo: 'Hace 5 horas',
        likes: 0,
        comments: 0,
      ),
    ];
  }

  List<ForumPost> _getMyResponsesPosts() {
    return [
      ForumPost(
        userName: 'Sandra Castro',
        userInitials: 'SC',
        question: '¿Es legal que me remolquen sin avisar?',
        preview: 'Estacioné mi auto por unos minutos y cuando regresé ya no estaba...',
        timeAgo: 'Hace 3 horas',
        likes: 12,
        comments: 3,
        lawyerResponse:
            'Según el reglamento de tránsito, deben colocar señalamientos visibles...',
      ),
      ForumPost(
        userName: 'Carlos Ramírez',
        userInitials: 'CR',
        question: 'Choque con taxi, ¿quién paga?',
        preview: 'Un taxi me chocó por detrás en un semáforo...',
        timeAgo: 'Hace 1 día',
        likes: 8,
        comments: 5,
        lawyerResponse:
            'En caso de choque por alcance, generalmente la responsabilidad es del vehículo que impactó por detrás...',
      ),
    ];
  }
}

class ForumPost {
  final String userName;
  final String userInitials;
  final String question;
  final String preview;
  final String timeAgo;
  final int likes;
  final int comments;
  final String? lawyerResponse;

  ForumPost({
    required this.userName,
    required this.userInitials,
    required this.question,
    required this.preview,
    required this.timeAgo,
    required this.likes,
    required this.comments,
    this.lawyerResponse,
  });
}
