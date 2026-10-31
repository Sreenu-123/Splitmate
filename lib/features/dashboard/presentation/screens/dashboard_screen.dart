import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/balance_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_expenses.dart';
import '../widgets/bottom_nav_bar.dart';

import '../../../groups/presentation/screens/groups_screen.dart';
import '../../../expenses/presentation/screens/activity_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  Widget _buildHomeScreen() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            DashboardHeader(),
            SizedBox(height: 24),
            BalanceCard(),
            SizedBox(height: 24),
            QuickActions(),
            SizedBox(height: 28),
            RecentExpenses(),
          ],
        ),
      ),
    );
  }

  late final List<Widget> _screens = [
    _buildHomeScreen(),
    const GroupsScreen(),
    const ActivityScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
