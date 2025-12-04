import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../data/datasources/location_datasource.dart';
import '../../data/models/location_models.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/widgets/responsive_widgets.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../login/presentation/providers/login_notifier.dart';

class LegalMapPage extends StatefulWidget {
  const LegalMapPage({super.key});

  @override
  State<LegalMapPage> createState() => _LegalMapPageState();
}

class _LegalMapPageState extends State<LegalMapPage> {
  final LocationDataSource _locationDataSource = di.sl<LocationDataSource>();
  
  MapController? _mapController;
  final List<Marker> _markers = [];
  
  Position? _currentPosition;
  List<LegalLocation> _nearbyLocations = [];
  AdvisoryResponse? _advisory;
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedState = 'Chiapas';
  double _selectedRadius = 10.0;
  String _currentView = 'map';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'El servicio de ubicación está deshabilitado.';
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Permiso de ubicación denegado';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Los permisos están permanentemente denegados.';
          _isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });

      if (_mapController != null) {
        _mapController!.move(
          LatLng(position.latitude, position.longitude),
          14.0,
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al obtener ubicación: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchNearbyLocations() async {
    if (_currentPosition == null) {
      LexiaAlert.warning(context, title: 'Espera', message: 'Obteniendo tu ubicación...');
      await _getCurrentLocation();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _advisory = null;
    });

    try {
      final response = await _locationDataSource.getNearbyLocations(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        radiusKm: _selectedRadius,
      );

      setState(() {
        _nearbyLocations = response.ubicaciones;
        _isLoading = false;
      });

      _updateMapMarkers();

      LexiaAlert.success(
        context,
        title: '¡Encontrado!',
        message: '${_nearbyLocations.length} ubicaciones cercanas',
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al buscar: $e';
        _isLoading = false;
      });
    }
  }

  void _updateMapMarkers() {
    _markers.clear();

    if (_currentPosition != null) {
      _markers.add(
        Marker(
          point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () => _showMyLocationDialog(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.my_location, color: Colors.white, size: 24),
            ),
          ),
        ),
      );
    }

    for (var location in _nearbyLocations) {
      _markers.add(
        Marker(
          point: LatLng(location.latitud, location.longitud),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () => _showLocationDetails(location),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.location_on, color: Colors.white, size: 24),
            ),
          ),
        ),
      );
    }

    setState(() {});
  }

  void _showMyLocationDialog() {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Tu ubicación', style: TextStyle(color: colorScheme.onSurface)),
        content: Text('Esta es tu ubicación actual', style: TextStyle(color: colorScheme.onSurfaceVariant)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showLocationDetails(LegalLocation location) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              location.nombre,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.category, 'Tipo: ${location.tipo}', colorScheme),
            if (location.distanciaKm != null)
              _buildDetailRow(Icons.straighten, 'Distancia: ${location.distanciaKm!.toStringAsFixed(2)} km', colorScheme),
            const SizedBox(height: 20),
            ResponsiveButton(
              text: 'Cerrar',
              isOutlined: true,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 15)),
        ],
      ),
    );
  }

  Future<void> _getAdvisory() async {
    final loginNotifier = context.read<LoginNotifier>();
    final userId = loginNotifier.currentUser?.id ?? 'demo-user-uuid';

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _nearbyLocations = [];
      _markers.clear();
    });

    try {
      final response = await _locationDataSource.getAdvisory(
        userId: userId,
        state: _selectedState,
      );

      setState(() {
        _advisory = response;
        _isLoading = false;
      });

      if (response.oficinas.isNotEmpty) {
        _updateAdvisoryMarkers(response.oficinas);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al obtener asesoría: $e';
        _isLoading = false;
      });
    }
  }

  void _updateAdvisoryMarkers(List<PublicOffice> offices) {
    _markers.clear();

    for (var office in offices) {
      if (office.latitud != null && office.longitud != null) {
        _markers.add(
          Marker(
            point: LatLng(office.latitud!, office.longitud!),
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () => _showOfficeDetails(office),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.account_balance, color: Colors.white, size: 22),
              ),
            ),
          ),
        );
      }
    }

    final firstOfficeWithCoords = offices.firstWhere(
      (o) => o.latitud != null && o.longitud != null,
      orElse: () => offices.first,
    );
    
    if (firstOfficeWithCoords.latitud != null && 
        firstOfficeWithCoords.longitud != null &&
        _mapController != null) {
      _mapController!.move(
        LatLng(firstOfficeWithCoords.latitud!, firstOfficeWithCoords.longitud!),
        12.0,
      );
    }

    setState(() {});
  }

  void _showOfficeDetails(PublicOffice office) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              office.nombre,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            if (office.direccion != null)
              _buildDetailRow(Icons.location_on, office.direccion!, colorScheme),
            if (office.telefono != null)
              _buildDetailRow(Icons.phone, office.telefono!, colorScheme),
            if (office.horario != null)
              _buildDetailRow(Icons.access_time, office.horario!, colorScheme),
            const SizedBox(height: 20),
            ResponsiveButton(
              text: 'Cerrar',
              isOutlined: true,
              onPressed: () => Navigator.pop(context),
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
    final size = MediaQuery.of(context).size;
    
    final isWide = size.width > 600;
    final cardPadding = isWide ? 20.0 : 16.0;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Mapa Legal',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _currentView == 'map' ? Icons.list : Icons.map,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            onPressed: () {
              setState(() {
                _currentView = _currentView == 'map' ? 'list' : 'map';
              });
            },
            tooltip: _currentView == 'map' ? 'Ver lista' : 'Ver mapa',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Panel de filtros
          Padding(
            padding: EdgeInsets.all(ResponsiveSize.horizontalPadding(context)),
            child: ResponsiveCard(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buscar oficinas legales',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Selector de estado
                  DropdownButtonFormField<String>(
                    value: _selectedState,
                    dropdownColor: colorScheme.surfaceContainerHighest,
                    style: TextStyle(color: colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: 'Estado',
                      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                      prefixIcon: Icon(Icons.location_city, color: colorScheme.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colorScheme.primary, width: 2),
                      ),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                    items: ['Chiapas', 'Ciudad de México', 'Jalisco', 'Nuevo León']
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e, style: TextStyle(color: colorScheme.onSurface)),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedState = value!),
                  ),
                  const SizedBox(height: 16),
                  
                  // Slider de radio
                  Row(
                    children: [
                      Icon(Icons.radar, color: colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text('Radio:', style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w500)),
                      Expanded(
                        child: Slider(
                          value: _selectedRadius,
                          min: 1,
                          max: 50,
                          divisions: 49,
                          label: '${_selectedRadius.toInt()} km',
                          activeColor: colorScheme.primary,
                          onChanged: (value) => setState(() => _selectedRadius = value),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_selectedRadius.toInt()} km',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Botones
                  Row(
                    children: [
                      Expanded(
                        child: ResponsiveButton(
                          text: 'Buscar cercanas',
                          icon: Icon(Icons.search, color: colorScheme.onPrimary, size: 20),
                          isLoading: _isLoading,
                          onPressed: _searchNearbyLocations,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ResponsiveButton(
                          text: 'Asesoría',
                          icon: Icon(Icons.help_outline, color: colorScheme.primary, size: 20),
                          isOutlined: true,
                          isLoading: _isLoading,
                          onPressed: _getAdvisory,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Contenido principal
          Expanded(child: _buildContent()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        backgroundColor: colorScheme.primary,
        child: Icon(Icons.my_location, color: colorScheme.onPrimary),
        tooltip: 'Mi ubicación',
      ),
    );
  }

  Widget _buildContent() {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colorScheme.primary),
            const SizedBox(height: 16),
            Text('Cargando...', style: TextStyle(color: colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: EdgeInsets.all(ResponsiveSize.horizontalPadding(context)),
        child: ResponsiveCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colorScheme.error.withValues(alpha: 0.7)),
              const SizedBox(height: 16),
              Text(
                'Error',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ResponsiveButton(
                text: 'Reintentar',
                onPressed: _getCurrentLocation,
              ),
            ],
          ),
        ),
      );
    }

    if (_currentView == 'map') {
      return _buildMapView();
    } else {
      return _buildListView();
    }
  }

  Widget _buildMapView() {
    final initialPosition = _currentPosition != null
        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
        : LatLng(19.4326, -99.1332);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: FlutterMap(
        mapController: _mapController ??= MapController(),
        options: MapOptions(
          initialCenter: initialPosition,
          initialZoom: 14.0,
          minZoom: 5.0,
          maxZoom: 18.0,
          onMapReady: () {
            if (_currentPosition != null) {
              _mapController?.move(
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                14.0,
              );
            }
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.flutter_application_1',
            maxZoom: 19,
          ),
          MarkerLayer(markers: _markers),
        ],
      ),
    );
  }

  Widget _buildListView() {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (_nearbyLocations.isNotEmpty) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.horizontalPadding(context)),
        itemCount: _nearbyLocations.length,
        itemBuilder: (context, index) {
          final location = _nearbyLocations[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ResponsiveCard(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  setState(() => _currentView = 'map');
                  _mapController?.move(LatLng(location.latitud, location.longitud), 16.0);
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
        },
      );
    }

    if (_advisory != null) {
      return _buildAdvisoryView();
    }

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
              child: Icon(Icons.map_outlined, size: 48, color: colorScheme.primary),
            ),
            const SizedBox(height: 20),
            Text(
              'Explora el mapa',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Usa los botones de arriba para buscar\nubicaciones legales cercanas',
              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvisoryView() {
    final colorScheme = Theme.of(context).colorScheme;
    final loginNotifier = context.read<LoginNotifier>();
    final isPro = loginNotifier.currentUser?.isPro ?? false;

    if (!isPro) {
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
                  color: Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_outline, size: 48, color: Colors.orange),
              ),
              const SizedBox(height: 20),
              Text(
                _advisory!.mensaje,
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
              ),
              const SizedBox(height: 24),
              ResponsiveButton(
                text: 'Actualizar a Pro',
                onPressed: () {},
              ),
            ],
          ),
        ),
      );
    }

    if (_advisory!.oficinas.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron oficinas para este estado',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.horizontalPadding(context)),
      itemCount: _advisory!.oficinas.length,
      itemBuilder: (context, index) {
        final office = _advisory!.oficinas[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ResponsiveCard(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: () {
                if (office.latitud != null && office.longitud != null) {
                  setState(() => _currentView = 'map');
                  _mapController?.move(LatLng(office.latitud!, office.longitud!), 16.0);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.account_balance, color: Colors.green),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          office.nombre,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (office.direccion != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '📍 ${office.direccion}',
                            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
                          ),
                        ],
                        if (office.telefono != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            '📞 ${office.telefono}',
                            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
                          ),
                        ],
                        if (office.horario != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            '🕐 ${office.horario}',
                            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
