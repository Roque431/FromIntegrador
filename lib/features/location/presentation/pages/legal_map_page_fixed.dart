// Este archivo temporalmente contiene el código que necesita incluirse en legal_map_page.dart
// Cambio 1: En _getCurrentLocation, después de setState con _currentPosition, agregar:

      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });

      // AGREGAR ESTA LÍNEA:
      _updateMapMarkers();

      if (_mapController != null) {
        _mapController!.move(
          LatLng(position.latitude, position.longitude),
          14.0,
        );
      }
