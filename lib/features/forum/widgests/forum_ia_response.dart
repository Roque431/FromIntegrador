import 'package:flutter/material.dart';

class ForumIAResponse extends StatelessWidget {
  final String response;

  const ForumIAResponse({
    super.key,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              'Respuesta de LexIA',
              style: TextStyle(
                color: colors.tertiary.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
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
            response,
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