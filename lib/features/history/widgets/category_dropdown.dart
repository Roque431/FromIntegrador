import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
	final String? selectedCategory;
	final ValueChanged<String?> onChanged;
	final List<String> categories;

	const CategoryDropdown({
		super.key,
		required this.selectedCategory,
		required this.onChanged,
		this.categories = const <String>[
			'Todas',
			'Laboral',
			'Civil',
			'Penal',
			'Mercantil',
			'Familiar',
		],
	});

	@override
	Widget build(BuildContext context) {
		final colors = Theme.of(context).colorScheme;
		final isDark = Theme.of(context).brightness == Brightness.dark;

		return SizedBox(
			width: 140,
			child: DropdownButtonFormField<String>(
				initialValue: selectedCategory ?? (categories.contains('Todas') ? 'Todas' : null),
				items: categories
						.map((c) => DropdownMenuItem<String>(
									value: c,
									child: Text(
										c,
										style: TextStyle(color: colors.onSurface),
									),
								))
						.toList(),
				onChanged: onChanged,
				decoration: InputDecoration(
					hintText: 'Categoría',
					hintStyle: TextStyle(color: colors.onSurfaceVariant),
					filled: true,
					fillColor: colors.surfaceContainerHighest,
					border: OutlineInputBorder(
						borderRadius: BorderRadius.circular(12),
						borderSide: BorderSide.none,
					),
					contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
				),
				icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.onSurfaceVariant),
				dropdownColor: isDark ? colors.surfaceContainerHighest : colors.surface,
				style: TextStyle(color: colors.onSurface),
			),
		);
	}
}