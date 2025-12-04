import 'package:equatable/equatable.dart';
import '../../data/models/profesionista_model.dart';
import '../../data/models/anunciante_model.dart';

class Consultation extends Equatable {
  final String id;
  final String userId;
  final String query;
  final String response;
  final String sessionId;
  final DateTime createdAt;
  final String? category;
  final String? status;
  
  // Nuevos campos para cards interactivas
  final List<ProfesionistaModel> profesionistas;
  final List<AnuncianteModel> anunciantes;
  final List<String> sugerencias;
  final bool ofrecerMatch;
  final bool ofrecerForo;
  final String? cluster;
  final String? sentimiento;

  const Consultation({
    required this.id,
    required this.userId,
    required this.query,
    required this.response,
    required this.sessionId,
    required this.createdAt,
    this.category,
    this.status,
    this.profesionistas = const [],
    this.anunciantes = const [],
    this.sugerencias = const [],
    this.ofrecerMatch = false,
    this.ofrecerForo = false,
    this.cluster,
    this.sentimiento,
  });

  /// Indica si hay profesionistas disponibles para mostrar cards
  bool get tieneProfesionistas => profesionistas.isNotEmpty;
  
  /// Indica si hay anunciantes/servicios disponibles para mostrar cards
  bool get tieneAnunciantes => anunciantes.isNotEmpty;
  
  /// Indica si se deben mostrar sugerencias de preguntas
  bool get tieneSugerencias => sugerencias.isNotEmpty;

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
        profesionistas,
        anunciantes,
        sugerencias,
        ofrecerMatch,
        ofrecerForo,
        cluster,
        sentimiento,
      ];
}
