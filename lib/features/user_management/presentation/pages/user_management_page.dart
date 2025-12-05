import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/simple_user_management_notifier.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({Key? key}) : super(key: key);

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SimpleUserManagementNotifier>(
      builder: (context, notifier, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text(
              'Gestión de Usuarios',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
            elevation: 1,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => context.go('/admin'),
            ),
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.blue[600],
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Colors.blue[600],
              tabs: [
                Tab(
                  text: 'Todos (${notifier.totalUsuarios})',
                ),
                Tab(
                  text: 'Activos (${notifier.usuariosActivos})',
                ),
                Tab(
                  text: 'Suspendidos (${notifier.usuariosSuspendidos})',
                ),
                Tab(
                  text: 'Estadísticas',
                ),
              ],
              onTap: (index) {
                switch (index) {
                  case 0:
                    notifier.setFiltroEstado('Todos');
                    break;
                  case 1:
                    notifier.setFiltroEstado('Activo');
                    break;
                  case 2:
                    notifier.setFiltroEstado('Suspendido');
                    break;
                }
              },
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildUsersList(notifier), // Todos
              _buildUsersList(notifier), // Activos  
              _buildUsersList(notifier), // Suspendidos
              _buildStatsView(notifier), // Estadísticas
            ],
          ),
        );
      },
    );
  }

  Widget _buildUsersList(SimpleUserManagementNotifier notifier) {
    return Column(
      children: [
        // Barra de búsqueda
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).cardColor,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar usuarios...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Theme.of(context).dividerColor),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        notifier.buscarUsuarios('');
                        setState(() {});
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              notifier.buscarUsuarios(value);
              setState(() {});
            },
          ),
        ),
        // Lista de usuarios
        Expanded(
          child: Builder(
            builder: (context) {
              final usuarios = _searchController.text.isNotEmpty
                  ? notifier.usuariosFiltrados
                  : notifier.usuarios;
              
              if (usuarios.isEmpty) {
                return Center(
                  child: Text(
                    'No hay usuarios para mostrar',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                    ),
                  ),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: usuarios.length,
                itemBuilder: (context, index) {
                  if (index >= usuarios.length) return const SizedBox.shrink();
                  return _buildUserCard(usuarios[index], notifier);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(Map<String, dynamic> usuario, SimpleUserManagementNotifier notifier) {
    final isActive = usuario['estado'] == 'Activo';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
        border: !isActive ? Border.all(color: Colors.red[200]!, width: 2) : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showUserDetail(usuario, notifier),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar con ícono de tipo
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: usuario['color'],
                    child: Text(
                      usuario['avatar'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _getUserTypeColor(usuario['tipo']),
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).cardColor, width: 2),
                      ),
                      child: Icon(
                        _getUserTypeIcon(usuario['tipo']),
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Información del usuario
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            usuario['nombre'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getUserTypeColor(usuario['tipo']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getUserTypeIcon(usuario['tipo']),
                                size: 12,
                                color: _getUserTypeColor(usuario['tipo']),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                usuario['tipo'],
                                style: TextStyle(
                                  color: _getUserTypeColor(usuario['tipo']),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.green[100] : Colors.red[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            usuario['estado'],
                            style: TextStyle(
                              color: isActive ? Colors.green[700] : Colors.red[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      usuario['email'],
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.chat_bubble_outline, 
                             size: 16, color: Theme.of(context).iconTheme.color?.withOpacity(0.6)),
                        const SizedBox(width: 4),
                        Text(
                          '${usuario['consultas']} consultas',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.warning_amber_outlined, 
                             size: 16, color: Theme.of(context).iconTheme.color?.withOpacity(0.6)),
                        const SizedBox(width: 4),
                        Text(
                          '${usuario['reportes']} reportes',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Activo ${usuario['ultimaActividad']}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Acciones rápidas
              Column(
                children: [
                  IconButton(
                    icon: Icon(isActive ? Icons.block : Icons.check_circle),
                    color: isActive ? Colors.red[600] : Colors.green[600],
                    onPressed: () {
                      if (isActive) {
                        _showSuspendDialog(usuario['id'], notifier);
                      } else {
                        notifier.reactivarUsuario(usuario['id']);
                      }
                    },
                    tooltip: isActive ? 'Suspender' : 'Reactivar',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red[600],
                    onPressed: () => _showDeleteDialog(usuario, notifier),
                    tooltip: 'Eliminar',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsView(SimpleUserManagementNotifier notifier) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Cards de estadísticas
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Usuarios',
                  notifier.totalUsuarios.toString(),
                  Icons.people,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Usuarios Activos',
                  notifier.usuariosActivos.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Usuarios Suspendidos',
                  notifier.usuariosSuspendidos.toString(),
                  Icons.block,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Nuevos (7 días)',
                  '3',
                  Icons.trending_up,
                  Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Gráfico simple de actividad
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Actividad Reciente',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildActivityItem('Carlos Ramírez', 'Nueva consulta', '2h'),
                _buildActivityItem('María González', 'Perfil actualizado', '4h'),
                _buildActivityItem('Luis Hernández', 'Se registró', '6h'),
                _buildActivityItem('Sandra Castro', 'Nueva consulta', '1d'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String usuario, String accion, String tiempo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.blue[600],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  usuario,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  accion,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            tiempo,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showUserDetail(Map<String, dynamic> usuario, SimpleUserManagementNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: _getUserTypeColor(usuario['tipo']),
              child: Icon(
                _getUserTypeIcon(usuario['tipo']),
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    usuario['nombre'],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    usuario['tipo'],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: ${usuario['email']}'),
              const SizedBox(height: 8),
              Text('Estado: ${usuario['estado']}'),
              if (usuario['telefono'] != null) ...[
                const SizedBox(height: 8),
                Text('Teléfono: ${usuario['telefono']}'),
              ],
              if (usuario['ciudad'] != null) ...[
                const SizedBox(height: 8),
                Text('Ciudad: ${usuario['ciudad']}'),
              ],
              const SizedBox(height: 8),
              Text('Consultas: ${usuario['consultas']}'),
              Text('Reportes: ${usuario['reportes']}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (usuario['estado'] == 'Activo') {
                _showSuspendDialog(usuario['id'], notifier);
              } else {
                notifier.reactivarUsuario(usuario['id']);
              }
            },
            child: Text(usuario['estado'] == 'Activo' ? 'Suspender' : 'Activar'),
          ),
        ],
      ),
    );
  }

  // Métodos para obtener íconos y colores según el tipo de usuario
  IconData _getUserTypeIcon(String? tipo) {
    switch (tipo?.toLowerCase()) {
      case 'abogado':
        return Icons.gavel;
      case 'vendedor':
        return Icons.store;
      case 'ciudadano':
      default:
        return Icons.person;
    }
  }

  Color _getUserTypeColor(String? tipo) {
    switch (tipo?.toLowerCase()) {
      case 'abogado':
        return Colors.amber[600]!;
      case 'vendedor':
        return Colors.green[600]!;
      case 'ciudadano':
      default:
        return Colors.blue[600]!;
    }
  }

  void _showSuspendDialog(String usuarioId, SimpleUserManagementNotifier notifier) {
    final TextEditingController motivoController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suspender Usuario'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Motivo de la suspensión:'),
            const SizedBox(height: 8),
            TextField(
              controller: motivoController,
              decoration: const InputDecoration(
                hintText: 'Ingresa el motivo...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (motivoController.text.isNotEmpty) {
                notifier.suspenderUsuario(usuarioId, motivoController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Suspender'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> usuario, SimpleUserManagementNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Usuario'),
        content: Text('¿Eliminar a ${usuario['nombre']}?\nEsta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              notifier.eliminarUsuario(usuario['id']);
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}