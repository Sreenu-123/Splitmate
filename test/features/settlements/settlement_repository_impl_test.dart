import 'package:flutter_test/flutter_test.dart';
import 'package:splitmate/features/settlements/data/repositories/settlement_repository_impl.dart';

void main() {
  late SettlementRepositoryImpl repository;

  setUp(() {
    repository = SettlementRepositoryImpl();
  });

  group('Settlement Calculation Tests', () {
    test('One debtor and one creditor', () {
      final result = repository.calculateSettlements(
        balances: {'sreenu': 50000, 'alex': -50000},
      );

      expect(result.length, 1);
      expect(result.first.fromMemberId, 'alex');
      expect(result.first.toMemberId, 'sreenu');
      expect(result.first.amountPaise, 50000);
    });

    test('Multiple debtors and one creditor', () {
      final result = repository.calculateSettlements(
        balances: {'sreenu': 80000, 'alex': -50000, 'john': -30000},
      );

      expect(result.length, 2);
      expect(result.fold<int>(0, (sum, item) => sum + item.amountPaise), 80000);
    });

    test('One debtor and multiple creditors', () {
      final result = repository.calculateSettlements(
        balances: {'alex': -80000, 'sreenu': 50000, 'john': 30000},
      );

      expect(result.length, 2);
      expect(result.fold<int>(0, (sum, item) => sum + item.amountPaise), 80000);
    });

    test('All balances are zero', () {
      final result = repository.calculateSettlements(
        balances: {'sreenu': 0, 'alex': 0},
      );

      expect(result, isEmpty);
    });

    test('Empty balances', () {
      final result = repository.calculateSettlements(balances: {});

      expect(result, isEmpty);
    });
  });
}
