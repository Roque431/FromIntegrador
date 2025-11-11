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
  });

  // From JSON (compatible con backend LexIA)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = json['usuario'] != null
        ? Map<String, dynamic>.from(json['usuario'])
        : Map<String, dynamic>.from(json);

    final int? suscripcionId = data['suscripcion_id'] is int
        ? data['suscripcion_id'] as int
        : int.tryParse('${data['suscripcion_id'] ?? ''}');
  final String? suscripcionTipo = data['suscripcion'] is Map
    ? (data['suscripcion'] as Map)['tipo']?.toString()
    : null;
    final bool isPro = (suscripcionId == 2) || (suscripcionTipo == 'pro');

    DateTime? createdAt;
    final fechaRegistro = data['fecha_registro'] ?? data['createdAt'];
    if (fechaRegistro is String && fechaRegistro.isNotEmpty) {
      createdAt = DateTime.tryParse(fechaRegistro);
    }

    return UserModel(
      id: '${data['id'] ?? data['_id'] ?? ''}',
      email: '${data['email'] ?? ''}',
      name: '${data['nombre'] ?? data['name'] ?? ''}',
      lastName: data['apellidos']?.toString(),
      phone: data['telefono']?.toString(),
      isPro: isPro,
      createdAt: createdAt,
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
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      isPro: isPro ?? this.isPro,
      createdAt: createdAt ?? this.createdAt,
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
    );
  }
}
