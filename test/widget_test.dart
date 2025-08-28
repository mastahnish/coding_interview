// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:flutter_test/flutter_test.dart';

import 'package:coding_interview/main.dart';
import 'package:coding_interview/screens/exchange_calculator_screen.dart';

void main() {
  testWidgets('Currency Exchange App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // The title appears twice - once in AppBar and once in main content
    expect(find.text('Currency Exchange Calculator'), findsNWidgets(2));
    expect(find.byType(ExchangeCalculatorScreen), findsOneWidget);
  });
}
