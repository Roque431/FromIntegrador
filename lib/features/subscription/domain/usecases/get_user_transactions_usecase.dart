import '../../data/models/transaction_model.dart';
import '../../data/repository/transaction_repository.dart';

class GetUserTransactionsUseCase {
  final TransactionRepository _repository;

  GetUserTransactionsUseCase(this._repository);

  Future<List<TransactionModel>> call(String usuarioId) async {
    return await _repository.getUserTransactions(usuarioId);
  }
}
