class LawyerStats {
  final int casosAtendidos;
  final double calificacion;
  final int puntosReputacion;
  final int consultasPendientes;
  final int consultasSemanales;
  final int respuestasEnForo;
  final int nuevosClientes;

  const LawyerStats({
    required this.casosAtendidos,
    required this.calificacion,
    required this.puntosReputacion,
    required this.consultasPendientes,
    required this.consultasSemanales,
    required this.respuestasEnForo,
    required this.nuevosClientes,
  });

  // Constructor con valores por defecto para pruebas
  factory LawyerStats.demo() {
    return const LawyerStats(
      casosAtendidos: 127,
      calificacion: 4.8,
      puntosReputacion: 850,
      consultasPendientes: 12,
      consultasSemanales: 45,
      respuestasEnForo: 23,
      nuevosClientes: 8,
    );
  }
}
