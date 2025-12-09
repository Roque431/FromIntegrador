import 'package:flutter/material.dart';

class ForumUserPost extends StatelessWidget {
  final String userName;
  final String userInitials;
  final String date;
  final String category;
  final List<String> tags;
  final String question;
  final int likes;
  final int comments;
  final bool isLiked;
  final bool isDisliked;
  final int noUtilCount;
  final VoidCallback onLike;
  final VoidCallback? onDislike;
  final VoidCallback? onGroupTap;
  final VoidCallback? onReplyTap;

  const ForumUserPost({
    super.key,
    required this.userName,
    required this.userInitials,
    required this.date,
    required this.category,
    required this.tags,
    required this.question,
    required this.likes,
    required this.comments,
    required this.isLiked,
    this.isDisliked = false,
    this.noUtilCount = 0,
    required this.onLike,
    this.onDislike,
    this.onGroupTap,
    this.onReplyTap,
  });

  Color _getCategoryColor(String category, ColorScheme colorScheme) {
    switch (category) {
      case 'Accidentes':
        return const Color(0xFFFFA500);
      case 'Alcoholemia':
        return const Color(0xFFB366CC);
      case 'Multas':
        return const Color(0xFFD19A86);
      case 'Documentos':
        return const Color(0xFF4CAF50);
      case 'Estacionamiento':
        return const Color(0xFF2196F3);
      default:
        return colorScheme.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoryColor = _getCategoryColor(category, colorScheme);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primary,
                child: Text(
                  userInitials,
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                    ),
                    Text(
                      date,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag(category, categoryColor, isBold: true),
              ...tags.map((tag) => _buildTag(
                    '#$tag',
                    categoryColor.withOpacity(0.3),
                  )),
            ],
          ),

          const SizedBox(height: 12),

          // Pregunta
          Text(
            question,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
          ),

          const SizedBox(height: 12),

          // Footer with interactions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Useful
              InkWell(
                onTap: onLike,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.thumb_up,
                        size: 20,
                        color: isLiked ? colorScheme.primary : colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Útil ($likes)',
                        style: TextStyle(
                          color: isLiked ? colorScheme.primary : colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: isLiked ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Not useful (dislike) with animation and count
              GestureDetector(
                onTap: onDislike,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        padding: EdgeInsets.all(isDisliked ? 6 : 2),
                        decoration: BoxDecoration(
                          color: isDisliked ? colorScheme.errorContainer : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined,
                          size: isDisliked ? 20 : 20,
                          color: isDisliked ? colorScheme.onErrorContainer : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        noUtilCount > 0 ? 'No útil ($noUtilCount)' : 'No útil',
                        style: TextStyle(
                          color: isDisliked ? colorScheme.onErrorContainer : colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: isDisliked ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Group members
              InkWell(
                onTap: onGroupTap,
                child: Tooltip(
                  message: '$comments miembros del grupo - Toca para ver',
                  child: Row(
                    children: [
                      Icon(Icons.people_outline, size: 20, color: colorScheme.primary),
                      const SizedBox(width: 6),
                      Text(
                        '$comments',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color, {bool isBold = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(isBold ? 1.0 : 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color,
          width: isBold ? 0 : 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isBold ? Colors.white : color,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}
