import 'package:flutter/material.dart';

class ForumExpertComment extends StatelessWidget {
  final String userName;
  final String userInitials;
  final String date;
  final String comment;
  final int likes;
  final bool isLiked;
  final int replies;
  final VoidCallback onLike;
  final VoidCallback? onReply;

  const ForumExpertComment({
    super.key,
    required this.userName,
    required this.userInitials,
    required this.date,
    required this.comment,
    required this.likes,
    this.isLiked = false,
    required this.replies,
    required this.onLike,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                radius: 18,
                backgroundColor: colorScheme.secondary,
                child: Text(
                  userInitials,
                  style: TextStyle(
                    color: colorScheme.onSecondary,
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

          // Comentario
          Text(
            comment,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 15,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 12),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onLike,
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(isLiked ? 6 : 2),
                      decoration: BoxDecoration(
                        color: isLiked ? colorScheme.primaryContainer : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        size: 18,
                        color: isLiked ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Útil ($likes)',
                      style: TextStyle(
                        color: isLiked ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: isLiked ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: onReply,
                    child: Row(
                      children: [
                        Icon(Icons.reply_outlined, size: 18, color: colorScheme.primary),
                        const SizedBox(width: 4),
                        Text(
                          'Responder',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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