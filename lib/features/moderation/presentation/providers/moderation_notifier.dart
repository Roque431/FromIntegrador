import 'package:flutter/foundation.dart';
import '../../data/models/moderation_model.dart';
import '../../domain/usecases/moderation_usecases.dart';

enum ModerationLoadingState { idle, loading, refreshing, processing }

enum ModerationFilter { todos, pendientes, enRevision, resueltos, urgentes }

class ModerationNotifier extends ChangeNotifier {
  final GetReportesPendientesUseCase getReportesPendientesUseCase;
  final GetReportesPorStatusUseCase getReportesPorStatusUseCase;
  final GetReportesPorPrioridadUseCase getReportesPorPrioridadUseCase;
  final GetReportByIdUseCase getReportByIdUseCase;
  final ResolverReporteUseCase resolverReporteUseCase;
  final RechazarReporteUseCase rechazarReporteUseCase;
  final CambiarPrioridadUseCase cambiarPrioridadUseCase;
  final GetModerationStatsUseCase getModerationStatsUseCase;
  final GetReportesUrgentesUseCase getReportesUrgentesUseCase;
  final GetModerationSummaryUseCase getModerationSummaryUseCase;

  ModerationNotifier({
    required this.getReportesPendientesUseCase,
    required this.getReportesPorStatusUseCase,
    required this.getReportesPorPrioridadUseCase,
    required this.getReportByIdUseCase,
    required this.resolverReporteUseCase,
    required this.rechazarReporteUseCase,
    required this.cambiarPrioridadUseCase,
    required this.getModerationStatsUseCase,
    required this.getReportesUrgentesUseCase,
    required this.getModerationSummaryUseCase,
  });

  // Estados
  ModerationLoadingState _loadingState = ModerationLoadingState.idle;
  ModerationLoadingState get loadingState => _loadingState;
  bool get isLoading => _loadingState == ModerationLoadingState.loading;
  bool get isRefreshing => _loadingState == ModerationLoadingState.refreshing;
  bool get isProcessing => _loadingState == ModerationLoadingState.processing;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  // Datos
  List<ReportModel> _reportes = [];
  List<ReportModel> get reportes => _reportes;

  List<ReportModel> _reportesPendientes = [];
  List<ReportModel> get reportesPendientes => _reportesPendientes;

  List<ReportModel> _reportesEnRevision = [];
  List<ReportModel> get reportesEnRevision => _reportesEnRevision;

  List<ReportModel> _reportesResueltos = [];
  List<ReportModel> get reportesResueltos => _reportesResueltos;

  List<ReportModel> _reportesUrgentes = [];
  List<ReportModel> get reportesUrgentes => _reportesUrgentes;

  ModerationStatsModel? _stats;
  ModerationStatsModel? get stats => _stats;

  ModerationSummary? _summary;
  ModerationSummary? get summary => _summary;

  // Filtros y selección
  ModerationFilter _filtroActivo = ModerationFilter.pendientes;
  ModerationFilter get filtroActivo => _filtroActivo;

  ReportModel? _reporteSeleccionado;
  ReportModel? get reporteSeleccionado => _reporteSeleccionado;

  Set<String> _reportesEnProceso = {};
  Set<String> get reportesEnProceso => _reportesEnProceso;

  // Métodos principales
  Future<void> loadReportes({bool refresh = false}) async {
    if (refresh) {
      _loadingState = ModerationLoadingState.refreshing;
    } else {
      _loadingState = ModerationLoadingState.loading;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      // Cargar todos los reportes
      final todosLosReportes = await getReportesPendientesUseCase.execute();
      _reportes = todosLosReportes;

      // Separar por estado
      _reportesPendientes = todosLosReportes
          .where((reporte) => reporte.status == ReportStatus.pendiente)
          .toList();
      
      _reportesEnRevision = todosLosReportes
          .where((reporte) => reporte.status == ReportStatus.enRevision)
          .toList();
      
      _reportesResueltos = todosLosReportes
          .where((reporte) => reporte.status == ReportStatus.resuelto)
          .toList();

      // Cargar reportes urgentes
      _reportesUrgentes = await getReportesUrgentesUseCase.execute();

      // Cargar estadísticas
      _stats = await getModerationStatsUseCase.execute();

      // Cargar resumen completo
      _summary = await getModerationSummaryUseCase.execute();

      _loadingState = ModerationLoadingState.idle;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _loadingState = ModerationLoadingState.idle;
      notifyListeners();
    }
  }

  void cambiarFiltro(ModerationFilter nuevoFiltro) {
    if (_filtroActivo != nuevoFiltro) {
      _filtroActivo = nuevoFiltro;
      _reporteSeleccionado = null;
      notifyListeners();
    }
  }

  List<ReportModel> get reportesFiltrados {
    switch (_filtroActivo) {
      case ModerationFilter.todos:
        return _reportes;
      case ModerationFilter.pendientes:
        return _reportesPendientes;
      case ModerationFilter.enRevision:
        return _reportesEnRevision;
      case ModerationFilter.resueltos:
        return _reportesResueltos;
      case ModerationFilter.urgentes:
        return _reportesUrgentes;
    }
  }

  String get filtroTexto {
    switch (_filtroActivo) {
      case ModerationFilter.todos:
        return 'Todos los reportes';
      case ModerationFilter.pendientes:
        return 'Reportes Pendientes';
      case ModerationFilter.enRevision:
        return 'En Revisión';
      case ModerationFilter.resueltos:
        return 'Resueltos';
      case ModerationFilter.urgentes:
        return 'Urgentes';
    }
  }

  Future<void> seleccionarReporte(String reporteId) async {
    try {
      _reporteSeleccionado = await getReportByIdUseCase.execute(reporteId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> resolverReporte(String reporteId, ModerationAction accion, String comentario) async {
    if (_reportesEnProceso.contains(reporteId)) return false;

    _reportesEnProceso.add(reporteId);
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await resolverReporteUseCase.execute(reporteId, accion, comentario);
      
      if (success) {
        // Actualizar el reporte en las listas
        _actualizarReporteResuelto(reporteId, accion, comentario);
        
        // Limpiar selección si era el reporte seleccionado
        if (_reporteSeleccionado?.id == reporteId) {
          _reporteSeleccionado = null;
        }
        
        // Actualizar estadísticas
        await _actualizarEstadisticas();
      }

      _reportesEnProceso.remove(reporteId);
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      _reportesEnProceso.remove(reporteId);
      notifyListeners();
      return false;
    }
  }

  Future<bool> rechazarReporte(String reporteId, String motivo) async {
    if (_reportesEnProceso.contains(reporteId)) return false;

    _reportesEnProceso.add(reporteId);
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await rechazarReporteUseCase.execute(reporteId, motivo);
      
      if (success) {
        // Actualizar el reporte como rechazado
        _actualizarReporteRechazado(reporteId, motivo);
        
        // Limpiar selección si era el reporte seleccionado
        if (_reporteSeleccionado?.id == reporteId) {
          _reporteSeleccionado = null;
        }
        
        // Actualizar estadísticas
        await _actualizarEstadisticas();
      }

      _reportesEnProceso.remove(reporteId);
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      _reportesEnProceso.remove(reporteId);
      notifyListeners();
      return false;
    }
  }

  Future<bool> cambiarPrioridad(String reporteId, ReportPriority nuevaPrioridad) async {
    try {
      final success = await cambiarPrioridadUseCase.execute(reporteId, nuevaPrioridad);
      
      if (success) {
        // Actualizar la prioridad en todas las listas
        _actualizarPrioridadReporte(reporteId, nuevaPrioridad);
        
        // Actualizar reporte seleccionado si aplica
        if (_reporteSeleccionado?.id == reporteId) {
          _reporteSeleccionado = _reporteSeleccionado!.copyWith(prioridad: nuevaPrioridad);
        }
      }
      
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  bool isReporteEnProceso(String reporteId) {
    return _reportesEnProceso.contains(reporteId);
  }

  void limpiarError() {
    _errorMessage = null;
    notifyListeners();
  }

  void limpiarSeleccion() {
    _reporteSeleccionado = null;
    notifyListeners();
  }

  // Métodos privados de actualización
  void _actualizarReporteResuelto(String reporteId, ModerationAction accion, String comentario) {
    final ahora = DateTime.now();
    
    // Encontrar y actualizar el reporte
    for (int i = 0; i < _reportes.length; i++) {
      if (_reportes[i].id == reporteId) {
        _reportes[i] = _reportes[i].copyWith(
          status: ReportStatus.resuelto,
          fechaResolucion: ahora,
          accionTomada: _getAccionTexto(accion),
          comentarioModerador: comentario,
        );
        break;
      }
    }
    
    // Mover de pendientes/revisión a resueltos
    _reportesPendientes.removeWhere((reporte) => reporte.id == reporteId);
    _reportesEnRevision.removeWhere((reporte) => reporte.id == reporteId);
    _reportesUrgentes.removeWhere((reporte) => reporte.id == reporteId);
    
    // Agregar a resueltos
    final reporteResuelto = _reportes.firstWhere((r) => r.id == reporteId);
    _reportesResueltos.add(reporteResuelto);
  }

  void _actualizarReporteRechazado(String reporteId, String motivo) {
    final ahora = DateTime.now();
    
    // Encontrar y actualizar el reporte
    for (int i = 0; i < _reportes.length; i++) {
      if (_reportes[i].id == reporteId) {
        _reportes[i] = _reportes[i].copyWith(
          status: ReportStatus.rechazado,
          fechaResolucion: ahora,
          comentarioModerador: 'Rechazado: $motivo',
        );
        break;
      }
    }
    
    // Remover de todas las listas activas
    _reportesPendientes.removeWhere((reporte) => reporte.id == reporteId);
    _reportesEnRevision.removeWhere((reporte) => reporte.id == reporteId);
    _reportesUrgentes.removeWhere((reporte) => reporte.id == reporteId);
  }

  void _actualizarPrioridadReporte(String reporteId, ReportPriority nuevaPrioridad) {
    // Actualizar en todas las listas
    _actualizarPrioridadEnLista(_reportes, reporteId, nuevaPrioridad);
    _actualizarPrioridadEnLista(_reportesPendientes, reporteId, nuevaPrioridad);
    _actualizarPrioridadEnLista(_reportesEnRevision, reporteId, nuevaPrioridad);
    _actualizarPrioridadEnLista(_reportesUrgentes, reporteId, nuevaPrioridad);
  }

  void _actualizarPrioridadEnLista(List<ReportModel> lista, String reporteId, ReportPriority nuevaPrioridad) {
    for (int i = 0; i < lista.length; i++) {
      if (lista[i].id == reporteId) {
        lista[i] = lista[i].copyWith(prioridad: nuevaPrioridad);
        break;
      }
    }
  }

  String _getAccionTexto(ModerationAction accion) {
    switch (accion) {
      case ModerationAction.eliminar:
        return 'Contenido eliminado';
      case ModerationAction.advertir:
        return 'Usuario advertido';
      case ModerationAction.suspender:
        return 'Usuario suspendido';
      case ModerationAction.ignorar:
        return 'Reporte ignorado';
    }
  }

  Future<void> _actualizarEstadisticas() async {
    try {
      _stats = await getModerationStatsUseCase.execute();
      _summary = await getModerationSummaryUseCase.execute();
    } catch (e) {
      // Si falla la actualización de stats, no es crítico
      debugPrint('Error actualizando estadísticas: $e');
    }
  }

  // Método para refrescar todo
  Future<void> refresh() async {
    await loadReportes(refresh: true);
  }

  // Limpiar todo al dispose
  @override
  void dispose() {
    _reportesEnProceso.clear();
    super.dispose();
  }
}