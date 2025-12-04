import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/storage/secure_token_repository.dart';
import '../../../login/domain/repository/login_repository.dart';
import '../models/chat_message_request.dart';
import '../models/chat_message_response.dart';

abstract class ConsultationDataSource {
  Future<ChatMessageResponse> sendMessage(ChatMessageRequest request);
  Future<List<ChatMessageResponse>> getChatHistory();
}

class ConsultationDataSourceImpl implements ConsultationDataSource {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  final SecureTokenRepository secureTokenRepository;
  final LoginRepository loginRepository;

  ConsultationDataSourceImpl({
    required this.apiClient,
    required this.sharedPreferences,
    required this.secureTokenRepository,
    required this.loginRepository,
  });

  @override
  Future<ChatMessageResponse> sendMessage(ChatMessageRequest request) async {
    try {
      // Asegurar token de autenticación en ApiClient
      if (!apiClient.hasToken) {
        final storedToken = await secureTokenRepository.getAuthToken();
        if (storedToken != null && storedToken.isNotEmpty) {
          apiClient.setAuthToken(storedToken);
          print('🔐 ApiClient token restaurado desde almacenamiento seguro');
        }
      }
      if (!apiClient.hasToken) {
        throw UnauthorizedException('Usuario no autenticado: token ausente');
      }

      // Obtener usuario_id preferentemente desde almacenamiento seguro
      String? userId = await secureTokenRepository.getUserId();
      userId ??= sharedPreferences.getString('user_id');
      if (userId == null || userId.isEmpty) {
        throw UnauthorizedException('Usuario no autenticado: user_id ausente');
      }

      // Preparar nombre del usuario (se usa en start y en message para personalización)
      String nombreUsuario = 'Usuario';
      try {
        final user = await loginRepository.getCurrentUser();
        final parts = [user.name.trim(), (user.lastName ?? '').trim()]
            .where((p) => p.isNotEmpty)
            .toList();
        final full = parts.join(' ');
        if (full.isNotEmpty) nombreUsuario = full;
      } catch (_) {}

      // Si el request trae algo en sessionId que parece ser un JWT, ignorarlo y crear/recuperar sesión real
      String? sessionId = request.sessionId;
      // Tratar "" como no-proporcionado
      if (sessionId != null && sessionId.trim().isEmpty) {
        sessionId = null;
      }
      if (sessionId != null && sessionId.split('.').length == 3) {
        // Parece un JWT, no debe usarse como sessionId
        print('⚠️ sessionId recibido parece un JWT, se ignorará para crear/usar sesión real');
        sessionId = null;
      }

      // Si no tenemos sessionId válido, iniciar sesión de chat
      if (sessionId == null) {
        print('🔄 Iniciando nueva sesión de chat para usuario $userId');
        final startResponse = await apiClient.post(
          ApiEndpoints.chatSessionStart,
          body: {
            'usuarioId': userId,
            'nombre': nombreUsuario,
          },
          requiresAuth: true,
        );
        sessionId = startResponse['sessionId'] ?? const Uuid().v4();
        print('🆕 Sesión creada: $sessionId');
      }

      print('🔵 Datasource - usando sessionId: $sessionId');

      // Construir body conforme al backend de Chat Service
      final body = <String, dynamic>{
        'sessionId': sessionId,
        'mensaje': request.message,
        'usuarioId': userId,
        'nombre': nombreUsuario,
      };

      final response = await apiClient.post(
        ApiEndpoints.chatMessage,
        body: body,
        requiresAuth: true,
      );

      print('🟢 Datasource - sessionId en respuesta: ${response['sessionId'] ?? response['session_id']}');

      return ChatMessageResponse.fromJson(response);
    } on ApiException catch (e) {
      // Re-lanzar excepciones conocidas
      throw e;
    } catch (e) {
      throw ApiException('Error al enviar mensaje: $e');
    }
  }

  @override
  Future<List<ChatMessageResponse>> getChatHistory() async {
    try {
      // Obtener el usuario_id de SharedPreferences
      final userId = sharedPreferences.getString('user_id');
      if (userId == null) {
        print('❌ No se encontró user_id en SharedPreferences');
        return [];
      }

      // Usar el endpoint correcto con usuario_id en path
      final endpoint = ApiEndpoints.chatHistory(userId);
      
      final params = <String, String>{};
      // Parámetros de paginación por si el backend los requiere para evitar 422
      params['limit'] = '50';
      params['offset'] = '0';

      print('🔍 Solicitud historial => endpoint: $endpoint, params: $params');

      final response = await apiClient.get(
        endpoint,
        queryParameters: params.isNotEmpty ? params : null,
        requiresAuth: true,
      );

      // El backend devuelve: { usuario_id, total, limit, offset, consultas: [...] }
      if (response is Map<String, dynamic> && response['consultas'] is List) {
        return (response['consultas'] as List)
            .map((item) => ChatMessageResponse.fromJson(item))
            .toList();
      }
      
      if (response is List) {
        return response
            .map((item) => ChatMessageResponse.fromJson(item))
            .toList();
      }

      // Si el backend devuelve con un wrapper (ej: {data: [...], success: true})
      if (response is Map<String, dynamic> && response['data'] is List) {
        return (response['data'] as List)
            .map((item) => ChatMessageResponse.fromJson(item))
            .toList();
      }

      return [];
    } catch (e) {
      // Si es un error de validación 422 podemos devolver lista vacía para que la UI muestre mensaje amigable
      final msg = e.toString();
      print('❌ Error historial: $msg');
      if (msg.contains('validación') || msg.contains('422')) {
        return [];
      }
      throw ApiException('Error al obtener historial: $e');
    }
  }
}
