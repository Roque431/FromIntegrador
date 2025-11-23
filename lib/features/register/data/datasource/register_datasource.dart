import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/register_response.dart';
import '../models/register_request.dart';
import '../models/send_verification_request.dart';
import '../models/verify_email_request.dart';
import '../models/verify_email_response.dart';

abstract class RegisterDataSource {
  Future<RegisterResponse> register(RegisterRequest request);
  Future<VerifyEmailResponse> sendVerificationCode(SendVerificationRequest request);
  Future<VerifyEmailResponse> verifyEmail(VerifyEmailRequest request);
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

      return registerResponse;
    } catch (e) {
      throw ApiException('Error al registrarse: $e');
    }
  }

  @override
  Future<VerifyEmailResponse> sendVerificationCode(SendVerificationRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.sendVerificationCode,
        body: request.toJson(),
        requiresAuth: false,
      );

      return VerifyEmailResponse.fromJson(response);
    } catch (e) {
      throw ApiException('Error al enviar código de verificación: $e');
    }
  }

  @override
  Future<VerifyEmailResponse> verifyEmail(VerifyEmailRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.verifyEmail,
        body: request.toJson(),
        requiresAuth: false,
      );

      return VerifyEmailResponse.fromJson(response);
    } catch (e) {
      throw ApiException('Error al verificar email: $e');
    }
  }
}
