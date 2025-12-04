class CategoriaModel {
  final String id;
  final String nombre;
  final String? descripcion;
  final String? icono;
  final String? color;
  final int totalPublicaciones;

  CategoriaModel({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.icono,
    this.color,
    this.totalPublicaciones = 0,
  });

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
      icono: json['icono'],
      color: json['color'],
      totalPublicaciones: json['totalPublicaciones'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'icono': icono,
      'color': color,
      'totalPublicaciones': totalPublicaciones,
    };
  }
}
