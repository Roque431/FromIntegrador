import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../login/presentation/providers/login_notifier.dart';
import '../providers/subscription_notifier.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> with WidgetsBindingObserver {
  SubscriptionPlan _selectedPlan = SubscriptionPlan.proMonthly;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkUpgradeOnReturn();
    }
  }

  Future<void> _checkUpgradeOnReturn() async {
    if (!mounted) return;
    final loginNotifier = context.read<LoginNotifier>();
    final userId = loginNotifier.currentUser?.id;
    if (userId == null) return;

    final subNotifier = context.read<SubscriptionNotifier>();
    await subNotifier.loadUserTransactions(userId);

    final becamePro = subNotifier.hasActivePro(subNotifier.state.transactions);
    if (becamePro) {
      await context.read<LoginNotifier>().refreshCurrentUser();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pago confirmado. ¡Tu plan ahora es Pro!')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mejorar a Pro'),
        centerTitle: true,
      ),
      body: Consumer<SubscriptionNotifier>(
        builder: (context, notifier, _) {
          if (notifier.state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                const Icon(
                  Icons.workspace_premium,
                  size: 80,
                  color: Colors.amber,
                ),
                const SizedBox(height: 16),
                const Text(
                  'LexIA Pro',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Accede a todas las funciones premium',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Benefits
                _buildBenefitItem('Consultas ilimitadas con IA'),
                _buildBenefitItem('Historial completo de conversaciones'),
                _buildBenefitItem('Respuestas prioritarias'),
                _buildBenefitItem('Acceso a nuevas funciones'),
                _buildBenefitItem('Sin anuncios'),
                const SizedBox(height: 32),

                // Plan Selection
                _buildPlanCard(
                  plan: SubscriptionPlan.proMonthly,
                  isSelected: _selectedPlan == SubscriptionPlan.proMonthly,
                  onTap: () => setState(() => _selectedPlan = SubscriptionPlan.proMonthly),
                ),
                const SizedBox(height: 16),
                _buildPlanCard(
                  plan: SubscriptionPlan.proYearly,
                  isSelected: _selectedPlan == SubscriptionPlan.proYearly,
                  onTap: () => setState(() => _selectedPlan = SubscriptionPlan.proYearly),
                  badge: 'Ahorra 16%',
                ),
                const SizedBox(height: 32),

                // Error message
                if (notifier.state.error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            notifier.state.error!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Subscribe button (improved styling & disabled while processing)
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: notifier.state.isLoading ? null : () => _handleSubscribe(context, notifier),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 4,
                      backgroundColor: notifier.state.isLoading
                          ? Colors.grey.shade300
                          : (_selectedPlan == SubscriptionPlan.proYearly
                              ? Colors.deepPurple
                              : Theme.of(context).colorScheme.primary),
                      foregroundColor: Colors.white,
                      disabledForegroundColor: Colors.grey.shade600,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (notifier.state.isLoading) ...[
                          const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Icon(
                          _selectedPlan == SubscriptionPlan.proYearly ? Icons.auto_awesome : Icons.workspace_premium,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
              notifier.state.isLoading
                              ? 'Procesando pago...'
                              : (_selectedPlan == SubscriptionPlan.proYearly
                                  ? 'Elegir plan anual'
                                  : 'Suscribirme ahora'),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Helper text for selected plan
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _selectedPlan == SubscriptionPlan.proYearly
                        ? 'Facturación anual: ahorras 16% vs mensual'
                        : 'Facturación mensual, cancela cuando quieras',
                    key: ValueKey(_selectedPlan),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Cancela cuando quieras. Los pagos se procesan de forma segura con Stripe.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required SubscriptionPlan plan,
    required bool isSelected,
    required VoidCallback onTap,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        plan.displayPrice,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      if (plan == SubscriptionPlan.proYearly)
                        Text(
                          '\$${plan.monthlyEquivalent.toStringAsFixed(2)}/mes',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (badge != null)
              Positioned(
                top: -8,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubscribe(BuildContext context, SubscriptionNotifier notifier) async {
    final loginNotifier = context.read<LoginNotifier>();
    final userId = loginNotifier.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No se pudo obtener el ID del usuario')),
      );
      return;
    }

    await notifier.subscribeToplan(userId, _selectedPlan);

    if (!mounted) return;

    if (notifier.state.error == null && notifier.state.currentCheckout != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Abriendo Stripe... Completa el pago y vuelve a la app'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
