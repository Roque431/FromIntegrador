import 'package:flutter/material.dart';

class ForumPostCard extends StatelessWidget {
  final String userName;
  final String userInitials;
  final String date;
  final String category;
  final List<String> tags;
  final String question;
  final String excerpt;
  final int likes;
  final int comments;
  final VoidCallback onTap;
  final VoidCallback onLike;

  const ForumPostCard({
    super.key,
    required this.userName,
    required this.userInitials,
    required this.date,
    required this.category,
    required this.tags,
    required this.question,
    required this.excerpt,
    required this.likes,
    required this.comments,
    required this.onTap,
    required this.onLike,
  });

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Laboral':
        return const Color(0xFFD19A86);
      case 'Penal':
        return const Color(0xFFE57373);
      case 'Civil':
        return const Color(0xFF81C784);
      case 'Familiar':
        return const Color(0xFF64B5F6);
      default:
        return const Color(0xFFD19A86);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final categoryColor = _getCategoryColor(category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Avatar, nombre, fecha
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: colors.tertiary,
                    child: Text(
                      userInitials,
                      style: const TextStyle(
                        color: Colors.white,
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
                                color: colors.tertiary,
                              ),
                        ),
                        Text(
                          date,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: colors.tertiary.withOpacity(0.5),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Categoría y tags
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.tertiary,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Extracto
              Text(
                excerpt,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.tertiary.withOpacity(0.6),
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Footer: Likes y comentarios
              Row(
                children: [
                  InkWell(
                    onTap: onLike,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.star_outline, size: 18, color: colors.tertiary.withOpacity(0.6)),
                          const SizedBox(width: 4),
                          Text(
                            '$likes',
                            style: TextStyle(
                              color: colors.tertiary.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Icon(Icons.people_outline, size: 18, color: colors.tertiary.withOpacity(0.6)),
                      const SizedBox(width: 4),
                      Text(
                        '$comments',
                        style: TextStyle(
                          color: colors.tertiary.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color, {bool isBold = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isBold ? Colors.white : Colors.black87,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}