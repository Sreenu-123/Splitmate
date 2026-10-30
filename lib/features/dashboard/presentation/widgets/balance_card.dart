import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.border),
        gradient: const LinearGradient(
          colors: [Color(0xFF1C2415), AppTheme.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'TOTAL BALANCE',
                style: TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              Icon(
                Icons.account_balance_wallet_outlined,
                color: AppTheme.primary,
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Text(
            '₹ 2,450.00',
            style: TextStyle(
              color: AppTheme.primaryText,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Your net balance',
            style: TextStyle(color: AppTheme.secondaryText, fontSize: 13),
          ),

          const SizedBox(height: 22),

          const Divider(color: AppTheme.border),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _BalanceItem(
                  title: 'You are owed',
                  amount: '₹3,000',
                  icon: Icons.arrow_downward_rounded,
                  color: AppTheme.primary,
                ),
              ),
              Container(width: 1, height: 48, color: AppTheme.border),
              const SizedBox(width: 18),
              const Expanded(
                child: _BalanceItem(
                  title: 'You owe',
                  amount: '₹550',
                  icon: Icons.arrow_upward_rounded,
                  color: Color(0xFFFF7777),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceItem extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  const _BalanceItem({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
