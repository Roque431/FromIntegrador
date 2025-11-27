import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../login/presentation/providers/login_notifier.dart';
import '../../data/models/lawyer_stats.dart';
import '../widgets/lawyer_stat_card.dart';
import '../widgets/monthly_stats_card.dart';
import '../widgets/quick_action_button.dart';

class LawyerHomePage extends StatelessWidget {
  const LawyerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

    // Obtener información del usuario autenticado
    final loginNotifier = context.watch<LoginNotifier>();
    final currentUser = loginNotifier.currentUser;

    // Datos del abogado
    final lawyerName = currentUser?.name ?? 'Abogado';
    final lawyerInitials = currentUser?.initials ?? 'A';

    // Estadísticas de demostración
    final stats = LawyerStats.demo();

    return Scaffold(
      backgroundColor: colors.primary,
      appBar: AppBar(
        backgroundColor: colors.primary,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(isWeb ? 12 : 10),
          child: CircleAvatar(
            backgroundColor: colors.secondary,
            child: Text(
              lawyerInitials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Abogado, buenos días',
              style: TextStyle(
                color: colors.tertiary,
                fontSize: isWeb ? 14 : 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              lawyerName,
              style: TextStyle(
                color: colors.tertiary,
                fontSize: isWeb ? 18 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: isWeb ? 16 : 12),
            child: Image.asset(
              'lib/img/portada.png',
              width: isWeb ? 45 : 40,
              height: isWeb ? 45 : 40,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWeb ? 900 : double.infinity),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: isWeb ? 24 : 16),

                  // Tarjetas de estadísticas principales (2x2)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isWeb ? 32 : 24),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: isWeb ? 16 : 12,
                      mainAxisSpacing: isWeb ? 16 : 12,
                      childAspectRatio: isWeb ? 1.5 : 1.3,
                      children: [
                        LawyerStatCard(
                          value: '${stats.casosAtendidos}',
                          label: 'Casos Atendidos',
                        ),
                        LawyerStatCard(
                          value: '${stats.calificacion}',
                          label: 'Calificación',
                          showStar: true,
                        ),
                        LawyerStatCard(
                          value: '${stats.puntosReputacion}',
                          label: 'Puntos Reputación',
                        ),
                        LawyerStatCard(
                          value: '${stats.consultasPendientes}',
                          label: 'Consultas Pendientes\nf -4 esta semana',
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isWeb ? 24 : 20),

                  // Estadísticas del mes
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isWeb ? 32 : 24),
                    child: MonthlyStatsCard(
                      respuestasEnForo: stats.respuestasEnForo,
                      consultasSemanales: stats.consultasSemanales,
                      nuevosClientes: stats.nuevosClientes,
                    ),
                  ),

                  SizedBox(height: isWeb ? 32 : 24),

                  // Título de Acciones Rápidas
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isWeb ? 32 : 24),
                    child: Text(
                      'Acciones Rápidas',
                      style: TextStyle(
                        fontSize: isWeb ? 20 : 18,
                        fontWeight: FontWeight.bold,
                        color: colors.tertiary,
                      ),
                    ),
                  ),

                  SizedBox(height: isWeb ? 16 : 12),

                  // Botones de acciones rápidas
                  QuickActionButton(
                    icon: Icons.chat_outlined,
                    title: 'Mis Consultas',
                    subtitle: '${stats.consultasPendientes} pendientes de responder',
                    onTap: () {
                      context.push('/lawyer/consultations');
                    },
                  ),

                  QuickActionButton(
                    icon: Icons.person_outline,
                    title: 'Editar Perfil',
                    subtitle: 'Actualiza tu información',
                    onTap: () {
                      context.push('/lawyer/profile');
                    },
                  ),

                  QuickActionButton(
                    icon: Icons.credit_card_outlined,
                    title: 'Mi Suscripción',
                    subtitle: 'Plan Profesional - Activo',
                    onTap: () {
                      context.push('/lawyer/subscription');
                    },
                  ),

                  QuickActionButton(
                    icon: Icons.bar_chart_outlined,
                    title: 'Estadísticas Avanzadas',
                    subtitle: 'Análisis detallado',
                    onTap: () {
                      // TODO: Navegar a estadísticas
                    },
                  ),

                  QuickActionButton(
                    icon: Icons.forum_outlined,
                    title: 'Foro Comunitario',
                    subtitle: 'Responder publicaciones',
                    onTap: () {
                      context.push('/lawyer/forum');
                    },
                  ),

                  SizedBox(height: isWeb ? 32 : 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
