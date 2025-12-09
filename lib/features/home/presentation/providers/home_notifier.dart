import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../login/domain/repository/login_repository.dart';
import '../../../forum/data/repository/foro_repository.dart';
import '../../domain/entities/consultation.dart';
import '../../domain/usecase/send_message_usecase.dart';
import '../../domain/usecase/get_chat_history_usecase.dart';
import '../../data/models/chat_session_model.dart';

enum HomeState { initial, loading, success, error, quotaExceeded }

class HomeNotifier extends ChangeNotifier {
  final SendMessageUseCase sendMessageUseCase;
  final GetChatHistoryUseCase getChatHistoryUseCase;
  final LoginRepository loginRepository;
  final ApiClient apiClient;
  final ForoRepository foroRepository;

  HomeNotifier({
    required this.sendMessageUseCase,
    required this.getChatHistoryUseCase,
    required this.loginRepository,
    required this.apiClient,
    required this.foroRepository,
  }) {
    _loadSessionIdAndUser();
  }

  // Estado
  HomeState _state = HomeState.initial;
  HomeState get state => _state;

  // Datos
  List<Consultation> _consultations = [];
  List<Consultation> get consultations => _consultations;

  Consultation? _currentConsultation;
  Consultation? get currentConsultation => _currentConsultation;

  String? _currentResponse;
  String? get currentResponse => _currentResponse;

  String? _sessionId;
  String? get sessionId => _sessionId;
  
  String? _userId; // <--- ¡NUEVO! Para identificar al usuario en el chat
  String? get userId => _userId;

  // NUEVO: Método para cargar sessionId y userId
  Future<void> _loadSessionIdAndUser() async {
    try {
      // Nunca usar el token como sessionId de chat
      _sessionId = null;
      _userId = await loginRepository.getStoredUserId(); // ID del usuario autenticado
      
      print('🟢 HomeNotifier - userId cargado: $_userId');
      print('🟢 HomeNotifier - userId cargado: $_userId');
      
      if (_userId != null) {
        notifyListeners();
      }
    } catch (e) {
      print('🔴 HomeNotifier - Error al cargar sessionId/userId: $e');
      _userId = null;
    }
  }

  // Error y límite de consultas
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? _quotaLimitInfo;
  Map<String, dynamic>? get quotaLimitInfo => _quotaLimitInfo;

  // Estado de carga
  bool get isLoading => _state == HomeState.loading;
  bool get hasError => _state == HomeState.error;
  bool get isQuotaExceeded => _state == HomeState.quotaExceeded;

  /// Enviar mensaje a la API
  Future<bool> sendMessage(String message) async {
    Consultation? tempConsultation;
    
    try {
      print('🔵 HomeNotifier - sessionId antes de enviar: $_sessionId');
      
      // Crear consulta temporal para mostrar el mensaje del usuario inmediatamente
      tempConsultation = Consultation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _userId ?? '', // <--- ¡USA EL USER ID CARGADO!
        query: message,
        response: '', // Se llenará después
        sessionId: _sessionId ?? '',
        createdAt: DateTime.now(),
        status: 'pending',
      );
      
      // Agregar mensaje del usuario a la lista inmediatamente
      _consultations.add(tempConsultation);
      _state = HomeState.loading;
      _errorMessage = null;
      _quotaLimitInfo = null;
      notifyListeners();

      final result = await sendMessageUseCase.call(
        message: message,
        sessionId: _sessionId,
        // Nota: El userId debe ser manejado por el ConsultationRepository/DataSource
        // si el backend lo requiere en el cuerpo de la solicitud.
      );

      print('🟢 HomeNotifier - sessionId después de recibir: ${result.consultation.sessionId}');
      
      // Actualizar la consulta temporal con la respuesta
      final index = _consultations.indexWhere((c) => c.id == tempConsultation?.id);
      if (index != -1) {
        _consultations[index] = result.consultation;
      } else {
        _consultations.add(result.consultation);
      }

      _currentConsultation = result.consultation;
      _currentResponse = result.response;
      _sessionId = result.consultation.sessionId;
      // El userId no cambia a menos que el usuario se desloguee.

      _state = HomeState.success;
      notifyListeners();
      return true;
    } on ForbiddenException catch (e) {
      // Manejo específico de límite de consultas
      if (e.isQuotaLimit) {
        _state = HomeState.quotaExceeded;
        _errorMessage = e.message;
        _quotaLimitInfo = {
          'usage': e.usage,
          'limit': e.limit,
          'reset_date': e.resetDate,
        };
      } else {
        _state = HomeState.error;
        _errorMessage = e.toString();
      }
      
      
      if (tempConsultation != null) {
        _consultations.removeWhere((c) => c.id == tempConsultation!.id);
      }
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _state = HomeState.error;
      
      // Remover la consulta temporal
      if (tempConsultation != null) {
        _consultations.removeWhere((c) => c.id == tempConsultation!.id);
      }
      notifyListeners();
      return false;
    }
  }

  /// Obtener historial de consultas
  Future<void> loadChatHistory() async {
    try {
      _state = HomeState.loading;
      _errorMessage = null;
      notifyListeners();

      _consultations = await getChatHistoryUseCase.call();

      _state = HomeState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = HomeState.error;
      notifyListeners();
    }
  }

  /// Enviar mensaje a una sesión específica (para retomar conversaciones)
  Future<bool> sendMessageWithSession(String message, String existingSessionId) async {
    try {
      print('🔵 HomeNotifier - Retomando conversación con sessionId: $existingSessionId');
      
      _state = HomeState.loading;
      _errorMessage = null;
      notifyListeners();

      final result = await sendMessageUseCase.call(
        message: message,
        sessionId: existingSessionId,
      );

      print('🟢 HomeNotifier - Respuesta recibida para sesión: ${result.consultation.sessionId}');
      
      _currentConsultation = result.consultation;
      _currentResponse = result.response;

      _state = HomeState.success;
      notifyListeners();
      return true;
    } on ForbiddenException catch (e) {
      if (e.isQuotaLimit) {
        _state = HomeState.quotaExceeded;
        _errorMessage = e.message;
        _quotaLimitInfo = {
          'usage': e.usage,
          'limit': e.limit,
          'reset_date': e.resetDate,
        };
      } else {
        _state = HomeState.error;
        _errorMessage = e.toString();
      }
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _state = HomeState.error;
      notifyListeners();
      return false;
    }
  }

  /// Limpiar sesión actual
  void clearSession() {
    // Inicia un nuevo chat manteniendo el usuario autenticado
    _sessionId = null;
    _currentConsultation = null;
    _currentResponse = null;
    // El LoginRepository ya limpia el token en su método logout, no es necesario limpiar aquí.
    notifyListeners();
  }

  /// Reiniciar estado
  void reset() {
    _state = HomeState.initial;
    _consultations = [];
    _currentConsultation = null;
    _currentResponse = null;
    _sessionId = null; // mantiene la sesión limpia pero preserva userId
    _errorMessage = null;
    // El LoginRepository ya limpia el token en su método logout, no es necesario limpiar aquí.
    notifyListeners();
  }

  // ====================================================================
  // NUEVAS FUNCIONALIDADES: Gestión de Sesiones y Compartir al Foro
  // ====================================================================

  /// Crear nueva conversación (limpia la sesión actual)
  void startNewConversation() {
    _sessionId = null;
    _consultations = [];
    _currentConsultation = null;
    _currentResponse = null;
    _errorMessage = null;
    _quotaLimitInfo = null;
    _state = HomeState.initial;
    notifyListeners();
  }

  /// Obtener todas las sesiones del usuario
  Future<List<ChatSessionModel>> getChatSessions() async {
    try {
      if (_userId == null) {
        print('🔴 HomeNotifier - No hay userId para obtener sesiones');
        return [];
      }

      final response = await apiClient.get(
        '${ApiEndpoints.chat}/user/$_userId/sessions',
        queryParameters: {'limit': '20'},
      );

      if (response['success'] == true && response['sesiones'] != null) {
        final List<dynamic> data = response['sesiones'];
        return data.map((json) => ChatSessionModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('🔴 Error obteniendo sesiones: $e');
      return [];
    }
  }

  /// Cargar una sesión existente con su historial
  Future<void> loadSession(String sessionId) async {
    try {
      _state = HomeState.loading;
      _sessionId = sessionId;
      _errorMessage = null;
      notifyListeners();

      // Obtener historial de la sesión
      final response = await apiClient.get(
        '${ApiEndpoints.chat}/session/$sessionId/history',
      );

      if (response['success'] == true && response['mensajes'] != null) {
        final List<dynamic> messages = response['mensajes'];

        // Convertir mensajes a consultations
        _consultations = _convertMessagesToConsultations(messages);

        _state = HomeState.success;
        notifyListeners();
      } else {
        throw Exception('No se pudo cargar el historial de la sesión');
      }
    } catch (e) {
      _errorMessage = 'Error al cargar la sesión: ${e.toString()}';
      _state = HomeState.error;
      notifyListeners();
    }
  }

  /// Convertir mensajes de API a Consultations
  List<Consultation> _convertMessagesToConsultations(List<dynamic> messages) {
    final List<Consultation> consultations = [];

    for (int i = 0; i < messages.length; i++) {
      final message = messages[i];

      // Solo procesar mensajes del usuario
      if (message['rol'] == 'user') {
        final userMessage = message['mensaje'] as String;

        // Buscar la respuesta del asistente siguiente
        String assistantResponse = '';
        if (i + 1 < messages.length && messages[i + 1]['rol'] == 'assistant') {
          assistantResponse = messages[i + 1]['mensaje'] as String;
        }

        // Crear consultation
        consultations.add(
          Consultation(
            id: message['id'] ?? '${DateTime.now().millisecondsSinceEpoch}_$i',
            userId: _userId ?? '',
            query: userMessage,
            response: assistantResponse,
            sessionId: message['sesion_id'] ?? message['sesionId'] ?? _sessionId ?? '',
            createdAt: DateTime.parse(message['fecha'] ?? DateTime.now().toIso8601String()),
            status: 'completed',
          ),
        );
      }
    }

    return consultations;
  }

  /// Eliminar una sesión completamente
  Future<bool> deleteSession(String sessionId) async {
    try {
      await apiClient.delete('${ApiEndpoints.chat}/session/$sessionId');

      // Si es la sesión actual, limpiarla
      if (_sessionId == sessionId) {
        startNewConversation();
      }

      return true;
    } catch (e) {
      print('🔴 Error eliminando sesión: $e');
      _errorMessage = 'Error al eliminar la sesión';
      return false;
    }
  }

  /// Compartir la conversación actual al foro
  Future<bool> compartirConversacionAlForo({
    required String categoriaId,
    String? titulo,
  }) async {
    try {
      if (_sessionId == null || _userId == null) {
        throw Exception('No hay conversación activa para compartir');
      }

      if (_consultations.isEmpty) {
        throw Exception('No hay mensajes en la conversación para compartir');
      }

      await foroRepository.compartirConversacion(
        usuarioId: _userId!,
        sessionId: _sessionId!,
        categoriaId: categoriaId,
        titulo: titulo,
      );

      return true;
    } catch (e) {
      print('🔴 Error compartiendo conversación: $e');
      _errorMessage = e.toString();
      return false;
    }
  }

  /// Registrar preferencia de profesionista (Me interesa / No me interesa)
  Future<bool> registrarPreferenciaProfesionista({
    required String profesionistaId,
    required String profesionistaNombre,
    required String tipoInteraccion, // 'me_interesa', 'no_interesa', 'contacto'
    String? cluster,
  }) async {
    try {
      if (_userId == null) {
        print('🔴 HomeNotifier - No hay userId para registrar preferencia');
        return false;
      }

      final response = await apiClient.post(
        ApiEndpoints.profesionistasPreferencia,
        body: {
          'usuarioId': _userId!,
          'profesionistaId': profesionistaId,
          'profesionistaNombre': profesionistaNombre,
          'tipoInteraccion': tipoInteraccion,
          if (cluster != null) 'cluster': cluster,
        },
      );

      if (response['success'] == true) {
        final emoji = tipoInteraccion == 'me_interesa' ? '👍' : tipoInteraccion == 'no_interesa' ? '👎' : '📞';
        print('$emoji Preferencia registrada: $profesionistaNombre ($tipoInteraccion)');
        return true;
      }

      return false;
    } catch (e) {
      print('🔴 Error registrando preferencia: $e');
      return false;
    }
  }
}
