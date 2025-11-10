class ChatMessageRequest {
  final String message;
  final String? sessionId;

  const ChatMessageRequest({
    required this.message,
    this.sessionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      if (sessionId != null) 'sessionId': sessionId,
    };
  }
}
