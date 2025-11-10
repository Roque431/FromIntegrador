import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? lastName;
  final String? phone;
  final bool isPro;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.lastName,
    this.phone,
    this.isPro = false,
    this.createdAt,
  });

  String get fullName => lastName != null ? '$name $lastName' : name;

  String get initials {
    final firstInitial = name.isNotEmpty ? name[0].toUpperCase() : '';
    final lastInitial = lastName != null && lastName!.isNotEmpty
        ? lastName![0].toUpperCase()
        : '';
    return '$firstInitial$lastInitial';
  }

  @override
  List<Object?> get props => [id, email, name, lastName, phone, isPro, createdAt];
}
