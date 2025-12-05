import 'package:flutter/material.dart';

class SimpleAdminNotifier extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  
  // Estados simulados para testing
  final Map<String, dynamic> _stats = {
    'totalUsers': 1250,
    'totalLawyers': 85,
    'totalConsultations': 2340,
    'pendingValidations': 12,
    'monthlyRevenue': 15750.50,
    'activeUsers': 892,
  };

  final List<Map<String, dynamic>> _pendingProfiles = [
    {
      'id': '1',
      'name': 'Dr. Juan Pérez García',
      'email': 'juan.perez@email.com',
      'cedula': '12345678',
      'especialidad': 'Derecho Civil',
      'experiencia': '5 años',
      'status': 'pending',
      'submittedAt': '2024-12-03 10:30:00',
    },
    {
      'id': '2', 
      'name': 'Lic. María González López',
      'email': 'maria.gonzalez@email.com',
      'cedula': '87654321',
      'especialidad': 'Derecho Penal',
      'experiencia': '8 años',
      'status': 'pending',
      'submittedAt': '2024-12-03 14:15:00',
    },
  ];

  final List<Map<String, dynamic>> _pendingReports = [
    {
      'id': '1',
      'type': 'inappropriate_content',
      'reportedBy': 'usuario123',
      'targetUser': 'abogado456',
      'description': 'Contenido inapropiado en comentario',
      'status': 'pending',
      'reportedAt': '2024-12-03 09:45:00',
    },
    {
      'id': '2',
      'type': 'spam',
      'reportedBy': 'cliente789',
      'targetUser': 'consultor101',
      'description': 'Envío masivo de mensajes no solicitados',
      'status': 'pending',
      'reportedAt': '2024-12-03 16:20:00',
    },
  ];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic> get stats => _stats;
  List<Map<String, dynamic>> get pendingProfiles => _pendingProfiles;
  List<Map<String, dynamic>> get pendingReports => _pendingReports;

  // Métodos simulados
  Future<void> loadAdminStats() async {
    _setLoading(true);
    
    // Simular carga de datos
    await Future.delayed(const Duration(seconds: 1));
    
    _setLoading(false);
    _setError(null);
    notifyListeners();
  }

  Future<void> validateProfile(String profileId, bool approve) async {
    _setLoading(true);
    
    // Simular validación
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Remover de la lista de pendientes
    _pendingProfiles.removeWhere((profile) => profile['id'] == profileId);
    
    _setLoading(false);
    notifyListeners();
  }

  Future<void> moderateReport(String reportId, String action) async {
    _setLoading(true);
    
    // Simular moderación
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Remover de la lista de pendientes
    _pendingReports.removeWhere((report) => report['id'] == reportId);
    
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