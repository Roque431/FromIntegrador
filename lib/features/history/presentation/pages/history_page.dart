import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/responsive_widgets.dart';
import '../../../../core/widgets/responsive_text_field.dart';
import '../providers/historial_notifier.dart';
import '../../data/models/conversacion_model.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistorialNotifier>().loadConversaciones();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.of(context).size;
    final notifier = context.watch<HistorialNotifier>();
    final conversaciones = notifier.conversacionesFiltradas;
    
    final isWide = size.width > 600;
    final isDesktop = size.width > 900;
    final maxWidth = isDesktop ? 800.0 : (isWide ? 700.0 : double.infinity);
    final cardPadding = isDesktop ? 24.0 : (isWide ? 20.0 : 16.0);
    
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
          'Historial',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              children: [
                // Card de búsqueda y filtros
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.horizontalPadding(context),
                    vertical: 16,
                  ),
                  child: ResponsiveCard(
                    padding: EdgeInsets.all(cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buscar en tu historial',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Campo de búsqueda
                        ResponsiveTextField(
                          controller: _searchController,
                          hintText: 'Buscar consulta...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          onChanged: (value) {
                            notifier.setBusqueda(value);
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Chips de filtros
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFilterChip(
                                context,
                                label: 'Todos',
                                count: notifier.conversaciones.length,
                                isSelected: notifier.filtroCluster == null,
                                onTap: () => notifier.setFiltroCluster(null),
                              ),
                              const SizedBox(width: 8),
                              _buildFilterChip(
                                context,
                                label: 'Accidentes',
                                count: notifier.conversaciones.where((c) => c.clusterPrincipal == 'C1').length,
                                isSelected: notifier.filtroCluster == 'C1',
                                onTap: () => notifier.setFiltroCluster('C1'),
                              ),
                              const SizedBox(width: 8),
                              _buildFilterChip(
                                context,
                                label: 'Multas',
                                count: notifier.conversaciones.where((c) => c.clusterPrincipal == 'C2').length,
                                isSelected: notifier.filtroCluster == 'C2',
                                onTap: () => notifier.setFiltroCluster('C2'),
                              ),
                              const SizedBox(width: 8),
                              _buildFilterChip(
                                context,
                                label: 'Documentos',
                                count: notifier.conversaciones.where((c) => c.clusterPrincipal == 'C3').length,
                                isSelected: notifier.filtroCluster == 'C3',
                                onTap: () => notifier.setFiltroCluster('C3'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Lista de consultas
                Expanded(
                  child: _buildContent(notifier, conversaciones, colorScheme, cardPadding),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected 
              ? colorScheme.primary.withValues(alpha: 0.15)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected 
                    ? colorScheme.primary 
                    : colorScheme.outline.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    HistorialNotifier notifier, 
    List<ConversacionModel> conversaciones, 
    ColorScheme colorScheme,
    double cardPadding,
  ) {
    if (notifier.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Cargando historial...',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    if (notifier.hasError) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.horizontalPadding(context),
        ),
        child: ResponsiveCard(
          padding: EdgeInsets.all(cardPadding * 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: colorScheme.error.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 16),
              Text(
                'Error al cargar',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                notifier.errorMessage ?? 'Ocurrió un error inesperado',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ResponsiveButton(
                text: 'Reintentar',
                onPressed: () => notifier.loadConversaciones(),
              ),
            ],
          ),
        ),
      );
    }

    if (conversaciones.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.horizontalPadding(context),
        ),
        child: ResponsiveCard(
          padding: EdgeInsets.all(cardPadding * 2),
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
                child: Icon(
                  Icons.history_outlined,
                  size: 48,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Sin consultas aún',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tus conversaciones con LexIA\naparecerán aquí',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => notifier.loadConversaciones(),
      color: colorScheme.primary,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.horizontalPadding(context),
        ),
        itemCount: conversaciones.length,
        itemBuilder: (context, index) {
          final c = conversaciones[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildConsultationCard(context, c, cardPadding),
          );
        },
      ),
    );
  }

  Widget _buildConsultationCard(BuildContext context, ConversacionModel c, double padding) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Material(
      color: colorScheme.surfaceContainerHighest,
      elevation: isDark ? 4 : 6,
      borderRadius: BorderRadius.circular(16),
      shadowColor: isDark
          ? Colors.black.withValues(alpha: 0.4)
          : Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        onTap: () {
          context.push('/consultation/${c.id}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: categoría y fecha
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      c.clusterDescripcion,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    c.fechaFormateada,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Pregunta
              Text(
                c.ultimoMensaje ?? c.titulo ?? 'Conversación',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // Footer
              Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${c.totalMensajes} mensajes',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}