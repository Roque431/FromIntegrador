import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/conversacion_model.dart';

class HistorialRepository {
  final ApiClient _apiClient;

  HistorialRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Obtener todas las conversaciones del usuario
  Future<List<ConversacionModel>> getConversaciones(String usuarioId, {int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.userConversations(usuarioId),
        queryParameters: {'limit': limit.toString()},
        requiresAuth: true,
      );

      if (response['success'] == true && response['conversaciones'] != null) {
        final List<dynamic> data = response['conversaciones'];
        return data.map((json) => ConversacionModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('❌ Error obteniendo conversaciones: $e');
      rethrow;
    }
  }

  /// Obtener detalle de una conversación con todos sus mensajes
  Future<ConversacionDetalleModel?> getConversacionDetalle(String sessionId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.conversationDetail(sessionId),
        requiresAuth: true,
      );

      if (response['success'] == true) {
        return ConversacionDetalleModel.fromJson(response);
      }
      return null;
    } catch (e) {
      print('❌ Error obteniendo detalle de conversación: $e');
      rethrow;
    }
  }
}
