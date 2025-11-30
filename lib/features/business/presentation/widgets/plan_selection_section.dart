import 'package:flutter/material.dart';

class PlanSelectionSection extends StatelessWidget {
  final String billingPeriod;
  final Function(String) onBillingPeriodChanged;

  const PlanSelectionSection({
    super.key,
    required this.billingPeriod,
    required this.onBillingPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plan de Negocio',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Selecciona el período de facturación que prefieras',
          style: TextStyle(
            color: colors.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 20),

        // Plan de negocio card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.green.withValues(alpha: 0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.store, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      'Plan Negocio Premium',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Incluye:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                _buildFeatureItem('✓ Perfil destacado en búsquedas'),
                _buildFeatureItem('✓ Aparición en el mapa legal'),
                _buildFeatureItem('✓ Contacto directo con clientes'),
                _buildFeatureItem('✓ Estadísticas de visualizaciones'),
                _buildFeatureItem('✓ Galería de fotos del negocio'),
                _buildFeatureItem('✓ Reseñas y calificaciones'),
                _buildFeatureItem('✓ Badge de verificado'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Selección de período de facturación
        Text(
          'Período de Facturación',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _PlanOption(
                title: 'Mensual',
                price: '\$199',
                period: 'por mes',
                isSelected: billingPeriod == 'Mensual',
                onTap: () => onBillingPeriodChanged('Mensual'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _PlanOption(
                title: 'Anual',
                price: '\$1,999',
                period: 'por año',
                discount: '15% OFF',
                savings: 'Ahorras \$389',
                isSelected: billingPeriod == 'Anual',
                onTap: () => onBillingPeriodChanged('Anual'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Beneficios de registrarse
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.green.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Beneficios de registrarte',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildBenefitItem('✓ Aparece en búsquedas de servicios'),
              _buildBenefitItem('✓ Perfil empresarial verificado'),
              _buildBenefitItem('✓ Contacto directo con clientes'),
              _buildBenefitItem('✓ Estadísticas de visualizaciones'),
              _buildBenefitItem('✓ Reseñas y calificaciones'),
              _buildBenefitItem('✓ Promoción en el mapa legal'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.green.shade900,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _PlanOption extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final String? discount;
  final String? savings;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanOption({
    required this.title,
    required this.price,
    required this.period,
    this.discount,
    this.savings,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.secondary.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? colors.secondary
                : colors.outline.withValues(alpha: 0.3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            if (discount != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? colors.secondary : colors.onSurface,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      discount!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            else
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? colors.secondary : colors.onSurface,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isSelected ? colors.secondary : colors.onSurface,
              ),
            ),
            Text(
              period,
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.7),
              ),
            ),
            if (savings != null && isSelected)
              Text(
                savings!,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
