import '../../data/models/transaction_model.dart';
import '../../data/repository/transaction_repository.dart';

class CreateCheckoutUseCase {
  final TransactionRepository _repository;

  CreateCheckoutUseCase(this._repository);

  Future<CheckoutSessionModel> call({
    required String usuarioId,
    required String plan,
  }) async {
    if (plan != 'pro_monthly' && plan != 'pro_yearly') {
      throw ArgumentError('Plan inválido. Use "pro_monthly" o "pro_yearly"');
    }

    return await _repository.createCheckout(
      usuarioId: usuarioId,
      plan: plan,
    );
  }
}
