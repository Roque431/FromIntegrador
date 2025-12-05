import 'package:flutter/foundation.dart';
import '../../data/models/profile_validation_model.dart';
import '../../domain/usecases/profile_validation_usecases.dart';

enum ProfileValidationLoadingState { idle, loading, refreshing, processing }

class ProfileValidationNotifier extends ChangeNotifier {
  final GetProfilesPendientesUseCase getProfilesPendientesUseCase;
  final GetProfileByIdUseCase getProfileByIdUseCase;
  final AprobarPerfilUseCase aprobarPerfilUseCase;
  final RechazarPerfilUseCase rechazarPerfilUseCase;
  final GetProfileStatsUseCase getProfileStatsUseCase;
  final ValidateAllDocumentsUseCase validateAllDocumentsUseCase;

  ProfileValidationNotifier({
    required this.getProfilesPendientesUseCase,
    required this.getProfileByIdUseCase,
    required this.aprobarPerfilUseCase,
    required this.rechazarPerfilUseCase,
    required this.getProfileStatsUseCase,
    required this.validateAllDocumentsUseCase,
  });

  // Estados
  ProfileValidationLoadingState _loadingState = ProfileValidationLoadingState.idle;
  ProfileValidationLoadingState get loadingState => _loadingState;
  bool get isLoading => _loadingState == ProfileValidationLoadingState.loading;
  bool get isRefreshing => _loadingState == ProfileValidationLoadingState.refreshing;
  bool get isProcessing => _loadingState == ProfileValidationLoadingState.processing;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  // Datos
  List<ProfileValidationModel> _perfiles = [];
  List<ProfileValidationModel> get perfiles => _perfiles;

  List<ProfileValidationModel> _abogados = [];
  List<ProfileValidationModel> get abogados => _abogados;

  List<ProfileValidationModel> _anunciantes = [];
  List<ProfileValidationModel> get anunciantes => _anunciantes;

  ProfileType _filtroActivo = ProfileType.abogado;
  ProfileType get filtroActivo => _filtroActivo;

  ProfileValidationModel? _perfilSeleccionado;
  ProfileValidationModel? get perfilSeleccionado => _perfilSeleccionado;

  ProfileValidationStats? _stats;
  ProfileValidationStats? get stats => _stats;

  Set<String> _perfilesEnProceso = {};
  Set<String> get perfilesEnProceso => _perfilesEnProceso;

  // Métodos principales
  Future<void> loadProfiles({bool refresh = false}) async {
    if (refresh) {
      _loadingState = ProfileValidationLoadingState.refreshing;
    } else {
      _loadingState = ProfileValidationLoadingState.loading;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      // Cargar todos los perfiles
      final todosLosPerfiles = await getProfilesPendientesUseCase.execute();
      _perfiles = todosLosPerfiles;

      // Separar por tipo
      _abogados = todosLosPerfiles
          .where((perfil) => perfil.tipo == ProfileType.abogado)
          .toList();
      
      _anunciantes = todosLosPerfiles
          .where((perfil) => perfil.tipo == ProfileType.anunciante)
          .toList();

      // Cargar estadísticas
      _stats = await getProfileStatsUseCase.execute();
      
      _loadingState = ProfileValidationLoadingState.idle;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _loadingState = ProfileValidationLoadingState.idle;
      notifyListeners();
    }
  }

  void cambiarFiltro(ProfileType nuevoFiltro) {
    if (_filtroActivo != nuevoFiltro) {
      _filtroActivo = nuevoFiltro;
      _perfilSeleccionado = null;
      notifyListeners();
    }
  }

  List<ProfileValidationModel> get perfilesFiltrados {
    switch (_filtroActivo) {
      case ProfileType.abogado:
        return _abogados;
      case ProfileType.anunciante:
        return _anunciantes;
    }
  }

  Future<void> seleccionarPerfil(String perfilId) async {
    try {
      _perfilSeleccionado = await getProfileByIdUseCase.execute(perfilId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> aprobarPerfil(String perfilId) async {
    if (_perfilesEnProceso.contains(perfilId)) return false;

    _perfilesEnProceso.add(perfilId);
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await aprobarPerfilUseCase.execute(perfilId);
      
      if (success) {
        // Remover el perfil de las listas
        _perfiles.removeWhere((perfil) => perfil.id == perfilId);
        _abogados.removeWhere((perfil) => perfil.id == perfilId);
        _anunciantes.removeWhere((perfil) => perfil.id == perfilId);
        
        // Limpiar selección si era el perfil seleccionado
        if (_perfilSeleccionado?.id == perfilId) {
          _perfilSeleccionado = null;
        }
        
        // Actualizar estadísticas
        _actualizarEstadisticas();
      }

      _perfilesEnProceso.remove(perfilId);
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      _perfilesEnProceso.remove(perfilId);
      notifyListeners();
      return false;
    }
  }

  Future<bool> rechazarPerfil(String perfilId, String motivo) async {
    if (_perfilesEnProceso.contains(perfilId)) return false;

    _perfilesEnProceso.add(perfilId);
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await rechazarPerfilUseCase.execute(perfilId, motivo);
      
      if (success) {
        // Remover el perfil de las listas
        _perfiles.removeWhere((perfil) => perfil.id == perfilId);
        _abogados.removeWhere((perfil) => perfil.id == perfilId);
        _anunciantes.removeWhere((perfil) => perfil.id == perfilId);
        
        // Limpiar selección si era el perfil seleccionado
        if (_perfilSeleccionado?.id == perfilId) {
          _perfilSeleccionado = null;
        }
        
        // Actualizar estadísticas
        _actualizarEstadisticas();
      }

      _perfilesEnProceso.remove(perfilId);
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      _perfilesEnProceso.remove(perfilId);
      notifyListeners();
      return false;
    }
  }

  bool isPerfilEnProceso(String perfilId) {
    return _perfilesEnProceso.contains(perfilId);
  }

  void limpiarError() {
    _errorMessage = null;
    notifyListeners();
  }

  void limpiarSeleccion() {
    _perfilSeleccionado = null;
    notifyListeners();
  }

  void _actualizarEstadisticas() {
    if (_stats != null) {
      _stats = ProfileValidationStats(
        totalPendientes: _perfiles.length,
        abogadosPendientes: _abogados.length,
        anunciantesPendientes: _anunciantes.length,
        perfilesMasAntiguos: _stats!.perfilesMasAntiguos
            .where((perfil) => _perfiles.any((p) => p.id == perfil.id))
            .toList(),
      );
    }
  }

  // Método para refrescar todo
  Future<void> refresh() async {
    await loadProfiles(refresh: true);
  }

  // Limpiar todo al dispose
  @override
  void dispose() {
    _perfilesEnProceso.clear();
    super.dispose();
  }
}