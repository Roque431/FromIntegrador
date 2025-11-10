import 'consultation_model.dart';

class ChatMessageResponse {
  final String response;
  final String sessionId;
  final ConsultationModel? consultation;
  final DateTime timestamp;

  const ChatMessageResponse({
    required this.response,
    required this.sessionId,
    this.consultation,
    required this.timestamp,
  });

  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) {
    return ChatMessageResponse(
      response: json['response'] ?? json['message'] ?? '',
      sessionId: json['sessionId'] ?? json['session_id'] ?? '',
      consultation: json['consultation'] != null
          ? ConsultationModel.fromJson(json['consultation'])
          : null,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'sessionId': sessionId,
      if (consultation != null) 'consultation': consultation!.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
