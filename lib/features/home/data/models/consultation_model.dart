import '../../domain/entities/consultation.dart';
import 'profesionista_model.dart';
import 'anunciante_model.dart';

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
    super.profesionistas,
    super.anunciantes,
    super.sugerencias,
    super.ofrecerMatch,
    super.ofrecerForo,
    super.cluster,
    super.sentimiento,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) {
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
      print('⚠️ Error parsing profesionistas: $e');
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
      print('⚠️ Error parsing anunciantes: $e');
      anunciantes = const [];
    }

    // Parsear sugerencias - manejar null de forma segura
    List<String> sugerencias = const [];
    try {
      if (json['sugerencias'] != null && json['sugerencias'] is List) {
        sugerencias = (json['sugerencias'] as List).whereType<String>().toList();
      }
    } catch (e) {
      print('⚠️ Error parsing sugerencias: $e');
      sugerencias = const [];
    }

    return ConsultationModel(
      id: json['id'] ?? json['_id'] ?? '',
      userId: json['userId'] ?? json['user_id'] ?? '',
      // Soporta 'texto_original' (ES) y otras variantes
      query: json['query'] ?? json['message'] ?? json['texto_original'] ?? '',
      // Soporta 'respuesta_generada' (ES) y otras variantes
      response: json['response'] ?? json['answer'] ?? json['respuesta_generada'] ?? json['mensaje'] ?? '',
      sessionId: json['sessionId'] ?? json['session_id'] ?? '',
      createdAt: (json['createdAt'] ?? json['fecha_creacion']) != null
          ? DateTime.parse((json['createdAt'] ?? json['fecha_creacion']))
          : DateTime.now(),
      category: json['category'],
      status: json['status'] ?? 'completed',
      // Nuevos campos
      profesionistas: profesionistas,
      anunciantes: anunciantes,
      sugerencias: sugerencias,
      ofrecerMatch: json['ofrecerMatch'] ?? json['ofrecer_match'] ?? false,
      ofrecerForo: json['ofrecerForo'] ?? json['ofrecer_foro'] ?? false,
      cluster: json['cluster'],
      sentimiento: json['sentimiento'],
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
      profesionistas: profesionistas,
      anunciantes: anunciantes,
      sugerencias: sugerencias,
      ofrecerMatch: ofrecerMatch,
      ofrecerForo: ofrecerForo,
      cluster: cluster,
      sentimiento: sentimiento,
    );
  }
}
