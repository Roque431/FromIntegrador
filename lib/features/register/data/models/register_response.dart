import 'user_model.dart';

/// El backend de registro devuelve únicamente el objeto Usuario (sin token).
/// Si se necesita un token después del registro, se debe realizar login aparte.
class RegisterResponse {
  final UserModel user;

  const RegisterResponse({
    required this.user,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    // Si viene envuelto en {"usuario": {...}} o directamente el objeto
    final Map<String, dynamic> data = json['usuario'] != null
        ? Map<String, dynamic>.from(json['usuario'])
        : Map<String, dynamic>.from(json);
    return RegisterResponse(
      user: UserModel.fromJson(data),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
    };
  }
}
