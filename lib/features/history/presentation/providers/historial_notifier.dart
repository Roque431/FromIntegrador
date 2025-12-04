import 'package:flutter/material.dart';
import '../../data/models/conversacion_model.dart';
import '../../data/repository/historial_repository.dart';

enum HistorialState { initial, loading, success, error }

class HistorialNotifier extends ChangeNotifier {
  final HistorialRepository _repository;
  final String? _currentUserId;

  HistorialNotifier({
    required HistorialRepository repository,
    String? currentUserId,
  })  : _repository = repository,
        _currentUserId = currentUserId;

  // Estado
  HistorialState _state = HistorialState.initial;
  HistorialState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == HistorialState.loading;
  bool get hasError => _state == HistorialState.error;

  // Datos
  List<ConversacionModel> _conversaciones = [];
  List<ConversacionModel> get conversaciones => _conversaciones;

  ConversacionDetalleModel? _conversacionActual;
  ConversacionDetalleModel? get conversacionActual => _conversacionActual;

  // Filtros
  String? _filtroCluster;
  String? get filtroCluster => _filtroCluster;

  String _busqueda = '';
  String get busqueda => _busqueda;

  /// Conversaciones filtradas
  List<ConversacionModel> get conversacionesFiltradas {
    var result = _conversaciones;

    // Filtrar por cluster
    if (_filtroCluster != null) {
      result = result.where((c) => c.clusterPrincipal == _filtroCluster).toList();
    }

    // Filtrar por búsqueda
    if (_busqueda.isNotEmpty) {
      final query = _busqueda.toLowerCase();
      result = result.where((c) {
        return (c.titulo?.toLowerCase().contains(query) ?? false) ||
            (c.ultimoMensaje?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return result;
  }

  // ========================================
  // Métodos públicos
  // ========================================

  /// Cargar conversaciones del usuario
  Future<void> loadConversaciones() async {
    if (_currentUserId == null) {
      _errorMessage = 'Usuario no autenticado';
      _state = HistorialState.error;
      notifyListeners();
      return;
    }

    try {
      _state = HistorialState.loading;
      _errorMessage = null;
      notifyListeners();

      _conversaciones = await _repository.getConversaciones(_currentUserId);

      _state = HistorialState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = HistorialState.error;
      notifyListeners();
    }
  }

  /// Cargar detalle de una conversación
  Future<void> loadConversacionDetalle(String sessionId) async {
    try {
      _state = HistorialState.loading;
      _errorMessage = null;
      notifyListeners();

      _conversacionActual = await _repository.getConversacionDetalle(sessionId);

      _state = HistorialState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = HistorialState.error;
      notifyListeners();
    }
  }

  /// Establecer filtro de cluster
  void setFiltroCluster(String? cluster) {
    _filtroCluster = cluster;
    notifyListeners();
  }

  /// Establecer búsqueda
  void setBusqueda(String query) {
    _busqueda = query;
    notifyListeners();
  }

  /// Limpiar filtros
  void clearFiltros() {
    _filtroCluster = null;
    _busqueda = '';
    notifyListeners();
  }

  /// Limpiar estado
  void clear() {
    _state = HistorialState.initial;
    _conversaciones = [];
    _conversacionActual = null;
    _errorMessage = null;
    _filtroCluster = null;
    _busqueda = '';
    notifyListeners();
  }
}
