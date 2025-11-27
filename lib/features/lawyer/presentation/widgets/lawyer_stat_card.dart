import 'package:flutter/material.dart';

class LawyerStatCard extends StatelessWidget {
  final String value;
  final String label;
  final bool showStar;

  const LawyerStatCard({
    super.key,
    required this.value,
    required this.label,
    this.showStar = false,
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: isWeb ? 32 : 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFB8907D),
                ),
              ),
              if (showStar) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                ),
              ],
            ],
          ),
          SizedBox(height: isWeb ? 8 : 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isWeb ? 14 : 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
