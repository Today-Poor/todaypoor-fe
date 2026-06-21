import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:today_poor/app/app.dart';
import 'package:today_poor/features/landing/presentation/logged_in_landing_page.dart';
import 'package:today_poor/features/landing/presentation/login_page.dart';

void main() {
  group('LoginPage', () {
    testWidgets('기본 요소가 렌더링된다', (tester) async {
      await tester.pumpWidget(const _TestWrapper(child: LoginPage()));

      expect(find.text('로그인 후 이용해 주세요!'), findsOneWidget);
      expect(find.text('카카오 로그인으로 시작하기'), findsOneWidget);
      expect(find.text('구글 로그인으로 시작하기'), findsOneWidget);
    });

    testWidgets('앱 시작 화면으로 노출된다', (tester) async {
      await tester.pumpWidget(const TodayPoorApp());

      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('카카오 로그인 버튼을 누르면 로그인 완료 랜딩으로 이동한다', (tester) async {
      await tester.pumpWidget(const _TestWrapper(child: LoginPage()));

      final kakaoButton = find.text('카카오 로그인으로 시작하기');
      await tester.ensureVisible(kakaoButton);
      await tester.tap(kakaoButton);
      await tester.pumpAndSettle();

      expect(find.byType(LoggedInLandingPage), findsOneWidget);
      expect(find.bySemanticsLabel('쌓인 코인'), findsOneWidget);
    });

    testWidgets('구글 로그인 버튼을 누르면 로그인 완료 랜딩으로 이동한다', (tester) async {
      await tester.pumpWidget(const _TestWrapper(child: LoginPage()));

      final googleButton = find.text('구글 로그인으로 시작하기');
      await tester.ensureVisible(googleButton);
      await tester.tap(googleButton);
      await tester.pumpAndSettle();

      expect(find.byType(LoggedInLandingPage), findsOneWidget);
    });
  });
}

/// 테스트용 최소 MaterialApp 래퍼
class _TestWrapper extends StatelessWidget {
  const _TestWrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: child);
  }
}
