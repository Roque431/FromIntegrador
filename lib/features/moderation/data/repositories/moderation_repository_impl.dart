import '../models/moderation_model.dart';
import '../datasources/moderation_datasource.dart';

abstract class ModerationRepository {
  Future<List<ReportModel>> getReportesPendientes();
  Future<List<ReportModel>> getReportesPorStatus(ReportStatus status);
  Future<List<ReportModel>> getReportesPorPrioridad(ReportPriority prioridad);
  Future<ReportModel> getReportById(String reportId);
  Future<bool> resolverReporte(String reportId, ModerationAction accion, String comentario);
  Future<bool> rechazarReporte(String reportId, String motivo);
  Future<bool> cambiarPrioridad(String reportId, ReportPriority nuevaPrioridad);
  Future<ModerationStatsModel> getModerationStats();
}

class ModerationRepositoryImpl implements ModerationRepository {
  final ModerationDataSource dataSource;

  const ModerationRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<List<ReportModel>> getReportesPendientes() async {
    try {
      return await dataSource.getReportesPendientes();
    } catch (e) {
      throw Exception('Error al obtener reportes pendientes: $e');
    }
  }

  @override
  Future<List<ReportModel>> getReportesPorStatus(ReportStatus status) async {
    try {
      return await dataSource.getReportesPorStatus(status);
    } catch (e) {
      throw Exception('Error al obtener reportes por status: $e');
    }
  }

  @override
  Future<List<ReportModel>> getReportesPorPrioridad(ReportPriority prioridad) async {
    try {
      return await dataSource.getReportesPorPrioridad(prioridad);
    } catch (e) {
      throw Exception('Error al obtener reportes por prioridad: $e');
    }
  }

  @override
  Future<ReportModel> getReportById(String reportId) async {
    try {
      if (reportId.isEmpty) {
        throw Exception('ID de reporte requerido');
      }
      return await dataSource.getReportById(reportId);
    } catch (e) {
      throw Exception('Error al obtener reporte: $e');
    }
  }

  @override
  Future<bool> resolverReporte(String reportId, ModerationAction accion, String comentario) async {
    try {
      if (reportId.isEmpty) {
        throw Exception('ID de reporte requerido');
      }
      if (comentario.trim().isEmpty) {
        throw Exception('Comentario de resolución requerido');
      }
      return await dataSource.resolverReporte(reportId, accion, comentario);
    } catch (e) {
      throw Exception('Error al resolver reporte: $e');
    }
  }

  @override
  Future<bool> rechazarReporte(String reportId, String motivo) async {
    try {
      if (reportId.isEmpty) {
        throw Exception('ID de reporte requerido');
      }
      if (motivo.trim().isEmpty) {
        throw Exception('Motivo de rechazo requerido');
      }
      return await dataSource.rechazarReporte(reportId, motivo);
    } catch (e) {
      throw Exception('Error al rechazar reporte: $e');
    }
  }

  @override
  Future<bool> cambiarPrioridad(String reportId, ReportPriority nuevaPrioridad) async {
    try {
      if (reportId.isEmpty) {
        throw Exception('ID de reporte requerido');
      }
      return await dataSource.cambiarPrioridad(reportId, nuevaPrioridad);
    } catch (e) {
      throw Exception('Error al cambiar prioridad: $e');
    }
  }

  @override
  Future<ModerationStatsModel> getModerationStats() async {
    try {
      return await dataSource.getModerationStats();
    } catch (e) {
      throw Exception('Error al obtener estadísticas: $e');
    }
  }
}