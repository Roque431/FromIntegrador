import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../data/datasources/location_datasource.dart';
import '../../data/models/location_models.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../login/presentation/providers/login_notifier.dart';

class LegalMapPage extends StatefulWidget {
  const LegalMapPage({super.key});

  @override
  State<LegalMapPage> createState() => _LegalMapPageState();
}

class _LegalMapPageState extends State<LegalMapPage> {
  final LocationDataSource _locationDataSource = di.sl<LocationDataSource>();
  
  // Flutter Map (OpenStreetMap)
  MapController? _mapController; // Nullable hasta que se renderice
  final List<Marker> _markers = [];
  
  Position? _currentPosition;
  List<LegalLocation> _nearbyLocations = [];
  AdvisoryResponse? _advisory;
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedState = 'Chiapas';
  double _selectedRadius = 10.0;
  
  // Vista actual: 'map' o 'list'
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
      // Verificar si el servicio de ubicación está habilitado
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'El servicio de ubicación está deshabilitado. Por favor, actívalo.';
          _isLoading = false;
        });
        return;
      }

      // Verificar permisos
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
          _errorMessage = 'Los permisos de ubicación están permanentemente denegados. Por favor, habilítalos en la configuración.';
          _isLoading = false;
        });
        return;
      }

      // Obtener la ubicación actual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });

      // Mover la cámara a la ubicación actual (solo si el mapa ya está renderizado)
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Obteniendo tu ubicación...')),
      );
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

      // Crear marcadores en el mapa
      _updateMapMarkers();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_nearbyLocations.length} ubicaciones encontradas')),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al buscar ubicaciones: $e';
        _isLoading = false;
      });
    }
  }

  void _updateMapMarkers() {
    _markers.clear();

    // Marcador de ubicación actual
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Tu ubicación'),
                  content: const Text('Esta es tu ubicación actual'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
              );
            },
            child: const Icon(
              Icons.my_location,
              color: Colors.blue,
              size: 40,
            ),
          ),
        ),
      );
    }

    // Marcadores de ubicaciones legales
    for (var location in _nearbyLocations) {
      _markers.add(
        Marker(
          point: LatLng(location.latitud, location.longitud),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () => _showLocationDetails(location),
            child: const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40,
            ),
          ),
        ),
      );
    }

    setState(() {});
  }

  void _showLocationDetails(LegalLocation location) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location.nombre,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Tipo: ${location.tipo}'),
            if (location.distanciaKm != null)
              Text('Distancia: ${location.distanciaKm!.toStringAsFixed(2)} km'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
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

      // Si hay oficinas públicas, mostrarlas en el mapa
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
              child: const Icon(
                Icons.account_balance,
                color: Colors.green,
                size: 40,
              ),
            ),
          ),
        );
      }
    }

    // Centrar el mapa en el primer marcador
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
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              office.nombre,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (office.direccion != null) ...[
              const Icon(Icons.location_on, size: 16),
              const SizedBox(width: 4),
              Text(office.direccion!),
              const SizedBox(height: 8),
            ],
            if (office.telefono != null) ...[
              const Icon(Icons.phone, size: 16),
              const SizedBox(width: 4),
              Text(office.telefono!),
              const SizedBox(height: 8),
            ],
            if (office.horario != null) ...[
              const Icon(Icons.access_time, size: 16),
              const SizedBox(width: 4),
              Text(office.horario!),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Legal'),
        actions: [
          IconButton(
            icon: Icon(_currentView == 'map' ? Icons.list : Icons.map),
            onPressed: () {
              setState(() {
                _currentView = _currentView == 'map' ? 'list' : 'map';
              });
            },
            tooltip: _currentView == 'map' ? 'Ver lista' : 'Ver mapa',
          ),
        ],
      ),
      body: Column(
        children: [
          // Panel de filtros
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Selector de estado
                DropdownButtonFormField<String>(
                  value: _selectedState,
                  decoration: const InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Chiapas', child: Text('Chiapas')),
                    DropdownMenuItem(value: 'Ciudad de México', child: Text('Ciudad de México')),
                    DropdownMenuItem(value: 'Jalisco', child: Text('Jalisco')),
                    DropdownMenuItem(value: 'Nuevo León', child: Text('Nuevo León')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedState = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Slider de radio
                Row(
                  children: [
                    const Text('Radio:'),
                    Expanded(
                      child: Slider(
                        value: _selectedRadius,
                        min: 1,
                        max: 50,
                        divisions: 49,
                        label: '${_selectedRadius.toInt()} km',
                        onChanged: (value) {
                          setState(() {
                            _selectedRadius = value;
                          });
                        },
                      ),
                    ),
                    Text('${_selectedRadius.toInt()} km'),
                  ],
                ),
                const SizedBox(height: 16),
                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _searchNearbyLocations,
                        icon: const Icon(Icons.search),
                        label: const Text('Cercanas'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _getAdvisory,
                        icon: const Icon(Icons.help_outline),
                        label: const Text('Asesoría'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Contenido principal
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
        tooltip: 'Mi ubicación',
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text('Reintentar'),
            ),
          ],
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
        : LatLng(19.4326, -99.1332); // Ciudad de México por defecto

    return FlutterMap(
      mapController: _mapController ??= MapController(), // Inicializar aquí
      options: MapOptions(
        initialCenter: initialPosition,
        initialZoom: 14.0,
        minZoom: 5.0,
        maxZoom: 18.0,
        onMapReady: () {
          // Callback cuando el mapa está listo
          print('🗺️ Mapa renderizado y listo');
          // Si tenemos ubicación, centrar
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
        MarkerLayer(
          markers: _markers,
        ),
      ],
    );
  }

  Widget _buildListView() {
    if (_nearbyLocations.isNotEmpty) {
      return ListView.builder(
        itemCount: _nearbyLocations.length,
        itemBuilder: (context, index) {
          final location = _nearbyLocations[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.location_on, color: Colors.red),
              title: Text(location.nombre),
              subtitle: Text('${location.tipo} - ${location.distanciaKm?.toStringAsFixed(1)} km'),
              onTap: () {
                // Cambiar a vista de mapa y centrar en esta ubicación
                setState(() {
                  _currentView = 'map';
                });
                if (_mapController != null) {
                  _mapController!.move(
                    LatLng(location.latitud, location.longitud),
                    16.0,
                  );
                }
              },
            ),
          );
        },
      );
    }

    if (_advisory != null) {
      return _buildAdvisoryView();
    }

    return const Center(
      child: Text('Usa los botones de arriba para buscar ubicaciones o solicitar asesoría'),
    );
  }

  Widget _buildAdvisoryView() {
    final loginNotifier = context.read<LoginNotifier>();
    final isPro = loginNotifier.currentUser?.isPro ?? false;

    if (!isPro) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: Colors.orange),
              const SizedBox(height: 16),
              Text(
                _advisory!.mensaje,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Navegar a página de suscripción
                },
                child: const Text('Actualizar a Pro'),
              ),
            ],
          ),
        ),
      );
    }

    if (_advisory!.oficinas.isEmpty) {
      return const Center(
        child: Text('No se encontraron oficinas públicas para este estado'),
      );
    }

    return ListView.builder(
      itemCount: _advisory!.oficinas.length,
      itemBuilder: (context, index) {
        final office = _advisory!.oficinas[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.account_balance, color: Colors.green),
            title: Text(office.nombre),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (office.direccion != null) Text('📍 ${office.direccion}'),
                if (office.telefono != null) Text('📞 ${office.telefono}'),
                if (office.horario != null) Text('🕐 ${office.horario}'),
              ],
            ),
            onTap: () {
              // Cambiar a vista de mapa y centrar en esta oficina
              if (office.latitud != null && office.longitud != null) {
                setState(() {
                  _currentView = 'map';
                });
                if (_mapController != null) {
                  _mapController!.move(
                    LatLng(office.latitud!, office.longitud!),
                    16.0,
                  );
                }
              }
            },
          ),
        );
      },
    );
  }
}
