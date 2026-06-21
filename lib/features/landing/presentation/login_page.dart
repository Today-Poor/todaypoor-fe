import 'package:flutter/material.dart';
import 'package:today_poor/core/theme/app_colors.dart';
import 'package:today_poor/features/landing/presentation/logged_in_landing_page.dart';

/// 로그인 전 처음 노출되는 랜딩 화면.
///
/// 실제 소셜 로그인과 이미지 에셋은 별도 이슈에서 연결한다.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const double _designWidth = 402;
  static const double _designHeight = 820;

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
              final canvasHeight = constraints.maxHeight < _designHeight
                  ? _designHeight
                  : constraints.maxHeight;

              return SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: constraints.maxWidth.clamp(0, _designWidth),
                    height: canvasHeight,
                    child: const _LandingContent(),
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

class _LandingContent extends StatelessWidget {
  const _LandingContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 33),
      child: Column(
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
          const SizedBox(height: 56),
          const _LandingAsset(
            path: 'assets/images/landing_coin.png',
            width: 49,
            height: 48,
          ),
          const Spacer(),
          const Text(
            '로그인 후 이용해 주세요!',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          _SocialLoginButton(
            label: '카카오 로그인으로 시작하기',
            backgroundColor: AppColors.kakaoBackground,
            foregroundColor: AppColors.kakaoText,
            leading: const _SocialLogo(path: 'assets/images/kakao_logo.png'),
            onPressed: () => _openLoggedInLanding(context),
          ),
          const SizedBox(height: 14),
          _SocialLoginButton(
            label: '구글 로그인으로 시작하기',
            backgroundColor: AppColors.googleBackground,
            foregroundColor: AppColors.googleText,
            leading: const _SocialLogo(path: 'assets/images/google_logo.png'),
            onPressed: () => _openLoggedInLanding(context),
          ),
          const SizedBox(height: 73),
        ],
      ),
    );
  }

  static void _openLoggedInLanding(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const LoggedInLandingPage()),
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

class _SocialLogo extends StatelessWidget {
  const _SocialLogo({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: 18,
      height: 18,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.leading,
    required this.onPressed,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget leading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 41,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            leading,
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
