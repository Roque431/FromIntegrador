import 'package:flutter/material.dart';

class AdminStatsModel {
  final int usuariosActivos;
  final int abogadosVerificados;
  final int anunciantesActivos;
  final int consultasDelMes;
  final double crecimientoUsuarios;
  final double crecimientoAbogados;
  final double crecimientoAnunciantes;
  final double crecimientoConsultas;

  AdminStatsModel({
    required this.usuariosActivos,
    required this.abogadosVerificados,
    required this.anunciantesActivos,
    required this.consultasDelMes,
    required this.crecimientoUsuarios,
    required this.crecimientoAbogados,
    required this.crecimientoAnunciantes,
    required this.crecimientoConsultas,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminStatsModel(
      usuariosActivos: json['usuarios_activos'] ?? 0,
      abogadosVerificados: json['abogados_verificados'] ?? 0,
      anunciantesActivos: json['anunciantes_activos'] ?? 0,
      consultasDelMes: json['consultas_del_mes'] ?? 0,
      crecimientoUsuarios: (json['crecimiento_usuarios'] ?? 0).toDouble(),
      crecimientoAbogados: (json['crecimiento_abogados'] ?? 0).toDouble(),
      crecimientoAnunciantes: (json['crecimiento_anunciantes'] ?? 0).toDouble(),
      crecimientoConsultas: (json['crecimiento_consultas'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuarios_activos': usuariosActivos,
      'abogados_verificados': abogadosVerificados,
      'anunciantes_activos': anunciantesActivos,
      'consultas_del_mes': consultasDelMes,
      'crecimiento_usuarios': crecimientoUsuarios,
      'crecimiento_abogados': crecimientoAbogados,
      'crecimiento_anunciantes': crecimientoAnunciantes,
      'crecimiento_consultas': crecimientoConsultas,
    };
  }
}

class AdminActionItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final int? badgeCount;
  final VoidCallback? onTap;

  AdminActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.badgeCount,
    this.onTap,
  });
}