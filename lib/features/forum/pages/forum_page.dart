import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/forum/widgests/category_filter_button.dart';
import 'package:flutter_application_1/features/forum/widgests/forum_filter_chip.dart';
import 'package:flutter_application_1/features/forum/widgests/forum_post_card.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/responsive_widgets.dart';
import '../presentation/providers/foro_notifier.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = context.read<ForoNotifier>();
      notifier.loadCategorias();
      notifier.loadPublicaciones();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final notifier = context.read<ForoNotifier>();
    if (query.isEmpty) {
      notifier.loadPublicaciones();
    } else {
      notifier.buscarPublicaciones(query);
    }
  }

  void _showNuevaPublicacionDialog() {
    final notifier = context.read<ForoNotifier>();
    final tituloController = TextEditingController();
    final contenidoController = TextEditingController();
    String? categoriaSeleccionada;
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Nueva Publicación', style: TextStyle(color: colorScheme.onSurface)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: categoriaSeleccionada,
                  dropdownColor: colorScheme.surfaceContainerHighest,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.primary, width: 2),
                    ),
                  ),
                  items: notifier.categorias.map((cat) {
                    return DropdownMenuItem(
                      value: cat.id,
                      child: Text(cat.nombre, style: TextStyle(color: colorScheme.onSurface)),
                    );
                  }).toList(),
                  onChanged: (value) => setDialogState(() => categoriaSeleccionada = value),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: tituloController,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Título',
                    labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    hintText: '¿Cuál es tu pregunta?',
                    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.primary, width: 2),
                    ),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contenidoController,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    hintText: 'Describe tu situación con más detalle...',
                    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.primary, width: 2),
                    ),
                  ),
                  maxLines: 5,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancelar', style: TextStyle(color: colorScheme.onSurfaceVariant)),
            ),
            FilledButton(
              onPressed: () async {
                if (tituloController.text.trim().isEmpty ||
                    contenidoController.text.trim().isEmpty ||
                    categoriaSeleccionada == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Completa todos los campos')),
                  );
                  return;
                }

                Navigator.pop(ctx);

                final result = await notifier.crearPublicacion(
                  titulo: tituloController.text.trim(),
                  contenido: contenidoController.text.trim(),
                  categoriaId: categoriaSeleccionada!,
                );

                if (result != null && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Publicación creada')),
                  );
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(notifier.errorMessage ?? 'Error al crear')),
                  );
                }
              },
              child: const Text('Publicar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final notifier = context.watch<ForoNotifier>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(
          'Foro Comunitario',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Buscador y filtro de categorías
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.horizontalPadding(context)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: 'Buscar consulta',
                        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                        prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      onSubmitted: _onSearch,
                      onChanged: (value) {
                        if (value.isEmpty) _onSearch('');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  CategoryFilterButton(
                    selectedCategory: notifier.categoriaSeleccionada,
                    onChanged: (value) => notifier.setCategoriaSeleccionada(value),
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
                padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.horizontalPadding(context)),
                children: [
                  ForumFilterChip(
                    icon: Icons.access_time,
                    label: 'Recientes',
                    isSelected: notifier.filtroActual == 'Recientes',
                    onTap: () => notifier.setFiltro('Recientes'),
                  ),
                  const SizedBox(width: 8),
                  ForumFilterChip(
                    icon: Icons.star_outline,
                    label: 'Populares',
                    isSelected: notifier.filtroActual == 'Populares',
                    onTap: () => notifier.setFiltro('Populares'),
                  ),
                  const SizedBox(width: 8),
                  ForumFilterChip(
                    icon: Icons.people_outline,
                    label: 'Más Útiles',
                    isSelected: notifier.filtroActual == 'Mas Utiles',
                    onTap: () => notifier.setFiltro('Mas Utiles'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Lista de posts
            Expanded(child: _buildContent(notifier, colorScheme)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showNuevaPublicacionDialog,
        backgroundColor: colorScheme.primary,
        icon: Icon(Icons.add, color: colorScheme.onPrimary),
        label: Text('Nueva', style: TextStyle(color: colorScheme.onPrimary)),
      ),
    );
  }

  Widget _buildContent(ForoNotifier notifier, ColorScheme colorScheme) {
    if (notifier.isLoading) {
      return Center(child: CircularProgressIndicator(color: colorScheme.primary));
    }

    if (notifier.hasError) {
      return Padding(
        padding: EdgeInsets.all(ResponsiveSize.horizontalPadding(context)),
        child: ResponsiveCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              ResponsiveButton(
                text: 'Reintentar',
                onPressed: () => notifier.loadPublicaciones(),
              ),
            ],
          ),
        ),
      );
    }

    if (notifier.publicaciones.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(ResponsiveSize.horizontalPadding(context)),
        child: ResponsiveCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.forum_outlined, size: 48, color: colorScheme.primary),
              ),
              const SizedBox(height: 16),
              Text(
                'No hay publicaciones',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '¡Sé el primero en publicar!',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => notifier.loadPublicaciones(),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.horizontalPadding(context)),
        itemCount: notifier.publicaciones.length,
        itemBuilder: (context, index) {
          final post = notifier.publicaciones[index];
          return ForumPostCard(
            userName: post.autorNombre,
            userInitials: post.autorInitials,
            date: post.fechaFormateada,
            category: post.categoriaNombre,
            tags: const [],
            question: post.titulo,
            excerpt: post.contenido.length > 150
                ? '${post.contenido.substring(0, 150)}...'
                : post.contenido,
            likes: post.likes,
            comments: post.comentarios,
            onTap: () {
              context.pushNamed(
                AppRoutes.forumDetail,
                pathParameters: {'id': post.id},
              );
            },
            onLike: () => notifier.toggleLike(post.id),
            onDislike: () => notifier.reportUtilidad(post.id, false),
          );
        },
      ),
    );
  }
}

