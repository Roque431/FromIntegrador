import 'package:flutter/material.dart';
import '../providers/moderation_notifier.dart';

class ModerationFilterChips extends StatelessWidget {
  final ModerationFilter selectedFilter;
  final Function(ModerationFilter) onFilterChanged;
  final Map<ModerationFilter, int> counts;

  const ModerationFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.counts,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            context,
            ModerationFilter.pendientes,
            'Pendientes',
            Icons.pending_actions,
            Colors.orange,
            colors,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            ModerationFilter.urgentes,
            'Urgentes',
            Icons.priority_high,
            Colors.red,
            colors,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            ModerationFilter.enRevision,
            'En Revisión',
            Icons.rate_review,
            Colors.blue,
            colors,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            ModerationFilter.resueltos,
            'Resueltos',
            Icons.check_circle,
            Colors.green,
            colors,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context,
            ModerationFilter.todos,
            'Todos',
            Icons.list,
            colors.primary,
            colors,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    ModerationFilter filter,
    String label,
    IconData icon,
    Color chipColor,
    ColorScheme colors,
  ) {
    final isSelected = selectedFilter == filter;
    final count = counts[filter] ?? 0;

    return FilterChip(
      selected: isSelected,
      onSelected: (_) => onFilterChanged(filter),
      avatar: Icon(
        icon,
        size: 18,
        color: isSelected ? colors.onPrimary : chipColor,
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? colors.onPrimary : colors.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.onPrimary.withOpacity(0.2)
                    : chipColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? colors.onPrimary : chipColor,
                ),
              ),
            ),
          ],
        ],
      ),
      selectedColor: colors.primary,
      backgroundColor: colors.surface,
      side: BorderSide(
        color: isSelected ? colors.primary : colors.outline.withOpacity(0.3),
      ),
      elevation: isSelected ? 2 : 0,
      pressElevation: 1,
    );
  }
}