import 'dart:math' as math;
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/location_models.dart';

abstract class LocationDataSource {
  Future<NearbyLocationsResponse> getNearbyLocations({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
    String? type,
    int limit = 10,
  });

  Future<AdvisoryResponse> getAdvisory({
    required String userId,
    String state = 'Chiapas',
    String? topic,
  });

  // Nuevo método para obtener oficinas de tránsito
  Future<TransitOfficesResponse> getTransitOffices({
    required double latitude,
    required double longitude,
    String city = 'Tuxtla Gutiérrez',
    String state = 'Chiapas',
  });
}

class LocationDataSourceImpl implements LocationDataSource {
  final ApiClient apiClient;

  LocationDataSourceImpl({required this.apiClient});

  @override
  Future<NearbyLocationsResponse> getNearbyLocations({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
    String? type,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, String>{
        'latitud': latitude.toString(),
        'longitud': longitude.toString(),
        'distancia_km': radiusKm.toString(),
        'limit': limit.toString(),
      };

      if (type != null) {
        queryParams['tipo'] = type;
      }

      final response = await apiClient.get(
        ApiEndpoints.nearbyLocations,
        queryParameters: queryParams,
        requiresAuth: true,
      );

      return NearbyLocationsResponse.fromJson(response);
    } catch (e) {
      throw ApiException('Error al obtener ubicaciones cercanas: $e');
    }
  }

  @override
  Future<AdvisoryResponse> getAdvisory({
    required String userId,
    String state = 'Chiapas',
    String? topic,
  }) async {
    try {
      final queryParams = <String, String>{
        'usuario_id': userId,
        'estado': state,
      };

      if (topic != null) {
        queryParams['tema'] = topic;
      }

      final response = await apiClient.get(
        ApiEndpoints.advisory,
        queryParameters: queryParams,
        requiresAuth: true,
      );

      return AdvisoryResponse.fromJson(response);
    } catch (e) {
      throw ApiException('Error al obtener asesoría: $e');
    }
  }

  @override
  Future<TransitOfficesResponse> getTransitOffices({
    required double latitude,
    required double longitude,
    String city = 'Tuxtla Gutiérrez',
    String state = 'Chiapas',
  }) async {
    // Simulando datos reales de oficinas de tránsito en Tuxtla Gutiérrez
    await Future.delayed(const Duration(milliseconds: 800));

    // Datos de oficinas de tránsito en todo Chiapas
    final oficinasData = [
      // ===================== TUXTLA GUTIÉRREZ =====================
      {
        'id': 'smyt-chiapas-001',
        'nombre': 'Secretaría de Movilidad y Transporte de Chiapas',
        'tipo': 'smyt',
        'descripcion': 'Dependencia estatal encargada de licencias de conducir, concesiones de transporte público y regulación del transporte en Chiapas.',
        'direccion': '2da Avenida Sur Poniente No. 1391, Colonia Centro, Tuxtla Gutiérrez, Chiapas',
        'telefono': '961 617 1570',
        'email': 'smyt@chiapas.gob.mx',
        'sitio_web': 'https://smyt.chiapas.gob.mx',
        'redes_sociales': 'Facebook: /SMyTChiapas',
        'horario_atencion': 'Lunes a Viernes de 8:00 AM a 4:00 PM',
        'imagen_url': 'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSxdTXavggTR3UzMA6unM8bUgHJ7D6XZXtPoPNiqEiqxpRZm6B8zwfl07AwiuUWpv5bELLJxaMLWR3uc6UX3qsHVjihPcD_BprOe1dB_zyX0IP1YjIifeJbf84GuWlatJ2T50XDS=w600-h400-k-no',
        'latitud': 16.7569,
        'longitud': -93.1292,
        'servicios_ofrecidos': ['licenciasEstatales', 'concesionesTransporte', 'consultasDudas'],
        'atiende_sabados': false,
        'tiene_linea_denuncia': true,
        'numero_linea_denuncia': '961 617 1580',
        'procedimiento_atencion': 'Requiere cita previa para licencias. Documentos necesarios: INE, CURP, RFC, comprobante de domicilio.'
      },
      {
        'id': 'transito-municipal-tuxtla',
        'nombre': 'Dirección de Tránsito Municipal Tuxtla',
        'tipo': 'transitoMunicipal',
        'descripcion': 'Oficina municipal encargada de infracciones, reglamento de tránsito local, recursos contra multas y atención ciudadana.',
        'direccion': 'Boulevard Andrés Serra Rojas No. 1090, Colonia Maya, Tuxtla Gutiérrez, Chiapas',
        'telefono': '961 617 7000 ext. 1234',
        'email': 'transito@tuxtla.gob.mx',
        'sitio_web': 'https://tuxtla.gob.mx/transito',
        'redes_sociales': 'Facebook: /TransitoTuxtla',
        'horario_atencion': 'Lunes a Viernes de 8:00 AM a 3:00 PM',
        'imagen_url': 'https://via.placeholder.com/600x400/16a34a/ffffff?text=TRANSITO+MUNICIPAL+•+Blvd+Serra+Rojas',
        'latitud': 16.7506,
        'longitud': -93.1161,
        'servicios_ofrecidos': ['infraccionesTraficas', 'reglamentoLocal', 'recursosMultas', 'consultasDudas'],
        'atiende_sabados': false,
        'tiene_linea_denuncia': true,
        'numero_linea_denuncia': '911',
        'procedimiento_atencion': 'Para recursos contra multas presentar escrito con copia de infracción y identificación oficial.'
      },

      // ===================== SAN CRISTÓBAL DE LAS CASAS =====================
      {
        'id': 'transito-sancristobal-001',
        'nombre': 'Dirección de Tránsito Municipal San Cristóbal',
        'tipo': 'transitoMunicipal',
        'descripcion': 'Oficina municipal de tránsito para San Cristóbal de las Casas.',
        'direccion': 'Avenida Insurgentes No. 43, Centro, San Cristóbal de las Casas, Chiapas',
        'telefono': '967 678 0554',
        'email': 'transito@sancristobal.gob.mx',
        'sitio_web': 'https://sancristobal.gob.mx',
        'horario_atencion': 'Lunes a Viernes de 8:00 AM a 4:00 PM, Sábados de 9:00 AM a 1:00 PM',
        'imagen_url': 'https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=CAoSLEFGMVFpcE4xTGprWlhsbW1oUXNqUVJqZGFGX2hHN3RGWGJxOUZBNnJhMGE&cb_client=search.gws-prod.gps&w=600&h=400&yaw=0&pitch=0&thumbfov=100',
        'latitud': 16.7370,
        'longitud': -92.6376,
        'servicios_ofrecidos': ['infraccionesTraficas', 'licenciaConducir', 'recursosMultas', 'consultasDudas'],
        'atiende_sabados': true,
        'tiene_linea_denuncia': true,
        'numero_linea_denuncia': '967 678 0555',
        'procedimiento_atencion': 'Atención presencial para infracciones y licencias municipales.'
      },
      {
        'id': 'smyt-sancristobal-001',
        'nombre': 'SMYT Delegación San Cristóbal',
        'tipo': 'smyt',
        'descripcion': 'Delegación estatal para licencias de conducir y servicios de transporte.',
        'direccion': 'Carretera Panamericana Km 1156, San Cristóbal de las Casas, Chiapas',
        'telefono': '967 678 2100',
        'email': 'sancristobal@smyt.chiapas.gob.mx',
        'horario_atencion': 'Lunes a Viernes de 8:00 AM a 3:00 PM',
        'latitud': 16.7250,
        'longitud': -92.6580,
        'servicios_ofrecidos': ['licenciasEstatales', 'consultasDudas'],
        'atiende_sabados': false,
        'tiene_linea_denuncia': false,
      },

      // ===================== TAPACHULA =====================
      {
        'id': 'transito-tapachula-001',
        'nombre': 'Dirección de Tránsito Municipal Tapachula',
        'tipo': 'transitoMunicipal',
        'descripcion': 'Oficina municipal de tránsito de Tapachula.',
        'direccion': 'Avenida 8a Norte No. 15, Centro, Tapachula, Chiapas',
        'telefono': '962 626 2940',
        'email': 'transito@tapachula.gob.mx',
        'horario_atencion': 'Lunes a Viernes de 8:00 AM a 4:00 PM',
        'imagen_url': 'https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=CAoSLEFGMVFpcE1MdVRiM3ZIWTdZaWJiUFhpVFJVQmVkM0hDSGpnLWRKbkdTUjc&cb_client=search.gws-prod.gps&w=600&h=400&yaw=90&pitch=0&thumbfov=100',
        'latitud': 14.9067,
        'longitud': -92.2676,
        'servicios_ofrecidos': ['infraccionesTraficas', 'licenciaConducir', 'recursosMultas'],
        'atiende_sabados': false,
        'tiene_linea_denuncia': true,
        'numero_linea_denuncia': '962 626 2941',
      },
      {
        'id': 'smyt-tapachula-001',
        'nombre': 'SMYT Delegación Tapachula',
        'tipo': 'smyt',
        'descripcion': 'Delegación estatal especializada en zona fronteriza.',
        'direccion': 'Carretera Internacional Km 252, Tapachula, Chiapas',
        'telefono': '962 626 3050',
        'email': 'tapachula@smyt.chiapas.gob.mx',
        'horario_atencion': 'Lunes a Sábado de 7:00 AM a 5:00 PM',
        'latitud': 14.8950,
        'longitud': -92.2850,
        'servicios_ofrecidos': ['licenciasEstatales', 'concesionesTransporte', 'serviciosEspeciales'],
        'atiende_sabados': true,
        'tiene_linea_denuncia': false,
      },

      // ===================== COMITÁN DE DOMÍNGUEZ =====================
      {
        'id': 'transito-comitan-001',
        'nombre': 'Tránsito Municipal Comitán',
        'tipo': 'transitoMunicipal',
        'descripcion': 'Oficina de tránsito municipal de Comitán de Domínguez.',
        'direccion': 'Avenida Central Sur No. 10, Centro, Comitán de Domínguez, Chiapas',
        'telefono': '963 632 0180',
        'email': 'transito@comitan.gob.mx',
        'horario_atencion': 'Lunes a Viernes de 8:00 AM a 3:00 PM',
        'imagen_url': 'https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=CAoSLEFGMVFpcE5lWUxKVGI3akF2Q1Vhc3JKeE9TWkZuT2VnLWpEUk10eFo2NXM&cb_client=search.gws-prod.gps&w=600&h=400&yaw=0&pitch=0&thumbfov=100',
        'latitud': 16.2472,
        'longitud': -92.1347,
        'servicios_ofrecidos': ['infraccionesTraficas', 'licenciaConducir', 'recursosMultas'],
        'atiende_sabados': false,
        'tiene_linea_denuncia': true,
        'numero_linea_denuncia': '963 632 0181',
      },

      // ===================== PALENQUE =====================
      {
        'id': 'transito-palenque-001',
        'nombre': 'Tránsito Municipal Palenque',
        'tipo': 'transitoMunicipal',
        'descripcion': 'Oficina de tránsito municipal de Palenque.',
        'direccion': 'Avenida Juárez No. 123, Centro, Palenque, Chiapas',
        'telefono': '916 345 0234',
        'email': 'transito@palenque.gob.mx',
        'horario_atencion': 'Lunes a Viernes de 8:00 AM a 3:00 PM',
        'imagen_url': 'https://via.placeholder.com/600x400/ea580c/ffffff?text=TRANSITO+PALENQUE+•+Calle+Juarez',
        'latitud': 17.5089,
        'longitud': -91.9821,
        'servicios_ofrecidos': ['infraccionesTraficas', 'licenciaConducir', 'consultasDudas'],
        'atiende_sabados': false,
        'tiene_linea_denuncia': true,
        'numero_linea_denuncia': '916 345 0235',
      },

      // ===================== CHIAPA DE CORZO =====================
      {
        'id': 'transito-chiapadecorzo-001',
        'nombre': 'Tránsito Municipal Chiapa de Corzo',
        'tipo': 'transitoMunicipal',
        'descripcion': 'Oficina de tránsito municipal de Chiapa de Corzo.',
        'direccion': 'Plaza Central 5 de Febrero, Centro, Chiapa de Corzo, Chiapas',
        'telefono': '961 616 0045',
        'email': 'transito@chiapadecorzo.gob.mx',
        'horario_atencion': 'Lunes a Viernes de 8:00 AM a 2:00 PM',
        'imagen_url': 'https://images.unsplash.com/photo-1503387837-b154d5074bd2?w=400&h=200&fit=crop&crop=faces',
        'latitud': 16.9019,
        'longitud': -93.0134,
        'servicios_ofrecidos': ['infraccionesTraficas', 'licenciaConducir', 'recursosMultas'],
        'atiende_sabados': false,
        'tiene_linea_denuncia': true,
        'numero_linea_denuncia': '961 616 0046',
      },

      // ===================== OCOSINGO =====================
      {
        'id': 'transito-ocosingo-001',
        'nombre': 'Tránsito Municipal Ocosingo',
        'tipo': 'transitoMunicipal',
        'descripcion': 'Oficina de tránsito municipal de Ocosingo.',
        'direccion': 'Calle Central Norte No. 45, Centro, Ocosingo, Chiapas',
        'telefono': '919 673 0123',
        'email': 'transito@ocosingo.gob.mx',
        'horario_atencion': 'Lunes a Viernes de 8:00 AM a 3:00 PM',
        'imagen_url': 'https://images.unsplash.com/photo-1503387837-b154d5074bd2?w=400&h=200&fit=crop&crop=faces',
        'latitud': 16.9030,
        'longitud': -92.1035,
        'servicios_ofrecidos': ['infraccionesTraficas', 'licenciaConducir', 'recursosMultas'],
        'atiende_sabados': false,
        'tiene_linea_denuncia': true,
        'numero_linea_denuncia': '919 673 0124',
      },

      // ===================== ARRIAGA =====================
      {
        'id': 'transito-arriaga-001',
        'nombre': 'Tránsito Municipal Arriaga',
        'tipo': 'transitoMunicipal',
        'descripcion': 'Oficina de tránsito municipal de Arriaga.',
        'direccion': 'Avenida Central No. 78, Centro, Arriaga, Chiapas',
        'telefono': '966 663 0090',
        'email': 'transito@arriaga.gob.mx',
        'horario_atencion': 'Lunes a Viernes de 8:00 AM a 3:00 PM',
        'imagen_url': 'https://via.placeholder.com/600x400/be123c/ffffff?text=TRANSITO+ARRIAGA+•+Av+Central',
        'latitud': 16.2339,
        'longitud': -93.9058,
        'servicios_ofrecidos': ['infraccionesTraficas', 'licenciaConducir', 'recursosMultas'],
        'atiende_sabados': false,
        'tiene_linea_denuncia': true,
        'numero_linea_denuncia': '966 663 0091',
      },

      // ===================== PIJIJIAPAN =====================
      {
        'id': 'transito-pijijiapan-001',
        'nombre': 'Tránsito Municipal Pijijiapan',
        'tipo': 'transitoMunicipal',
        'descripcion': 'Oficina de tránsito municipal de Pijijiapan.',
        'direccion': 'Calle 5 de Mayo No. 25, Centro, Pijijiapan, Chiapas',
        'telefono': '994 632 0078',
        'email': 'transito@pijijiapan.gob.mx',
        'horario_atencion': 'Lunes a Viernes de 8:00 AM a 3:00 PM',
        'imagen_url': 'https://via.placeholder.com/600x400/9333ea/ffffff?text=TRANSITO+PIJIJIAPAN+•+Calle+5+Mayo',
        'latitud': 15.6851,
        'longitud': -93.2095,
        'servicios_ofrecidos': ['infraccionesTraficas', 'licenciaConducir', 'recursosMultas'],
        'atiende_sabados': false,
        'tiene_linea_denuncia': true,
        'numero_linea_denuncia': '994 632 0079',
      },

      // ===================== VILLAFLORES =====================
      {
        'id': 'transito-villaflores-001',
        'nombre': 'Tránsito Municipal Villaflores',
        'tipo': 'transitoMunicipal',
        'descripcion': 'Oficina de tránsito municipal de Villaflores.',
        'direccion': 'Avenida Central No. 34, Centro, Villaflores, Chiapas',
        'telefono': '965 651 0067',
        'email': 'transito@villaflores.gob.mx',
        'horario_atencion': 'Lunes a Viernes de 8:00 AM a 3:00 PM',
        'imagen_url': 'https://via.placeholder.com/600x400/0d9488/ffffff?text=TRANSITO+VILLAFLORES+•+Av+Central',
        'latitud': 16.1939,
        'longitud': -93.2751,
        'servicios_ofrecidos': ['infraccionesTraficas', 'licenciaConducir', 'recursosMultas'],
        'atiende_sabados': false,
        'tiene_linea_denuncia': true,
        'numero_linea_denuncia': '965 651 0068',
      },

      // ===================== OFICINAS ESPECIALES DE TUXTLA =====================
      {
        'id': 'seguridad-publica-tuxtla',
        'nombre': 'Secretaría de Seguridad Pública Municipal',
        'tipo': 'seguridadPublica',
        'descripcion': 'Dependencia municipal encargada de la seguridad pública y coordinación con tránsito municipal.',
        'direccion': 'Boulevard Belisario Domínguez No. 1081, Colonia Moctezuma, Tuxtla Gutiérrez, Chiapas',
        'telefono': '961 617 7001',
        'email': 'seguridad@tuxtla.gob.mx',
        'sitio_web': 'https://tuxtla.gob.mx/seguridad',
        'redes_sociales': 'Facebook: /SeguridadTuxtla',
        'horario_atencion': 'Lunes a Domingo 24 horas',
        'imagen_url': 'https://via.placeholder.com/600x400/991b1b/ffffff?text=SEGURIDAD+PUBLICA+•+Blvd+Dominguez',
        'latitud': 16.7611,
        'longitud': -93.1147,
        'servicios_ofrecidos': ['denunciasCiudadanas', 'consultasDudas', 'infraccionesTraficas'],
        'atiende_sabados': true,
        'tiene_linea_denuncia': true,
        'numero_linea_denuncia': '911',
        'procedimiento_atencion': 'Atención 24/7 para emergencias. Denuncias anónimas disponibles.'
      },
      {
        'id': 'oficina-licencias-tuxtla',
        'nombre': 'Oficina de Expedición de Licencias SMYT',
        'tipo': 'oficinaLicencias',
        'descripcion': 'Oficina especializada en trámites de licencias de conducir estatales y renovaciones.',
        'direccion': 'Libramiento Norte Poniente No. 2718, Fraccionamiento Las Palmas, Tuxtla Gutiérrez, Chiapas',
        'telefono': '961 617 1575',
        'email': 'licencias@smyt.chiapas.gob.mx',
        'horario_atencion': 'Lunes a Viernes de 7:30 AM a 3:30 PM',
        'imagen_url': 'https://lh3.googleusercontent.com/gps-cs-s/AG0ilSzSU1NhshT6unOWBQSqpl_uX-cLmPhwsF_RkfiT1NmJxoCZuw0Lhg_SUKsEDUaeMnZh-uhddVXc2qlevvFqnJm6dFmYrXhtw4NnRw8O7KUyTKbzqh6M7TD6nxFL55reTi6pV-k-iuP8Ok-_=w600-h400-k-no',
        'latitud': 16.7389,
        'longitud': -93.1542,
        'servicios_ofrecidos': ['licenciasEstatales', 'consultasDudas'],
        'atiende_sabados': false,
        'tiene_linea_denuncia': false,
        'procedimiento_atencion': 'Cita previa obligatoria. Sistema en línea disponible en smyt.chiapas.gob.mx'
      },
    ];

    // Calcular distancias desde la ubicación del usuario
    final oficinasConDistancia = oficinasData.map((oficina) {
      final distancia = _calcularDistancia(
        latitude,
        longitude,
        oficina['latitud'] as double,
        oficina['longitud'] as double,
      );
      
      final oficinaConDistancia = Map<String, dynamic>.from(oficina);
      oficinaConDistancia['distancia_km'] = distancia;
      return oficinaConDistancia;
    }).toList();

    // Ordenar por distancia
    oficinasConDistancia.sort((a, b) => 
      (a['distancia_km'] as double).compareTo(b['distancia_km'] as double));

    return TransitOfficesResponse(
      latitudUsuario: latitude,
      longitudUsuario: longitude,
      ciudad: city,
      estado: state,
      total: oficinasConDistancia.length,
      oficinas: oficinasConDistancia
          .map((item) => TransitOffice.fromJson(item))
          .toList(),
    );
  }

  // Función auxiliar para calcular distancia entre dos puntos
  double _calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
    const double radioTierra = 6371; // Radio de la Tierra en km
    final double dLat = _gradosARadianes(lat2 - lat1);
    final double dLon = _gradosARadianes(lon2 - lon1);
    
    final double a = 
      math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_gradosARadianes(lat1)) * math.cos(_gradosARadianes(lat2)) * 
      math.sin(dLon / 2) * math.sin(dLon / 2);
    
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return radioTierra * c;
  }

  double _gradosARadianes(double grados) {
    return grados * (math.pi / 180);
  }
}
