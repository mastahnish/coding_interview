import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:coding_interview/l10n/app_localizations.dart';
import 'package:coding_interview/widgets/currency_selector.dart';
import 'package:coding_interview/models/currency.dart';

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
  group('CurrencySelector Widget Tests', () {
    final testCurrencies = [
      const Currency(
        id: 'BTC',
        name: 'Bitcoin',
        symbol: 'BTC',
        type: CurrencyType.crypto,
        imagePath: 'assets/crypto/btc.png',
      ),
      const Currency(
        id: 'USD',
        name: 'US Dollar',
        symbol: 'USD',
        type: CurrencyType.fiat,
        imagePath: 'assets/fiat/usd.png',
      ),
    ];

    testWidgets('should render with title and placeholder when no currency selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CurrencySelector(
            title: 'Select Currency',
            selectedCurrency: null,
            currencies: testCurrencies,
            onCurrencySelected: (currency) {},
          ),
        ),
      );

      expect(find.text('Select Currency'), findsNWidgets(2)); // Title and placeholder
      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
    });

    testWidgets('should render with selected currency when one is provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CurrencySelector(
            title: 'From Currency',
            selectedCurrency: testCurrencies[0],
            currencies: testCurrencies,
            onCurrencySelected: (currency) {},
          ),
        ),
      );

      expect(find.text('From Currency'), findsOneWidget);
      expect(find.text('BTC'), findsOneWidget);
      expect(find.text('Bitcoin'), findsOneWidget);
      expect(find.byIcon(Icons.add_circle_outline), findsNothing);
    });

    testWidgets('should show currency picker when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CurrencySelector(
            title: 'Select Currency',
            selectedCurrency: null,
            currencies: testCurrencies,
            onCurrencySelected: (currency) {},
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('Select Currency'), findsNWidgets(3)); // Title, placeholder, and modal title
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should display all currencies in picker', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CurrencySelector(
            title: 'Select Currency',
            selectedCurrency: null,
            currencies: testCurrencies,
            onCurrencySelected: (currency) {},
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('BTC'), findsOneWidget); // One in picker
      expect(find.text('USD'), findsOneWidget);
      expect(find.text('Bitcoin'), findsOneWidget);
      expect(find.text('US Dollar'), findsOneWidget);
    });

    testWidgets('should call onCurrencySelected when currency is selected', (WidgetTester tester) async {
      Currency? selectedCurrency;
      
      await tester.pumpWidget(
        createTestWidget(
          child: CurrencySelector(
            title: 'Select Currency',
            selectedCurrency: null,
            currencies: testCurrencies,
            onCurrencySelected: (currency) {
              selectedCurrency = currency;
            },
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      await tester.tap(find.text('BTC').last);
      await tester.pumpAndSettle();

      expect(selectedCurrency, equals(testCurrencies[0]));
    });

    testWidgets('should close picker after selection', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CurrencySelector(
            title: 'Select Currency',
            selectedCurrency: null,
            currencies: testCurrencies,
            onCurrencySelected: (currency) {},
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);

      await tester.tap(find.text('BTC').last);
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('should show selected indicator for current currency', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CurrencySelector(
            title: 'Select Currency',
            selectedCurrency: testCurrencies[0],
            currencies: testCurrencies,
            onCurrencySelected: (currency) {},
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should handle disabled state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CurrencySelector(
            title: 'Select Currency',
            selectedCurrency: null,
            currencies: testCurrencies,
            onCurrencySelected: (currency) {},
            isEnabled: false,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Should not show picker when disabled
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('should show proper border styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: CurrencySelector(
            title: 'Select Currency',
            selectedCurrency: null,
            currencies: testCurrencies,
            onCurrencySelected: (currency) {},
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.border, isNotNull);
      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('should handle image loading errors gracefully', (WidgetTester tester) async {
      final currencyWithInvalidImage = const Currency(
        id: 'INVALID',
        name: 'Invalid Currency',
        symbol: 'INV',
        type: CurrencyType.crypto,
        imagePath: 'assets/nonexistent.png',
      );

      await tester.pumpWidget(
        createTestWidget(
          child: CurrencySelector(
            title: 'Select Currency',
            selectedCurrency: currencyWithInvalidImage,
            currencies: [currencyWithInvalidImage],
            onCurrencySelected: (currency) {},
          ),
        ),
      );

      // Wait for image loading to complete and error to be handled
      await tester.pumpAndSettle();

      // Should show fallback icon instead of crashing
      expect(find.byIcon(Icons.currency_bitcoin), findsAtLeastNWidgets(1));
    });

    testWidgets('should render multiple currency selectors correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: Column(
            children: [
              CurrencySelector(
                title: 'Crypto',
                selectedCurrency: testCurrencies[0], // BTC (crypto)
                currencies: testCurrencies,
                onCurrencySelected: (currency) {},
              ),
              CurrencySelector(
                title: 'Fiat',
                selectedCurrency: testCurrencies[1], // USD (fiat)
                currencies: testCurrencies,
                onCurrencySelected: (currency) {},
              ),
            ],
          ),
        ),
      );

      // Should show both currency selectors with correct titles
      expect(find.text('Crypto'), findsOneWidget);
      expect(find.text('Fiat'), findsOneWidget);
      expect(find.text('BTC'), findsOneWidget);
      expect(find.text('USD'), findsOneWidget);
    });
  });
}
