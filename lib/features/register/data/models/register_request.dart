class RegisterRequest {
  final String email;
  final String password;
  final String name;
  final String? lastName;
  final String? phone;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    this.lastName,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      if (lastName != null) 'lastName': lastName,
      if (phone != null) 'phone': phone,
    };
  }
}
