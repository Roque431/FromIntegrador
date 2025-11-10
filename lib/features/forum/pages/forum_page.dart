import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/forum/widgests/category_filter_button.dart';
import 'package:flutter_application_1/features/forum/widgests/forum_filter_chip.dart';
import 'package:flutter_application_1/features/forum/widgests/forum_post_card.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes.dart';


class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Recientes';
  String? _selectedCategory;

  // Datos de ejemplo - TODO: Reemplazar con datos reales de la API
  final List<Map<String, dynamic>> _posts = [
    {
      'id': 'post_1',
      'userName': 'Luis Torrez',
      'userInitials': 'LT',
      'date': '29/05/2025',
      'category': 'Penal',
      'tags': ['Defensa', 'Inquilino'],
      'question': '¿Qué pasa si me despiden y no me pagan mi liquidación?',
      'excerpt': 'De acuerdo con el Código Civil, el arrendador tiene la obligación de mantener...',
      'likes': 8,
      'comments': 4,
    },
    {
      'id': 'post_2',
      'userName': 'Ramos Molina',
      'userInitials': 'RA',
      'date': '29/05/2025',
      'category': 'Laboral',
      'tags': ['Despido', 'Liquidacion'],
      'question': '¿Qué pasa si me despiden y no me pagan mi liquidación?',
      'excerpt': 'De acuerdo con el Código Civil, el arrendador tiene la obligación de mantener...',
      'likes': 8,
      'comments': 4,
    },
    {
      'id': 'post_3',
      'userName': 'Ramos Molina',
      'userInitials': 'RA',
      'date': '28/05/2025',
      'category': 'Laboral',
      'tags': ['Despido', 'Liquidacion'],
      'question': '¿Qué pasa si me despiden y no me pagan mi liquidación?',
      'excerpt': 'De acuerdo con el Código Civil, el arrendador tiene la obligación de mantener...',
      'likes': 8,
      'comments': 4,
    },
  ];

  List<Map<String, dynamic>> get _filteredPosts {
    var filtered = _posts;

    // Filtrar por categoría
    if (_selectedCategory != null) {
      filtered = filtered.where((post) => post['category'] == _selectedCategory).toList();
    }

    // Filtrar por búsqueda
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered
          .where((post) => post['question'].toLowerCase().contains(query))
          .toList();
    }

    // Ordenar según filtro seleccionado
    if (_selectedFilter == 'Populares') {
      filtered.sort((a, b) => (b['likes'] as int).compareTo(a['likes'] as int));
    } else if (_selectedFilter == 'Mas Utiles') {
      filtered.sort((a, b) => (b['comments'] as int).compareTo(a['comments'] as int));
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
              context.go('/home');
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Foro Comunitario',
              style: TextStyle(
                color: colors.tertiary,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            Text(
              'Comparte y descubre soluciones legales de la comunidad LexIA',
              style: TextStyle(
                color: colors.tertiary.withOpacity(0.6),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Buscador y filtro de categorías
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar consulta',
                        hintStyle: TextStyle(color: colors.tertiary.withOpacity(0.4)),
                        prefixIcon: Icon(Icons.search, color: colors.tertiary.withOpacity(0.5)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  CategoryFilterButton(
                    selectedCategory: _selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Filtros: Recientes, Populares, Más Útiles
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ForumFilterChip(
                    icon: Icons.access_time,
                    label: 'Recientes',
                    isSelected: _selectedFilter == 'Recientes',
                    onTap: () => setState(() => _selectedFilter = 'Recientes'),
                  ),
                  const SizedBox(width: 8),
                  ForumFilterChip(
                    icon: Icons.star_outline,
                    label: 'Populares',
                    isSelected: _selectedFilter == 'Populares',
                    onTap: () => setState(() => _selectedFilter = 'Populares'),
                  ),
                  const SizedBox(width: 8),
                  ForumFilterChip(
                    icon: Icons.people_outline,
                    label: 'Mas Utiles',
                    isSelected: _selectedFilter == 'Mas Utiles',
                    onTap: () => setState(() => _selectedFilter = 'Mas Utiles'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Lista de posts
            Expanded(
              child: _filteredPosts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.forum_outlined,
                            size: 64,
                            color: colors.tertiary.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay publicaciones',
                            style: TextStyle(
                              color: colors.tertiary.withOpacity(0.6),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = _filteredPosts[index];
                        return ForumPostCard(
                          userName: post['userName'],
                          userInitials: post['userInitials'],
                          date: post['date'],
                          category: post['category'],
                          tags: List<String>.from(post['tags']),
                          question: post['question'],
                          excerpt: post['excerpt'],
                          likes: post['likes'],
                          comments: post['comments'],
                          onTap: () {
                            context.pushNamed(
                              AppRoutes.forumDetail,
                              pathParameters: {'id': post['id']},
                            );
                          },
                          onLike: () {
                            // TODO: Implementar like
                            setState(() {
                              post['likes']++;
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      // Botón flotante para crear nueva publicación
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navegar a crear nueva publicación
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Crear nueva publicación - TODO')),
          );
        },
        backgroundColor: colors.secondary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Nueva', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

