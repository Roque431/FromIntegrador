class SendVerificationRequest {
  final String email;

  const SendVerificationRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
