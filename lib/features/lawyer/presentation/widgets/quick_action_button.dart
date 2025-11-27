import 'package:flutter/material.dart';

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isWeb ? 32 : 24,
        vertical: isWeb ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(isWeb ? 14 : 12),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isWeb ? 14 : 12),
        child: Padding(
          padding: EdgeInsets.all(isWeb ? 18 : 16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isWeb ? 12 : 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFB8907D).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(isWeb ? 12 : 10),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFB8907D),
                  size: isWeb ? 26 : 24,
                ),
              ),
              SizedBox(width: isWeb ? 16 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isWeb ? 16 : 15,
                        fontWeight: FontWeight.w600,
                        color: colors.tertiary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: isWeb ? 13 : 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: isWeb ? 24 : 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
