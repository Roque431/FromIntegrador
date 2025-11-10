import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String initials;
  final String? imageUrl;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.initials,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Avatar
        CircleAvatar(
          radius: 50,
          backgroundColor: colors.secondary,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
          child: imageUrl == null
              ? Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
        const SizedBox(height: 16),
        
        // Nombre
        Text(
          name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.tertiary,
              ),
        ),
      ],
    );
  }
}