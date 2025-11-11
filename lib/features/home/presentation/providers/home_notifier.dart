import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/consultation.dart';
import '../../domain/usecase/send_message_usecase.dart';
import '../../domain/usecase/get_chat_history_usecase.dart';

enum HomeState { initial, loading, success, error, quotaExceeded }

class HomeNotifier extends ChangeNotifier {
  final SendMessageUseCase sendMessageUseCase;
  final GetChatHistoryUseCase getChatHistoryUseCase;

  HomeNotifier({
    required this.sendMessageUseCase,
    required this.getChatHistoryUseCase,
  });

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
    // Declarar tempConsultation fuera del try para que sea accesible en catch
    Consultation? tempConsultation;
    
    try {
      print('🔵 HomeNotifier - sessionId antes de enviar: $_sessionId');
      
      // Crear consulta temporal para mostrar el mensaje del usuario inmediatamente
      tempConsultation = Consultation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: '',
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
      );

      print('🟢 HomeNotifier - sessionId después de recibir: ${result.consultation.sessionId}');
      
      // Actualizar la consulta temporal con la respuesta
      final index = _consultations.indexWhere((c) => c.id == tempConsultation!.id);
      if (index != -1) {
        _consultations[index] = result.consultation;
      } else {
        _consultations.add(result.consultation);
      }

      _currentConsultation = result.consultation;
      _currentResponse = result.response;
      _sessionId = result.consultation.sessionId;

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
      
      // Remover la consulta temporal
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

  /// Limpiar sesión actual
  void clearSession() {
    _sessionId = null;
    _currentConsultation = null;
    _currentResponse = null;
    notifyListeners();
  }

  /// Reiniciar estado
  void reset() {
    _state = HomeState.initial;
    _consultations = [];
    _currentConsultation = null;
    _currentResponse = null;
    _sessionId = null;
    _errorMessage = null;
    notifyListeners();
  }
}
