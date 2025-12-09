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
       padding: const EdgeInsets.all(16),
       child: SingleChildScrollView(
         child: Column(
           children: [
             Row(
               children: [
                 Expanded(
                   child: SizedBox(
                     height: 48,
                     child: FilledButton.icon(
                       icon: const Icon(Icons.search, size: 18),
                       label: const Text('Buscar'),
                       onPressed: isLoading ? null : onSearchNearby,
                       style: FilledButton.styleFrom(
                         backgroundColor: colorScheme.primary,
                         disabledBackgroundColor: colorScheme.primary.withValues(alpha: 0.5),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                       ),
                     ),
                   ),
                 ),
                 const SizedBox(width: 12),
                 Expanded(
                   child: SizedBox(
                     height: 48,
                     child: OutlinedButton.icon(
                       icon: Icon(Icons.help_outline, size: 18, color: colorScheme.primary),
                       label: Text('Asesoría', style: TextStyle(color: colorScheme.primary)),
                       onPressed: isLoading ? null : onGetAdvisory,
                       style: OutlinedButton.styleFrom(
                         side: BorderSide(color: colorScheme.primary),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                       ),
                     ),
                   ),
                 ),
               ],
             ),
             const SizedBox(height: 12),
             SizedBox(
               width: double.infinity,
               height: 48,
               child: OutlinedButton.icon(
                 icon: Icon(Icons.traffic, size: 18, color: colorScheme.primary),
                 label: Text('Oficinas de Tránsito', style: TextStyle(color: colorScheme.primary)),
                 onPressed: isLoading ? null : onGetTransitOffices,
                 style: OutlinedButton.styleFrom(
                   side: BorderSide(color: colorScheme.primary),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                 ),
               ),
             ),
           ],
         ),
       ),
     );
  }
}