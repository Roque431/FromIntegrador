import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/login_response.dart';
import '../models/login_request.dart';
import '../models/user_model.dart';

abstract class LoginDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<LoginResponse> loginWithGoogle(String idToken);
  Future<UserModel> getCurrentUser();
  Future<UserModel> updateProfile({
    required String name,
    required String email,
    String? phone,
  });
  // Permite inicializar/establecer el token en el ApiClient cuando venga desde storage
  void setAuthToken(String token);
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
  Future<LoginResponse> loginWithGoogle(String idToken) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.googleLogin,
        body: {'id_token': idToken},
        requiresAuth: false,
      );

      final loginResponse = LoginResponse.fromJson(response);

      // Guardar el token en el ApiClient
      apiClient.setAuthToken(loginResponse.token);

      return loginResponse;
    } catch (e) {
      throw ApiException('Error al iniciar sesión con Google: $e');
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
  Future<UserModel> updateProfile({
    required String name,
    required String email,
    String? phone,
  }) async {
    try {
      // Dividir el nombre completo en nombre y apellido
      final nameParts = name.trim().split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts[0] : name;
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : null;

      // Mapear los campos al formato que espera el backend (español)
      final requestBody = {
        'nombre': firstName,
        if (lastName != null) 'apellidos': lastName,
        'email': email,
        if (phone != null && phone.isNotEmpty) 'telefono': phone,
      };

      final response = await apiClient.put(
        ApiEndpoints.updateProfile,
        body: requestBody,
        requiresAuth: true,
      );

      // Si el backend devuelve algo que no es JSON válido (como un UUID),
      // hacer un GET para obtener los datos actualizados del usuario
      if (response == null || response is! Map<String, dynamic>) {
        print('⚠️ UPDATE response no es JSON válido, obteniendo usuario actualizado...');
        return await getCurrentUser();
      }

      return UserModel.fromJson(response);
    } catch (e) {
      print('❌ Error al actualizar el perfil: $e');
      
      // Si hay error al parsear la respuesta, intentar obtener el usuario actualizado
      if (e.toString().contains('no attribute') || e.toString().contains('UUID')) {
        print('🔄 Reintentando con GET después del PUT...');
        try {
          return await getCurrentUser();
        } catch (getError) {
          throw ApiException('Error al actualizar y obtener el perfil: $getError');
        }
      }
      
      throw ApiException('Error al actualizar el perfil: $e');
    }
  }

  @override
  void setAuthToken(String token) {
    apiClient.setAuthToken(token);
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
