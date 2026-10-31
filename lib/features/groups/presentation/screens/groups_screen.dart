import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../settlements/presentation/screens/settle_up_screen.dart';
import '../../../settlements/domain/entities/settlement.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final List<Map<String, dynamic>> _groups = [];

  // CREATE GROUP

  Future<void> _createGroup() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const CreateGroupDialog(),
    );

    if (!mounted || result == null) return;

    final names = (result['members'] ?? '')
        .split(',')
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    // Each member gets a unique ID.
    // Duplicate names are intentionally allowed.
    final members = <Map<String, String>>[
      {'id': 'you_${DateTime.now().microsecondsSinceEpoch}', 'name': 'You'},
    ];

    for (int i = 0; i < names.length; i++) {
      members.add({
        'id': 'member_${DateTime.now().microsecondsSinceEpoch}_$i',
        'name': names[i],
      });
    }

    setState(() {
      _groups.add({
        'id': 'group_${DateTime.now().microsecondsSinceEpoch}',
        'name': result['name'] ?? 'Untitled Group',
        'description': result['description'] ?? '',
        'members': members,
        'expenses': <Map<String, dynamic>>[],
        'paidSettlements': <Map<String, dynamic>>[],
        'createdAt': DateTime.now(),
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Group created successfully!')),
    );
  }

  // DELETE GROUP
  Future<void> _deleteGroup(Map<String, dynamic> group) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF202326),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Delete group?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          '"${group['name']}" and all its expenses will be permanently removed.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _groups.removeWhere((item) => item['id'] == group['id']));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Group deleted successfully.')),
    );
  }

  // OPEN GROUP DETAILS

  Future<void> _openGroup(Map<String, dynamic> group) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return GroupDetailsSheet(
          group: group,
          onChanged: () {
            if (mounted) setState(() {});
          },
        );
      },
    );

    if (!mounted) return;
    setState(() {});
  }

  // GROUP CARD

  Widget _buildGroupCard(Map<String, dynamic> group) {
    final members = group['members'] as List<Map<String, String>>;
    final expenses = group['expenses'] as List<Map<String, dynamic>>;
    final totalPaise = expenses.fold<int>(
      0,
      (total, expense) => total + (expense['amountPaise'] as int),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF15191A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _openGroup(group),
              child: Padding(
                padding: const EdgeInsets.all(17),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.groups_rounded,
                        color: AppTheme.primary,
                        size: 27,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group['name'].toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${members.length} members  •  ${expenses.length} expenses',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '₹${(totalPaise / 100).toStringAsFixed(2)} total spent',
                            style: const TextStyle(
                              color: AppTheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white38),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Delete group',
            onPressed: () => _deleteGroup(group),
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.redAccent,
              size: 21,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }

  // EMPTY STATE

  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.groups_outlined,
              size: 65,
              color: AppTheme.primary,
            ),
            const SizedBox(height: 20),
            const Text(
              'No groups yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a group and start\nsplitting expenses together.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _createGroup,
                icon: const Icon(Icons.add),
                label: const Text('Create your first group'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MAIN SCREEN

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Groups',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: _createGroup,
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: AppTheme.primary,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Manage shared expenses together.',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 25),
              if (_groups.isEmpty)
                _buildEmptyState()
              else
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _groups.length,
                    itemBuilder: (context, index) {
                      return _buildGroupCard(_groups[index]);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// GROUP DETAILS
// ============================================================

class GroupDetailsSheet extends StatefulWidget {
  final Map<String, dynamic> group;
  final VoidCallback onChanged;

  const GroupDetailsSheet({
    super.key,
    required this.group,
    required this.onChanged,
  });

  @override
  State<GroupDetailsSheet> createState() => _GroupDetailsSheetState();
}

class _GroupDetailsSheetState extends State<GroupDetailsSheet> {
  List<Map<String, String>> get members =>
      widget.group['members'] as List<Map<String, String>>;

  List<Map<String, dynamic>> get expenses =>
      widget.group['expenses'] as List<Map<String, dynamic>>;

  int get totalPaise {
    return expenses.fold<int>(
      0,
      (total, expense) => total + (expense['amountPaise'] as int),
    );
  }

  String _formatMoney(int paise) {
    return '₹${(paise / 100).toStringAsFixed(2)}';
  }

  String _memberName(String id) {
    for (final member in members) {
      if (member['id'] == id) {
        return member['name'] ?? 'Unknown member';
      }
    }
    return 'Unknown member';
  }

  // MEMBER BALANCES

  Map<String, int> _calculateBalances() {
    final balances = <String, int>{
      for (final member in members) member['id']!: 0,
    };

    for (final expense in expenses) {
      final amount = expense['amountPaise'] as int;
      final paidById = expense['paidById'] as String;
      final shares = expense['shares'] as Map<String, int>;

      // The payer gets credit for the full amount.
      balances[paidById] = (balances[paidById] ?? 0) + amount;

      // Each participant is responsible for their share.
      for (final entry in shares.entries) {
        balances[entry.key] = (balances[entry.key] ?? 0) - entry.value;
      }
    }

    final paidSettlements =
        (widget.group['paidSettlements'] as List<Map<String, dynamic>>?) ?? [];

    // A completed payment reduces the sender's debt and the receiver's credit.
    for (final payment in paidSettlements) {
      final fromId = payment['fromMemberId'] as String;
      final toId = payment['toMemberId'] as String;
      final amount = payment['amountPaise'] as int;

      balances[fromId] = (balances[fromId] ?? 0) + amount;
      balances[toId] = (balances[toId] ?? 0) - amount;
    }

    return balances;
  }

  // OPEN SETTLEMENT SCREEN
  void _openSettleUp() {
    final memberNames = <String, String>{
      for (final member in members) member['id']!: member['name']!,
    };

    // Make sure this group has a place to store completed payments.
    widget.group.putIfAbsent('paidSettlements', () => <Map<String, dynamic>>[]);

    final balances = _calculateBalances();

    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            builder: (_) => SettleUpScreen(
              memberNames: memberNames,
              balances: balances,
              onSettlementPaid: _markSettlementPaid,
              paidSettlementIds: (widget.group['paidSettlements'] as List)
                  .map((item) => item['id'].toString())
                  .toSet(),
            ),
          ),
        )
        .then((_) {
          if (mounted) setState(() {});
          widget.onChanged();
        });
  }

  void _markSettlementPaid(Settlement settlement) {
    final paidSettlements =
        widget.group['paidSettlements'] as List<Map<String, dynamic>>;

    final id =
        '${settlement.fromMemberId}_${settlement.toMemberId}_${settlement.amountPaise}';

    final alreadyPaid = paidSettlements.any((item) => item['id'] == id);
    if (alreadyPaid) return;

    setState(() {
      paidSettlements.add({
        'id': id,
        'fromMemberId': settlement.fromMemberId,
        'toMemberId': settlement.toMemberId,
        'amountPaise': settlement.amountPaise,
        'paidAt': DateTime.now(),
      });
    });

    widget.onChanged();
  }

  // ADD EXPENSE

  Future<void> _addExpense() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => AddGroupExpenseDialog(members: members),
    );

    if (!mounted || result == null) return;

    setState(() {
      expenses.add(result);
    });

    widget.onChanged();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Expense added successfully!')),
    );
  }

  // DELETE EXPENSE

  Future<void> _deleteExpense(Map<String, dynamic> expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF202326),
          title: const Text(
            'Delete expense?',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'This expense will be removed from the group.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
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
      setState(() => expenses.remove(expense));
      widget.onChanged();
    }
  }

  // SUMMARY CARD

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total group expenses',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            _formatMoney(totalPaise),
            style: const TextStyle(
              color: AppTheme.primary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.people_outline, color: Colors.white60, size: 17),
              const SizedBox(width: 6),
              Text(
                '${members.length} members',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(width: 18),
              const Icon(
                Icons.receipt_long_outlined,
                color: Colors.white60,
                size: 17,
              ),
              const SizedBox(width: 6),
              Text(
                '${expenses.length} expenses',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _addMember() async {
    String enteredName = '';

    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF202326),
          title: const Text(
            'Add Member',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              enteredName = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter member name',
              hintStyle: TextStyle(color: Colors.white38),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, enteredName.trim());
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (!mounted || name == null || name.isEmpty) {
      return;
    }

    final newMember = {
      'id': 'member_${DateTime.now().microsecondsSinceEpoch}',
      'name': name,
    };

    setState(() {
      members.add(newMember);
    });

    widget.onChanged();
  }

  Widget _buildMembers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Group Members',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${members.length} members',
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 14),

        ...members.map((member) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF15191A),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                  child: Text(
                    member['name']!.isNotEmpty
                        ? member['name']![0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    member['name']!,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        }),

        OutlinedButton.icon(
          onPressed: _addMember,
          icon: const Icon(Icons.person_add_alt_1),
          label: const Text('Add Member'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primary,
            side: BorderSide(color: AppTheme.primary.withValues(alpha: 0.5)),
          ),
        ),
      ],
    );
  }

  // BALANCE SECTION

  Widget _buildBalances() {
    final balances = _calculateBalances();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Member Balances',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        ...members.map((member) {
          final id = member['id']!;
          final balance = balances[id] ?? 0;

          final description = balance > 0
              ? 'Gets back ${_formatMoney(balance)}'
              : balance < 0
              ? 'Owes ${_formatMoney(balance.abs())}'
              : 'Settled up';

          final color = balance > 0
              ? AppTheme.primary
              : balance < 0
              ? Colors.orangeAccent
              : Colors.white54;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF15191A),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                  child: Text(
                    member['name']!.isNotEmpty
                        ? member['name']![0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    member['name']!,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // EXPENSE CARD

  Widget _buildExpenseCard(Map<String, dynamic> expense) {
    final amount = expense['amountPaise'] as int;
    final paidBy = _memberName(expense['paidById'] as String);
    final shares = expense['shares'] as Map<String, int>;
    final date = expense['date'] as DateTime;

    return GestureDetector(
      onLongPress: () => _deleteExpense(expense),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF15191A),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense['title'].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Paid by $paidBy',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatMoney(amount),
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  expense['category'].toString(),
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
                const Spacer(),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
            const Divider(color: Colors.white10, height: 22),
            Text(
              '${expense['splitType']} split • ${shares.length} participants',
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
            const SizedBox(height: 8),
            ...shares.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _memberName(entry.key),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      _formatMoney(entry.value),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 4),
            const Text(
              'Long press to delete',
              style: TextStyle(color: Colors.white30, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final description = widget.group['description'].toString();

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Color(0xFF101415),
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 12),
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.group['name'].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white70),
                      ),
                    ],
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  _buildSummaryCard(),
                  const SizedBox(height: 25),
                  _buildMembers(),
                  const SizedBox(height: 25),

                  // ADD EXPENSE BUTTON
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _addExpense,
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Add Expense',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: expenses.isEmpty ? null : _openSettleUp,
                      icon: const Icon(Icons.swap_horiz_rounded),
                      label: const Text(
                        'Settle Up',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                        side: BorderSide(
                          color: AppTheme.primary.withValues(alpha: 0.55),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),
                  _buildBalances(),
                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Expense History',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${expenses.length} records',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  if (expenses.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: const Color(0xFF15191A),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            color: Colors.white38,
                            size: 35,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'No expenses yet',
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Add your first group expense.',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...expenses.reversed.map(_buildExpenseCard),

                  const SizedBox(height: 25),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('Close Group'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ADD GROUP EXPENSE DIALOG
// ============================================================

class AddGroupExpenseDialog extends StatefulWidget {
  final List<Map<String, String>> members;

  const AddGroupExpenseDialog({super.key, required this.members});

  @override
  State<AddGroupExpenseDialog> createState() => _AddGroupExpenseDialogState();
}

class _AddGroupExpenseDialogState extends State<AddGroupExpenseDialog> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  final Map<String, TextEditingController> _customControllers = {};

  String? _paidById;
  String _splitType = 'Equal';
  String _category = 'Other';
  String? _errorMessage;

  final Set<String> _selectedMemberIds = {};

  final List<String> _categories = [
    'Food',
    'Travel',
    'Shopping',
    'Stay',
    'Entertainment',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.members.isNotEmpty) {
      _paidById = widget.members.first['id'];
    }

    for (final member in widget.members) {
      final id = member['id']!;
      _customControllers[id] = TextEditingController();
      _selectedMemberIds.add(id);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();

    for (final controller in _customControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  int? _parseAmountPaise(String value) {
    final amount = double.tryParse(value.trim());

    if (amount == null || amount <= 0 || !amount.isFinite) {
      return null;
    }

    return (amount * 100).round();
  }

  String _memberName(String id) {
    return widget.members.firstWhere((member) => member['id'] == id)['name']!;
  }

  // EQUAL SPLIT
  // Remaining paise are distributed one by one.
  Map<String, int> _calculateEqualSplit(int totalPaise) {
    final selected = _selectedMemberIds.toList();
    if (selected.isEmpty) return {};

    final baseShare = totalPaise ~/ selected.length;
    final remainder = totalPaise % selected.length;

    final shares = <String, int>{};

    for (int i = 0; i < selected.length; i++) {
      shares[selected[i]] = baseShare + (i < remainder ? 1 : 0);
    }

    return shares;
  }

  // CUSTOM SPLIT

  Map<String, int>? _calculateCustomSplit(int totalPaise) {
    final shares = <String, int>{};

    for (final id in _selectedMemberIds) {
      final value = _customControllers[id]!.text.trim();

      if (value.isEmpty) return null;

      final amount = double.tryParse(value);

      if (amount == null || amount < 0 || !amount.isFinite) {
        return null;
      }

      shares[id] = (amount * 100).round();
    }

    final customTotal = shares.values.fold<int>(
      0,
      (total, value) => total + value,
    );

    if (customTotal != totalPaise) return null;

    return shares;
  }

  // SAVE EXPENSE
  void _saveExpense() {
    final title = _titleController.text.trim();
    final totalPaise = _parseAmountPaise(_amountController.text);

    void fail(String message) {
      setState(() => _errorMessage = message);
    }

    if (title.isEmpty) {
      fail('Please enter an expense title.');
      return;
    }
    if (totalPaise == null) {
      fail('Please enter a valid amount greater than zero.');
      return;
    }
    if (_selectedMemberIds.isEmpty) {
      fail('Select at least one member to split this expense.');
      return;
    }
    if (_paidById == null ||
        !widget.members.any((member) => member['id'] == _paidById)) {
      fail('Please select who paid.');
      return;
    }

    Map<String, int> shares;
    if (_splitType == 'Equal') {
      shares = _calculateEqualSplit(totalPaise);
    } else {
      final customShares = _calculateCustomSplit(totalPaise);
      if (customShares == null) {
        fail(
          'Enter a valid share for every selected member. The shares must add up exactly to the total amount.',
        );
        return;
      }
      shares = customShares;
    }

    Navigator.of(context).pop({
      'id': 'expense_${DateTime.now().microsecondsSinceEpoch}',
      'title': title,
      'amountPaise': totalPaise,
      'category': _category,
      'date': DateTime.now(),
      'paidById': _paidById!,
      'splitType': _splitType,
      'shares': shares,
    });
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: const Color(0xFF15191A),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // MEMBER SELECTION

  Widget _buildMemberSelection() {
    return Column(
      children: widget.members.map((member) {
        final id = member['id']!;
        final name = member['name']!;
        final selected = _selectedMemberIds.contains(id);

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF15191A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppTheme.primary : Colors.white10,
            ),
          ),
          child: CheckboxListTile(
            value: selected,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  _selectedMemberIds.add(id);
                } else {
                  _selectedMemberIds.remove(id);
                }
                _errorMessage = null;
              });
            },
            activeColor: AppTheme.primary,
            checkColor: Colors.black,
            title: Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          ),
        );
      }).toList(),
    );
  }

  // CUSTOM SHARE INPUTS

  Widget _buildCustomInputs() {
    return Column(
      children: _selectedMemberIds.map((id) {
        final name = _memberName(id);

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
              SizedBox(
                width: 125,
                child: TextField(
                  controller: _customControllers[id],
                  onChanged: (_) => setState(() => _errorMessage = null),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration('₹0.00'),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPaise = _parseAmountPaise(_amountController.text);

    return AlertDialog(
      backgroundColor: const Color(0xFF202326),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: const Text(
        'Add Expense',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Expense title'),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: _decoration('e.g. Dinner'),
                onChanged: (_) => setState(() => _errorMessage = null),
              ),
              const SizedBox(height: 18),

              _sectionTitle('Amount'),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(color: Colors.white),
                decoration: _decoration('Enter amount in ₹'),
                onChanged: (_) => setState(() => _errorMessage = null),
              ),
              const SizedBox(height: 18),

              _sectionTitle('Category'),
              DropdownButtonFormField<String>(
                initialValue: _category,
                dropdownColor: const Color(0xFF202326),
                style: const TextStyle(color: Colors.white),
                decoration: _decoration('Select category'),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _category = value);
                  }
                },
              ),
              const SizedBox(height: 18),

              _sectionTitle('Paid by'),
              DropdownButtonFormField<String>(
                initialValue: _paidById,
                dropdownColor: const Color(0xFF202326),
                style: const TextStyle(color: Colors.white),
                decoration: _decoration('Select member'),
                items: widget.members.map((member) {
                  return DropdownMenuItem(
                    value: member['id'],
                    child: Text(member['name']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _paidById = value);
                },
              ),
              const SizedBox(height: 18),

              _sectionTitle('Split between'),
              _buildMemberSelection(),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),

              _sectionTitle('Split type'),
              Row(
                children: [
                  Expanded(child: _splitOption('Equal')),
                  const SizedBox(width: 10),
                  Expanded(child: _splitOption('Custom')),
                ],
              ),

              if (_splitType == 'Equal') ...[
                const SizedBox(height: 12),
                const Text(
                  'The total amount will be divided equally among selected members.',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
                if (totalPaise != null && _selectedMemberIds.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Approx. ₹${(totalPaise / 100 / _selectedMemberIds.length).toStringAsFixed(2)} per member',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],

              if (_splitType == 'Custom') ...[
                const SizedBox(height: 14),
                _sectionTitle('Enter each member\'s share'),
                _buildCustomInputs(),
                const SizedBox(height: 8),
                const Text(
                  'All custom shares must add up exactly to the expense amount.',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveExpense,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.black,
          ),
          child: const Text('Save Expense'),
        ),
      ],
    );
  }

  Widget _splitOption(String value) {
    final selected = _splitType == value;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            _splitType = value;
            _errorMessage = null;
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: selected
                ? AppTheme.primary.withValues(alpha: 0.14)
                : const Color(0xFF15191A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppTheme.primary : Colors.white10,
            ),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: selected ? AppTheme.primary : Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CREATE GROUP DIALOG
// ============================================================

class CreateGroupDialog extends StatefulWidget {
  const CreateGroupDialog({super.key});

  @override
  State<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _membersController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _membersController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _membersController.dispose();
    super.dispose();
  }

  void _create() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a group name')),
      );
      return;
    }

    Navigator.of(context).pop({
      'name': name,
      'description': _descriptionController.text.trim(),
      'members': _membersController.text,
    });
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: const Color(0xFF15191A),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF202326),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: const Text(
        'Create Group',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Group name',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('e.g. Weekend Trip'),
            ),
            const SizedBox(height: 18),
            const Text(
              'Description',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white),
              maxLines: 2,
              decoration: _inputDecoration('What is this group for?'),
            ),
            const SizedBox(height: 18),
            const Text(
              'Members',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _membersController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Names separated by commas')
                  .copyWith(
                    helperText: 'Example: Alex, John, Alex',
                    helperStyle: const TextStyle(color: Colors.white38),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'You will automatically be added as a member.',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _create,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.black,
          ),
          child: const Text('Create Group'),
        ),
      ],
    );
  }
}
