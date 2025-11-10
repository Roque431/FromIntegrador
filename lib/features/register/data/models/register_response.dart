import 'user_model.dart';

class RegisterResponse {
  final UserModel user;
  final String token;
  final String? refreshToken;

  const RegisterResponse({
    required this.user,
    required this.token,
    this.refreshToken,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      user: UserModel.fromJson(json['user'] ?? json['data'] ?? {}),
      token: json['token'] ?? json['access_token'] ?? '',
      refreshToken: json['refreshToken'] ?? json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
      if (refreshToken != null) 'refreshToken': refreshToken,
    };
  }
}
