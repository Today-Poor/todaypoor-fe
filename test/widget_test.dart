import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:today_poor/app/app.dart';
import 'package:today_poor/features/crew/presentation/crew_status_page.dart';
import 'package:today_poor/features/home/presentation/home_page.dart';
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

  group('LoggedInLandingPage', () {
    testWidgets('2초 후 방이 없는 메인 화면으로 이동한다', (tester) async {
      await tester.pumpWidget(const _TestWrapper(child: LoggedInLandingPage()));

      expect(find.byType(LoggedInLandingPage), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.byType(LoggedInLandingPage), findsNothing);
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text('참여 중인 방이 없어요.\n아이콘을 눌러 방을 추가해주세요.'), findsOneWidget);
    });
  });

  group('HomePage', () {
    testWidgets('참여 중인 방이 없으면 빈 상태를 보여준다', (tester) async {
      await tester.pumpWidget(const _TestWrapper(child: HomePage()));

      expect(find.text('참여 중인 방이 없어요.\n아이콘을 눌러 방을 추가해주세요.'), findsOneWidget);
      expect(find.bySemanticsLabel('방 추가'), findsOneWidget);
      expect(find.bySemanticsLabel('첫 방 추가'), findsOneWidget);
      expect(find.bySemanticsLabel('프로필'), findsOneWidget);
    });

    testWidgets('추가 버튼을 누르면 크루 생성 모달을 보여준다', (tester) async {
      await tester.pumpWidget(const _TestWrapper(child: HomePage()));

      await tester.tap(find.bySemanticsLabel('첫 방 추가'));
      await tester.pumpAndSettle();

      expect(find.text('새로운 크루 만들기'), findsOneWidget);
      expect(find.text('크루 이름'), findsOneWidget);
      expect(find.text('인원 수'), findsOneWidget);
      expect(find.text('취소'), findsOneWidget);
      expect(find.text('만들기'), findsOneWidget);
    });

    testWidgets('모달 입력 후 만들기를 누르면 생성한 방 목록을 보여준다', (tester) async {
      await tester.pumpWidget(const _TestWrapper(child: HomePage()));

      await tester.tap(find.bySemanticsLabel('첫 방 추가'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('room-name-field')),
        '테스트 크루',
      );
      await tester.enterText(
        find.byKey(const ValueKey('room-capacity-field')),
        '4',
      );
      await tester.tap(find.text('만들기'));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('room-list')), findsOneWidget);
      expect(find.byType(Scrollable), findsWidgets);
      expect(find.text('나만의 소비내역 리포트 보기'), findsOneWidget);
      expect(find.text('테스트 크루 1/4'), findsOneWidget);
      expect(find.text('김세원 따까리(신여원) 2/3'), findsNothing);
      expect(find.text('최예윤과 아이들 3/4'), findsNothing);
      expect(find.text('배병윤 멍청이 5/5'), findsNothing);
    });

    testWidgets('취소를 누르면 빈 상태로 돌아간다', (tester) async {
      await tester.pumpWidget(const _TestWrapper(child: HomePage()));

      await tester.tap(find.bySemanticsLabel('첫 방 추가'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();

      expect(find.text('새로운 크루 만들기'), findsNothing);
      expect(find.text('참여 중인 방이 없어요.\n아이콘을 눌러 방을 추가해주세요.'), findsOneWidget);
    });

    testWidgets('방 카드가 쌓이면 목록을 스크롤할 수 있다', (tester) async {
      await tester.pumpWidget(const _TestWrapper(child: HomePage()));

      await _createRoom(tester, name: '크루 1');
      await _createRoom(tester, name: '크루 2');
      await _createRoom(tester, name: '크루 3');
      await _createRoom(tester, name: '크루 4');

      final roomList = find.byKey(const ValueKey('room-list'));
      final scrollable = find.descendant(
        of: roomList,
        matching: find.byType(Scrollable),
      );
      final scrollableState = tester.state<ScrollableState>(scrollable);

      expect(scrollableState.position.maxScrollExtent, greaterThan(0));

      await tester.drag(roomList, const Offset(0, -240));
      await tester.pumpAndSettle();

      expect(scrollableState.position.pixels, greaterThan(0));
    });

    testWidgets('방 카드를 누르면 크루 현황 화면으로 이동한다', (tester) async {
      await tester.pumpWidget(const _TestWrapper(child: HomePage()));

      await tester.tap(find.bySemanticsLabel('첫 방 추가'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('room-name-field')),
        '테스트 크루',
      );
      await tester.enterText(
        find.byKey(const ValueKey('room-capacity-field')),
        '4',
      );
      await tester.tap(find.text('만들기'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('테스트 크루 1/4'));
      await tester.pumpAndSettle();

      expect(find.byType(CrewStatusPage), findsOneWidget);
    });
  });

  group('CrewStatusPage', () {
    const sampleMembers = [
      CrewMember(name: '세원', hasUploaded: true),
      CrewMember(name: '예윤', hasUploaded: false, isMe: true),
      CrewMember(name: '여원', hasUploaded: true),
      CrewMember(name: '병윤', hasUploaded: true),
    ];

    Widget buildPage() => const _TestWrapper(
      child: CrewStatusPage(
        crewName: '김세원 따까리(신여원)',
        capacity: 4,
        members: sampleMembers,
      ),
    );

    testWidgets('제목·리포트 안내·멤버 상태를 보여준다', (tester) async {
      await tester.pumpWidget(buildPage());

      expect(find.text('김세원 따까리(신여원)4/4'), findsOneWidget);
      expect(find.text('22:00에 리포트가 공개됩니다.'), findsOneWidget);
      expect(find.text('업로드 완료!'), findsNWidgets(3));
      expect(find.text('아직 업로드되지 않았어요.'), findsNothing);
      expect(find.text('눌러서 업로드하기'), findsOneWidget);
      expect(find.bySemanticsLabel('내 소비내역 업로드'), findsOneWidget);
      for (final name in ['세원', '예윤', '여원', '병윤']) {
        expect(find.text(name), findsOneWidget);
      }
    });

    testWidgets('타인이 미업로드면 안내 문구를 보여준다', (tester) async {
      await tester.pumpWidget(
        const _TestWrapper(
          child: CrewStatusPage(
            crewName: '테스트 크루',
            capacity: 2,
            members: [
              CrewMember(name: '세원', hasUploaded: false),
              CrewMember(name: '예윤', hasUploaded: true, isMe: true),
            ],
          ),
        ),
      );

      expect(find.text('아직 업로드되지 않았어요.'), findsOneWidget);
      expect(find.text('눌러서 업로드하기'), findsNothing);
    });

    testWidgets('내 카드를 누르면 업로드 완료로 바뀐다', (tester) async {
      await tester.pumpWidget(buildPage());

      expect(find.text('업로드 완료!'), findsNWidgets(3));

      await tester.tap(find.bySemanticsLabel('내 소비내역 업로드'));
      await tester.pumpAndSettle();

      expect(find.text('업로드 완료!'), findsNWidgets(4));
      expect(find.text('눌러서 업로드하기'), findsNothing);
    });
  });
}

Future<void> _createRoom(WidgetTester tester, {required String name}) async {
  final addButton = find.bySemanticsLabel('방 추가').evaluate().isEmpty
      ? find.bySemanticsLabel('첫 방 추가')
      : find.bySemanticsLabel('방 추가');

  await tester.tap(addButton);
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const ValueKey('room-name-field')), name);
  await tester.enterText(
    find.byKey(const ValueKey('room-capacity-field')),
    '5',
  );
  await tester.tap(find.text('만들기'));
  await tester.pumpAndSettle();
}

class _TestWrapper extends StatelessWidget {
  const _TestWrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: child);
  }
}
