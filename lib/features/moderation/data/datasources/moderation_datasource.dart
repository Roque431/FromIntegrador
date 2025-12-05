import '../models/moderation_model.dart';

abstract class ModerationDataSource {
  Future<List<ReportModel>> getReportesPendientes();
  Future<List<ReportModel>> getReportesPorStatus(ReportStatus status);
  Future<List<ReportModel>> getReportesPorPrioridad(ReportPriority prioridad);
  Future<ReportModel> getReportById(String reportId);
  Future<bool> resolverReporte(String reportId, ModerationAction accion, String comentario);
  Future<bool> rechazarReporte(String reportId, String motivo);
  Future<bool> cambiarPrioridad(String reportId, ReportPriority nuevaPrioridad);
  Future<ModerationStatsModel> getModerationStats();
}

class ModerationDataSourceImpl implements ModerationDataSource {
  
  @override
  Future<List<ReportModel>> getReportesPendientes() async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    final reportesMock = [
      // Reporte de contenido inapropiado - ALTO
      ReportModel(
        id: 'rep_001',
        titulo: 'Contenido Inapropiado en foro',
        contenidoReportado: 'Este abogado es un fraude, me robó \$5,000 pesos y nunca resolvió mi caso...',
        tipo: ReportType.contenidoInapropiado,
        status: ReportStatus.pendiente,
        prioridad: ReportPriority.alto,
        tipoContenido: ContentType.publicacion,
        motivoReporte: 'Difamación, lenguaje ofensivo y acusaciones sin fundamento',
        reportadoPor: 'María Contreras',
        autorContenido: 'Luis Ramírez',
        fechaReporte: DateTime.now().subtract(const Duration(hours: 2)),
        evidencias: ['screenshot1.png', 'conversacion.pdf'],
      ),

      // Reporte de spam - MEDIO  
      ReportModel(
        id: 'rep_002',
        titulo: 'Spam en foro',
        contenidoReportado: '¡GANA DINERO FÁCIL! Invierte en criptomonedas. Visita: www.scam-crypto.com',
        tipo: ReportType.spam,
        status: ReportStatus.pendiente,
        prioridad: ReportPriority.medio,
        tipoContenido: ContentType.publicacion,
        motivoReporte: 'Publicidad no autorizada, contenido no relacionado',
        reportadoPor: 'Carlos Jiménez',
        autorContenido: 'InversionesBot2024',
        fechaReporte: DateTime.now().subtract(const Duration(hours: 5)),
        evidencias: ['spam_post.jpg'],
      ),

      // Reporte de fraude - CRÍTICO
      ReportModel(
        id: 'rep_003',
        titulo: 'Posible estafa',
        contenidoReportado: 'Abogado solicitando pagos adelantados sin dar servicios reales. Múltiples víctimas reportadas.',
        tipo: ReportType.fraude,
        status: ReportStatus.enRevision,
        prioridad: ReportPriority.critico,
        tipoContenido: ContentType.perfil,
        motivoReporte: 'Estafa confirmada, múltiples denuncias de clientes',
        reportadoPor: 'Ana García',
        autorContenido: 'Abogado Falso',
        fechaReporte: DateTime.now().subtract(const Duration(days: 1)),
        evidencias: ['denuncia1.pdf', 'denuncia2.pdf', 'evidencia_pago.jpg'],
      ),

      // Reporte de acoso - ALTO
      ReportModel(
        id: 'rep_004',
        titulo: 'Acoso hacia usuario',
        contenidoReportado: 'Mensajes repetidos de acoso, amenazas y lenguaje inapropiado hacia cliente femenina.',
        tipo: ReportType.acoso,
        status: ReportStatus.pendiente,
        prioridad: ReportPriority.alto,
        tipoContenido: ContentType.mensaje,
        motivoReporte: 'Acoso sexual, amenazas, comportamiento inapropiado',
        reportadoPor: 'Laura Méndez',
        autorContenido: 'Usuario Problemático',
        fechaReporte: DateTime.now().subtract(const Duration(hours: 8)),
        evidencias: ['mensajes_acoso.png', 'historial_chat.pdf'],
      ),

      // Reporte de violación de términos - MEDIO
      ReportModel(
        id: 'rep_005',
        titulo: 'Violación términos de servicio',
        contenidoReportado: 'Usuario ofreciendo servicios legales sin credenciales válidas.',
        tipo: ReportType.violacionTerminos,
        status: ReportStatus.pendiente,
        prioridad: ReportPriority.medio,
        tipoContenido: ContentType.perfil,
        motivoReporte: 'Ejercicio ilegal de la profesión, sin cédula profesional',
        reportadoPor: 'Colegio de Abogados',
        autorContenido: 'Falso Abogado 123',
        fechaReporte: DateTime.now().subtract(const Duration(hours: 12)),
        evidencias: ['perfil_falso.jpg', 'verificacion_cedula.pdf'],
      ),

      // Reporte de contenido inapropiado - BAJO
      ReportModel(
        id: 'rep_006',
        titulo: 'Lenguaje inadecuado',
        contenidoReportado: 'Uso de palabras altisonantes en comentarios del foro.',
        tipo: ReportType.contenidoInapropiado,
        status: ReportStatus.pendiente,
        prioridad: ReportPriority.bajo,
        tipoContenido: ContentType.comentario,
        motivoReporte: 'Lenguaje ofensivo, no apropiado para el foro profesional',
        reportadoPor: 'Moderador Automático',
        autorContenido: 'Usuario Informal',
        fechaReporte: DateTime.now().subtract(const Duration(hours: 3)),
        evidencias: ['comentario_inapropiado.png'],
      ),

      // Reporte resuelto - para mostrar histórico
      ReportModel(
        id: 'rep_007',
        titulo: 'Spam resuelto',
        contenidoReportado: 'Publicidad de casino online en foro legal.',
        tipo: ReportType.spam,
        status: ReportStatus.resuelto,
        prioridad: ReportPriority.medio,
        tipoContenido: ContentType.publicacion,
        motivoReporte: 'Contenido no relacionado con servicios legales',
        reportadoPor: 'Sistema Automático',
        autorContenido: 'Casino Bot',
        fechaReporte: DateTime.now().subtract(const Duration(days: 2)),
        fechaResolucion: DateTime.now().subtract(const Duration(days: 1)),
        accionTomada: 'Contenido eliminado y usuario suspendido',
        comentarioModerador: 'Spam comercial eliminado. Usuario notificado sobre políticas.',
        evidencias: ['spam_casino.jpg'],
      ),
    ];

    return reportesMock;
  }

  @override
  Future<List<ReportModel>> getReportesPorStatus(ReportStatus status) async {
    final todosLosReportes = await getReportesPendientes();
    return todosLosReportes.where((reporte) => reporte.status == status).toList();
  }

  @override
  Future<List<ReportModel>> getReportesPorPrioridad(ReportPriority prioridad) async {
    final todosLosReportes = await getReportesPendientes();
    return todosLosReportes.where((reporte) => reporte.prioridad == prioridad).toList();
  }

  @override
  Future<ReportModel> getReportById(String reportId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final reportes = await getReportesPendientes();
    return reportes.firstWhere(
      (reporte) => reporte.id == reportId,
      orElse: () => throw Exception('Reporte no encontrado'),
    );
  }

  @override
  Future<bool> resolverReporte(String reportId, ModerationAction accion, String comentario) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    
    if (comentario.trim().isEmpty) {
      throw Exception('El comentario de resolución es requerido');
    }
    
    // Simular resolución exitosa
    return true;
  }

  @override
  Future<bool> rechazarReporte(String reportId, String motivo) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (motivo.trim().isEmpty) {
      throw Exception('El motivo de rechazo es requerido');
    }
    
    return true;
  }

  @override
  Future<bool> cambiarPrioridad(String reportId, ReportPriority nuevaPrioridad) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }

  @override
  Future<ModerationStatsModel> getModerationStats() async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final reportes = await getReportesPendientes();
    final pendientes = reportes.where((r) => r.status == ReportStatus.pendiente).length;
    final enRevision = reportes.where((r) => r.status == ReportStatus.enRevision).length;
    final resueltos = reportes.where((r) => r.status == ReportStatus.resuelto).length;
    final altos = reportes.where((r) => r.prioridad == ReportPriority.alto).length;
    final criticos = reportes.where((r) => r.prioridad == ReportPriority.critico).length;
    
    final reportesPorTipo = <ReportType, int>{};
    for (final tipo in ReportType.values) {
      reportesPorTipo[tipo] = reportes.where((r) => r.tipo == tipo).length;
    }
    
    return ModerationStatsModel(
      totalReportes: reportes.length,
      reportesPendientes: pendientes,
      reportesEnRevision: enRevision,
      reportesResueltos: resueltos,
      reportesAlta: altos,
      reportesCriticos: criticos,
      reportesPorTipo: reportesPorTipo,
    );
  }
}