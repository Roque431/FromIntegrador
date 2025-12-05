import 'package:flutter/material.dart';

enum ReportType { contenidoInapropiado, spam, fraude, acoso, violacionTerminos }

enum ReportStatus { pendiente, enRevision, resuelto, rechazado }

enum ReportPriority { bajo, medio, alto, critico }

enum ContentType { publicacion, comentario, perfil, mensaje }

enum ModerationAction { eliminar, advertir, suspender, ignorar }

class ReportModel {
  final String id;
  final String titulo;
  final String contenidoReportado;
  final ReportType tipo;
  final ReportStatus status;
  final ReportPriority prioridad;
  final ContentType tipoContenido;
  final String motivoReporte;
  final String reportadoPor;
  final String autorContenido;
  final DateTime fechaReporte;
  final DateTime? fechaResolucion;
  final String? accionTomada;
  final String? comentarioModerador;
  final List<String> evidencias;

  const ReportModel({
    required this.id,
    required this.titulo,
    required this.contenidoReportado,
    required this.tipo,
    required this.status,
    required this.prioridad,
    required this.tipoContenido,
    required this.motivoReporte,
    required this.reportadoPor,
    required this.autorContenido,
    required this.fechaReporte,
    this.fechaResolucion,
    this.accionTomada,
    this.comentarioModerador,
    this.evidencias = const [],
  });

  String get tipoTexto {
    switch (tipo) {
      case ReportType.contenidoInapropiado:
        return 'Contenido Inapropiado';
      case ReportType.spam:
        return 'Spam';
      case ReportType.fraude:
        return 'Fraude';
      case ReportType.acoso:
        return 'Acoso';
      case ReportType.violacionTerminos:
        return 'Violación de Términos';
    }
  }

  String get statusTexto {
    switch (status) {
      case ReportStatus.pendiente:
        return 'Pendiente';
      case ReportStatus.enRevision:
        return 'En Revisión';
      case ReportStatus.resuelto:
        return 'Resuelto';
      case ReportStatus.rechazado:
        return 'Rechazado';
    }
  }

  String get prioridadTexto {
    switch (prioridad) {
      case ReportPriority.bajo:
        return 'Bajo';
      case ReportPriority.medio:
        return 'Medio';
      case ReportPriority.alto:
        return 'Alto';
      case ReportPriority.critico:
        return 'Crítico';
    }
  }

  Color get prioridadColor {
    switch (prioridad) {
      case ReportPriority.bajo:
        return Colors.green;
      case ReportPriority.medio:
        return Colors.orange;
      case ReportPriority.alto:
        return Colors.red;
      case ReportPriority.critico:
        return Colors.purple;
    }
  }

  Color get statusColor {
    switch (status) {
      case ReportStatus.pendiente:
        return Colors.orange;
      case ReportStatus.enRevision:
        return Colors.blue;
      case ReportStatus.resuelto:
        return Colors.green;
      case ReportStatus.rechazado:
        return Colors.grey;
    }
  }

  String get tipoContenidoTexto {
    switch (tipoContenido) {
      case ContentType.publicacion:
        return 'Publicación';
      case ContentType.comentario:
        return 'Comentario';
      case ContentType.perfil:
        return 'Perfil';
      case ContentType.mensaje:
        return 'Mensaje';
    }
  }

  String get tiempoTranscurrido {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fechaReporte);
    
    if (diferencia.inDays > 0) {
      return 'hace ${diferencia.inDays} día${diferencia.inDays > 1 ? 's' : ''}';
    } else if (diferencia.inHours > 0) {
      return 'hace ${diferencia.inHours} hora${diferencia.inHours > 1 ? 's' : ''}';
    } else {
      return 'hace ${diferencia.inMinutes} minuto${diferencia.inMinutes > 1 ? 's' : ''}';
    }
  }

  IconData get tipoIcon {
    switch (tipo) {
      case ReportType.contenidoInapropiado:
        return Icons.block;
      case ReportType.spam:
        return Icons.report;
      case ReportType.fraude:
        return Icons.warning;
      case ReportType.acoso:
        return Icons.person_remove;
      case ReportType.violacionTerminos:
        return Icons.gavel;
    }
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] ?? '',
      titulo: json['titulo'] ?? '',
      contenidoReportado: json['contenidoReportado'] ?? '',
      tipo: ReportType.values.firstWhere(
        (e) => e.name == json['tipo'],
        orElse: () => ReportType.contenidoInapropiado,
      ),
      status: ReportStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ReportStatus.pendiente,
      ),
      prioridad: ReportPriority.values.firstWhere(
        (e) => e.name == json['prioridad'],
        orElse: () => ReportPriority.medio,
      ),
      tipoContenido: ContentType.values.firstWhere(
        (e) => e.name == json['tipoContenido'],
        orElse: () => ContentType.publicacion,
      ),
      motivoReporte: json['motivoReporte'] ?? '',
      reportadoPor: json['reportadoPor'] ?? '',
      autorContenido: json['autorContenido'] ?? '',
      fechaReporte: DateTime.parse(json['fechaReporte'] ?? DateTime.now().toIso8601String()),
      fechaResolucion: json['fechaResolucion'] != null 
          ? DateTime.parse(json['fechaResolucion']) 
          : null,
      accionTomada: json['accionTomada'],
      comentarioModerador: json['comentarioModerador'],
      evidencias: List<String>.from(json['evidencias'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'contenidoReportado': contenidoReportado,
      'tipo': tipo.name,
      'status': status.name,
      'prioridad': prioridad.name,
      'tipoContenido': tipoContenido.name,
      'motivoReporte': motivoReporte,
      'reportadoPor': reportadoPor,
      'autorContenido': autorContenido,
      'fechaReporte': fechaReporte.toIso8601String(),
      'fechaResolucion': fechaResolucion?.toIso8601String(),
      'accionTomada': accionTomada,
      'comentarioModerador': comentarioModerador,
      'evidencias': evidencias,
    };
  }

  ReportModel copyWith({
    String? id,
    String? titulo,
    String? contenidoReportado,
    ReportType? tipo,
    ReportStatus? status,
    ReportPriority? prioridad,
    ContentType? tipoContenido,
    String? motivoReporte,
    String? reportadoPor,
    String? autorContenido,
    DateTime? fechaReporte,
    DateTime? fechaResolucion,
    String? accionTomada,
    String? comentarioModerador,
    List<String>? evidencias,
  }) {
    return ReportModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      contenidoReportado: contenidoReportado ?? this.contenidoReportado,
      tipo: tipo ?? this.tipo,
      status: status ?? this.status,
      prioridad: prioridad ?? this.prioridad,
      tipoContenido: tipoContenido ?? this.tipoContenido,
      motivoReporte: motivoReporte ?? this.motivoReporte,
      reportadoPor: reportadoPor ?? this.reportadoPor,
      autorContenido: autorContenido ?? this.autorContenido,
      fechaReporte: fechaReporte ?? this.fechaReporte,
      fechaResolucion: fechaResolucion ?? this.fechaResolucion,
      accionTomada: accionTomada ?? this.accionTomada,
      comentarioModerador: comentarioModerador ?? this.comentarioModerador,
      evidencias: evidencias ?? this.evidencias,
    );
  }
}

class ModerationStatsModel {
  final int totalReportes;
  final int reportesPendientes;
  final int reportesEnRevision;
  final int reportesResueltos;
  final int reportesAlta;
  final int reportesCriticos;
  final Map<ReportType, int> reportesPorTipo;

  const ModerationStatsModel({
    required this.totalReportes,
    required this.reportesPendientes,
    required this.reportesEnRevision,
    required this.reportesResueltos,
    required this.reportesAlta,
    required this.reportesCriticos,
    required this.reportesPorTipo,
  });

  factory ModerationStatsModel.fromJson(Map<String, dynamic> json) {
    return ModerationStatsModel(
      totalReportes: json['totalReportes'] ?? 0,
      reportesPendientes: json['reportesPendientes'] ?? 0,
      reportesEnRevision: json['reportesEnRevision'] ?? 0,
      reportesResueltos: json['reportesResueltos'] ?? 0,
      reportesAlta: json['reportesAlta'] ?? 0,
      reportesCriticos: json['reportesCriticos'] ?? 0,
      reportesPorTipo: Map<ReportType, int>.from(
        (json['reportesPorTipo'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(
            ReportType.values.firstWhere((e) => e.name == key),
            value,
          ),
        ),
      ),
    );
  }
}