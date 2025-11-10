import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LexiaMessageBubble extends StatelessWidget {
  final String message;
  final String? label;

  const LexiaMessageBubble({
    super.key,
    required this.message,
    this.label = 'Respuesta de LexIA',
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header con avatar de LexIA
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: colors.secondary,
              child: const Text(
                'IA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label ?? 'Respuesta de LexIA',
              style: TextStyle(
                color: colors.tertiary.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Burbuja del mensaje con contenido formateado
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contenido del mensaje con formato Markdown-like
              _buildFormattedText(context, message),
              
              const SizedBox(height: 12),
              
              // Botones de acción
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.copy_outlined, size: 20, color: colors.tertiary.withOpacity(0.6)),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: message));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Respuesta copiada al portapapeles'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    tooltip: 'Copiar respuesta',
                  ),
                  IconButton(
                    icon: Icon(Icons.thumb_up_outlined, size: 20, color: colors.tertiary.withOpacity(0.6)),
                    onPressed: () {
                      // TODO: Enviar feedback positivo
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('¡Gracias por tu feedback!')),
                      );
                    },
                    tooltip: 'Me gusta',
                  ),
                  IconButton(
                    icon: Icon(Icons.thumb_down_outlined, size: 20, color: colors.tertiary.withOpacity(0.6)),
                    onPressed: () {
                      // TODO: Enviar feedback negativo
                      _showFeedbackDialog(context);
                    },
                    tooltip: 'No me gusta',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormattedText(BuildContext context, String text) {
    final colors = Theme.of(context).colorScheme;
    final lines = text.split('\n');
    final widgets = <Widget>[];

    for (var line in lines) {
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 8));
        continue;
      }

      // Títulos en negrita (** **)
      if (line.startsWith('**') && line.endsWith('**')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Text(
              line.replaceAll('**', ''),
              style: TextStyle(
                color: colors.tertiary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
          ),
        );
      }
      // Elementos de lista (-)
      else if (line.trim().startsWith('-')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: colors.secondary, fontSize: 15)),
                Expanded(
                  child: Text(
                    line.trim().substring(1).trim(),
                    style: TextStyle(
                      color: colors.tertiary,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      // Numeración (1. 2. etc)
      else if (RegExp(r'^\d+\.').hasMatch(line.trim())) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              line,
              style: TextStyle(
                color: colors.tertiary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
        );
      }
      // Texto normal
      else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              line,
              style: TextStyle(
                color: colors.tertiary,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Qué podemos mejorar?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Cuéntanos qué no te gustó de esta respuesta...',
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
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Gracias por tu feedback')),
              );
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}