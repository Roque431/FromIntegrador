import 'package:flutter/material.dart';

enum ProfileType { abogado, anunciante }

enum DocumentType { cedula, ine, titulo, certificacion }

enum ValidationStatus { pendiente, aprobado, rechazado }

class ProfileValidationModel {
  final String id;
  final String nombre;
  final String apellido;
  final ProfileType tipo;
  final String cedulaProfesional;
  final String especialidad;
  final int anosExperiencia;
  final List<DocumentModel> documentos;
  final DateTime fechaSolicitud;
  final ValidationStatus status;
  final String? motivoRechazo;

  const ProfileValidationModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.tipo,
    required this.cedulaProfesional,
    required this.especialidad,
    required this.anosExperiencia,
    required this.documentos,
    required this.fechaSolicitud,
    required this.status,
    this.motivoRechazo,
  });

  String get nombreCompleto => '$nombre $apellido';
  
  String get tipoTexto {
    switch (tipo) {
      case ProfileType.abogado:
        return 'Abogado Independiente';
      case ProfileType.anunciante:
        return 'Bufete Jurídico';
    }
  }

  String get iniciales {
    return '${nombre.isNotEmpty ? nombre[0] : ''}${apellido.isNotEmpty ? apellido[0] : ''}'.toUpperCase();
  }

  Color get avatarColor {
    switch (tipo) {
      case ProfileType.abogado:
        return const Color(0xFF2E7D32); // Verde para abogados
      case ProfileType.anunciante:
        return const Color(0xFF1565C0); // Azul para anunciantes
    }
  }

  String get tiempoEspera {
    final diferencia = DateTime.now().difference(fechaSolicitud);
    if (diferencia.inDays > 0) {
      return 'hace ${diferencia.inDays} día${diferencia.inDays > 1 ? 's' : ''}';
    } else if (diferencia.inHours > 0) {
      return 'hace ${diferencia.inHours} hora${diferencia.inHours > 1 ? 's' : ''}';
    } else {
      return 'hace ${diferencia.inMinutes} minuto${diferencia.inMinutes > 1 ? 's' : ''}';
    }
  }

  factory ProfileValidationModel.fromJson(Map<String, dynamic> json) {
    return ProfileValidationModel(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      tipo: ProfileType.values.firstWhere(
        (e) => e.name == json['tipo'],
        orElse: () => ProfileType.abogado,
      ),
      cedulaProfesional: json['cedulaProfesional'] ?? '',
      especialidad: json['especialidad'] ?? '',
      anosExperiencia: json['anosExperiencia'] ?? 0,
      documentos: (json['documentos'] as List? ?? [])
          .map((doc) => DocumentModel.fromJson(doc))
          .toList(),
      fechaSolicitud: DateTime.parse(json['fechaSolicitud'] ?? DateTime.now().toIso8601String()),
      status: ValidationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ValidationStatus.pendiente,
      ),
      motivoRechazo: json['motivoRechazo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'tipo': tipo.name,
      'cedulaProfesional': cedulaProfesional,
      'especialidad': especialidad,
      'anosExperiencia': anosExperiencia,
      'documentos': documentos.map((doc) => doc.toJson()).toList(),
      'fechaSolicitud': fechaSolicitud.toIso8601String(),
      'status': status.name,
      'motivoRechazo': motivoRechazo,
    };
  }

  ProfileValidationModel copyWith({
    String? id,
    String? nombre,
    String? apellido,
    ProfileType? tipo,
    String? cedulaProfesional,
    String? especialidad,
    int? anosExperiencia,
    List<DocumentModel>? documentos,
    DateTime? fechaSolicitud,
    ValidationStatus? status,
    String? motivoRechazo,
  }) {
    return ProfileValidationModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      tipo: tipo ?? this.tipo,
      cedulaProfesional: cedulaProfesional ?? this.cedulaProfesional,
      especialidad: especialidad ?? this.especialidad,
      anosExperiencia: anosExperiencia ?? this.anosExperiencia,
      documentos: documentos ?? this.documentos,
      fechaSolicitud: fechaSolicitud ?? this.fechaSolicitud,
      status: status ?? this.status,
      motivoRechazo: motivoRechazo ?? this.motivoRechazo,
    );
  }
}

class DocumentModel {
  final String id;
  final DocumentType tipo;
  final String nombre;
  final String url;
  final bool esVerificado;

  const DocumentModel({
    required this.id,
    required this.tipo,
    required this.nombre,
    required this.url,
    this.esVerificado = false,
  });

  String get tipoTexto {
    switch (tipo) {
      case DocumentType.cedula:
        return 'Cédula Profesional';
      case DocumentType.ine:
        return 'INE';
      case DocumentType.titulo:
        return 'Título Profesional';
      case DocumentType.certificacion:
        return 'Certificación';
    }
  }

  IconData get icono {
    switch (tipo) {
      case DocumentType.cedula:
        return Icons.badge;
      case DocumentType.ine:
        return Icons.credit_card;
      case DocumentType.titulo:
        return Icons.school;
      case DocumentType.certificacion:
        return Icons.verified;
    }
  }

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] ?? '',
      tipo: DocumentType.values.firstWhere(
        (e) => e.name == json['tipo'],
        orElse: () => DocumentType.cedula,
      ),
      nombre: json['nombre'] ?? '',
      url: json['url'] ?? '',
      esVerificado: json['esVerificado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo.name,
      'nombre': nombre,
      'url': url,
      'esVerificado': esVerificado,
    };
  }
}