import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/transaction_model.dart';

class TransactionDatasource {
  final ApiClient _apiClient;

  TransactionDatasource(this._apiClient);

  /// Crear una sesión de checkout de Stripe para un plan específico
  Future<CheckoutSessionModel> createCheckout({
    required String usuarioId,
    required String plan,
  }) async {
    final request = CreateCheckoutRequest(
      usuarioId: usuarioId,
      plan: plan,
    );

    final data = await _apiClient.post(
      ApiEndpoints.createCheckout,
      body: request.toJson(),
    );

    return CheckoutSessionModel.fromJson(data as Map<String, dynamic>);
  }

  /// Obtener transacciones de un usuario
  Future<List<TransactionModel>> getUserTransactions(String usuarioId) async {
    final data = await _apiClient.get(
      ApiEndpoints.userTransactions(usuarioId),
    );

    final List<dynamic> list = data as List<dynamic>;
    return list.map((json) => TransactionModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Obtener una transacción por ID
  Future<TransactionModel> getTransactionById(String transaccionId) async {
    final data = await _apiClient.get(
      ApiEndpoints.transactionById(transaccionId),
    );

    return TransactionModel.fromJson(data as Map<String, dynamic>);
  }
}
