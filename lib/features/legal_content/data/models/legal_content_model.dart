class LegalContentModel {
  final String id;
  final String titulo;
  final String tipo; // Ley, Reglamento, Jurisprudencia, Artículo
  final String textoOriginal;
  final String? textoSimplificado;
  final String version;
  final DateTime? fechaPublicacion;
  final DateTime? fechaActualizacion;
  final String? fuente;

  const LegalContentModel({
    required this.id,
    required this.titulo,
    required this.tipo,
    required this.textoOriginal,
    this.textoSimplificado,
    required this.version,
    this.fechaPublicacion,
    this.fechaActualizacion,
    this.fuente,
  });

  factory LegalContentModel.fromJson(Map<String, dynamic> json) {
    return LegalContentModel(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      tipo: json['tipo'] as String,
      textoOriginal: json['texto_original'] as String,
      textoSimplificado: json['texto_simplificado'] as String?,
      version: json['version'] as String,
      fechaPublicacion: json['fecha_publicacion'] != null
          ? DateTime.parse(json['fecha_publicacion'] as String)
          : null,
      fechaActualizacion: json['fecha_actualizacion'] != null
          ? DateTime.parse(json['fecha_actualizacion'] as String)
          : null,
      fuente: json['fuente'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'tipo': tipo,
      'texto_original': textoOriginal,
      if (textoSimplificado != null) 'texto_simplificado': textoSimplificado,
      'version': version,
      if (fechaPublicacion != null)
        'fecha_publicacion': fechaPublicacion!.toIso8601String().split('T')[0],
      if (fechaActualizacion != null)
        'fecha_actualizacion': fechaActualizacion!.toIso8601String(),
      if (fuente != null) 'fuente': fuente,
    };
  }

  String get tipoDisplay {
    switch (tipo.toLowerCase()) {
      case 'ley':
        return '📜 Ley';
      case 'reglamento':
        return '📋 Reglamento';
      case 'jurisprudencia':
        return '⚖️ Jurisprudencia';
      case 'artículo':
      case 'articulo':
        return '📄 Artículo';
      default:
        return '📚 $tipo';
    }
  }
}


class LegalContentSearchResult {
  final String id;
  final String titulo;
  final String tipo;
  final String? snippet; // Fragmento relevante del texto
  final double? score; // Score de relevancia
  final String? fuente;
  final DateTime? fechaPublicacion;

  const LegalContentSearchResult({
    required this.id,
    required this.titulo,
    required this.tipo,
    this.snippet,
    this.score,
    this.fuente,
    this.fechaPublicacion,
  });

  factory LegalContentSearchResult.fromJson(Map<String, dynamic> json) {
    return LegalContentSearchResult(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      tipo: json['tipo'] as String,
      snippet: json['snippet'] as String?,
      score: (json['score'] as num?)?.toDouble(),
      fuente: json['fuente'] as String?,
      fechaPublicacion: json['fecha_publicacion'] != null
          ? DateTime.parse(json['fecha_publicacion'] as String)
          : null,
    );
  }
}


class LegalContentListResponse {
  final List<LegalContentModel> items;
  final int total;
  final int page;
  final int perPage;

  const LegalContentListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
  });

  factory LegalContentListResponse.fromJson(Map<String, dynamic> json) {
    return LegalContentListResponse(
      items: (json['items'] as List<dynamic>)
          .map((item) => LegalContentModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      perPage: json['per_page'] as int,
    );
  }

  bool get hasMore => (page * perPage) < total;
  int get totalPages => (total / perPage).ceil();
}
