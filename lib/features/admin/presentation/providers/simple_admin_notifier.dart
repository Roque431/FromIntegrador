import 'package:flutter/material.dart';
import '../../data/datasources/admin_datasource.dart';

class SimpleAdminNotifier extends ChangeNotifier {
  final AdminDataSource adminDataSource;
  
  SimpleAdminNotifier({required this.adminDataSource});
  
  bool _isLoading = false;
  String? _errorMessage;
  
  // Datos reales desde la API
  Map<String, dynamic> _stats = {
    'totalUsers': 0,
    'totalLawyers': 0,
    'totalConsultations': 0,
    'pendingValidations': 0,
    'monthlyRevenue': 0.0,
    'activeUsers': 0,
  };

  List<Map<String, dynamic>> _pendingProfiles = [];
  List<Map<String, dynamic>> _pendingReports = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic> get stats => _stats;
  List<Map<String, dynamic>> get pendingProfiles => _pendingProfiles;
  List<Map<String, dynamic>> get pendingReports => _pendingReports;

  // Cargar estadísticas desde la API
  Future<void> loadAdminStats() async {
    _setLoading(true);
    
    try {
      // Cargar estadísticas
      final statsModel = await adminDataSource.getAdminStats();
      
      _stats = {
        'totalUsers': statsModel.usuariosActivos,
        'totalLawyers': statsModel.abogadosVerificados,
        'totalConsultations': statsModel.consultasDelMes,
        'pendingValidations': _pendingProfiles.length,
        'activeUsers': statsModel.usuariosActivos,
        'crecimientoUsuarios': statsModel.crecimientoUsuarios,
        'crecimientoAbogados': statsModel.crecimientoAbogados,
      };
      
      // Cargar perfiles pendientes
      _pendingProfiles = await adminDataSource.getPendingProfiles();
      
      // Cargar reportes pendientes
      _pendingReports = await adminDataSource.getPendingReports();
      
      _setError(null);
    } catch (e) {
      _setError(e.toString());
      print('Error al cargar estadísticas de admin: $e');
    } finally {
      _setLoading(false);
    }
    
    notifyListeners();
  }

  Future<void> validateProfile(String profileId, bool approve) async {
    _setLoading(true);
    
    try {
      final success = await adminDataSource.validateProfile(profileId, approve);
      
      if (success) {
        // Remover de la lista de pendientes
        _pendingProfiles.removeWhere((profile) => profile['id'] == profileId);
        _setError(null);
      } else {
        _setError('No se pudo validar el perfil');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    
    notifyListeners();
  }

  Future<void> moderateReport(String reportId, String action) async {
    _setLoading(true);
    
    try {
      final success = await adminDataSource.moderateContent(reportId, action);
      
      if (success) {
        // Remover de la lista de pendientes
        _pendingReports.removeWhere((report) => report['id'] == reportId);
        _setError(null);
      } else {
        _setError('No se pudo moderar el reporte');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
    
    _setLoading(false);
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }
}