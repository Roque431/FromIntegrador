class RegisterRequest {
  final String email;
  final String password;
  final String name; // nombre
  final String? lastName; // apellidos
  final String? phone; // telefono

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    this.lastName,
    this.phone,
  });

  // El backend espera: nombre, apellidos, telefono, email, password
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'nombre': name,
      if (lastName != null && lastName!.isNotEmpty) 'apellidos': lastName,
      if (phone != null && phone!.isNotEmpty) 'telefono': phone,
    };
  }
}
