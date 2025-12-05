import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/simple_profile_validation_notifier.dart';
import '../widgets/profile_validation_card.dart';
import '../widgets/profile_type_filter_chips.dart';
import '../../data/models/profile_validation_model.dart';

class ProfileValidationPage extends StatefulWidget {
  const ProfileValidationPage({super.key});

  @override
  State<ProfileValidationPage> createState() => _ProfileValidationPageState();
}

class _ProfileValidationPageState extends State<ProfileValidationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SimpleProfileValidationNotifier>().loadProfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.onPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/admin');
            }
          },
        ),
        title: Text(
          'Validar Perfiles',
          style: TextStyle(
            color: colors.onPrimary,
            fontWeight: FontWeight.w600,
            fontSize: isWeb ? 22 : 20,
          ),
        ),
        actions: [
          Consumer<SimpleProfileValidationNotifier>(
            builder: (context, notifier, child) {
              return IconButton(
                icon: notifier.isRefreshing
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(colors.onPrimary),
                        ),
                      )
                    : Icon(Icons.refresh, color: colors.onPrimary),
                onPressed: notifier.isRefreshing ? null : () {
                  notifier.refresh();
                },
              );
            },
          ),
          SizedBox(width: isWeb ? 8 : 4),
        ],
      ),
      body: Consumer<SimpleProfileValidationNotifier>(
        builder: (context, notifier, child) {
          if (notifier.isLoading && notifier.perfiles.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (notifier.hasError && notifier.perfiles.isEmpty) {
            return _buildErrorState(notifier.errorMessage, colors);
          }

          return RefreshIndicator(
            onRefresh: notifier.refresh,
            child: CustomScrollView(
              slivers: [
                // Filtros y estadísticas
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(isWeb ? 24 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filtros por tipo
                        ProfileTypeFilterChips(
                          selectedType: notifier.filtroActivo,
                          onTypeChanged: notifier.cambiarFiltro,
                          abogadosCount: notifier.abogados.length,
                          anunciantesCount: notifier.anunciantes.length,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Indicador de resultados
                        Row(
                          children: [
                            Icon(
                              notifier.filtroActivo == ProfileType.abogado
                                  ? Icons.gavel
                                  : Icons.business,
                              size: 20,
                              color: colors.onSurface.withOpacity(0.7),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${notifier.perfilesFiltrados.length} ${notifier.filtroActivo == ProfileType.abogado ? 'abogados' : 'anunciantes'} pendientes',
                              style: TextStyle(
                                fontSize: isWeb ? 16 : 14,
                                fontWeight: FontWeight.w500,
                                color: colors.onSurface.withOpacity(0.8),
                              ),
                            ),
                            if (notifier.isRefreshing) ...[
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Lista de perfiles
                if (notifier.perfilesFiltrados.isEmpty)
                  SliverFillRemaining(
                    child: _buildEmptyState(notifier.filtroActivo, colors),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 24 : 16,
                      vertical: 8,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final profile = notifier.perfilesFiltrados[index];
                          return ProfileValidationCard(
                            profile: profile,
                            isSelected: notifier.perfilSeleccionado?.id == profile.id,
                            isProcessing: notifier.isPerfilEnProceso(profile.id),
                            onTap: () => notifier.seleccionarPerfil(profile.id),
                            onApprove: () => _showApproveDialog(context, profile, notifier),
                            onReject: () => _showRejectDialog(context, profile, notifier),
                          );
                        },
                        childCount: notifier.perfilesFiltrados.length,
                      ),
                    ),
                  ),
                
                // Espaciado inferior
                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String? message, ColorScheme colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colors.error),
            const SizedBox(height: 16),
            Text(
              'Error al cargar perfiles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message ?? 'Ha ocurrido un error inesperado',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: colors.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<SimpleProfileValidationNotifier>().loadProfiles();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ProfileType tipo, ColorScheme colors) {
    final tipoText = tipo == ProfileType.abogado ? 'abogados' : 'anunciantes';
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tipo == ProfileType.abogado ? Icons.gavel : Icons.business,
              size: 64,
              color: colors.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay $tipoText pendientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Todos los $tipoText han sido validados',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: colors.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showApproveDialog(
    BuildContext context,
    ProfileValidationModel profile,
    SimpleProfileValidationNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Aprobar Perfil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('¿Está seguro de aprobar el perfil de:'),
              const SizedBox(height: 8),
              Text(
                profile.nombreCompleto,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Tipo: ${profile.tipoTexto}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Esta acción no se puede deshacer.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                final success = await notifier.aprobarPerfil(profile.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Perfil aprobado exitosamente'
                            : 'Error al aprobar perfil',
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Aprobar'),
            ),
          ],
        );
      },
    );
  }

  void _showRejectDialog(
    BuildContext context,
    ProfileValidationModel profile,
    SimpleProfileValidationNotifier notifier,
  ) {
    final motivoController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Rechazar Perfil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rechazando el perfil de:'),
              const SizedBox(height: 8),
              Text(
                profile.nombreCompleto,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: motivoController,
                decoration: const InputDecoration(
                  labelText: 'Motivo del rechazo',
                  hintText: 'Especifique por qué rechaza este perfil',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                maxLength: 500,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final motivo = motivoController.text.trim();
                if (motivo.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('El motivo es requerido'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                Navigator.of(dialogContext).pop();
                final success = await notifier.rechazarPerfil(profile.id, motivo);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Perfil rechazado exitosamente'
                            : 'Error al rechazar perfil',
                      ),
                      backgroundColor: success ? Colors.orange : Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Rechazar'),
            ),
          ],
        );
      },
    );
  }
}