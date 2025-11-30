import 'package:flutter/material.dart';

class DocumentUploadSection extends StatelessWidget {
  const DocumentUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Documentos Requeridos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.tertiary,
          ),
        ),
        const SizedBox(height: 16),

        Text(
          'Para completar el registro, necesitamos los siguientes documentos:',
          style: TextStyle(
            color: colors.tertiary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 16),

        _DocumentItem(
          icon: Icons.badge,
          title: 'Identificación Oficial del Propietario',
          description: 'INE, Pasaporte o Cédula Profesional',
          required: true,
          color: colors.secondary,
        ),
        const SizedBox(height: 12),

        _DocumentItem(
          icon: Icons.business,
          title: 'Comprobante de Domicilio',
          description: 'No mayor a 3 meses del negocio',
          required: true,
          color: colors.tertiary,
        ),
        const SizedBox(height: 12),

        _DocumentItem(
          icon: Icons.store,
          title: 'Registro del Negocio',
          description: 'RFC, Acta Constitutiva o Alta en Hacienda',
          required: true,
          color: const Color(0xFFB8907D),
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Información Importante',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '• Los documentos serán revisados por nuestro equipo de verificación\n'
                '• El proceso de verificación toma entre 24-48 horas\n'
                '• Te notificaremos por email el resultado\n'
                '• Todos los documentos son tratados de forma confidencial',
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DocumentItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool required;
  final Color color;

  const _DocumentItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.required,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: colors.tertiary,
                        ),
                      ),
                    ),
                    if (required)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Requerido',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: colors.tertiary.withValues(alpha: 0.75),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implementar selección de archivo
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Subir',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
