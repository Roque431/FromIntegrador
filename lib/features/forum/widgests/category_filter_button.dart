import 'package:flutter/material.dart';

class CategoryFilterButton extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const CategoryFilterButton({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopupMenuButton<String>(
      color: colorScheme.surfaceContainerHighest,
      icon: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.category_outlined, color: colorScheme.secondary, size: 20),
            const SizedBox(width: 4),
            Text(
              'Todas Las Categorias',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: const Offset(0, 50),
      itemBuilder: (context) => [
        _buildMenuItem('Todas Las Categorias', null, colorScheme),
        const PopupMenuDivider(),
        _buildMenuItem('Laboral', 'Laboral', colorScheme),
        _buildMenuItem('Penal', 'Penal', colorScheme),
        _buildMenuItem('Civil', 'Civil', colorScheme),
        _buildMenuItem('Familiar', 'Familiar', colorScheme),
      ],
      onSelected: onChanged,
    );
  }

  PopupMenuItem<String> _buildMenuItem(String title, String? value, ColorScheme colorScheme) {
    final isSelected = selectedCategory == value;
    return PopupMenuItem<String>(
      value: value,
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}