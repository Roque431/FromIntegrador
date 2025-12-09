import 'package:flutter/material.dart';
import '../../data/models/profesionista_model.dart';

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

    return GestureDetector(
      onTap: onVerPerfil,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CABECERA
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatar(context),
                const SizedBox(width: 14),
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
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (profesionista.verificado)
                            Icon(
                              Icons.verified_rounded,
                              color: Colors.green.shade600,
                              size: 20,
                            ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            "${profesionista.rating.toStringAsFixed(1)} (${profesionista.totalCalificaciones})",
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ESPECIALIDADES
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profesionista.especialidades.take(3).map((esp) {
                return Chip(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  label: Text(
                    esp,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontSize: 11,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // DESCRIPCION
            if (profesionista.descripcion.isNotEmpty)
              Text(
                profesionista.descripcion,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  height: 1.4,
                ),
              ),

            const SizedBox(height: 16),

            // ACCIONES
            Row(
              children: [
                // DESCARTAR
                if (onRechazar != null)
                  _circleButton(
                    icon: Icons.close_rounded,
                    color: Colors.red.shade400,
                    onTap: onRechazar!,
                  ),

                const SizedBox(width: 12),

                // MATCH
                if (onMatch != null)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onMatch,
                      icon: const Icon(Icons.handshake_outlined),
                      label: const Text("Hacer Match"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
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

  // AVATAR
  Widget _buildAvatar(BuildContext context) {
    final theme = Theme.of(context);

    if (profesionista.fotoProfesional != null &&
        profesionista.fotoProfesional!.isNotEmpty) {
      return CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(profesionista.fotoProfesional!),
      );
    }

    return CircleAvatar(
      radius: 28,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: Text(
        profesionista.iniciales,
        style: TextStyle(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // BOTÓN REDONDO (DESCARTAR)
  Widget _circleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
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
