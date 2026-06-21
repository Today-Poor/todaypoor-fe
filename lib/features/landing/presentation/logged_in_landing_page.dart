import 'dart:async';

import 'package:flutter/material.dart';
import 'package:today_poor/core/theme/app_colors.dart';
import 'package:today_poor/features/home/presentation/home_page.dart';

/// 로그인 성공 이후 임시로 노출되는 랜딩 화면.
///
/// 실제 인증과 홈 이동이 구현되기 전까지 소셜 로그인 성공 상태를 표현한다.
class LoggedInLandingPage extends StatefulWidget {
  const LoggedInLandingPage({super.key});

  @override
  State<LoggedInLandingPage> createState() => _LoggedInLandingPageState();
}

class _LoggedInLandingPageState extends State<LoggedInLandingPage> {
  static const double _designWidth = 402;
  static const double _minimumContentHeight = 757;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _navigationTimer = Timer(const Duration(seconds: 2), _openHome);
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  void _openHome() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (_, _, _) => const HomePage(),
        transitionDuration: const Duration(milliseconds: 700),
        transitionsBuilder: (_, animation, _, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );

          return FadeTransition(opacity: curvedAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.background],
            stops: [0.08, 1],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final canvasHeight = constraints.maxHeight.clamp(
                _minimumContentHeight,
                double.infinity,
              );

              return SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: constraints.maxWidth.clamp(0, _designWidth),
                    height: canvasHeight,
                    child: const _LoggedInLandingContent(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LoggedInLandingContent extends StatelessWidget {
  const _LoggedInLandingContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 88),
        const _LandingAsset(
          path: 'assets/images/landing_pig.png',
          width: 100,
          height: 114,
        ),
        const SizedBox(height: 28),
        const _LandingAsset(
          path: 'assets/images/landing_coin.png',
          width: 30,
          height: 29,
        ),
        const SizedBox(height: 17),
        const _LandingAsset(
          path: 'assets/images/today_poor_logo.png',
          width: 250,
          height: 207,
        ),
        const SizedBox(height: 52),
        const _LandingAsset(
          path: 'assets/images/landing_coin.png',
          width: 49,
          height: 48,
        ),
        const Spacer(),
        const _CharactersScene(),
        const SizedBox(height: 29),
      ],
    );
  }
}

class _CharactersScene extends StatelessWidget {
  const _CharactersScene();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const ValueKey('logged-in-characters-scene'),
      width: 356,
      height: 145,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          const Positioned(
            left: 0,
            bottom: 0,
            child: _LandingAsset(
              path: 'assets/images/landing_character_left.png',
              width: 128,
              height: 129,
            ),
          ),
          const Positioned(
            right: 0,
            bottom: 0,
            child: _LandingAsset(
              path: 'assets/images/landing_character_right.png',
              width: 131,
              height: 128,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Semantics(
              label: '쌓인 코인',
              child: const _LandingAsset(
                path: 'assets/images/landing_coin_stack.png',
                width: 70,
                height: 85,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LandingAsset extends StatelessWidget {
  const _LandingAsset({
    required this.path,
    required this.width,
    required this.height,
  });

  final String path;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
