import '../datasource/transaction_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final TransactionDatasource _datasource;

  TransactionRepository(this._datasource);

  Future<CheckoutSessionModel> createCheckout({
    required String usuarioId,
    required String plan,
  }) async {
    try {
      return await _datasource.createCheckout(
        usuarioId: usuarioId,
        plan: plan,
      );
    } catch (e) {
      throw Exception('Error en el repositorio al crear checkout: $e');
    }
  }

  Future<List<TransactionModel>> getUserTransactions(String usuarioId) async {
    try {
      return await _datasource.getUserTransactions(usuarioId);
    } catch (e) {
      throw Exception('Error en el repositorio al obtener transacciones: $e');
    }
  }

  Future<TransactionModel> getTransactionById(String transaccionId) async {
    try {
      return await _datasource.getTransactionById(transaccionId);
    } catch (e) {
      throw Exception('Error en el repositorio al obtener transacción: $e');
    }
  }
}
