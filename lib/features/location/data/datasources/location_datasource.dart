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
}
