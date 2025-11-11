import '../datasource/consultation_datasource.dart';
import '../models/consultation_model.dart';

class ConsultationRepository {
  final ConsultationDatasource _datasource;

  ConsultationRepository(this._datasource);

  Future<ConsultationResponseModel> sendMessage({
    required String message,
    String? sessionId,
  }) async {
    try {
      return await _datasource.sendMessage(
        message: message,
        sessionId: sessionId,
      );
    } catch (e) {
      throw Exception('Error al enviar mensaje: $e');
    }
  }

  Future<List<ConsultationModel>> getChatHistory({
    required String usuarioId,
    int? limit,
    int? offset,
  }) async {
    try {
      return await _datasource.getChatHistory(
        usuarioId: usuarioId,
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      throw Exception('Error al obtener historial: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getChatSessions({
    required String usuarioId,
  }) async {
    try {
      return await _datasource.getChatSessions(usuarioId: usuarioId);
    } catch (e) {
      throw Exception('Error al obtener sesiones: $e');
    }
  }

  Future<Map<String, dynamic>> getChatSessionById(String sessionId) async {
    try {
      return await _datasource.getChatSessionById(sessionId);
    } catch (e) {
      throw Exception('Error al obtener sesión: $e');
    }
  }
}
