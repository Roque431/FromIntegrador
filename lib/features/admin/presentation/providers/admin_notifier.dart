import 'package:flutter/material.dart';
import '../../domain/usecases/admin_usecases.dart';
import '../../data/models/admin_stats_model.dart';

enum AdminLoadingState { idle, loading, error }

class AdminNotifier extends ChangeNotifier {
  final GetAdminStatsUseCase getAdminStatsUseCase;
  final ValidateProfileUseCase validateProfileUseCase;
  final ModerateContentUseCase moderateContentUseCase;
  final GetPendingItemsUseCase getPendingItemsUseCase;

  AdminNotifier({
    required this.getAdminStatsUseCase,
    required this.validateProfileUseCase,
    required this.moderateContentUseCase,
    required this.getPendingItemsUseCase,
  });

  // Estados
  AdminLoadingState _loadingState = AdminLoadingState.idle;
  AdminStatsModel? _stats;
  List<Map<String, dynamic>> _pendingProfiles = [];
  List<Map<String, dynamic>> _pendingReports = [];
  String? _errorMessage;

  // Getters
  AdminLoadingState get loadingState => _loadingState;
  AdminStatsModel? get stats => _stats;
  List<Map<String, dynamic>> get pendingProfiles => _pendingProfiles;
  List<Map<String, dynamic>> get pendingReports => _pendingReports;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _loadingState == AdminLoadingState.loading;
  bool get hasError => _loadingState == AdminLoadingState.error;

  /// Cargar estadísticas del dashboard
  Future<void> loadAdminStats() async {
    _loadingState = AdminLoadingState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _stats = await getAdminStatsUseCase.call();
      _loadingState = AdminLoadingState.idle;
    } catch (e) {
      _errorMessage = e.toString();
      _loadingState = AdminLoadingState.error;
    }
    notifyListeners();
  }

  /// Cargar elementos pendientes (perfiles y reportes)
  Future<void> loadPendingItems() async {
    try {
      final result = await getPendingItemsUseCase.call();
      _pendingProfiles = result.profiles;
      _pendingReports = result.reports;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _loadingState = AdminLoadingState.error;
      notifyListeners();
    }
  }

  /// Validar perfil de abogado
  Future<bool> validateProfile(String profileId, bool approved) async {
    try {
      final success = await validateProfileUseCase.call(profileId, approved);
      if (success) {
        // Remover el perfil de la lista de pendientes
        _pendingProfiles.removeWhere((profile) => profile['id'] == profileId);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Moderar contenido
  Future<bool> moderateContent(String contentId, String action) async {
    try {
      final success = await moderateContentUseCase.call(contentId, action);
      if (success) {
        // Remover el reporte de la lista de pendientes
        _pendingReports.removeWhere((report) => report['id'] == contentId);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Limpiar error
  void clearError() {
    _errorMessage = null;
    _loadingState = AdminLoadingState.idle;
    notifyListeners();
  }

  /// Recargar todos los datos
  Future<void> refreshAll() async {
    await Future.wait([
      loadAdminStats(),
      loadPendingItems(),
    ]);
  }
}