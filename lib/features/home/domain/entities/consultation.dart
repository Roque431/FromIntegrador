import 'package:equatable/equatable.dart';

class Consultation extends Equatable {
  final String id;
  final String userId;
  final String query;
  final String response;
  final String sessionId;
  final DateTime createdAt;
  final String? category;
  final String? status;

  const Consultation({
    required this.id,
    required this.userId,
    required this.query,
    required this.response,
    required this.sessionId,
    required this.createdAt,
    this.category,
    this.status,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        query,
        response,
        sessionId,
        createdAt,
        category,
        status,
      ];
}
