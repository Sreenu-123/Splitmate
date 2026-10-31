import '../../domain/entities/settlement.dart';
import '../../domain/repositories/settlement_repository.dart';

class SettlementRepositoryImpl implements SettlementRepository {
  @override
  List<Settlement> calculateSettlements({required Map<String, int> balances}) {
    final creditors = <MapEntry<String, int>>[];
    final debtors = <MapEntry<String, int>>[];

    for (final entry in balances.entries) {
      if (entry.value > 0) {
        creditors.add(entry);
      } else if (entry.value < 0) {
        debtors.add(MapEntry(entry.key, -entry.value));
      }
    }

    final settlements = <Settlement>[];

    var creditorIndex = 0;
    var debtorIndex = 0;

    while (creditorIndex < creditors.length && debtorIndex < debtors.length) {
      final creditor = creditors[creditorIndex];
      final debtor = debtors[debtorIndex];

      final amount = creditor.value < debtor.value
          ? creditor.value
          : debtor.value;

      settlements.add(
        Settlement(
          fromMemberId: debtor.key,
          toMemberId: creditor.key,
          amountPaise: amount,
        ),
      );

      creditors[creditorIndex] = MapEntry(
        creditor.key,
        creditor.value - amount,
      );

      debtors[debtorIndex] = MapEntry(debtor.key, debtor.value - amount);

      if (creditors[creditorIndex].value == 0) {
        creditorIndex++;
      }

      if (debtors[debtorIndex].value == 0) {
        debtorIndex++;
      }
    }

    return settlements;
  }
}
