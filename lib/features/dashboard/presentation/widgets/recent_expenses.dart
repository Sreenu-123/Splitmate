import 'package:flutter/material.dart';

class RecentExpenses extends StatelessWidget {
  const RecentExpenses({super.key});

  static const List<_ExpenseItem> expenses = [
    _ExpenseItem(
      title: 'Dinner',
      subtitle: 'Yesterday · Weekend Trip',
      amount: '₹850.00',
      icon: Icons.restaurant_rounded,
      color: Color(0xFFFFA45B),
    ),
    _ExpenseItem(
      title: 'Uber Ride',
      subtitle: 'Yesterday · Weekend Trip',
      amount: '₹320.00',
      icon: Icons.directions_car_rounded,
      color: Color(0xFF8B9CFF),
    ),
    _ExpenseItem(
      title: 'Groceries',
      subtitle: '28 Oct · Roommates',
      amount: '₹1,280.00',
      icon: Icons.shopping_basket_rounded,
      color: Color(0xFFB9FF39),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Expenses',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'See All',
                style: TextStyle(color: Color(0xFFB9FF39), fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...expenses.map((expense) => _ExpenseTile(expense: expense)),
      ],
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  final _ExpenseItem expense;

  const _ExpenseTile({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151719),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: expense.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(expense.icon, color: expense.color, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  expense.subtitle,
                  style: const TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ],
            ),
          ),
          Text(
            expense.amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseItem {
  final String title;
  final String subtitle;
  final String amount;
  final IconData icon;
  final Color color;

  const _ExpenseItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
    required this.color,
  });
}
