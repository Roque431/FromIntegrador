import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../data/models/location_models.dart';
import '../../../../../core/widgets/responsive_widgets.dart';

class LegalLocationCard extends StatelessWidget {
  final LegalLocation location;
  final MapController? mapController;
  final VoidCallback onViewChange;

  const LegalLocationCard({
    super.key,
    required this.location,
    required this.mapController,
    required this.onViewChange,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ResponsiveCard(
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: () {
            onViewChange();
            mapController?.move(LatLng(location.latitud, location.longitud), 16.0);
          },
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.location_on, color: colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.nombre,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${location.tipo} • ${location.distanciaKm?.toStringAsFixed(1)} km',
                      style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}