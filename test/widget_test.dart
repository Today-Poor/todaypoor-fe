import 'package:flutter_test/flutter_test.dart';
import 'package:today_poor/app/app.dart';

void main() {
  testWidgets('shows the home dashboard', (tester) async {
    await tester.pumpWidget(const TodayPoorApp());

    expect(find.text('Today Poor'), findsOneWidget);
    expect(find.text('오늘 쓸 수 있는 돈'), findsOneWidget);
    expect(find.text('지출 기록하기'), findsOneWidget);
  });
}
