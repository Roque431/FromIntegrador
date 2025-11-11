class VerifyEmailResponse {
  final String message;

  const VerifyEmailResponse({
    required this.message,
  });

  factory VerifyEmailResponse.fromJson(Map<String, dynamic> json) {
    return VerifyEmailResponse(
      message: json['detail'] ?? json['message'] ?? 'Verificación exitosa',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detail': message,
    };
  }
}
