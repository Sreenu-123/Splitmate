import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;

    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
        ? 'Good afternoon'
        : 'Good evening';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting,',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.secondaryText,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Sreenu 👋',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryText,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Here's your expense overview",
                style: TextStyle(fontSize: 13, color: AppTheme.secondaryText),
              ),
            ],
          ),
        ),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: AppTheme.primaryText,
          ),
        ),
        const SizedBox(width: 10),
        CircleAvatar(
          radius: 23,
          backgroundColor: AppTheme.primary.withValues(alpha: 0.15),
          child: const Icon(
            Icons.person_outline_rounded,
            color: AppTheme.primary,
          ),
        ),
      ],
    );
  }
}
