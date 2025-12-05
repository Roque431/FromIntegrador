import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapWidget extends StatelessWidget {
  final MapController? mapController;
  final Position? currentPosition;
  final List<Marker> markers;
  final VoidCallback? onMapControllerReady;

  const MapWidget({
    super.key,
    required this.mapController,
    required this.currentPosition,
    required this.markers,
    this.onMapControllerReady,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: currentPosition != null
                    ? LatLng(currentPosition!.latitude, currentPosition!.longitude)
                    : const LatLng(16.7569, -93.1292),
                initialZoom: 13.0,
                maxZoom: 18.0,
                minZoom: 8.0,
                onMapReady: onMapControllerReady,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.flutter_application_1',
                ),
                MarkerLayer(
                  markers: markers,
                ),
              ],
            ),
            // Botones de zoom y ubicación
            Positioned(
              top: 16,
              right: 16,
              child: Column(
                children: [
                  _buildZoomButton(
                    context,
                    Icons.add,
                    'Acercar',
                    () => _zoomIn(),
                  ),
                  const SizedBox(height: 8),
                  _buildZoomButton(
                    context,
                    Icons.remove,
                    'Alejar',
                    () => _zoomOut(),
                  ),
                  const SizedBox(height: 8),
                  _buildZoomButton(
                    context,
                    Icons.my_location,
                    'Mi ubicación',
                    () => _centerOnUserLocation(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoomButton(BuildContext context, IconData icon, String tooltip, VoidCallback onPressed) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 20,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  void _zoomIn() {
    if (mapController != null) {
      final currentZoom = mapController!.camera.zoom;
      mapController!.move(mapController!.camera.center, currentZoom + 1);
    }
  }

  void _zoomOut() {
    if (mapController != null) {
      final currentZoom = mapController!.camera.zoom;
      mapController!.move(mapController!.camera.center, currentZoom - 1);
    }
  }

  void _centerOnUserLocation() {
    if (mapController != null && currentPosition != null) {
      mapController!.move(
        LatLng(currentPosition!.latitude, currentPosition!.longitude), 
        15.0
      );
    }
  }
}