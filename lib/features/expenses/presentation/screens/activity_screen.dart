import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _transactions = [
    {
      'title': 'Dinner',
      'subtitle': 'Weekend Trip',
      'date': 'Today',
      'amount': 850.0,
      'icon': Icons.restaurant,
      'color': Colors.orange,
      'type': 'Expense',
      'description': 'Dinner shared with friends.',
    },
    {
      'title': 'Uber Ride',
      'subtitle': 'Weekend Trip',
      'date': 'Yesterday',
      'amount': 320.0,
      'icon': Icons.directions_car,
      'color': Colors.blue,
      'type': 'Expense',
      'description': 'Transportation expense.',
    },
    {
      'title': 'Groceries',
      'subtitle': 'Roommates',
      'date': '28 Oct',
      'amount': 1280.0,
      'icon': Icons.shopping_basket,
      'color': Colors.lightGreen,
      'type': 'Expense',
      'description': 'Shared grocery shopping.',
    },
    {
      'title': 'Movie Tickets',
      'subtitle': 'Friends Group',
      'date': '26 Oct',
      'amount': 450.0,
      'icon': Icons.movie,
      'color': Colors.purple,
      'type': 'Expense',
      'description': 'Movie tickets with friends.',
    },
    {
      'title': 'Salary',
      'subtitle': 'Monthly Income',
      'date': '25 Oct',
      'amount': 25000.0,
      'icon': Icons.account_balance_wallet,
      'color': Colors.green,
      'type': 'Income',
      'description': 'Monthly salary received.',
    },
    {
      'title': 'Freelance Payment',
      'subtitle': 'Website Project',
      'date': '24 Oct',
      'amount': 5000.0,
      'icon': Icons.laptop,
      'color': Colors.teal,
      'type': 'Income',
      'description': 'Freelance project payment.',
    },
  ];

  // Safe value helpers

  String _stringValue(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    return value.toString();
  }

  double _amountValue(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  Color _colorValue(dynamic value) {
    return value is Color ? value : AppTheme.primary;
  }

  IconData _iconValue(dynamic value) {
    return value is IconData ? value : Icons.receipt_long;
  }

  // Filtered transactions

  List<Map<String, dynamic>> get _filteredTransactions {
    if (_selectedFilter == 'All') {
      return _transactions;
    }

    return _transactions.where((item) {
      return _stringValue(item['type']) == _selectedFilter;
    }).toList();
  }

  // Total expense

  double get _totalSpent {
    return _transactions
        .where((item) => _stringValue(item['type']) == 'Expense')
        .fold(0.0, (total, item) {
          return total + _amountValue(item['amount']);
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Activity',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Track all your transactions.',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
            const SizedBox(height: 28),
            _buildSummaryCard(),
            const SizedBox(height: 28),
            const Text(
              'Transactions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFilters(),
            const SizedBox(height: 20),
            if (_filteredTransactions.isEmpty)
              _buildEmptyState()
            else
              ..._filteredTransactions.map(_buildTransactionCard),
          ],
        ),
      ),
    );
  }

  // Summary card

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF15191A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(
            child: _summaryItem(
              'Total Spent',
              _formatAmount(_totalSpent),
              Colors.white,
            ),
          ),
          Container(width: 1, height: 48, color: Colors.white12),
          Expanded(
            child: _summaryItem(
              'Transactions',
              _transactions.length.toString().padLeft(2, '0'),
              AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String title, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Filters

  Widget _buildFilters() {
    const filters = ['All', 'Expense', 'Income'];

    return Row(
      children: filters.map((filter) {
        final isSelected = _selectedFilter == filter;

        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : const Color(0xFF171A1B),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Transaction card

  Widget _buildTransactionCard(Map<String, dynamic> item) {
    final iconColor = _colorValue(item['color']);
    final isIncome = _stringValue(item['type']) == 'Income';
    final amount = _amountValue(item['amount']);

    return GestureDetector(
      onTap: () => _showTransactionDetails(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF15191A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(_iconValue(item['icon']), color: iconColor, size: 21),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _stringValue(item['title'], fallback: 'Transaction'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${_stringValue(item['subtitle'], fallback: 'General')} • '
                    '${_stringValue(item['date'], fallback: 'Unknown date')}',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  ),
                ],
              ),
            ),
            Text(
              '${isIncome ? '+' : '-'}${_formatAmount(amount)}',
              style: TextStyle(
                color: isIncome ? AppTheme.primary : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(Icons.chevron_right, color: Colors.white38, size: 18),
          ],
        ),
      ),
    );
  }

  // Transaction details

  Future<void> _showTransactionDetails(Map<String, dynamic> item) async {
    final title = _stringValue(item['title'], fallback: 'Transaction');

    final subtitle = _stringValue(item['subtitle'], fallback: 'General');

    final date = _stringValue(item['date'], fallback: 'Unknown date');

    final description = _stringValue(
      item['description'],
      fallback: 'No description provided.',
    );

    final type = _stringValue(item['type'], fallback: 'Expense');

    final isIncome = type == 'Income';
    final itemColor = _colorValue(item['color']);

    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF15191A),
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 25),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: itemColor.withValues(alpha: 0.15),
                    child: Icon(
                      _iconValue(item['icon']),
                      color: itemColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${isIncome ? '+' : '-'}'
                    '${_formatAmount(_amountValue(item['amount']))}',
                    style: TextStyle(
                      color: isIncome ? AppTheme.primary : Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  _detailRow('Transaction type', type),
                  _detailRow('Group / Category', subtitle),
                  _detailRow('Date', date),
                  _detailRow('Description', description),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(
                              sheetContext,
                              rootNavigator: true,
                            ).pop('edit');
                          },
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primary,
                            side: const BorderSide(color: AppTheme.primary),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(
                              sheetContext,
                              rootNavigator: true,
                            ).pop('delete');
                          },
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF5350),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Wait until bottom sheet is removed.

    if (!mounted) return;

    if (action == 'edit') {
      await Future<void>.delayed(const Duration(milliseconds: 250));

      if (!mounted) return;

      await _editTransaction(item);
    } else if (action == 'delete') {
      await Future<void>.delayed(const Duration(milliseconds: 250));

      if (!mounted) return;

      await _deleteTransaction(item);
    }
  }

  // Detail row

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // Edit transaction

  Future<void> _editTransaction(Map<String, dynamic> item) async {
    final newAmount = await showDialog<double>(
      context: context,
      useRootNavigator: true,
      builder: (_) {
        return EditAmountDialog(initialAmount: _amountValue(item['amount']));
      },
    );

    if (!mounted || newAmount == null) return;

    setState(() {
      item['amount'] = newAmount;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Transaction updated')));
  }

  // Delete transaction

  Future<void> _deleteTransaction(Map<String, dynamic> item) async {
    final title = _stringValue(item['title'], fallback: 'this transaction');

    final confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF202326),
          title: const Text(
            'Delete transaction?',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete $title?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext, rootNavigator: true).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext, rootNavigator: true).pop(true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      setState(() {
        _transactions.remove(item);
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Transaction deleted')));
    }
  }

  // Empty state

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 55),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: Colors.grey.shade700,
            ),
            const SizedBox(height: 16),
            Text(
              'No $_selectedFilter transactions',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your transactions will appear here.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // Amount formatter

  String _formatAmount(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }
}

// Separate StatefulWidget for Edit Amount dialog.
// The controller lives as long as the dialog's State.

class EditAmountDialog extends StatefulWidget {
  final double initialAmount;

  const EditAmountDialog({super.key, required this.initialAmount});

  @override
  State<EditAmountDialog> createState() => _EditAmountDialogState();
}

class _EditAmountDialogState extends State<EditAmountDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.initialAmount.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final amount = double.tryParse(_controller.text.trim());

    if (amount == null || !amount.isFinite || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    Navigator.of(context).pop(amount);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF202326),
      title: const Text('Edit Amount', style: TextStyle(color: Colors.white)),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          prefixText: '₹ ',
          hintText: 'Enter amount',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
