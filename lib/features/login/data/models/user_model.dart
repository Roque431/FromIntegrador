import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.lastName,
    super.phone,
    super.isPro,
    super.createdAt,
    super.userType,
    super.profileImageUrl,
    super.cedulaProfesional,
    super.descripcionProfesional,
  });

  // From JSON - Compatible con backend LexIA
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Si viene del login, el usuario puede estar anidado en 'usuario' o 'user'
    final Map<String, dynamic> userData = json['usuario'] != null
        ? Map<String, dynamic>.from(json['usuario'])
        : (json['user'] != null
            ? Map<String, dynamic>.from(json['user'])
            : Map<String, dynamic>.from(json));
    
    // Detectar si es PRO basándose en suscripcion_id o suscripcion.tipo
    final int? suscripcionId = userData['suscripcion_id'] is int
        ? userData['suscripcion_id'] as int
        : int.tryParse('${userData['suscripcion_id'] ?? ''}');
    
    final String? suscripcionTipo = userData['suscripcion'] is Map
        ? (userData['suscripcion']?['tipo'] as String?)
        : null;
    
    final bool isPro = (suscripcionId == 2) || (suscripcionTipo == 'pro');
    
    // Parsear fecha de creación
    DateTime? createdAt;
    final fechaRegistro = userData['fecha_registro'] ?? userData['createdAt'];
    if (fechaRegistro is String && fechaRegistro.isNotEmpty) {
      createdAt = DateTime.tryParse(fechaRegistro);
    }

    // Detectar tipo de usuario
    final String? role = userData['role'] ?? userData['tipo'] ?? userData['userType'];
    final UserType userType = role == 'lawyer' || role == 'abogado'
        ? UserType.lawyer
        : UserType.user;

    return UserModel(
      id: '${userData['id'] ?? userData['_id'] ?? ''}',
      email: '${userData['email'] ?? ''}',
      name: '${userData['nombre'] ?? userData['name'] ?? ''}',
      lastName: userData['apellidos']?.toString() ?? userData['apellido']?.toString(),
      phone: userData['telefono']?.toString() ?? userData['phone']?.toString(),
      isPro: isPro,
      createdAt: createdAt,
      userType: userType,
      profileImageUrl: userData['profile_image_url'] ?? userData['foto_perfil'],
      cedulaProfesional: userData['cedula_profesional'] ?? userData['cedulaProfesional'],
      descripcionProfesional: userData['descripcion_profesional'] ?? userData['descripcionProfesional'] ?? userData['descripcion'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      if (lastName != null) 'lastName': lastName,
      if (phone != null) 'phone': phone,
      'isPro': isPro,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      'userType': userType == UserType.lawyer ? 'lawyer' : 'user',
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      if (cedulaProfesional != null) 'cedulaProfesional': cedulaProfesional,
      if (descripcionProfesional != null) 'descripcionProfesional': descripcionProfesional,
    };
  }

  // Copy with
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? lastName,
    String? phone,
    bool? isPro,
    DateTime? createdAt,
    UserType? userType,
    String? profileImageUrl,
    String? cedulaProfesional,
    String? descripcionProfesional,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      isPro: isPro ?? this.isPro,
      createdAt: createdAt ?? this.createdAt,
      userType: userType ?? this.userType,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      cedulaProfesional: cedulaProfesional ?? this.cedulaProfesional,
      descripcionProfesional: descripcionProfesional ?? this.descripcionProfesional,
    );
  }

  // Convert to domain entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      lastName: lastName,
      phone: phone,
      isPro: isPro,
      createdAt: createdAt,
      userType: userType,
      profileImageUrl: profileImageUrl,
      cedulaProfesional: cedulaProfesional,
      descripcionProfesional: descripcionProfesional,
    );
  }
}
