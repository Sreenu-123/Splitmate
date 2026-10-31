import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/settlement.dart';

class SettlementCard extends StatelessWidget {
  final Settlement settlement;
  final String fromMemberName;
  final String toMemberName;
  final VoidCallback? onMarkAsPaid;
  final bool isPaid;

  const SettlementCard({
    super.key,
    required this.settlement,
    required this.fromMemberName,
    required this.toMemberName,
    this.onMarkAsPaid,
    this.isPaid = false,
  });

  String _formatMoney(int amountPaise) {
    return '₹${(amountPaise / 100).toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                child: Text(
                  fromMemberName.isNotEmpty
                      ? fromMemberName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fromMemberName,
                      style: const TextStyle(
                        color: AppTheme.primaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Pays to',
                      style: TextStyle(
                        color: AppTheme.secondaryText,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_rounded,
                color: AppTheme.secondaryText,
                size: 20,
              ),

              const SizedBox(width: 12),

              CircleAvatar(
                radius: 21,
                backgroundColor: AppTheme.accent.withValues(alpha: 0.12),
                child: Text(
                  toMemberName.isNotEmpty ? toMemberName[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Divider(color: AppTheme.border, height: 1),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Settlement Amount',
                style: TextStyle(color: AppTheme.secondaryText, fontSize: 12),
              ),

              Text(
                _formatMoney(settlement.amountPaise),
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isPaid ? Icons.check_circle_rounded : Icons.pending_rounded,
                    color: isPaid ? AppTheme.primary : Colors.orangeAccent,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isPaid ? 'Paid' : 'Pending',
                    style: TextStyle(
                      color: isPaid ? AppTheme.primary : Colors.orangeAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              if (!isPaid && onMarkAsPaid != null)
                TextButton(
                  onPressed: onMarkAsPaid,
                  child: const Text(
                    'Mark as Paid',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
