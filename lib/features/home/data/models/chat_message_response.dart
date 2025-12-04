import 'consultation_model.dart';
import 'profesionista_model.dart';
import 'anunciante_model.dart';

class ChatMessageResponse {
  final String response;
  final String sessionId;
  final ConsultationModel? consultation;
  final DateTime timestamp;
  final String? consultationId;
  final List<Map<String, dynamic>>? documentosReferenciados;
  
  // Nuevos campos del SmartResponseService
  final List<ProfesionistaModel> profesionistas;
  final List<AnuncianteModel> anunciantes;
  final List<String> sugerencias;
  final bool ofrecerMatch;
  final bool ofrecerForo;
  final String? cluster;
  final String? sentimiento;

  const ChatMessageResponse({
    required this.response,
    required this.sessionId,
    this.consultation,
    required this.timestamp,
    this.consultationId,
    this.documentosReferenciados,
    this.profesionistas = const [],
    this.anunciantes = const [],
    this.sugerencias = const [],
    this.ofrecerMatch = false,
    this.ofrecerForo = false,
    this.cluster,
    this.sentimiento,
  });

  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) {
    // Parsear profesionistas - manejar null de forma segura
    List<ProfesionistaModel> profesionistas = const [];
    try {
      if (json['profesionistas'] != null && json['profesionistas'] is List) {
        profesionistas = (json['profesionistas'] as List)
            .whereType<Map<String, dynamic>>()
            .map((p) => ProfesionistaModel.fromJson(p))
            .toList();
      }
    } catch (e) {
      print('⚠️ Error parsing profesionistas in response: $e');
      profesionistas = const [];
    }

    // Parsear anunciantes - manejar null de forma segura
    List<AnuncianteModel> anunciantes = const [];
    try {
      if (json['anunciantes'] != null && json['anunciantes'] is List) {
        anunciantes = (json['anunciantes'] as List)
            .whereType<Map<String, dynamic>>()
            .map((a) => AnuncianteModel.fromJson(a))
            .toList();
      }
    } catch (e) {
      print('⚠️ Error parsing anunciantes in response: $e');
      anunciantes = const [];
    }

    // Parsear sugerencias - manejar null de forma segura
    List<String> sugerencias = const [];
    try {
      if (json['sugerencias'] != null && json['sugerencias'] is List) {
        sugerencias = (json['sugerencias'] as List).whereType<String>().toList();
      }
    } catch (e) {
      print('⚠️ Error parsing sugerencias in response: $e');
      sugerencias = const [];
    }

    // El backend devuelve directamente la consulta con estos campos:
    // id, usuario_id, texto_original, respuesta_generada, session_id, documentos_referenciados, fecha_creacion
    
    // Determinar si el payload incluye una consulta completa
    final hasConsultationFields =
        json.containsKey('id') ||
        json.containsKey('usuario_id') ||
        json.containsKey('user_id') ||
        json.containsKey('texto_original') ||
        json.containsKey('createdAt') ||
        json.containsKey('fecha_creacion');

    return ChatMessageResponse(
      // Soporta formatos del Chat Service: 'mensaje' (ES) y variantes
      response: json['respuesta_generada'] ?? json['response'] ?? json['mensaje'] ?? json['message'] ?? '',
      sessionId: json['session_id'] ?? json['sessionId'] ?? '',
      consultationId: json['id']?.toString(),
      documentosReferenciados: json['documentos_referenciados'] != null 
          ? List<Map<String, dynamic>>.from(json['documentos_referenciados'])
          : null,
      consultation: hasConsultationFields
          ? ConsultationModel.fromJson({
              'id': json['id']?.toString() ?? '',
              'user_id': json['usuario_id']?.toString() ?? json['user_id']?.toString() ?? '',
              // query debe ser la pregunta del usuario, nunca la respuesta de la IA
              'query': json['texto_original'] ?? json['query'] ?? json['message'] ?? '',
              // response sí puede mapear 'mensaje' (respuesta de la IA)
              'response': json['respuesta_generada'] ?? json['response'] ?? json['mensaje'] ?? json['message'] ?? '',
              'session_id': json['session_id'] ?? json['sessionId'] ?? '',
              'sessionId': json['sessionId'] ?? json['session_id'] ?? '',
              'createdAt': json['fecha_creacion'] ?? json['createdAt'],
              // Pasar los nuevos campos al modelo de consulta
              'profesionistas': json['profesionistas'],
              'anunciantes': json['anunciantes'],
              'sugerencias': json['sugerencias'],
              'ofrecerMatch': json['ofrecerMatch'],
              'ofrecerForo': json['ofrecerForo'],
              'cluster': json['cluster'],
              'sentimiento': json['sentimiento'],
            })
          : null,
      timestamp: json['fecha_creacion'] != null
          ? DateTime.parse(json['fecha_creacion'])
          : (json['timestamp'] != null 
              ? DateTime.parse(json['timestamp'])
              : DateTime.now()),
      // Nuevos campos directamente del response
      profesionistas: profesionistas,
      anunciantes: anunciantes,
      sugerencias: sugerencias,
      ofrecerMatch: json['ofrecerMatch'] ?? false,
      ofrecerForo: json['ofrecerForo'] ?? false,
      cluster: json['cluster'],
      sentimiento: json['sentimiento'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
      'sessionId': sessionId,
      if (consultation != null) 'consultation': consultation!.toJson(),
      'timestamp': timestamp.toIso8601String(),
      if (consultationId != null) 'id': consultationId,
      if (documentosReferenciados != null) 'documentos_referenciados': documentosReferenciados,
      if (profesionistas.isNotEmpty) 
        'profesionistas': profesionistas.map((p) => p.toJson()).toList(),
      if (anunciantes.isNotEmpty) 
        'anunciantes': anunciantes.map((a) => a.toJson()).toList(),
      if (sugerencias.isNotEmpty) 'sugerencias': sugerencias,
      'ofrecerMatch': ofrecerMatch,
      'ofrecerForo': ofrecerForo,
      if (cluster != null) 'cluster': cluster,
      if (sentimiento != null) 'sentimiento': sentimiento,
    };
  }
}
