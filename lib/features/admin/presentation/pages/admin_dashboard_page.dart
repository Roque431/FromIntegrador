import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/router/routes.dart';
import '../providers/simple_admin_notifier.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SimpleAdminNotifier>().loadAdminStats());
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: const Text(
          'Panel de Administración - LexIA',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Consumer<SimpleAdminNotifier>(
        builder: (context, adminNotifier, child) {
          if (adminNotifier.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => adminNotifier.loadAdminStats(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bienvenida
                  Card(
                    color: colors.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.dashboard,
                            size: 32,
                            color: colors.onPrimaryContainer,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '¡Bienvenido al Panel de Administración!\nAquí puedes gestionar toda la plataforma LexIA.',
                              style: TextStyle(
                                color: colors.onPrimaryContainer,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // Estadísticas generales
                  Text(
                    'Estadísticas del Sistema',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Grid de estadísticas
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.3,
                    children: [
                      _buildStatCard(
                        'Usuarios Totales',
                        '${adminNotifier.stats['totalUsers']}',
                        Icons.people,
                        Colors.blue,
                      ),
                      _buildStatCard(
                        'Abogados Verificados',
                        '${adminNotifier.stats['totalLawyers']}',
                        Icons.gavel,
                        Colors.purple,
                      ),
                      _buildStatCard(
                        'Consultas Realizadas',
                        '${adminNotifier.stats['totalConsultations']}',
                        Icons.chat_bubble,
                        Colors.green,
                      ),
                      _buildStatCard(
                        'Usuarios Activos',
                        '${adminNotifier.stats['activeUsers']}',
                        Icons.online_prediction,
                        Colors.orange,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Tareas pendientes
                  Text(
                    'Tareas de Administración',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildActionCard(
                    'Validar Perfiles de Abogados',
                    '${adminNotifier.pendingProfiles.length} perfiles esperando aprobación',
                    Icons.verified_user,
                    Colors.blue,
                    () => context.go('/${AppRoutes.profileValidation}'),
                  ),

                  const SizedBox(height: 12),

                  _buildActionCard(
                    'Moderar Reportes',
                    '${adminNotifier.pendingReports.length} reportes requieren revisión',
                    Icons.report_problem,
                    Colors.red,
                    () => context.go('/${AppRoutes.moderation}'),
                  ),

                  const SizedBox(height: 12),

                  _buildActionCard(
                    'Gestión de Usuarios',
                    'Administrar perfiles y suspender cuentas',
                    Icons.people_outline,
                    Colors.purple,
                    () => context.go('/${AppRoutes.userManagement}'),
                  ),

                  const SizedBox(height: 12),

                  _buildActionCard(
                    'Gestión de Contenido',
                    'Administrar publicaciones y comentarios',
                    Icons.content_paste,
                    Colors.green,
                    () => _showMessage('Panel de gestión de contenido'),
                  ),

                  const SizedBox(height: 12),

                  _buildActionCard(
                    'Configuración del Sistema',
                    'Ajustes generales y configuración',
                    Icons.settings,
                    Colors.grey,
                    () => _showMessage('Panel de configuración'),
                  ),

                  const SizedBox(height: 32),

                  // Información financiera
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.attach_money, color: colors.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Información Financiera',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow('💰 Ingresos Mensuales', '\$${adminNotifier.stats['monthlyRevenue']}'),
                          _buildInfoRow('⏳ Validaciones Pendientes', '${adminNotifier.stats['pendingValidations']}'),
                          _buildInfoRow('🏢 Sistema', 'LexIA - Plataforma Jurídica Digital'),
                          _buildInfoRow('📊 Estado', 'Operacional'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showMessage(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - En desarrollo'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.arrow_forward_ios, color: color, size: 16),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}