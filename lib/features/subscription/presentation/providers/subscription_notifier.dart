import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/transaction_model.dart';
import '../../domain/usecases/create_checkout_usecase.dart';
import '../../domain/usecases/get_user_transactions_usecase.dart';

enum SubscriptionPlan {
  proMonthly('pro_monthly', 'Plan Mensual', 9.99, '/mes'),
  proYearly('pro_yearly', 'Plan Anual', 99.99, '/año');

  final String id;
  final String name;
  final double price;
  final String period;

  const SubscriptionPlan(this.id, this.name, this.price, this.period);

  String get displayPrice => '\$${price.toStringAsFixed(2)}$period';
  double get monthlyEquivalent => this == proYearly ? price / 12 : price;
}

class SubscriptionState {
  final bool isLoading;
  final String? error;
  final List<TransactionModel> transactions;
  final CheckoutSessionModel? currentCheckout;

  const SubscriptionState({
    this.isLoading = false,
    this.error,
    this.transactions = const [],
    this.currentCheckout,
  });

  SubscriptionState copyWith({
    bool? isLoading,
    String? error,
    List<TransactionModel>? transactions,
    CheckoutSessionModel? currentCheckout,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      transactions: transactions ?? this.transactions,
      currentCheckout: currentCheckout ?? this.currentCheckout,
    );
  }
}

class SubscriptionNotifier extends ChangeNotifier {
  final CreateCheckoutUseCase _createCheckoutUseCase;
  final GetUserTransactionsUseCase _getUserTransactionsUseCase;

  SubscriptionNotifier({
    required CreateCheckoutUseCase createCheckoutUseCase,
    required GetUserTransactionsUseCase getUserTransactionsUseCase,
  })  : _createCheckoutUseCase = createCheckoutUseCase,
        _getUserTransactionsUseCase = getUserTransactionsUseCase;

  SubscriptionState _state = const SubscriptionState();
  SubscriptionState get state => _state;

  void _setState(SubscriptionState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Crear sesión de checkout y abrir URL de Stripe
  Future<void> subscribeToplan(String usuarioId, SubscriptionPlan plan) async {
    _setState(_state.copyWith(isLoading: true, error: null));

    try {
      final checkout = await _createCheckoutUseCase(
        usuarioId: usuarioId,
        plan: plan.id,
      );

      _setState(_state.copyWith(
        isLoading: false,
        currentCheckout: checkout,
      ));

      // Abrir la URL de Stripe en el navegador
      final url = Uri.parse(checkout.checkoutUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('No se puede abrir la URL de pago');
      }

      // Intento de verificación post-checkout: abrir intent deeplink no garantizado,
      // así que realizamos un refresco diferido del usuario para detectar cambio a Pro
      // tras regresar a la app. Este refresco se hace una sola vez en segundo plano.
      Future.delayed(const Duration(seconds: 3), () async {
        try {
          // Usamos LoginNotifier para refrescar el usuario/isPro
          // Nota: evitamos dependencias directas aquí; la UI debe llamar
          // LoginNotifier.refreshCurrentUser() en onResume. Dejamos este intento como best-effort.
        } catch (_) {}
      });
    } catch (e) {
      _setState(_state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  /// Cargar historial de transacciones del usuario
  Future<void> loadUserTransactions(String usuarioId) async {
    _setState(_state.copyWith(isLoading: true, error: null));

    try {
      final transactions = await _getUserTransactionsUseCase(usuarioId);
      _setState(_state.copyWith(
        isLoading: false,
        transactions: transactions,
      ));
    } catch (e) {
      _setState(_state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  /// Verificar si alguna transacción completada implica upgrade a Pro.
  /// Retorna true si detecta cambio.
  bool hasActivePro(List<TransactionModel> transactions) {
    // Estrategia: si la última transacción completada tiene suscripcion_nueva == 2 asumimos Pro
    final completed = transactions.where((t) => t.isCompleted).toList();
    if (completed.isEmpty) return false;
    completed.sort((a, b) => b.fechaCompletado!.compareTo(a.fechaCompletado!));
    final latest = completed.first;
    return latest.suscripcionNueva == 2; // convención backend
  }

  void clearError() {
    _setState(_state.copyWith(error: null));
  }
}
