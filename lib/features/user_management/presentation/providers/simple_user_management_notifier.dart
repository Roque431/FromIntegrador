import 'package:flutter/material.dart';

class SimpleUserManagementNotifier extends ChangeNotifier {
  List<Map<String, dynamic>> _usuarios = [
    {
      'id': '1',
      'nombre': 'Carlos Ramírez',
      'email': 'carlos.ramirez@email.com',
      'tipo': 'Ciudadano',
      'fechaRegistro': '15/11/2024',
      'estado': 'Activo',
      'avatar': 'CR',
      'color': Colors.blue,
      'consultas': 12,
      'reportes': 0,
      'ultimaActividad': '2 días ago',
      'telefono': '+52 555 123 4567',
      'ciudad': 'Ciudad de México',
      'universidad': 'UNAM'
    },
    {
      'id': '2',
      'nombre': 'María González',
      'email': 'maria.gonzalez@email.com',
      'tipo': 'Ciudadano',
      'fechaRegistro': '20/11/2024',
      'estado': 'Activo',
      'avatar': 'MG',
      'color': Colors.purple,
      'consultas': 8,
      'reportes': 1,
      'ultimaActividad': '1 día ago',
      'telefono': '+52 555 987 6543',
      'ciudad': 'Guadalajara',
      'universidad': 'UDG'
    },
    {
      'id': '3',
      'nombre': 'Ana Martínez',
      'email': 'ana.martinez@email.com',
      'tipo': 'Abogado',
      'fechaRegistro': '10/11/2024',
      'estado': 'Suspendido',
      'avatar': 'AM',
      'color': Colors.red,
      'consultas': 25,
      'reportes': 3,
      'ultimaActividad': '1 semana ago',
      'telefono': '+52 555 111 2222',
      'ciudad': 'Monterrey',
      'cedula': 'CED123456',
      'experiencia': '5 años',
      'especialidad': 'Derecho Penal'
    },
    {
      'id': '4',
      'nombre': 'Luis Hernández',
      'email': 'luis.hernandez@email.com',
      'tipo': 'Vendedor',
      'fechaRegistro': '25/11/2024',
      'estado': 'Activo',
      'avatar': 'LH',
      'color': Colors.green,
      'consultas': 5,
      'reportes': 0,
      'ultimaActividad': '5 horas ago',
      'telefono': '+52 555 333 4444',
      'ciudad': 'Puebla',
      'empresa': 'Tech Solutions',
      'categoria': 'Software Legal'
    },
    {
      'id': '5',
      'nombre': 'Sandra Castro',
      'email': 'sandra.castro@email.com',
      'tipo': 'Abogado',
      'fechaRegistro': '18/11/2024',
      'estado': 'Activo',
      'avatar': 'SC',
      'color': Colors.orange,
      'consultas': 15,
      'reportes': 1,
      'ultimaActividad': '3 horas ago',
      'telefono': '+52 555 555 6666',
      'ciudad': 'Tijuana',
      'cedula': 'CED789012',
      'experiencia': '8 años',
      'especialidad': 'Derecho Corporativo'
    },
  ];

  List<Map<String, dynamic>> _filteredUsuarios = [];
  String _filtroEstado = 'Todos';

  List<Map<String, dynamic>> get usuarios => _filtroEstado == 'Todos' 
      ? _usuarios 
      : _usuarios.where((u) => u['estado'] == _filtroEstado).toList();
  
  String get filtroEstado => _filtroEstado;
  
  int get totalUsuarios => _usuarios.length;
  int get usuariosActivos => _usuarios.where((u) => u['estado'] == 'Activo').length;
  int get usuariosSuspendidos => _usuarios.where((u) => u['estado'] == 'Suspendido').length;

  void setFiltroEstado(String estado) {
    _filtroEstado = estado;
    notifyListeners();
  }

  void suspenderUsuario(String usuarioId, String motivo) {
    final index = _usuarios.indexWhere((u) => u['id'] == usuarioId);
    if (index != -1) {
      _usuarios[index]['estado'] = 'Suspendido';
      _usuarios[index]['motivoSuspension'] = motivo;
      _usuarios[index]['fechaSuspension'] = DateTime.now().toString();
      notifyListeners();
    }
  }

  void reactivarUsuario(String usuarioId) {
    final index = _usuarios.indexWhere((u) => u['id'] == usuarioId);
    if (index != -1) {
      _usuarios[index]['estado'] = 'Activo';
      _usuarios[index].remove('motivoSuspension');
      _usuarios[index].remove('fechaSuspension');
      notifyListeners();
    }
  }

  void eliminarUsuario(String usuarioId) {
    _usuarios.removeWhere((u) => u['id'] == usuarioId);
    notifyListeners();
  }

  Map<String, dynamic>? obtenerUsuario(String usuarioId) {
    try {
      return _usuarios.firstWhere((u) => u['id'] == usuarioId);
    } catch (e) {
      return null;
    }
  }

  void buscarUsuarios(String query) {
    if (query.isEmpty) {
      _filteredUsuarios = [];
    } else {
      _filteredUsuarios = _usuarios.where((usuario) {
        final nombre = usuario['nombre'].toString().toLowerCase();
        final email = usuario['email'].toString().toLowerCase();
        final queryLower = query.toLowerCase();
        return nombre.contains(queryLower) || email.contains(queryLower);
      }).toList();
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> get usuariosFiltrados => _filteredUsuarios;
}