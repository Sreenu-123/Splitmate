import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class SettlementSummary extends StatelessWidget {
  final int totalOwePaise;
  final int totalOwedToYouPaise;

  const SettlementSummary({
    super.key,
    required this.totalOwePaise,
    required this.totalOwedToYouPaise,
  });

  String _formatMoney(int amountPaise) {
    return '₹${(amountPaise / 100).toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final netBalance = totalOwedToYouPaise - totalOwePaise;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settlement Summary',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildAmountItem(
                  title: 'You owe',
                  amount: totalOwePaise,
                  color: Colors.orangeAccent,
                  icon: Icons.arrow_upward_rounded,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _buildAmountItem(
                  title: 'Owed to you',
                  amount: totalOwedToYouPaise,
                  color: AppTheme.primary,
                  icon: Icons.arrow_downward_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Net Balance',
                  style: TextStyle(color: AppTheme.secondaryText, fontSize: 12),
                ),

                const SizedBox(height: 6),

                Text(
                  '${netBalance >= 0 ? '+' : '-'}${_formatMoney(netBalance.abs())}',
                  style: TextStyle(
                    color: netBalance >= 0
                        ? AppTheme.primary
                        : Colors.orangeAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  netBalance > 0
                      ? 'You are owed money overall'
                      : netBalance < 0
                      ? 'You owe money overall'
                      : 'You are all settled up!',
                  style: const TextStyle(
                    color: AppTheme.secondaryText,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountItem({
    required String title,
    required int amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(color: AppTheme.secondaryText, fontSize: 12),
          ),

          const SizedBox(height: 6),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              _formatMoney(amount),
              style: TextStyle(
                color: color,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
