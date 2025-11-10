import 'package:flutter/material.dart';
import '../../domain/entities/consultation.dart';
import '../../domain/usecase/send_message_usecase.dart';
import '../../domain/usecase/get_chat_history_usecase.dart';

enum HomeState { initial, loading, success, error }

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

  // Error
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Estado de carga
  bool get isLoading => _state == HomeState.loading;
  bool get hasError => _state == HomeState.error;

  /// Enviar mensaje a la API
  Future<bool> sendMessage(String message) async {
    try {
      _state = HomeState.loading;
      _errorMessage = null;
      notifyListeners();

      final result = await sendMessageUseCase.call(
        message: message,
        sessionId: _sessionId,
      );

      _currentConsultation = result.consultation;
      _currentResponse = result.response;
      _sessionId = result.consultation.sessionId;

      // Agregar a la lista de consultas
      _consultations.insert(0, result.consultation);

      _state = HomeState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _state = HomeState.error;
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
