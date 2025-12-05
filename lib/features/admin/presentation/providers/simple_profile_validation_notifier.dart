import 'package:flutter/foundation.dart';
import '../../data/models/profile_validation_model.dart';

enum ProfileValidationLoadingState { idle, loading, refreshing, processing }

/// Versión simplificada del ProfileValidationNotifier para testing
/// No requiere inyección de dependencias ni casos de uso
class SimpleProfileValidationNotifier extends ChangeNotifier {
  // Estados
  ProfileValidationLoadingState _loadingState = ProfileValidationLoadingState.idle;
  ProfileValidationLoadingState get loadingState => _loadingState;
  bool get isLoading => _loadingState == ProfileValidationLoadingState.loading;
  bool get isRefreshing => _loadingState == ProfileValidationLoadingState.refreshing;
  bool get isProcessing => _loadingState == ProfileValidationLoadingState.processing;

  // Lista de perfiles pendientes
  List<ProfileValidationModel> _profiles = [];
  List<ProfileValidationModel> get profiles => _profiles;
  List<ProfileValidationModel> get perfiles => _profiles; // Alias para compatibilidad

  // Perfil seleccionado
  ProfileValidationModel? _perfilSeleccionado;
  ProfileValidationModel? get perfilSeleccionado => _perfilSeleccionado;

  // Filtros
  ProfileType _filtroActivo = ProfileType.abogado;
  ProfileType get filtroActivo => _filtroActivo;
  
  String _selectedType = 'Abogado';
  String get selectedType => _selectedType;

  // Stats mock
  Map<String, int> _stats = {};
  Map<String, int> get stats => _stats;

  // Error handling
  String? _error;
  String? get error => _error;
  String? get errorMessage => _error; // Alias para compatibilidad
  bool get hasError => _error != null;

  // Perfiles en proceso
  Set<String> _perfilesEnProceso = {};

  // Datos de prueba con modelo real
  static List<ProfileValidationModel> _mockProfiles = [
    ProfileValidationModel(
      id: '1',
      nombre: 'Juan',
      apellido: 'Pérez',
      tipo: ProfileType.abogado,
      cedulaProfesional: '12345678',
      especialidad: 'Derecho Civil',
      anosExperiencia: 5,
      documentos: [
        DocumentModel(
          id: 'doc1',
          tipo: DocumentType.titulo,
          nombre: 'Título Profesional',
          url: 'https://example.com/titulo1.pdf',
          esVerificado: false,
        ),
        DocumentModel(
          id: 'doc2', 
          tipo: DocumentType.cedula,
          nombre: 'Cédula Profesional',
          url: 'https://example.com/cedula1.pdf',
          esVerificado: false,
        ),
      ],
      fechaSolicitud: DateTime.now().subtract(const Duration(days: 2)),
      status: ValidationStatus.pendiente,
    ),
    ProfileValidationModel(
      id: '2',
      nombre: 'María',
      apellido: 'González',
      tipo: ProfileType.abogado,
      cedulaProfesional: '87654321',
      especialidad: 'Derecho Laboral',
      anosExperiencia: 8,
      documentos: [
        DocumentModel(
          id: 'doc3',
          tipo: DocumentType.titulo,
          nombre: 'Título Profesional',
          url: 'https://example.com/titulo2.pdf',
          esVerificado: false,
        ),
        DocumentModel(
          id: 'doc4',
          tipo: DocumentType.cedula,
          nombre: 'Cédula Profesional', 
          url: 'https://example.com/cedula2.pdf',
          esVerificado: false,
        ),
      ],
      fechaSolicitud: DateTime.now().subtract(const Duration(days: 1)),
      status: ValidationStatus.pendiente,
    ),
    ProfileValidationModel(
      id: '3',
      nombre: 'Carlos',
      apellido: 'Rodríguez',
      tipo: ProfileType.anunciante,
      cedulaProfesional: '11223344',
      especialidad: 'Servicios Jurídicos',
      anosExperiencia: 3,
      documentos: [
        DocumentModel(
          id: 'doc5',
          tipo: DocumentType.certificacion,
          nombre: 'Certificación Comercial',
          url: 'https://example.com/cert1.pdf',
          esVerificado: false,
        ),
      ],
      fechaSolicitud: DateTime.now().subtract(const Duration(hours: 12)),
      status: ValidationStatus.pendiente,
    ),
  ];

  /// Cargar perfiles pendientes con datos mock
  Future<void> loadProfiles({bool refresh = false}) async {
    if (refresh) {
      _loadingState = ProfileValidationLoadingState.refreshing;
    } else {
      _loadingState = ProfileValidationLoadingState.loading;
    }
    _error = null;
    notifyListeners();

    try {
      // Simular carga de datos
      await Future.delayed(const Duration(milliseconds: 1000));
      
      _profiles = List.from(_mockProfiles);
      _updateStats();
      
      _loadingState = ProfileValidationLoadingState.idle;
      notifyListeners();
    } catch (e) {
      _error = 'Error al cargar perfiles: $e';
      _loadingState = ProfileValidationLoadingState.idle;
      notifyListeners();
    }
  }

  /// Refrescar perfiles
  Future<void> refresh() async {
    await loadProfiles(refresh: true);
  }

  /// Actualizar filtro por tipo
  void setSelectedType(String type) {
    _selectedType = type;
    notifyListeners();
  }

  /// Cambiar filtro (método para compatibilidad)
  void cambiarFiltro(ProfileType tipo) {
    _filtroActivo = tipo;
    
    // Actualizar también selectedType para compatibilidad
    switch (tipo) {
      case ProfileType.abogado:
        _selectedType = 'Abogado';
        break;
      case ProfileType.anunciante:
        _selectedType = 'Anunciante';
        break;
    }
    
    notifyListeners();
  }

  /// Obtener perfiles filtrados
  List<ProfileValidationModel> getFilteredProfiles() {
    if (_filtroActivo == ProfileType.abogado) {
      return _profiles.where((profile) => profile.tipo == ProfileType.abogado).toList();
    } else {
      return _profiles.where((profile) => profile.tipo == ProfileType.anunciante).toList();
    }
  }

  /// Obtener perfiles filtrados (alias para compatibilidad)
  List<ProfileValidationModel> get perfilesFiltrados => getFilteredProfiles();

  /// Obtener perfiles de abogados
  List<ProfileValidationModel> get abogados => 
      _profiles.where((profile) => profile.tipo == ProfileType.abogado).toList();

  /// Obtener perfiles de anunciantes  
  List<ProfileValidationModel> get anunciantes => 
      _profiles.where((profile) => profile.tipo == ProfileType.anunciante).toList();

  /// Seleccionar perfil
  void seleccionarPerfil(String profileId) {
    try {
      _perfilSeleccionado = _profiles.firstWhere((p) => p.id == profileId);
    } catch (e) {
      _perfilSeleccionado = _profiles.isNotEmpty ? _profiles.first : null;
    }
    notifyListeners();
  }

  /// Verificar si perfil está en proceso
  bool isPerfilEnProceso(String profileId) {
    return _perfilesEnProceso.contains(profileId);
  }

  /// Aprobar perfil (método para compatibilidad)
  Future<bool> aprobarPerfil(String profileId) async {
    try {
      await approveProfile(profileId, 'admin123');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Rechazar perfil (método para compatibilidad)
  Future<bool> rechazarPerfil(String profileId, String motivo) async {
    try {
      await rejectProfile(profileId, 'admin123', motivo);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Aprobar perfil
  Future<void> approveProfile(String profileId, String adminId) async {
    _perfilesEnProceso.add(profileId);
    _loadingState = ProfileValidationLoadingState.processing;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      final profileIndex = _profiles.indexWhere((p) => p.id == profileId);
      if (profileIndex != -1) {
        _profiles[profileIndex] = _profiles[profileIndex].copyWith(
          status: ValidationStatus.aprobado,
        );
      }
      
      _perfilesEnProceso.remove(profileId);
      _updateStats();
      _loadingState = ProfileValidationLoadingState.idle;
      notifyListeners();
    } catch (e) {
      _perfilesEnProceso.remove(profileId);
      _error = 'Error al aprobar perfil: $e';
      _loadingState = ProfileValidationLoadingState.idle;
      notifyListeners();
    }
  }

  /// Rechazar perfil
  Future<void> rejectProfile(String profileId, String adminId, String reason) async {
    _perfilesEnProceso.add(profileId);
    _loadingState = ProfileValidationLoadingState.processing;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      final profileIndex = _profiles.indexWhere((p) => p.id == profileId);
      if (profileIndex != -1) {
        _profiles[profileIndex] = _profiles[profileIndex].copyWith(
          status: ValidationStatus.rechazado,
          motivoRechazo: reason,
        );
      }
      
      _perfilesEnProceso.remove(profileId);
      _updateStats();
      _loadingState = ProfileValidationLoadingState.idle;
      notifyListeners();
    } catch (e) {
      _perfilesEnProceso.remove(profileId);
      _error = 'Error al rechazar perfil: $e';
      _loadingState = ProfileValidationLoadingState.idle;
      notifyListeners();
    }
  }

  /// Actualizar estadísticas
  void _updateStats() {
    _stats = {
      'total': _profiles.length,
      'pending': _profiles.where((p) => p.status == ValidationStatus.pendiente).length,
      'approved': _profiles.where((p) => p.status == ValidationStatus.aprobado).length,
      'rejected': _profiles.where((p) => p.status == ValidationStatus.rechazado).length,
    };
  }

  /// Limpiar error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}