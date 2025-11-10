import 'package:flutter/material.dart';

class ForumExpertComment extends StatelessWidget {
  final String userName;
  final String userInitials;
  final String date;
  final String comment;
  final int likes;
  final int replies;
  final VoidCallback onLike;

  const ForumExpertComment({
    super.key,
    required this.userName,
    required this.userInitials,
    required this.date,
    required this.comment,
    required this.likes,
    required this.replies,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey.shade400,
                child: Text(
                  userInitials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
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

          // Comentario
          Text(
            comment,
            style: TextStyle(
              color: colors.tertiary,
              fontSize: 15,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 12),

          // Footer
          Row(
            children: [
              InkWell(
                onTap: onLike,
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
              const SizedBox(width: 16),
              Row(
                children: [
                  Icon(Icons.people_outline, size: 18, color: colors.tertiary.withOpacity(0.6)),
                  const SizedBox(width: 4),
                  Text(
                    '$replies',
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
    );
  }
}