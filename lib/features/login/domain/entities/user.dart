import 'package:equatable/equatable.dart';

enum UserType { user, lawyer }

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? lastName;
  final String? phone;
  final bool isPro;
  final DateTime? createdAt;
  final UserType userType;
  final String? profileImageUrl;

  // Campos exclusivos para abogados
  final String? cedulaProfesional;
  final String? descripcionProfesional;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.lastName,
    this.phone,
    this.isPro = false,
    this.createdAt,
    this.userType = UserType.user,
    this.profileImageUrl,
    this.cedulaProfesional,
    this.descripcionProfesional,
  });

  String get fullName => lastName != null ? '$name $lastName' : name;

  String get initials {
    final firstInitial = name.isNotEmpty ? name[0].toUpperCase() : '';
    final lastInitial = lastName != null && lastName!.isNotEmpty
        ? lastName![0].toUpperCase()
        : '';
    return '$firstInitial$lastInitial';
  }

  bool get isLawyer => userType == UserType.lawyer;

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        lastName,
        phone,
        isPro,
        createdAt,
        userType,
        profileImageUrl,
        cedulaProfesional,
        descripcionProfesional,
      ];
}
