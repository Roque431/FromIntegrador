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

		return SizedBox(
			width: 140,
			child: DropdownButtonFormField<String>(
				value: selectedCategory ?? (categories.contains('Todas') ? 'Todas' : null),
				items: categories
						.map((c) => DropdownMenuItem<String>(
									value: c,
									child: Text(
										c,
										style: TextStyle(color: colors.tertiary),
									),
								))
						.toList(),
				onChanged: onChanged,
				decoration: InputDecoration(
					hintText: 'Categoría',
					hintStyle: TextStyle(color: Colors.grey.shade500),
					filled: true,
					fillColor: Colors.white,
					border: OutlineInputBorder(
						borderRadius: BorderRadius.circular(12),
						borderSide: BorderSide.none,
					),
					contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
				),
				icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.tertiary),
				dropdownColor: Colors.white,
				style: TextStyle(color: colors.tertiary),
			),
		);
	}
}