import '../../data/models/moderation_model.dart';
import '../repositories/moderation_repository.dart';

class GetReportesPendientesUseCase {
  final ModerationRepository repository;

  const GetReportesPendientesUseCase({
    required this.repository,
  });

  Future<List<ReportModel>> execute() async {
    return await repository.getReportesPendientes();
  }
}

class GetReportesPorStatusUseCase {
  final ModerationRepository repository;

  const GetReportesPorStatusUseCase({
    required this.repository,
  });

  Future<List<ReportModel>> execute(ReportStatus status) async {
    return await repository.getReportesPorStatus(status);
  }
}

class GetReportesPorPrioridadUseCase {
  final ModerationRepository repository;

  const GetReportesPorPrioridadUseCase({
    required this.repository,
  });

  Future<List<ReportModel>> execute(ReportPriority prioridad) async {
    return await repository.getReportesPorPrioridad(prioridad);
  }
}

class GetReportByIdUseCase {
  final ModerationRepository repository;

  const GetReportByIdUseCase({
    required this.repository,
  });

  Future<ReportModel> execute(String reportId) async {
    if (reportId.isEmpty) {
      throw Exception('ID de reporte requerido');
    }
    return await repository.getReportById(reportId);
  }
}

class ResolverReporteUseCase {
  final ModerationRepository repository;

  const ResolverReporteUseCase({
    required this.repository,
  });

  Future<bool> execute(String reportId, ModerationAction accion, String comentario) async {
    if (reportId.isEmpty) {
      throw Exception('ID de reporte requerido');
    }
    if (comentario.trim().isEmpty) {
      throw Exception('Comentario de resolución requerido');
    }
    if (comentario.trim().length < 10) {
      throw Exception('El comentario debe tener al menos 10 caracteres');
    }
    
    return await repository.resolverReporte(reportId, accion, comentario);
  }
}

class RechazarReporteUseCase {
  final ModerationRepository repository;

  const RechazarReporteUseCase({
    required this.repository,
  });

  Future<bool> execute(String reportId, String motivo) async {
    if (reportId.isEmpty) {
      throw Exception('ID de reporte requerido');
    }
    if (motivo.trim().isEmpty) {
      throw Exception('Motivo de rechazo requerido');
    }
    if (motivo.trim().length < 5) {
      throw Exception('El motivo debe tener al menos 5 caracteres');
    }
    
    return await repository.rechazarReporte(reportId, motivo);
  }
}

class CambiarPrioridadUseCase {
  final ModerationRepository repository;

  const CambiarPrioridadUseCase({
    required this.repository,
  });

  Future<bool> execute(String reportId, ReportPriority nuevaPrioridad) async {
    if (reportId.isEmpty) {
      throw Exception('ID de reporte requerido');
    }
    
    return await repository.cambiarPrioridad(reportId, nuevaPrioridad);
  }
}

class GetModerationStatsUseCase {
  final ModerationRepository repository;

  const GetModerationStatsUseCase({
    required this.repository,
  });

  Future<ModerationStatsModel> execute() async {
    return await repository.getModerationStats();
  }
}

class FilterReportesByTypeUseCase {
  final ModerationRepository repository;

  const FilterReportesByTypeUseCase({
    required this.repository,
  });

  Future<List<ReportModel>> execute(ReportType tipo) async {
    final todosLosReportes = await repository.getReportesPendientes();
    return todosLosReportes.where((reporte) => reporte.tipo == tipo).toList();
  }
}

class GetReportesUrgentesUseCase {
  final ModerationRepository repository;

  const GetReportesUrgentesUseCase({
    required this.repository,
  });

  Future<List<ReportModel>> execute() async {
    final todosLosReportes = await repository.getReportesPendientes();
    return todosLosReportes.where((reporte) => 
      reporte.prioridad == ReportPriority.alto || 
      reporte.prioridad == ReportPriority.critico
    ).toList()
    ..sort((a, b) {
      // Ordenar por prioridad (críticos primero) y luego por fecha
      final prioridadComparacion = b.prioridad.index.compareTo(a.prioridad.index);
      if (prioridadComparacion != 0) return prioridadComparacion;
      return a.fechaReporte.compareTo(b.fechaReporte);
    });
  }
}

class ValidateReportResolutionUseCase {
  Future<Map<String, bool>> execute(String reportId, ModerationAction accion, String comentario) async {
    Map<String, bool> validationResults = {
      'reportIdValid': reportId.isNotEmpty,
      'comentarioValid': comentario.trim().isNotEmpty && comentario.trim().length >= 10,
      'accionValid': true, // La acción siempre es válida si viene del enum
    };
    
    return validationResults;
  }
}

class GetModerationSummaryUseCase {
  final ModerationRepository repository;

  const GetModerationSummaryUseCase({
    required this.repository,
  });

  Future<ModerationSummary> execute() async {
    final stats = await repository.getModerationStats();
    final reportesUrgentes = await GetReportesUrgentesUseCase(repository: repository).execute();
    
    return ModerationSummary(
      stats: stats,
      reportesUrgentes: reportesUrgentes.take(5).toList(),
      eficienciaModerador: _calcularEficiencia(stats),
      reportesMasAntiguos: await _getReportesMasAntiguos(),
    );
  }

  double _calcularEficiencia(ModerationStatsModel stats) {
    if (stats.totalReportes == 0) return 0.0;
    return (stats.reportesResueltos / stats.totalReportes) * 100;
  }

  Future<List<ReportModel>> _getReportesMasAntiguos() async {
    final reportes = await repository.getReportesPendientes();
    final reportesPendientes = reportes.where((r) => r.status == ReportStatus.pendiente).toList();
    reportesPendientes.sort((a, b) => a.fechaReporte.compareTo(b.fechaReporte));
    return reportesPendientes.take(3).toList();
  }
}

class ModerationSummary {
  final ModerationStatsModel stats;
  final List<ReportModel> reportesUrgentes;
  final double eficienciaModerador;
  final List<ReportModel> reportesMasAntiguos;

  const ModerationSummary({
    required this.stats,
    required this.reportesUrgentes,
    required this.eficienciaModerador,
    required this.reportesMasAntiguos,
  });
}