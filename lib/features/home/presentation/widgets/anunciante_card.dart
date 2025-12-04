import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/anunciante_model.dart';

/// Card interactiva para mostrar un anunciante/servicio (grúa, taller, etc.)
/// El usuario puede llamar directamente o ver más detalles
class AnuncianteCard extends StatelessWidget {
  final AnuncianteModel anunciante;
  final VoidCallback? onVerDetalles;
  final VoidCallback? onLlamar;
  final VoidCallback? onRechazar;

  const AnuncianteCard({
    super.key,
    required this.anunciante,
    this.onVerDetalles,
    this.onLlamar,
    this.onRechazar,
  });

  Future<void> _llamarTelefono() async {
    if (anunciante.telefono.isEmpty) return;
    
    final uri = Uri.parse('tel:${anunciante.telefono}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con icono de categoría y datos principales
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icono de categoría
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getCategoriaColor().withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      anunciante.iconoCategoria,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
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
                              anunciante.nombreComercial,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (anunciante.disponible24h)
                            Container(
                              margin: const EdgeInsets.only(left: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.access_time_filled,
                                    size: 12,
                                    color: Colors.blue.shade700,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '24 hrs',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Categoría y rating
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getCategoriaColor().withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              anunciante.categoriaServicio,
                              style: TextStyle(
                                fontSize: 11,
                                color: _getCategoriaColor(),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (anunciante.rating > 0) ...[
                            Text(
                              anunciante.ratingEstrellas,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${anunciante.rating.toStringAsFixed(1)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Dirección y teléfono
          if (anunciante.direccion.isNotEmpty || anunciante.telefono.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (anunciante.direccion.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            anunciante.direccion,
                            style: theme.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  if (anunciante.telefono.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          anunciante.telefono,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (anunciante.distanciaKm != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.directions_car_outlined,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${anunciante.distanciaKm!.toStringAsFixed(1)} km de distancia',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          
          // Descripción (si existe)
          if (anunciante.descripcion.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                anunciante.descripcion,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
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
                // Botón No interesado
                if (onRechazar != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onRechazar,
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('No, gracias'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade600,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                if (onRechazar != null) const SizedBox(width: 8),
                
                // Botón Ver detalles
                if (onVerDetalles != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onVerDetalles,
                      icon: const Icon(Icons.info_outline, size: 18),
                      label: const Text('Detalles'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        side: BorderSide(color: theme.colorScheme.primary),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                if (onVerDetalles != null && anunciante.telefono.isNotEmpty) 
                  const SizedBox(width: 8),
                
                // Botón Llamar
                if (anunciante.telefono.isNotEmpty)
                  Expanded(
                    flex: onRechazar != null ? 1 : 2,
                    child: ElevatedButton.icon(
                      onPressed: onLlamar ?? _llamarTelefono,
                      icon: const Icon(Icons.phone, size: 18),
                      label: const Text('Llamar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
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

  Color _getCategoriaColor() {
    switch (anunciante.categoriaServicio.toLowerCase()) {
      case 'grua':
      case 'grúa':
        return Colors.orange.shade700;
      case 'taller':
        return Colors.blue.shade700;
      case 'ajustador':
        return Colors.purple.shade700;
      case 'seguro':
      case 'aseguradora':
        return Colors.teal.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}

/// Lista de cards de anunciantes/servicios
class AnunciantesListView extends StatelessWidget {
  final List<AnuncianteModel> anunciantes;
  final Function(AnuncianteModel)? onVerDetalles;
  final Function(AnuncianteModel)? onLlamar;
  final Function(AnuncianteModel)? onRechazar;
  final String? titulo;

  const AnunciantesListView({
    super.key,
    required this.anunciantes,
    this.onVerDetalles,
    this.onLlamar,
    this.onRechazar,
    this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    if (anunciantes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (titulo != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 8),
            child: Row(
              children: [
                Icon(
                  Icons.local_shipping_outlined,
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
        ...anunciantes.map((a) => AnuncianteCard(
          anunciante: a,
          onVerDetalles: onVerDetalles != null ? () => onVerDetalles!(a) : null,
          onLlamar: onLlamar != null ? () => onLlamar!(a) : null,
          onRechazar: onRechazar != null ? () => onRechazar!(a) : null,
        )),
      ],
    );
  }
}
