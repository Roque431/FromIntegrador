import 'package:flutter/material.dart';

class UserMessageBubble extends StatelessWidget {
  final String message;
  final String initials;
  final String? label;

  const UserMessageBubble({
    super.key,
    required this.message,
    required this.initials,
    this.label = 'Tu pregunta',
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header con avatar y etiqueta
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: colors.tertiary,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label ?? 'Tu pregunta',
              style: TextStyle(
                color: colors.tertiary.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Burbuja del mensaje
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
          child: Text(
            message,
            style: TextStyle(
              color: colors.tertiary,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}