import 'package:flutter/material.dart';
import '../../../../../core/widgets/responsive_widgets.dart';

class SearchButtonsWidget extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSearchNearby;
  final VoidCallback onGetAdvisory;
  final VoidCallback onGetTransitOffices;

  const SearchButtonsWidget({
    super.key,
    required this.isLoading,
    required this.onSearchNearby,
    required this.onGetAdvisory,
    required this.onGetTransitOffices,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return ResponsiveCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ResponsiveButton(
                  text: 'Buscar',
                  icon: Icon(Icons.search, color: Colors.white, size: 20),
                  isLoading: isLoading,
                  onPressed: onSearchNearby,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ResponsiveButton(
                  text: 'Asesoría',
                  icon: Icon(Icons.help_outline, color: colorScheme.primary, size: 20),
                  isOutlined: true,
                  isLoading: isLoading,
                  onPressed: onGetAdvisory,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ResponsiveButton(
            text: 'Oficinas de Tránsito',
            icon: Icon(Icons.traffic, color: colorScheme.primary, size: 20),
            isOutlined: true,
            isLoading: isLoading,
            onPressed: onGetTransitOffices,
          ),
        ],
      ),
    );
  }
}