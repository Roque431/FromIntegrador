import 'package:flutter/material.dart';
import '../../data/models/moderation_model.dart';

class ReportCard extends StatelessWidget {
  final ReportModel report;
  final bool isSelected;
  final bool isProcessing;
  final VoidCallback onTap;
  final VoidCallback onResolve;
  final VoidCallback onReject;
  final Function(ReportPriority) onPriorityChange;

  const ReportCard({
    super.key,
    required this.report,
    required this.onTap,
    required this.onResolve,
    required this.onReject,
    required this.onPriorityChange,
    this.isSelected = false,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 1,
      color: isSelected ? colors.primaryContainer.withOpacity(0.1) : colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? colors.primary : colors.outline.withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: isProcessing ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: report.prioridadColor,
                width: 4,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con prioridad y estado
                Row(
                  children: [
                    // Ícono del tipo de reporte
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: report.prioridadColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        report.tipoIcon,
                        color: report.prioridadColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Información principal
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.titulo,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Reportado por: ${report.reportadoPor} • ${report.tiempoTranscurrido}',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Badges de prioridad y estado
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: report.prioridadColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            report.prioridadTexto.toUpperCase(),
                            style: textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: report.statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: report.statusColor.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            report.statusTexto,
                            style: textTheme.labelSmall?.copyWith(
                              color: report.statusColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    if (isProcessing) ...[
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                        ),
                      ),
                    ],
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Información del reporte
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: colors.onSurface.withOpacity(0.6),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tipo: ${report.tipoTexto} • ${report.tipoContenidoTexto}',
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colors.onSurface.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Contenido reportado:',
                        style: textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '"${report.contenidoReportado}"',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurface,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Autor: ${report.autorContenido}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Motivo del reporte
                Text(
                  'Motivo del reporte:',
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  report.motivoReporte,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurface.withOpacity(0.8),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Botones de acción
                if (report.status == ReportStatus.pendiente || report.status == ReportStatus.enRevision)
                  Row(
                    children: [
                      // Cambiar prioridad
                      Expanded(
                        child: PopupMenuButton<ReportPriority>(
                          onSelected: onPriorityChange,
                          itemBuilder: (context) => ReportPriority.values.map((prioridad) {
                            return PopupMenuItem(
                              value: prioridad,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.flag,
                                    color: _getPrioridadColor(prioridad),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(_getPrioridadTexto(prioridad)),
                                ],
                              ),
                            );
                          }).toList(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: colors.outline.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.flag,
                                  size: 16,
                                  color: colors.onSurface.withOpacity(0.7),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Prioridad',
                                  style: textTheme.bodySmall,
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 16,
                                  color: colors.onSurface.withOpacity(0.7),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      // Rechazar
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isProcessing ? null : onReject,
                          icon: Icon(
                            Icons.close,
                            size: 16,
                            color: isProcessing ? null : colors.error,
                          ),
                          label: Text(
                            'Rechazar',
                            style: TextStyle(
                              color: isProcessing ? null : colors.error,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isProcessing ? colors.outline.withOpacity(0.3) : colors.error,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      // Resolver
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: isProcessing ? null : onResolve,
                          icon: Icon(
                            Icons.check,
                            size: 16,
                            color: isProcessing ? null : colors.onPrimary,
                          ),
                          label: Text(
                            'Resolver',
                            style: TextStyle(
                              color: isProcessing ? null : colors.onPrimary,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isProcessing ? null : colors.primary,
                            foregroundColor: isProcessing ? null : colors.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getPrioridadColor(ReportPriority prioridad) {
    switch (prioridad) {
      case ReportPriority.bajo:
        return Colors.green;
      case ReportPriority.medio:
        return Colors.orange;
      case ReportPriority.alto:
        return Colors.red;
      case ReportPriority.critico:
        return Colors.purple;
    }
  }

  String _getPrioridadTexto(ReportPriority prioridad) {
    switch (prioridad) {
      case ReportPriority.bajo:
        return 'Bajo';
      case ReportPriority.medio:
        return 'Medio';
      case ReportPriority.alto:
        return 'Alto';
      case ReportPriority.critico:
        return 'Crítico';
    }
  }
}