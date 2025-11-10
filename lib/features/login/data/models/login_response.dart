import 'user_model.dart';

class LoginResponse {
  final UserModel user;
  final String token;
  final String? refreshToken;

  const LoginResponse({
    required this.user,
    required this.token,
    this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
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
