import 'package:flutter/material.dart';
import '../../data/models/models.dart';
import '../../data/repository/foro_repository.dart';

enum ForoState { initial, loading, success, error }

class ForoNotifier extends ChangeNotifier {
  final ForoRepository _repository;
  final String? _currentUserId;

  ForoNotifier({
    required ForoRepository repository,
    String? currentUserId,
  })  : _repository = repository,
        _currentUserId = currentUserId;

  // Estado
  ForoState _state = ForoState.initial;
  ForoState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == ForoState.loading;
  bool get hasError => _state == ForoState.error;

  // Datos
  List<CategoriaModel> _categorias = [];
  List<CategoriaModel> get categorias => _categorias;

  List<PublicacionModel> _publicaciones = [];
  List<PublicacionModel> get publicaciones => _publicaciones;

  PublicacionModel? _publicacionActual;
  PublicacionModel? get publicacionActual => _publicacionActual;

  List<ComentarioModel> _comentariosActuales = [];
  List<ComentarioModel> get comentariosActuales => _comentariosActuales;

  String? _categoriaSeleccionada;
  String? get categoriaSeleccionada => _categoriaSeleccionada;

  String _filtroActual = 'Recientes';
  String get filtroActual => _filtroActual;

  // ========================================
  // Métodos públicos
  // ========================================

  /// Cargar categorías del foro
  Future<void> loadCategorias() async {
    try {
      _state = ForoState.loading;
      _errorMessage = null;
      notifyListeners();

      _categorias = await _repository.getCategorias();

      _state = ForoState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = ForoState.error;
      notifyListeners();
    }
  }

  /// Cargar publicaciones (opcionalmente filtradas por categoría)
  Future<void> loadPublicaciones({String? categoriaId}) async {
    try {
      _state = ForoState.loading;
      _errorMessage = null;
      notifyListeners();

      _publicaciones = await _repository.getPublicaciones(
        categoriaId: categoriaId ?? _categoriaSeleccionada,
        usuarioId: _currentUserId,
      );

      // Aplicar ordenamiento según filtro
      _sortPublicaciones();

      _state = ForoState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = ForoState.error;
      notifyListeners();
    }
  }

  /// Cargar publicación con comentarios
  Future<void> loadPublicacion(String publicacionId) async {
    try {
      _state = ForoState.loading;
      _errorMessage = null;
      notifyListeners();

      final result = await _repository.getPublicacion(
        publicacionId,
        usuarioId: _currentUserId,
      );

      _publicacionActual = result['publicacion'] as PublicacionModel;
      _comentariosActuales = result['comentarios'] as List<ComentarioModel>;

      _state = ForoState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = ForoState.error;
      notifyListeners();
    }
  }

  /// Crear nueva publicación
  Future<PublicacionModel?> crearPublicacion({
    required String titulo,
    required String contenido,
    required String categoriaId,
  }) async {
    if (_currentUserId == null) {
      _errorMessage = 'Usuario no autenticado';
      _state = ForoState.error;
      notifyListeners();
      return null;
    }

    try {
      _state = ForoState.loading;
      notifyListeners();

      final publicacion = await _repository.crearPublicacion(
        usuarioId: _currentUserId,
        titulo: titulo,
        contenido: contenido,
        categoriaId: categoriaId,
      );

      // Agregar al inicio de la lista
      _publicaciones.insert(0, publicacion);

      _state = ForoState.success;
      notifyListeners();
      return publicacion;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ForoState.error;
      notifyListeners();
      return null;
    }
  }

  /// Agregar comentario
  Future<ComentarioModel?> agregarComentario({
    required String publicacionId,
    required String contenido,
  }) async {
    if (_currentUserId == null) {
      _errorMessage = 'Usuario no autenticado';
      _state = ForoState.error;
      notifyListeners();
      return null;
    }

    try {
      final comentario = await _repository.crearComentario(
        publicacionId: publicacionId,
        usuarioId: _currentUserId,
        contenido: contenido,
      );

      // Agregar al final de comentarios
      _comentariosActuales.add(comentario);

      // Actualizar contador en publicación actual
      if (_publicacionActual != null && _publicacionActual!.id == publicacionId) {
        _publicacionActual = _publicacionActual!.copyWith(
          comentarios: _publicacionActual!.comentarios + 1,
        );
      }

      // Actualizar contador en la lista
      final idx = _publicaciones.indexWhere((p) => p.id == publicacionId);
      if (idx != -1) {
        _publicaciones[idx] = _publicaciones[idx].copyWith(
          comentarios: _publicaciones[idx].comentarios + 1,
        );
      }

      notifyListeners();
      return comentario;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Toggle like en publicación
  Future<void> toggleLike(String publicacionId) async {
    if (_currentUserId == null) return;

    try {
      final result = await _repository.toggleLike(
        publicacionId: publicacionId,
        usuarioId: _currentUserId,
      );

      final liked = result['liked'] as bool;
      final totalLikes = result['totalLikes'] as int;

      // Actualizar publicación actual
      if (_publicacionActual != null && _publicacionActual!.id == publicacionId) {
        _publicacionActual = _publicacionActual!.copyWith(
          yaLeDioLike: liked,
          likes: totalLikes,
        );
      }

      // Actualizar en la lista
      final idx = _publicaciones.indexWhere((p) => p.id == publicacionId);
      if (idx != -1) {
        _publicaciones[idx] = _publicaciones[idx].copyWith(
          yaLeDioLike: liked,
          likes: totalLikes,
        );
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Buscar publicaciones
  Future<void> buscarPublicaciones(String query) async {
    if (query.isEmpty) {
      await loadPublicaciones();
      return;
    }

    try {
      _state = ForoState.loading;
      _errorMessage = null;
      notifyListeners();

      _publicaciones = await _repository.buscarPublicaciones(
        query: query,
        categoriaId: _categoriaSeleccionada,
      );

      _state = ForoState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = ForoState.error;
      notifyListeners();
    }
  }

  /// Cargar mis publicaciones
  Future<void> loadMisPublicaciones() async {
    if (_currentUserId == null) return;

    try {
      _state = ForoState.loading;
      _errorMessage = null;
      notifyListeners();

      _publicaciones = await _repository.getMisPublicaciones(_currentUserId);

      _state = ForoState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = ForoState.error;
      notifyListeners();
    }
  }

  // ========================================
  // Filtros y ordenamiento
  // ========================================

  void setCategoriaSeleccionada(String? categoriaId) {
    _categoriaSeleccionada = categoriaId;
    loadPublicaciones(categoriaId: categoriaId);
  }

  void setFiltro(String filtro) {
    _filtroActual = filtro;
    _sortPublicaciones();
    notifyListeners();
  }

  void _sortPublicaciones() {
    switch (_filtroActual) {
      case 'Populares':
        _publicaciones.sort((a, b) => b.likes.compareTo(a.likes));
        break;
      case 'Mas Utiles':
        _publicaciones.sort((a, b) => b.comentarios.compareTo(a.comentarios));
        break;
      case 'Recientes':
      default:
        _publicaciones.sort((a, b) => b.fecha.compareTo(a.fecha));
        break;
    }
  }

  /// Limpiar estado
  void clear() {
    _state = ForoState.initial;
    _categorias = [];
    _publicaciones = [];
    _publicacionActual = null;
    _comentariosActuales = [];
    _errorMessage = null;
    notifyListeners();
  }
}
