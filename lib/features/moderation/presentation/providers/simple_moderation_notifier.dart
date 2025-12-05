import 'package:flutter/foundation.dart';

/// Versión simplificada del ModerationNotifier para testing
/// No requiere inyección de dependencias ni casos de uso
class SimpleModerationNotifier extends ChangeNotifier {
  // Estado de carga
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Lista de reportes mock
  List<Map<String, dynamic>> _reportes = [];
  List<Map<String, dynamic>> get reportes => _reportes;

  // Error handling
  String? _error;
  String? get error => _error;
  bool get hasError => _error != null;

  // Datos mock de reportes
  static List<Map<String, dynamic>> _mockReportes = [
    {
      'id': '1',
      'tipo': 'Contenido inapropiado',
      'descripcion': 'Difamación y lenguaje ofensivo en comentario',
      'estado': 'Pendiente',
      'fechaReporte': '2/12/2024',
      'reportadoPor': 'María Contreras',
      'contenidoReportado': {
        'tipo': 'comentario',
        'texto': 'Este abogado es un fraude, me robó \$5,000 pesos y nunca resolvió mi caso. No confíen en él, es un estafador que solo busca aprovecharse de la gente desesperada.',
        'autor': 'Luis Ramírez',
        'fechaPublicacion': '1/12/2024 14:30',
        'likes': 3,
        'respuestas': 1,
      },
      'ubicacion': 'Foro de consultas > Caso #1023',
      'prioridad': 'Alta'
    },
    {
      'id': '2', 
      'tipo': 'Spam',
      'descripcion': 'Publicación repetitiva con promociones no autorizadas',
      'estado': 'Pendiente',
      'fechaReporte': '1/12/2024',
      'reportadoPor': 'Carlos Jiménez',
      'contenidoReportado': {
        'tipo': 'publicacion',
        'texto': '🎯 ¡OFERTA ESPECIAL! Divorcios express en 24 horas. Garantizamos resultados o devolvemos tu dinero. Llama YA: 555-DIVORCIO. ¡Solo esta semana 50% descuento! #DivorcioRapido #AbogadosBaratos',
        'autor': 'Bufete Legal Express',
        'fechaPublicacion': '30/11/2024 09:15',
        'likes': 0,
        'respuestas': 8,
      },
      'ubicacion': 'Foro principal > Anuncios',
      'prioridad': 'Media'
    },
    {
      'id': '3',
      'tipo': 'Información falsa',
      'descripcion': 'Consejos legales incorrectos que pueden perjudicar',
      'estado': 'En revisión',
      'fechaReporte': '29/11/2024',
      'reportadoPor': 'Ana Ruiz',
      'contenidoReportado': {
        'tipo': 'respuesta',
        'texto': 'No necesitas abogado para esto, puedes falsificar tu acta de nacimiento fácilmente. Yo lo hice y nunca me descubrieron. Solo necesitas una computadora y una impresora buena.',
        'autor': 'Usuario_Anónimo_2024',
        'fechaPublicacion': '28/11/2024 16:45',
        'likes': 12,
        'respuestas': 4,
      },
      'ubicacion': 'Consulta #892 > Respuestas',
      'prioridad': 'Alta'
    },
  ];

  /// Cargar reportes pendientes con datos mock
  Future<void> loadReportes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simular carga de datos
      await Future.delayed(const Duration(milliseconds: 1200));
      
      _reportes = List.from(_mockReportes);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error al cargar reportes: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Aprobar reporte (marcar como resuelto)
  Future<void> aprobarReporte(String reporteId) async {
    try {
      final index = _reportes.indexWhere((r) => r['id'] == reporteId);
      if (index != -1) {
        _reportes[index]['estado'] = 'Resuelto';
        _reportes[index]['fechaResolucion'] = DateTime.now();
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error al aprobar reporte: $e';
      notifyListeners();
    }
  }

  /// Rechazar reporte (marcar como sin acción)
  Future<void> rechazarReporte(String reporteId, String motivo) async {
    try {
      final index = _reportes.indexWhere((r) => r['id'] == reporteId);
      if (index != -1) {
        _reportes[index]['estado'] = 'Rechazado';
        _reportes[index]['motivoRechazo'] = motivo;
        _reportes[index]['fechaResolucion'] = DateTime.now();
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error al rechazar reporte: $e';
      notifyListeners();
    }
  }

  /// Obtener reportes por estado
  List<Map<String, dynamic>> getReportesPorEstado(String estado) {
    return _reportes.where((r) => r['estado'] == estado).toList();
  }

  /// Obtener reportes pendientes
  List<Map<String, dynamic>> get reportesPendientes {
    return _reportes.where((r) => r['estado'] == 'Pendiente').toList();
  }

  /// Obtener reportes resueltos
  List<Map<String, dynamic>> get reportesResueltos {
    return _reportes.where((r) => r['estado'] == 'Resuelto').toList();
  }

  /// Obtener estadísticas
  Map<String, int> get estadisticas {
    return {
      'total': _reportes.length,
      'pendientes': _reportes.where((r) => r['estado'] == 'Pendientes').length,
      'resueltos': _reportes.where((r) => r['estado'] == 'Resuelto').length,
      'rechazados': _reportes.where((r) => r['estado'] == 'Rechazado').length,
    };
  }

  /// Limpiar error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}