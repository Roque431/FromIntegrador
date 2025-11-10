import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/login_response.dart';
import '../models/login_request.dart';
import '../models/user_model.dart';

abstract class LoginDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<UserModel> getCurrentUser();
  Future<void> logout();
}

class LoginDataSourceImpl implements LoginDataSource {
  final ApiClient apiClient;

  LoginDataSourceImpl({required this.apiClient});

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.login,
        body: request.toJson(),
        requiresAuth: false,
      );

      final loginResponse = LoginResponse.fromJson(response);

      // Guardar el token en el ApiClient
      apiClient.setAuthToken(loginResponse.token);

      return loginResponse;
    } catch (e) {
      throw ApiException('Error al iniciar sesión: $e');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.me,
        requiresAuth: true,
      );

      return UserModel.fromJson(response);
    } catch (e) {
      throw ApiException('Error al obtener usuario actual: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.post(
        ApiEndpoints.logout,
        requiresAuth: true,
      );

      // Limpiar el token
      apiClient.setAuthToken('');
    } catch (e) {
      throw ApiException('Error al cerrar sesión: $e');
    }
  }
}
