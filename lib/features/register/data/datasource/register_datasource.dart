import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/register_response.dart';
import '../models/register_request.dart';

abstract class RegisterDataSource {
  Future<RegisterResponse> register(RegisterRequest request);
}

class RegisterDataSourceImpl implements RegisterDataSource {
  final ApiClient apiClient;

  RegisterDataSourceImpl({required this.apiClient});

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.register,
        body: request.toJson(),
        requiresAuth: false,
      );

      final registerResponse = RegisterResponse.fromJson(response);

      // Guardar el token en el ApiClient
      apiClient.setAuthToken(registerResponse.token);

      return registerResponse;
    } catch (e) {
      throw ApiException('Error al registrarse: $e');
    }
  }
}
