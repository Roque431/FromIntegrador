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
import '../widgets/widgets.dart';

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
  TransitOfficesResponse? _transitOffices; // Nueva variable para oficinas de tránsito
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedState = 'Chiapas'; // Estado seleccionado para filtrar
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text, 
              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 15),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getAdvisory() async {
    final loginNotifier = context.read<LoginNotifier>();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _nearbyLocations = [];
      _markers.clear();
    });

    try {
      // Crear despachos jurídicos de Chiapas
      final despachosChiapas = _getDespachosJuridicosChiapas();
      
      final response = AdvisoryResponse(
        plan: loginNotifier.currentUser?.isPro == true ? 'pro' : 'basico',
        estado: 'Chiapas',
        tema: 'Despachos Jurídicos',
        mensaje: loginNotifier.currentUser?.isPro == true 
          ? 'Encuentra los mejores despachos jurídicos en Chiapas'
          : 'Actualiza a Pro para ver detalles completos de contacto',
        oficinas: despachosChiapas,
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
        _errorMessage = 'Error al obtener despachos jurídicos: $e';
        _isLoading = false;
      });
    }
  }

  List<PublicOffice> _getDespachosJuridicosChiapas() {
    return [
      PublicOffice(
        nombre: 'Bufete Jurídico García & Asociados',
        tipo: 'Despacho Jurídico',
        direccion: 'Av. Central Poniente No. 374, Col. Centro',
        ciudad: 'Tuxtla Gutiérrez',
        estado: 'Chiapas',
        telefono: '961 612 3456',
        horario: 'Lunes a Viernes: 8:00 - 18:00',
        latitud: 16.7516,
        longitud: -93.1161,
        esPublico: false,
      ),
      PublicOffice(
        nombre: 'Despacho Jurídico Morales',
        tipo: 'Despacho Jurídico',
        direccion: 'Calle 1ra Norte Poniente No. 285, Centro',
        ciudad: 'Tuxtla Gutiérrez',
        estado: 'Chiapas',
        telefono: '961 615 7890',
        horario: 'Lunes a Viernes: 9:00 - 17:00',
        latitud: 16.7540,
        longitud: -93.1140,
        esPublico: false,
      ),
      PublicOffice(
        nombre: 'Consultorio Jurídico López',
        tipo: 'Despacho Jurídico',
        direccion: 'Av. 14 Sur No. 145, Col. Xamaipak',
        ciudad: 'Tuxtla Gutiérrez',
        estado: 'Chiapas',
        telefono: '961 602 1234',
        horario: 'Lunes a Sábado: 8:30 - 19:00',
        latitud: 16.7300,
        longitud: -93.1050,
        esPublico: false,
      ),
      PublicOffice(
        nombre: 'Bufete Hernández & Partners',
        tipo: 'Despacho Jurídico',
        direccion: 'Blvd. Belisario Domínguez No. 2055, Plan de Ayala',
        ciudad: 'Tuxtla Gutiérrez',
        estado: 'Chiapas',
        telefono: '961 618 5678',
        horario: 'Lunes a Viernes: 8:00 - 17:30',
        latitud: 16.7450,
        longitud: -93.0980,
        esPublico: false,
      ),
      PublicOffice(
        nombre: 'Despacho Jurídico Ruiz Cortines',
        tipo: 'Despacho Jurídico',
        direccion: 'Av. Insurgentes No. 890, Col. Revolución Mexicana',
        ciudad: 'Tuxtla Gutiérrez',
        estado: 'Chiapas',
        telefono: '961 611 9876',
        horario: 'Lunes a Viernes: 9:00 - 18:00',
        latitud: 16.7380,
        longitud: -93.1200,
        esPublico: false,
      ),
      PublicOffice(
        nombre: 'Abogados Asociados San Cristóbal',
        tipo: 'Despacho Jurídico',
        direccion: 'Calle Real de Guadalupe No. 34, Centro Histórico',
        ciudad: 'San Cristóbal de Las Casas',
        estado: 'Chiapas',
        telefono: '967 678 1234',
        horario: 'Lunes a Viernes: 8:00 - 16:00',
        latitud: 16.7370,
        longitud: -92.6376,
        esPublico: false,
      ),
      PublicOffice(
        nombre: 'Bufete Jurídico Colonial',
        tipo: 'Despacho Jurídico',
        direccion: 'Av. 16 de Septiembre No. 12, Centro',
        ciudad: 'San Cristóbal de Las Casas',
        estado: 'Chiapas',
        telefono: '967 678 5678',
        horario: 'Lunes a Sábado: 9:00 - 17:00',
        latitud: 16.7360,
        longitud: -92.6390,
        esPublico: false,
      ),
      PublicOffice(
        nombre: 'Despacho Martínez & Asociados',
        tipo: 'Despacho Jurídico',
        direccion: 'Calle 1ra de Mayo No. 567, Col. Francisco Sarabia',
        ciudad: 'Tapachula',
        estado: 'Chiapas',
        telefono: '962 625 3456',
        horario: 'Lunes a Viernes: 8:30 - 18:30',
        latitud: 14.9067,
        longitud: -92.2681,
        esPublico: false,
      ),
      PublicOffice(
        nombre: 'Consultorio Jurídico Frontera Sur',
        tipo: 'Despacho Jurídico',
        direccion: 'Av. Hidalgo No. 234, Centro',
        ciudad: 'Tapachula',
        estado: 'Chiapas',
        telefono: '962 626 7890',
        horario: 'Lunes a Viernes: 9:00 - 17:00, Sábados: 9:00 - 13:00',
        latitud: 14.9080,
        longitud: -92.2650,
        esPublico: false,
      ),
      PublicOffice(
        nombre: 'Bufete Jurídico Palenque',
        tipo: 'Despacho Jurídico',
        direccion: 'Av. Juárez No. 89, Centro',
        ciudad: 'Palenque',
        estado: 'Chiapas',
        telefono: '916 345 1234',
        horario: 'Lunes a Viernes: 8:00 - 17:00',
        latitud: 17.5089,
        longitud: -91.9820,
        esPublico: false,
      ),
    ];
  }

  // Nuevo método para buscar oficinas de tránsito
  Future<void> _getTransitOffices() async {
    if (_currentPosition == null) {
      LexiaAlert.warning(context, title: 'Espera', message: 'Obteniendo tu ubicación...');
      await _getCurrentLocation();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _nearbyLocations = [];
      _advisory = null; // Limpiar asesoría previa
      _markers.clear();
    });

    try {
      final response = await _locationDataSource.getTransitOffices(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        city: 'Tuxtla Gutiérrez',
        state: 'Chiapas',
      );

      setState(() {
        _transitOffices = response;
        _isLoading = false;
      });

      if (response.oficinas.isNotEmpty) {
        _updateTransitOfficesMarkers(response.oficinas);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al obtener oficinas de tránsito: $e';
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

  // Método para actualizar marcadores de oficinas de tránsito
  void _updateTransitOfficesMarkers(List<TransitOffice> offices) {
    _markers.clear();

    for (var office in offices) {
      _markers.add(
        Marker(
          point: LatLng(office.latitud, office.longitud),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () => _showTransitOfficeDetails(office),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.traffic, color: Colors.white, size: 22),
            ),
          ),
        ),
      );
    }

    // Si existe ubicación actual, agregar marcador del usuario
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

    // Centrar mapa en la primera oficina
    if (offices.isNotEmpty && _mapController != null) {
      _mapController!.move(
        LatLng(offices.first.latitud, offices.first.longitud),
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

  // Método para mostrar detalles de oficinas de tránsito
  void _showTransitOfficeDetails(TransitOffice office) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => TransitOfficeDetailsDialog(office: office),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
          // Panel de búsqueda
          Padding(
            padding: EdgeInsets.all(ResponsiveSize.horizontalPadding(context)),
            child: SearchButtonsWidget(
              isLoading: _isLoading,
              onSearchNearby: _searchNearbyLocations,
              onGetAdvisory: _getAdvisory,
              onGetTransitOffices: _getTransitOffices,
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
    return MapWidget(
      mapController: _mapController ??= MapController(),
      currentPosition: _currentPosition,
      markers: _markers,
    );
  }

  Widget _buildListView() {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Si hay oficinas de tránsito, mostrar esas
    if (_transitOffices != null && _transitOffices!.oficinas.isNotEmpty) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.horizontalPadding(context)),
        itemCount: _transitOffices!.oficinas.length,
        itemBuilder: (context, index) {
          final office = _transitOffices!.oficinas[index];
          return TransitOfficeCard(
            office: office,
            onTap: () => _showTransitOfficeDetails(office),
          );
        },
      );
    }
    
    // Si hay ubicaciones legales normales, mostrar esas
    if (_nearbyLocations.isNotEmpty) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.horizontalPadding(context)),
        itemCount: _nearbyLocations.length,
        itemBuilder: (context, index) {
          final location = _nearbyLocations[index];
          return LegalLocationCard(
            location: location,
            mapController: _mapController,
            onViewChange: () => setState(() => _currentView = 'map'),
          );
        },
      );
    }

    if (_advisory != null) {
      return AdvisoryViewWidget(
        advisory: _advisory!,
        mapController: _mapController,
        onViewChange: () => setState(() => _currentView = 'map'),
      );
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
}