import 'package:flutter/material.dart';
import 'package:today_poor/core/theme/app_theme.dart';
import 'package:today_poor/features/home/presentation/home_page.dart';

class TodayPoorApp extends StatelessWidget {
  const TodayPoorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Today Poor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const HomePage(),
    );
  }
}
