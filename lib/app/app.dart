import 'package:flutter/material.dart';
import 'package:today_poor/core/theme/app_theme.dart';
import 'package:today_poor/features/landing/presentation/login_page.dart';

class TodayPoorApp extends StatelessWidget {
  const TodayPoorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '오늘의거지',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const LoginPage(),
    );
  }
}
