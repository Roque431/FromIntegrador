import 'package:flutter/material.dart';

class MonthlyStatsCard extends StatelessWidget {
  final int respuestasEnForo;
  final int consultasSemanales;
  final int nuevosClientes;

  const MonthlyStatsCard({
    super.key,
    required this.respuestasEnForo,
    required this.consultasSemanales,
    required this.nuevosClientes,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

    return Container(
      padding: EdgeInsets.all(isWeb ? 20 : 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(isWeb ? 16 : 12),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estadísticas del Mes',
            style: TextStyle(
              fontSize: isWeb ? 18 : 16,
              fontWeight: FontWeight.bold,
              color: colors.tertiary,
            ),
          ),
          SizedBox(height: isWeb ? 20 : 16),
          _buildStatRow(
            context,
            'Respuestas en foro:',
            '$respuestasEnForo / 50',
            isWeb,
          ),
          SizedBox(height: isWeb ? 16 : 12),
          _buildStatRow(
            context,
            'Consultas privadas:',
            '$consultasSemanales',
            isWeb,
          ),
          SizedBox(height: isWeb ? 16 : 12),
          _buildStatRow(
            context,
            'Nuevos clientes:',
            '$nuevosClientes',
            isWeb,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    bool isWeb,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isWeb ? 15 : 14,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isWeb ? 16 : 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
      ],
    );
  }
}
