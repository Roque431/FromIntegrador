import 'package:flutter/material.dart';

class ContentTypeFilter extends StatelessWidget {
  final String? selectedType;
  final Function(String?) onTypeChanged;

  const ContentTypeFilter({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(
            label: 'Todos',
            isSelected: selectedType == null,
            onTap: () => onTypeChanged(null),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Leyes',
            isSelected: selectedType == 'Ley',
            onTap: () => onTypeChanged('Ley'),
            color: Colors.blue,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Reglamentos',
            isSelected: selectedType == 'Reglamento',
            onTap: () => onTypeChanged('Reglamento'),
            color: Colors.orange,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Jurisprudencia',
            isSelected: selectedType == 'Jurisprudencia',
            onTap: () => onTypeChanged('Jurisprudencia'),
            color: Colors.purple,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Códigos',
            isSelected: selectedType == 'Codigo',
            onTap: () => onTypeChanged('Codigo'),
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? chipColor : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
