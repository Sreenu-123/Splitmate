import '../entities/settlement.dart';

abstract class SettlementRepository {
  List<Settlement> calculateSettlements({required Map<String, int> balances});
}
