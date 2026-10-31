import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/splash/presentation/screens/splash_screen.dart';

class SplitMateApp extends StatelessWidget {
  const SplitMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SplitMate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
