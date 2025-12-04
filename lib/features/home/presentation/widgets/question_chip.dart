import 'package:flutter/material.dart';

class QuestionChip extends StatelessWidget {
  final String question;

  const QuestionChip({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

    return InkWell(
      onTap: () {
        // TODO: Llenar el campo de texto con esta pregunta
      },
      borderRadius: BorderRadius.circular(isWeb ? 24 : 20),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isWeb ? 20 : 16,
          vertical: isWeb ? 14 : 10,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(isWeb ? 24 : 20),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: isDark ? 0.5 : 1.0),
            width: isWeb ? 1.5 : 1,
          ),
        ),
        child: Text(
          question,
          style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
                fontSize: isWeb ? 15 : null,
              ),
        ),
      ),
    );
  }
}