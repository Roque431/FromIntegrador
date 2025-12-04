import '../../../../core/network/api_client.dart';
import '../models/mensaje_privado_model.dart';

class ChatPrivadoRepository {
  final ApiClient _apiClient;

  ChatPrivadoRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Obtener todas las conversaciones del usuario
  Future<List<ConversacionPrivadaModel>> getConversaciones(String usuarioId) async {
    try {
      final response = await _apiClient.get(
        '/api/chat/mensajes/conversaciones/$usuarioId',
        requiresAuth: true,
      );

      if (response['success'] == true && response['conversaciones'] != null) {
        final List<dynamic> data = response['conversaciones'];
        return data.map((json) => ConversacionPrivadaModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('❌ Error obteniendo conversaciones: $e');
      rethrow;
    }
  }

  /// Obtener mensajes de una conversación específica
  Future<List<MensajePrivadoModel>> getMensajes({
    required String ciudadanoId,
    required String abogadoId,
    int limit = 50,
  }) async {
    try {
      final response = await _apiClient.get(
        '/api/chat/mensajes/$ciudadanoId/$abogadoId',
        queryParameters: {
          'limit': limit.toString(),
        },
        requiresAuth: true,
      );

      if (response['success'] == true && response['mensajes'] != null) {
        final List<dynamic> data = response['mensajes'];
        return data.map((json) => MensajePrivadoModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('❌ Error obteniendo mensajes: $e');
      rethrow;
    }
  }

  /// Enviar un mensaje
  Future<MensajePrivadoModel?> enviarMensaje({
    required String ciudadanoId,
    required String abogadoId,
    required String remitenteId,
    required String contenido,
  }) async {
    try {
      final response = await _apiClient.post(
        '/api/chat/mensajes/enviar',
        body: {
          'ciudadanoId': ciudadanoId,
          'abogadoId': abogadoId,
          'remitenteId': remitenteId,
          'contenido': contenido,
        },
        requiresAuth: true,
      );

      if (response['success'] == true && response['mensaje'] != null) {
        return MensajePrivadoModel.fromJson(response['mensaje']);
      }
      return null;
    } catch (e) {
      print('❌ Error enviando mensaje: $e');
      rethrow;
    }
  }

  /// Marcar mensajes como leídos
  Future<bool> marcarComoLeidos({
    required String ciudadanoId,
    required String abogadoId,
    required String lectorId,
  }) async {
    try {
      final response = await _apiClient.post(
        '/api/chat/mensajes/marcar-leidos',
        body: {
          'ciudadanoId': ciudadanoId,
          'abogadoId': abogadoId,
          'lectorId': lectorId,
        },
        requiresAuth: true,
      );

      return response['success'] == true;
    } catch (e) {
      print('❌ Error marcando como leídos: $e');
      return false;
    }
  }

  /// Crear nueva conversación (al hacer match)
  Future<ConversacionPrivadaModel?> crearConversacion({
    required String ciudadanoId,
    required String abogadoId,
    String? mensajeInicial,
  }) async {
    try {
      final response = await _apiClient.post(
        '/api/chat/mensajes/conversacion',
        body: {
          'ciudadanoId': ciudadanoId,
          'abogadoId': abogadoId,
          if (mensajeInicial != null) 'mensajeInicial': mensajeInicial,
        },
        requiresAuth: true,
      );

      if (response['success'] == true && response['conversacion'] != null) {
        return ConversacionPrivadaModel.fromJson(response['conversacion']);
      }
      return null;
    } catch (e) {
      print('❌ Error creando conversación: $e');
      rethrow;
    }
  }

  /// Obtener total de mensajes no leídos
  Future<int> getMensajesNoLeidos(String usuarioId) async {
    try {
      final response = await _apiClient.get(
        '/api/chat/mensajes/no-leidos/$usuarioId',
        requiresAuth: true,
      );

      if (response['success'] == true) {
        return response['noLeidos'] ?? 0;
      }
      return 0;
    } catch (e) {
      print('❌ Error obteniendo no leídos: $e');
      return 0;
    }
  }
}
