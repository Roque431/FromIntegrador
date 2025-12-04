import 'package:flutter/material.dart';
import '../../data/models/profesionista_model.dart';

/// Card interactiva para mostrar un profesionista (abogado)
/// El usuario puede ver el perfil completo o hacer match para contacto directo
class ProfesionistaCard extends StatelessWidget {
  final ProfesionistaModel profesionista;
  final VoidCallback? onVerPerfil;
  final VoidCallback? onMatch;
  final VoidCallback? onRechazar;

  const ProfesionistaCard({
    super.key,
    required this.profesionista,
    this.onVerPerfil,
    this.onMatch,
    this.onRechazar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con avatar y datos principales
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                _buildAvatar(context),
                const SizedBox(width: 12),
                // Datos principales
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              profesionista.nombre,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (profesionista.verificado)
                            Container(
                              margin: const EdgeInsets.only(left: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified,
                                    size: 12,
                                    color: Colors.green.shade700,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Verificado',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Rating y valoraciones
                      Row(
                        children: [
                          Text(
                            profesionista.ratingEstrellas,
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${profesionista.rating.toStringAsFixed(1)}/5',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            ' (${profesionista.totalCalificaciones} valoraciones)',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Especialidades y experiencia
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Experiencia y ubicación
                Row(
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${profesionista.experienciaAnios} años de experiencia',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        profesionista.ciudad,
                        style: theme.textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Especialidades
                if (profesionista.especialidades.isNotEmpty) ...[
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: profesionista.especialidades.take(3).map((esp) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          esp,
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Descripción (si existe)
          if (profesionista.descripcion.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                profesionista.descripcion,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          
          const SizedBox(height: 12),
          
          // Botones de acción
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Botón Rechazar
                if (onRechazar != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onRechazar,
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('No interesado'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade600,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                if (onRechazar != null) const SizedBox(width: 8),
                
                // Botón Ver Perfil
                if (onVerPerfil != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onVerPerfil,
                      icon: const Icon(Icons.person_outline, size: 18),
                      label: const Text('Ver perfil'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        side: BorderSide(color: theme.colorScheme.primary),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                if (onVerPerfil != null && onMatch != null) 
                  const SizedBox(width: 8),
                
                // Botón Match (Contactar)
                if (onMatch != null)
                  Expanded(
                    flex: onRechazar != null ? 1 : 2,
                    child: ElevatedButton.icon(
                      onPressed: onMatch,
                      icon: const Icon(Icons.handshake_outlined, size: 18),
                      label: const Text('Hacer Match'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final theme = Theme.of(context);
    
    if (profesionista.fotoProfesional != null && 
        profesionista.fotoProfesional!.isNotEmpty) {
      return CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(profesionista.fotoProfesional!),
        onBackgroundImageError: (_, __) {},
        child: null,
      );
    }
    
    return CircleAvatar(
      radius: 28,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: Text(
        profesionista.iniciales,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

/// Lista horizontal de cards de profesionistas
class ProfesionistasListView extends StatelessWidget {
  final List<ProfesionistaModel> profesionistas;
  final Function(ProfesionistaModel)? onVerPerfil;
  final Function(ProfesionistaModel)? onMatch;
  final Function(ProfesionistaModel)? onRechazar;
  final String? titulo;

  const ProfesionistasListView({
    super.key,
    required this.profesionistas,
    this.onVerPerfil,
    this.onMatch,
    this.onRechazar,
    this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    if (profesionistas.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (titulo != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 8),
            child: Row(
              children: [
                Icon(
                  Icons.gavel_rounded,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  titulo!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ...profesionistas.map((p) => ProfesionistaCard(
          profesionista: p,
          onVerPerfil: onVerPerfil != null ? () => onVerPerfil!(p) : null,
          onMatch: onMatch != null ? () => onMatch!(p) : null,
          onRechazar: onRechazar != null ? () => onRechazar!(p) : null,
        )),
      ],
    );
  }
}
