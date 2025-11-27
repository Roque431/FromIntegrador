import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/consultation_request.dart';

class MyConsultationsPage extends StatefulWidget {
  const MyConsultationsPage({super.key});

  @override
  State<MyConsultationsPage> createState() => _MyConsultationsPageState();
}

class _MyConsultationsPageState extends State<MyConsultationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<ConsultationRequest> _allConsultations =
      ConsultationRequest.getDemoData();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ConsultationRequest> _getConsultationsByStatus(
      ConsultationStatus status) {
    return _allConsultations
        .where((c) => c.status == status)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

    final pendientes =
        _getConsultationsByStatus(ConsultationStatus.pendiente);
    final enProceso =
        _getConsultationsByStatus(ConsultationStatus.enProceso);
    final resueltas =
        _getConsultationsByStatus(ConsultationStatus.resuelta);

    return Scaffold(
      backgroundColor: colors.primary,
      appBar: AppBar(
        backgroundColor: colors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colors.tertiary,
            size: isWeb ? 28 : 24,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Mis Consultas',
          style: TextStyle(
            color: colors.tertiary,
            fontWeight: FontWeight.w600,
            fontSize: isWeb ? 22 : null,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: colors.secondary,
          unselectedLabelColor: colors.tertiary.withValues(alpha: 0.6),
          indicatorColor: colors.secondary,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isWeb ? 15 : 14,
          ),
          tabs: [
            Tab(text: 'Pendientes (${pendientes.length})'),
            Tab(text: 'En Proceso (${enProceso.length})'),
            Tab(text: 'Resueltas (${resueltas.length})'),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: isWeb ? 900 : double.infinity),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildConsultationList(pendientes, isWeb),
                _buildConsultationList(enProceso, isWeb),
                _buildConsultationList(resueltas, isWeb),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConsultationList(
      List<ConsultationRequest> consultations, bool isWeb) {
    if (consultations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: isWeb ? 80 : 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: isWeb ? 16 : 12),
            Text(
              'No hay consultas aquí',
              style: TextStyle(
                fontSize: isWeb ? 18 : 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(isWeb ? 16 : 12),
      itemCount: consultations.length,
      itemBuilder: (context, index) {
        final consultation = consultations[index];
        return _buildConsultationCard(consultation, isWeb);
      },
    );
  }

  Widget _buildConsultationCard(
      ConsultationRequest consultation, bool isWeb) {
    final colors = Theme.of(context).colorScheme;

    Color statusColor;
    switch (consultation.status) {
      case ConsultationStatus.pendiente:
        statusColor = Colors.orange;
        break;
      case ConsultationStatus.enProceso:
        statusColor = Colors.blue;
        break;
      case ConsultationStatus.resuelta:
        statusColor = Colors.green;
        break;
    }

    return Card(
      margin: EdgeInsets.only(bottom: isWeb ? 12 : 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isWeb ? 14 : 12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navegar al detalle de la consulta
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Abriendo consulta: ${consultation.topic}'),
            ),
          );
        },
        borderRadius: BorderRadius.circular(isWeb ? 14 : 12),
        child: Padding(
          padding: EdgeInsets.all(isWeb ? 18 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar del cliente
                  CircleAvatar(
                    radius: isWeb ? 24 : 20,
                    backgroundColor: const Color(0xFFB8907D).withValues(alpha: 0.2),
                    child: Text(
                      consultation.clientInitials,
                      style: TextStyle(
                        color: const Color(0xFFB8907D),
                        fontWeight: FontWeight.bold,
                        fontSize: isWeb ? 16 : 14,
                      ),
                    ),
                  ),
                  SizedBox(width: isWeb ? 14 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          consultation.clientName,
                          style: TextStyle(
                            fontSize: isWeb ? 16 : 15,
                            fontWeight: FontWeight.w600,
                            color: colors.tertiary,
                          ),
                        ),
                        SizedBox(height: isWeb ? 4 : 2),
                        Text(
                          consultation.timeAgo,
                          style: TextStyle(
                            fontSize: isWeb ? 13 : 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 10 : 8,
                      vertical: isWeb ? 6 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      consultation.statusLabel,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: isWeb ? 12 : 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isWeb ? 14 : 12),
              Text(
                consultation.topic,
                style: TextStyle(
                  fontSize: isWeb ? 16 : 15,
                  fontWeight: FontWeight.bold,
                  color: colors.tertiary,
                ),
              ),
              SizedBox(height: isWeb ? 8 : 6),
              Text(
                consultation.preview,
                style: TextStyle(
                  fontSize: isWeb ? 14 : 13,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (consultation.status == ConsultationStatus.pendiente) ...[
                SizedBox(height: isWeb ? 14 : 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implementar responder
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Función de responder próximamente'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB8907D),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: isWeb ? 14 : 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Responder',
                      style: TextStyle(
                        fontSize: isWeb ? 15 : 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
              if (consultation.status == ConsultationStatus.enProceso) ...[
                SizedBox(height: isWeb ? 14 : 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Implementar continuar chat
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Función de continuar chat próximamente'),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFB8907D)),
                      padding: EdgeInsets.symmetric(
                        vertical: isWeb ? 14 : 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Continuar Chat',
                      style: TextStyle(
                        fontSize: isWeb ? 15 : 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFB8907D),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
