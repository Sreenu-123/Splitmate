import '../entities/settlement.dart';
import '../repositories/settlement_repository.dart';

class CalculateSettlements {
  final SettlementRepository repository;

  const CalculateSettlements(this.repository);

  List<Settlement> call({required Map<String, int> balances}) {
    return repository.calculateSettlements(balances: balances);
  }
}
