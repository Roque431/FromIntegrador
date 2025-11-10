import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown({
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
        child: Icon(
          Icons.filter_list,
          color: colors.secondary,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      offset: const Offset(0, 50),
      itemBuilder: (context) => [
        _buildMenuItem('Todas Las Categorías', null, colors),
        const PopupMenuDivider(),
        _buildMenuItem('Laboral', 'Laboral', colors),
        _buildMenuItem('Civil', 'Civil', colors),
        _buildMenuItem('Familiar', 'Familiar', colors),
        _buildMenuItem('Penal', 'Penal', colors),
        _buildMenuItem('Mercantil', 'Mercantil', colors),
        _buildMenuItem('Propiedad Intelectual', 'Propiedad Intelectual', colors),
        _buildMenuItem('Constitucional', 'Constitucional', colors),
        _buildMenuItem('Fiscal', 'Fiscal', colors),
      ],
      onSelected: onChanged,
    );
  }

  PopupMenuItem<String> _buildMenuItem(String title, String? value, ColorScheme colors) {
    final isSelected = selectedCategory == value;
    
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          if (isSelected)
            Icon(Icons.check, color: colors.secondary, size: 20)
          else
            const SizedBox(width: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? colors.secondary : colors.tertiary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}