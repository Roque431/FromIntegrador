import '../../domain/entities/consultation.dart';

class ConsultationModel extends Consultation {
  const ConsultationModel({
    required super.id,
    required super.userId,
    required super.query,
    required super.response,
    required super.sessionId,
    required super.createdAt,
    super.category,
    super.status,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) {
    return ConsultationModel(
      id: json['id'] ?? json['_id'] ?? '',
      userId: json['userId'] ?? json['user_id'] ?? '',
      query: json['query'] ?? json['message'] ?? '',
      response: json['response'] ?? json['answer'] ?? '',
      sessionId: json['sessionId'] ?? json['session_id'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      category: json['category'],
      status: json['status'] ?? 'completed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'query': query,
      'response': response,
      'sessionId': sessionId,
      'createdAt': createdAt.toIso8601String(),
      if (category != null) 'category': category,
      if (status != null) 'status': status,
    };
  }

  Consultation toEntity() {
    return Consultation(
      id: id,
      userId: userId,
      query: query,
      response: response,
      sessionId: sessionId,
      createdAt: createdAt,
      category: category,
      status: status,
    );
  }
}
