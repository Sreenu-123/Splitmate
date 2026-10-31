import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/repositories/settlement_repository_impl.dart';
import '../../domain/entities/settlement.dart';
import '../../domain/usecases/calculate_settlements.dart';
import '../widgets/settlement_card.dart';
import '../widgets/settlement_summary.dart';

class SettleUpScreen extends StatefulWidget {
  final Map<String, String> memberNames;
  final Map<String, int> balances;
  final ValueChanged<Settlement> onSettlementPaid;
  final Set<String> paidSettlementIds;

  const SettleUpScreen({
    super.key,
    required this.memberNames,
    required this.balances,
    required this.onSettlementPaid,
    required this.paidSettlementIds,
  });

  @override
  State<SettleUpScreen> createState() => _SettleUpScreenState();
}

class _SettleUpScreenState extends State<SettleUpScreen> {
  late final CalculateSettlements _calculateSettlements;

  late Map<String, int> _balances;

  late Set<String> _paidSettlementIds;

  @override
  void initState() {
    super.initState();

    _calculateSettlements = CalculateSettlements(SettlementRepositoryImpl());

    _balances = Map<String, int>.from(widget.balances);

    _paidSettlementIds = Set<String>.from(widget.paidSettlementIds);
  }

  List<Settlement> get _settlements {
    return _calculateSettlements(balances: _balances);
  }

  int get _totalOwePaise {
    return _balances.values
        .where((balance) => balance < 0)
        .fold<int>(0, (sum, balance) => sum + -balance);
  }

  int get _totalOwedToYouPaise {
    return _balances.values
        .where((balance) => balance > 0)
        .fold<int>(0, (sum, balance) => sum + balance);
  }

  String _getSettlementId(Settlement settlement) {
    return '${settlement.fromMemberId}-'
        '${settlement.toMemberId}-'
        '${settlement.amountPaise}';
  }

  void _markAsPaid(Settlement settlement) {
    final settlementId = _getSettlementId(settlement);

    // Prevent marking the same settlement twice.
    if (_paidSettlementIds.contains(settlementId)) {
      return;
    }

    // Save the paid settlement in the group data.
    widget.onSettlementPaid(settlement);

    setState(() {
      _paidSettlementIds.add(settlementId);

      final amount = settlement.amountPaise;

      // Update the debtor's balance.
      _balances[settlement.fromMemberId] =
          (_balances[settlement.fromMemberId] ?? 0) + amount;

      // Update the creditor's balance.
      _balances[settlement.toMemberId] =
          (_balances[settlement.toMemberId] ?? 0) - amount;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settlement marked as paid'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settlements = _settlements;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Settle Up',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: settlements.isEmpty
            ? _buildEmptyState()
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  SettlementSummary(
                    totalOwePaise: _totalOwePaise,
                    totalOwedToYouPaise: _totalOwedToYouPaise,
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Suggested Settlements',
                    style: TextStyle(
                      color: AppTheme.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Complete these payments to settle your balances.',
                    style: TextStyle(
                      color: AppTheme.secondaryText,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 16),

                  ...settlements.map((settlement) {
                    final fromName =
                        widget.memberNames[settlement.fromMemberId] ??
                        'Unknown member';

                    final toName =
                        widget.memberNames[settlement.toMemberId] ??
                        'Unknown member';

                    final settlementId = _getSettlementId(settlement);

                    final isPaid = _paidSettlementIds.contains(settlementId);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SettlementCard(
                        settlement: settlement,
                        fromMemberName: fromName,
                        toMemberName: toName,
                        isPaid: isPaid,
                        onMarkAsPaid: isPaid
                            ? null
                            : () {
                                _markAsPaid(settlement);
                              },
                      ),
                    );
                  }),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: AppTheme.primary,
                size: 48,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'You are all settled up!',
              style: TextStyle(
                color: AppTheme.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'There are no pending settlements right now.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.secondaryText, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
