enum ConsultationStatus { pendiente, enProceso, resuelta }

class ConsultationRequest {
  final String id;
  final String clientName;
  final String clientInitials;
  final String topic;
  final String preview;
  final DateTime createdAt;
  final ConsultationStatus status;

  const ConsultationRequest({
    required this.id,
    required this.clientName,
    required this.clientInitials,
    required this.topic,
    required this.preview,
    required this.createdAt,
    required this.status,
  });

  String get statusLabel {
    switch (status) {
      case ConsultationStatus.pendiente:
        return 'Nuevo';
      case ConsultationStatus.enProceso:
        return 'En proceso';
      case ConsultationStatus.resuelta:
        return 'Resuelta';
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} minutos';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} horas';
    } else {
      return 'Hace ${difference.inDays} días';
    }
  }

  // Datos de demostración
  static List<ConsultationRequest> getDemoData() {
    return [
      ConsultationRequest(
        id: '1',
        clientName: 'Ramiro Medina',
        clientInitials: 'RM',
        topic: 'Finiquito no pagado - laboral',
        preview: 'Ya pasaron 3 meses desde que terminé mi relación laboral y mi ex empleador no me ha pagado mi finiquito...',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        status: ConsultationStatus.pendiente,
      ),
      ConsultationRequest(
        id: '2',
        clientName: 'Carlos Jiménez',
        clientInitials: 'CJ',
        topic: 'Accidente de tránsito - seguros',
        preview: 'Tuve un accidente y el otro conductor no tiene seguro...',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        status: ConsultationStatus.enProceso,
      ),
      ConsultationRequest(
        id: '3',
        clientName: 'María López',
        clientInitials: 'ML',
        topic: 'Divorcio express',
        preview: '¿Cuáles son los pasos para divorciarme de forma rápida?',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        status: ConsultationStatus.enProceso,
      ),
      ConsultationRequest(
        id: '4',
        clientName: 'Pedro Sánchez',
        clientInitials: 'PS',
        topic: 'Despido injustificado',
        preview: 'Me despidieron sin causa justificada después de 5 años...',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        status: ConsultationStatus.resuelta,
      ),
    ];
  }
}
