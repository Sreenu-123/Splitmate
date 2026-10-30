import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(
        title: 'Add Expense',
        icon: Icons.add_circle_outline_rounded,
        color: const Color(0xFFB9FF39),
      ),
      _ActionItem(
        title: 'Create Group',
        icon: Icons.group_add_rounded,
        color: const Color(0xFF8B9CFF),
      ),
      _ActionItem(
        title: 'Settle Up',
        icon: Icons.account_balance_wallet_outlined,
        color: const Color(0xFFFFA45B),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: actions.map((action) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF151719),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(action.icon, color: action.color, size: 27),
                    const SizedBox(height: 10),
                    Text(
                      action.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ActionItem {
  final String title;
  final IconData icon;
  final Color color;

  const _ActionItem({
    required this.title,
    required this.icon,
    required this.color,
  });
}
