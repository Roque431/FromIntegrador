import 'package:flutter/material.dart';
import '../../data/models/mensaje_privado_model.dart';
import '../../data/repository/chat_privado_repository.dart';

enum ChatPrivadoState { initial, loading, success, error, sending }

class ChatPrivadoNotifier extends ChangeNotifier {
  final ChatPrivadoRepository _repository;
  String _currentUserId;
  bool _esAbogado;

  ChatPrivadoNotifier({
    required ChatPrivadoRepository repository,
    String? currentUserId,
    bool esAbogado = false,
  })  : _repository = repository,
        _currentUserId = currentUserId ?? '',
        _esAbogado = esAbogado;

  // Método para actualizar el userId después de login
  void setCurrentUserId(String userId) {
    print('📨 [ChatPrivado] setCurrentUserId: $userId (anterior: $_currentUserId)');
    _currentUserId = userId;
    notifyListeners();
  }

  void setEsAbogado(bool esAbogado) {
    _esAbogado = esAbogado;
    notifyListeners();
  }

  // Estado
  ChatPrivadoState _state = ChatPrivadoState.initial;
  ChatPrivadoState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == ChatPrivadoState.loading;
  bool get isSending => _state == ChatPrivadoState.sending;
  bool get hasError => _state == ChatPrivadoState.error;

  // Datos
  List<ConversacionPrivadaModel> _conversaciones = [];
  List<ConversacionPrivadaModel> get conversaciones => _conversaciones;

  List<MensajePrivadoModel> _mensajes = [];
  List<MensajePrivadoModel> get mensajes => _mensajes;

  ConversacionPrivadaModel? _conversacionActual;
  ConversacionPrivadaModel? get conversacionActual => _conversacionActual;

  int _totalNoLeidos = 0;
  int get totalNoLeidos => _totalNoLeidos;

  String get currentUserId => _currentUserId;
  bool get esAbogado => _esAbogado;

  // ========================================
  // Métodos públicos
  // ========================================

  /// Cargar todas las conversaciones del usuario
  Future<void> loadConversaciones() async {
    try {
      print('📨 [ChatPrivado] Cargando conversaciones para userId: $_currentUserId');
      
      if (_currentUserId.isEmpty) {
        print('❌ [ChatPrivado] userId está vacío, no se pueden cargar conversaciones');
        _errorMessage = 'Usuario no autenticado';
        _state = ChatPrivadoState.error;
        notifyListeners();
        return;
      }
      
      _state = ChatPrivadoState.loading;
      _errorMessage = null;
      notifyListeners();

      _conversaciones = await _repository.getConversaciones(_currentUserId);
      _totalNoLeidos = await _repository.getMensajesNoLeidos(_currentUserId);
      
      print('✅ [ChatPrivado] Conversaciones cargadas: ${_conversaciones.length}');

      _state = ChatPrivadoState.success;
      notifyListeners();
    } catch (e) {
      print('❌ [ChatPrivado] Error cargando conversaciones: $e');
      _errorMessage = e.toString();
      _state = ChatPrivadoState.error;
      notifyListeners();
    }
  }

  /// Cargar mensajes de una conversación
  Future<void> loadMensajes(ConversacionPrivadaModel conversacion) async {
    try {
      _state = ChatPrivadoState.loading;
      _errorMessage = null;
      _conversacionActual = conversacion;
      notifyListeners();

      _mensajes = await _repository.getMensajes(
        ciudadanoId: conversacion.ciudadanoId,
        abogadoId: conversacion.abogadoId,
      );

      // Marcar como leídos
      await _repository.marcarComoLeidos(
        ciudadanoId: conversacion.ciudadanoId,
        abogadoId: conversacion.abogadoId,
        lectorId: _currentUserId,
      );

      _state = ChatPrivadoState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = ChatPrivadoState.error;
      notifyListeners();
    }
  }

  /// Enviar un mensaje
  Future<bool> enviarMensaje(String contenido) async {
    if (_conversacionActual == null || contenido.trim().isEmpty) return false;

    try {
      _state = ChatPrivadoState.sending;
      notifyListeners();

      final mensaje = await _repository.enviarMensaje(
        ciudadanoId: _conversacionActual!.ciudadanoId,
        abogadoId: _conversacionActual!.abogadoId,
        remitenteId: _currentUserId,
        contenido: contenido.trim(),
      );

      if (mensaje != null) {
        _mensajes.add(mensaje);
        _state = ChatPrivadoState.success;
        notifyListeners();
        return true;
      }

      _state = ChatPrivadoState.error;
      _errorMessage = 'No se pudo enviar el mensaje';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ChatPrivadoState.error;
      notifyListeners();
      return false;
    }
  }

  /// Iniciar nueva conversación con un profesionista
  Future<ConversacionPrivadaModel?> iniciarConversacion({
    required String abogadoId,
    String? mensajeInicial,
  }) async {
    try {
      _state = ChatPrivadoState.loading;
      notifyListeners();

      final conversacion = await _repository.crearConversacion(
        ciudadanoId: _currentUserId,
        abogadoId: abogadoId,
        mensajeInicial: mensajeInicial,
      );

      if (conversacion != null) {
        // Agregar a la lista de conversaciones
        _conversaciones.insert(0, conversacion);
        _conversacionActual = conversacion;
        
        // Si hay mensaje inicial, cargarlo
        if (mensajeInicial != null) {
          await loadMensajes(conversacion);
        }
      }

      _state = ChatPrivadoState.success;
      notifyListeners();
      return conversacion;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ChatPrivadoState.error;
      notifyListeners();
      return null;
    }
  }

  /// Refrescar mensajes no leídos
  Future<void> refreshNoLeidos() async {
    _totalNoLeidos = await _repository.getMensajesNoLeidos(_currentUserId);
    notifyListeners();
  }

  /// Limpiar conversación actual
  void clearConversacionActual() {
    _conversacionActual = null;
    _mensajes = [];
    notifyListeners();
  }

  /// Limpiar todo
  void clear() {
    _state = ChatPrivadoState.initial;
    _conversaciones = [];
    _mensajes = [];
    _conversacionActual = null;
    _errorMessage = null;
    _totalNoLeidos = 0;
    notifyListeners();
  }
}
