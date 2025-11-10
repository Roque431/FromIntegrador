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
    final colors = Theme.of(context).colorScheme;

    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.category_outlined, color: colors.secondary, size: 20),
            const SizedBox(width: 4),
            Text(
              'Todas Las Categorias',
              style: TextStyle(
                color: colors.tertiary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: const Offset(0, 50),
      itemBuilder: (context) => [
        _buildMenuItem('Todas Las Categorias', null, colors),
        const PopupMenuDivider(),
        _buildMenuItem('Laboral', 'Laboral', colors),
        _buildMenuItem('Penal', 'Penal', colors),
        _buildMenuItem('Civil', 'Civil', colors),
        _buildMenuItem('Familiar', 'Familiar', colors),
      ],
      onSelected: onChanged,
    );
  }

  PopupMenuItem<String> _buildMenuItem(String title, String? value, ColorScheme colors) {
    final isSelected = selectedCategory == value;
    return PopupMenuItem<String>(
      value: value,
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? colors.secondary : colors.tertiary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}