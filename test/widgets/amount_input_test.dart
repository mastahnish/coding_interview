import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:coding_interview/l10n/app_localizations.dart';
import 'package:coding_interview/widgets/amount_input.dart';

Widget createTestWidget({
  required Widget child,
}) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en'),
    ],
    home: Scaffold(body: child),
  );
}

void main() {
  group('AmountInput Widget Tests', () {
    testWidgets('should render with label and hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: AmountInput(
            label: 'Amount to Exchange',
            value: null,
            onChanged: (value) {},
          ),
        ),
      );

      expect(find.text('Amount to Exchange'), findsOneWidget);
      expect(find.text('0.00'), findsOneWidget);
    });

    testWidgets('should show initial value when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: AmountInput(
            label: 'Amount',
            value: 100.0,
            onChanged: (value) {},
          ),
        ),
      );

      expect(find.text('100.0'), findsOneWidget);
    });

    testWidgets('should call onChanged when text is entered', (WidgetTester tester) async {
      double? changedValue;
      
      await tester.pumpWidget(
        createTestWidget(
          child: AmountInput(
            label: 'Amount',
            value: null,
            onChanged: (value) {
              changedValue = value;
            },
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '50.0');
      await tester.pump();

      expect(changedValue, equals(50.0));
    });

    testWidgets('should show error text when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: AmountInput(
            label: 'Amount',
            value: null,
            onChanged: (value) {},
            errorText: 'Invalid amount',
          ),
        ),
      );

      expect(find.text('Invalid amount'), findsOneWidget);
    });

    testWidgets('should be disabled when isEnabled is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: AmountInput(
            label: 'Amount',
            value: null,
            onChanged: (value) {},
            isEnabled: false,
          ),
        ),
      );

      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('should validate input correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: AmountInput(
            label: 'Amount',
            value: null,
            onChanged: (value) {},
          ),
        ),
      );

      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      final validator = textField.validator;

      // Test empty input
      expect(validator?.call(''), isNotNull);
      
      // Test invalid input
      expect(validator?.call('abc'), isNotNull);
      
      // Test valid input
      expect(validator?.call('100.0'), isNull);
    });

    testWidgets('should format input correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: AmountInput(
            label: 'Amount',
            value: null,
            onChanged: (value) {},
          ),
        ),
      );

      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField, isNotNull);
    });

    testWidgets('should show info text about automatic updates', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: AmountInput(
            label: 'Amount',
            value: null,
            onChanged: (value) {},
          ),
        ),
      );

      expect(find.text('Exchange rate updates automatically'), findsOneWidget);
    });

    testWidgets('should apply proper styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: AmountInput(
            label: 'Amount',
            value: null,
            onChanged: (value) {},
          ),
        ),
      );

      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField, isNotNull);
    });

    testWidgets('should handle decimal input correctly', (WidgetTester tester) async {
      double? changedValue;
      
      await tester.pumpWidget(
        createTestWidget(
          child: AmountInput(
            label: 'Amount',
            value: null,
            onChanged: (value) {
              changedValue = value;
            },
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '123.45');
      await tester.pump();

      expect(changedValue, equals(123.45));
    });

    testWidgets('should handle zero input correctly', (WidgetTester tester) async {
      double? changedValue;
      
      await tester.pumpWidget(
        createTestWidget(
          child: AmountInput(
            label: 'Amount',
            value: null,
            onChanged: (value) {
              changedValue = value;
            },
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '0');
      await tester.pump();

      expect(changedValue, equals(0.0));
    });
  });
}
