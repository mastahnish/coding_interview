import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:coding_interview/l10n/app_localizations.dart';
import 'package:coding_interview/widgets/exchange_result.dart';

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
  group('ExchangeResult Widget Tests', () {
    testWidgets('should show loading state when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: ExchangeResult(
            amount: 100.0,
            exchangeRate: 0.0,
            resultAmount: 0.0,
            fromCurrencySymbol: 'BTC',
            toCurrencySymbol: 'USD',
            isLoading: true,
            errorMessage: null,
          ),
        ),
      );

      expect(find.text('Calculating exchange rate...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error state when errorMessage is provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: ExchangeResult(
            amount: 100.0,
            exchangeRate: 0.0,
            resultAmount: 0.0,
            fromCurrencySymbol: 'BTC',
            toCurrencySymbol: 'USD',
            isLoading: false,
            errorMessage: 'Network error occurred',
          ),
        ),
      );

      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Network error occurred'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should show empty state when amount is 0', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: ExchangeResult(
            amount: 0.0,
            exchangeRate: 0.0,
            resultAmount: 0.0,
            fromCurrencySymbol: 'BTC',
            toCurrencySymbol: 'USD',
            isLoading: false,
            errorMessage: null,
          ),
        ),
      );

      expect(find.text('Enter amount to see exchange rate'), findsOneWidget);
      expect(find.byIcon(Icons.currency_exchange), findsOneWidget);
    });

    testWidgets('should show empty state when amount > 0 but no exchange data yet', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: ExchangeResult(
            amount: 100.0,
            exchangeRate: 0.0,
            resultAmount: 0.0,
            fromCurrencySymbol: 'BTC',
            toCurrencySymbol: 'USD',
            isLoading: false,
            errorMessage: null,
          ),
        ),
      );

      expect(find.text('Enter amount to see exchange rate'), findsOneWidget);
      expect(find.byIcon(Icons.currency_exchange), findsOneWidget);
    });

    testWidgets('should show result state when all data is valid', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: ExchangeResult(
            amount: 100.0,
            exchangeRate: 5.0,
            resultAmount: 500.0,
            fromCurrencySymbol: 'BTC',
            toCurrencySymbol: 'USD',
            isLoading: false,
            errorMessage: null,
          ),
        ),
      );

      expect(find.text('Exchange Rate'), findsOneWidget);
      expect(find.text('1 BTC = 5.00 USD'), findsOneWidget);
      expect(find.text('BTC - USD'), findsOneWidget);
      expect(find.text('100.00'), findsOneWidget);
      expect(find.text('500.00'), findsOneWidget);
    });

    testWidgets('should show correct exchange rate format', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: ExchangeResult(
            amount: 50.0,
            exchangeRate: 2.5,
            resultAmount: 125.0,
            fromCurrencySymbol: 'ETH',
            toCurrencySymbol: 'EUR',
            isLoading: false,
            errorMessage: null,
          ),
        ),
      );

      expect(find.text('1 ETH = 2.50 EUR'), findsOneWidget);
    });

    testWidgets('should show correct amounts with proper formatting', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: ExchangeResult(
            amount: 1234.56,
            exchangeRate: 1.23,
            resultAmount: 1518.51,
            fromCurrencySymbol: 'BTC',
            toCurrencySymbol: 'USD',
            isLoading: false,
            errorMessage: null,
          ),
        ),
      );

      expect(find.text('1,234.56'), findsOneWidget);
      expect(find.text('1,518.51'), findsOneWidget);
    });

    testWidgets('should apply proper styling to result container', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: ExchangeResult(
            amount: 100.0,
            exchangeRate: 5.0,
            resultAmount: 500.0,
            fromCurrencySymbol: 'BTC',
            toCurrencySymbol: 'USD',
            isLoading: false,
            errorMessage: null,
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.color, isNotNull);
      expect(decoration.borderRadius, isNotNull);
      expect(decoration.boxShadow, isNotNull);
    });

    testWidgets('should show loading state with proper styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: ExchangeResult(
            amount: 100.0,
            exchangeRate: 0.0,
            resultAmount: 0.0,
            fromCurrencySymbol: 'BTC',
            toCurrencySymbol: 'USD',
            isLoading: true,
            errorMessage: null,
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.color, isNotNull);
      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('should show error state with proper styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: ExchangeResult(
            amount: 100.0,
            exchangeRate: 0.0,
            resultAmount: 0.0,
            fromCurrencySymbol: 'BTC',
            toCurrencySymbol: 'USD',
            isLoading: false,
            errorMessage: 'Network error occurred',
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.color, isNotNull);
      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('should show empty state with proper styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: ExchangeResult(
            amount: 0.0,
            exchangeRate: 0.0,
            resultAmount: 0.0,
            fromCurrencySymbol: 'BTC',
            toCurrencySymbol: 'USD',
            isLoading: false,
            errorMessage: null,
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.color, isNotNull);
      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('should handle different currency symbols correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: ExchangeResult(
            amount: 100.0,
            exchangeRate: 1.5,
            resultAmount: 150.0,
            fromCurrencySymbol: 'ETH',
            toCurrencySymbol: 'EUR',
            isLoading: false,
            errorMessage: null,
          ),
        ),
      );

      expect(find.text('1 ETH = 1.50 EUR'), findsOneWidget);
      expect(find.text('ETH - EUR'), findsOneWidget);
      expect(find.text('100.00'), findsOneWidget);
      expect(find.text('150.00'), findsOneWidget);
    });
  });
}
