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

  // From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? json['firstName'] ?? '',
      lastName: json['lastName'] ?? json['apellidos'],
      phone: json['phone'] ?? json['telefono'],
      isPro: json['isPro'] ?? json['is_pro'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
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
}
