import 'package:flutter/material.dart';
import '../../data/models/profile_validation_model.dart';

class ProfileTypeFilterChips extends StatelessWidget {
  final ProfileType selectedType;
  final Function(ProfileType) onTypeChanged;
  final int abogadosCount;
  final int anunciantesCount;

  const ProfileTypeFilterChips({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    required this.abogadosCount,
    required this.anunciantesCount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: FilterChip(
            selected: selectedType == ProfileType.abogado,
            onSelected: (_) => onTypeChanged(ProfileType.abogado),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Abogados'),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: selectedType == ProfileType.abogado
                        ? colors.onPrimary.withOpacity(0.2)
                        : colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$abogadosCount',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: selectedType == ProfileType.abogado
                          ? colors.onPrimary
                          : colors.primary,
                    ),
                  ),
                ),
              ],
            ),
            selectedColor: colors.primary,
            backgroundColor: colors.surface,
            side: BorderSide(
              color: selectedType == ProfileType.abogado
                  ? colors.primary
                  : colors.outline.withOpacity(0.3),
            ),
            labelStyle: TextStyle(
              color: selectedType == ProfileType.abogado
                  ? colors.onPrimary
                  : colors.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilterChip(
            selected: selectedType == ProfileType.anunciante,
            onSelected: (_) => onTypeChanged(ProfileType.anunciante),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Anunciantes'),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: selectedType == ProfileType.anunciante
                        ? colors.onPrimary.withOpacity(0.2)
                        : colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$anunciantesCount',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: selectedType == ProfileType.anunciante
                          ? colors.onPrimary
                          : colors.primary,
                    ),
                  ),
                ),
              ],
            ),
            selectedColor: colors.primary,
            backgroundColor: colors.surface,
            side: BorderSide(
              color: selectedType == ProfileType.anunciante
                  ? colors.primary
                  : colors.outline.withOpacity(0.3),
            ),
            labelStyle: TextStyle(
              color: selectedType == ProfileType.anunciante
                  ? colors.onPrimary
                  : colors.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}