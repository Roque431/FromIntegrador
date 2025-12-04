import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../../../login/domain/repository/login_repository.dart'; // NUEVO
import '../../domain/entities/consultation.dart';
import '../../domain/usecase/send_message_usecase.dart';
import '../../domain/usecase/get_chat_history_usecase.dart';

enum HomeState { initial, loading, success, error, quotaExceeded }

class HomeNotifier extends ChangeNotifier {
  final SendMessageUseCase sendMessageUseCase;
  final GetChatHistoryUseCase getChatHistoryUseCase;
  final LoginRepository loginRepository; // Para obtener token y userId

  HomeNotifier({
    required this.sendMessageUseCase,
    required this.getChatHistoryUseCase,
    required this.loginRepository,
  }) {
    _loadSessionIdAndUser(); // ¡Cambiado el nombre para reflejar la carga de ambos!
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
}
