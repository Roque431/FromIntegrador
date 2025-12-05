import 'package:flutter/material.dart';
import '../../data/models/profile_validation_model.dart';

class ProfileValidationCard extends StatelessWidget {
  final ProfileValidationModel profile;
  final bool isSelected;
  final bool isProcessing;
  final VoidCallback onTap;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const ProfileValidationCard({
    super.key,
    required this.profile,
    required this.onTap,
    required this.onApprove,
    required this.onReject,
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con avatar y información básica
              Row(
                children: [
                  // Avatar con iniciales
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: profile.avatarColor,
                    child: Text(
                      profile.iniciales,
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Información principal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.nombreCompleto,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Solicitó verificación ${profile.tiempoEspera}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Indicador de procesamiento
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
              
              // Información profesional en chips
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      'Tipo:',
                      profile.tipoTexto,
                      Icons.work_outline,
                      colors,
                      textTheme,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Cédula Profesional:',
                      profile.cedulaProfesional,
                      Icons.badge,
                      colors,
                      textTheme,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Especialidad:',
                      profile.especialidad,
                      Icons.school,
                      colors,
                      textTheme,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Años experiencia:',
                      '${profile.anosExperiencia} años',
                      Icons.timeline,
                      colors,
                      textTheme,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Documentos adjuntos
              Text(
                'Documentos adjuntos:',
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 8),
              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: profile.documentos.map((documento) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.secondaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colors.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          documento.icono,
                          size: 14,
                          color: colors.onSurface.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          documento.nombre,
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 16),
              
              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isProcessing ? null : onReject,
                      icon: Icon(
                        Icons.close,
                        size: 18,
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isProcessing ? null : onApprove,
                      icon: Icon(
                        Icons.check,
                        size: 18,
                        color: isProcessing ? null : colors.onPrimary,
                      ),
                      label: Text(
                        'Aprobar',
                        style: TextStyle(
                          color: isProcessing ? null : colors.onPrimary,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isProcessing ? null : Colors.green,
                        foregroundColor: isProcessing ? null : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: colors.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: colors.onSurface.withOpacity(0.8),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}