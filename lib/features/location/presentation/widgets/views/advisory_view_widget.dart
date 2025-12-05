import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/responsive_widgets.dart';
import '../../../data/models/location_models.dart';
import '../../../../login/presentation/providers/login_notifier.dart';

class AdvisoryViewWidget extends StatelessWidget {
  final AdvisoryResponse advisory;
  final MapController? mapController;
  final VoidCallback? onViewChange;

  const AdvisoryViewWidget({
    super.key,
    required this.advisory,
    this.mapController,
    this.onViewChange,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final loginNotifier = context.read<LoginNotifier>();
    final isPro = loginNotifier.currentUser?.isPro ?? false;

    if (!isPro) {
      return Padding(
        padding: EdgeInsets.all(ResponsiveSize.horizontalPadding(context)),
        child: ResponsiveCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_outline, size: 48, color: Colors.orange),
              ),
              const SizedBox(height: 20),
              Text(
                advisory.mensaje,
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
              ),
              const SizedBox(height: 24),
              ResponsiveButton(
                text: 'Actualizar a Pro',
                onPressed: () {},
              ),
            ],
          ),
        ),
      );
    }

    if (advisory.oficinas.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron oficinas para este estado',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.horizontalPadding(context)),
      itemCount: advisory.oficinas.length,
      itemBuilder: (context, index) {
        final office = advisory.oficinas[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ResponsiveCard(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: () {
                if (office.latitud != null && office.longitud != null) {
                  onViewChange?.call();
                  mapController?.move(LatLng(office.latitud!, office.longitud!), 16.0);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.account_balance, color: Colors.green),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          office.nombre,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (office.direccion != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '📍 ${office.direccion}',
                            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
                          ),
                        ],
                        if (office.telefono != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            '📞 ${office.telefono}',
                            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
                          ),
                        ],
                        if (office.horario != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            '🕐 ${office.horario}',
                            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}