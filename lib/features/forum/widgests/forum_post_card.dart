import 'package:flutter/material.dart';
import 'group_members_dialog.dart';

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
  final VoidCallback? onDislike;

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
    this.onDislike,
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
      case 'Alcoholemia':
        return const Color(0xFFBA68C8);
      case 'Accidentes':
        return const Color(0xFFFFB74D);
      default:
        return const Color(0xFFD19A86);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final categoryColor = _getCategoryColor(category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                          style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                        ),
                        Text(
                          date,
                          style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
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
                        categoryColor.withValues(alpha: 0.3),
                      )),
                ],
              ),

              const SizedBox(height: 12),

              // Pregunta
              Text(
                question,
                style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Extracto
              Text(
                excerpt,
                style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Footer: Likes y comentarios
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Useful
                  InkWell(
                    onTap: onLike,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.thumb_up, size: 18, color: colorScheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            'Útil ($likes)',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Not useful
                  InkWell(
                    onTap: onDislike,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.thumb_down_outlined, size: 18, color: colorScheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            'No útil',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Group members - clickeable
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => GroupMembersDialog(
                          groupName: 'Grupo de ${category}',
                          totalMembers: comments,
                          members: [
                            GroupMember(
                              id: '1',
                              name: userName,
                              initials: userInitials,
                              participations: likes,
                            ),
                          ],
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.people_outline, size: 18, color: colorScheme.primary),
                          const SizedBox(width: 4),
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
        ),
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