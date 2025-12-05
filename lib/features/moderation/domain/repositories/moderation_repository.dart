import '../../data/models/moderation_model.dart';

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