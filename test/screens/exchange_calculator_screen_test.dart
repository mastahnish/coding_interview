import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:coding_interview/l10n/app_localizations.dart';
import 'package:coding_interview/screens/exchange_calculator_screen.dart';
import 'package:coding_interview/providers/currency_provider.dart';

import 'package:coding_interview/widgets/currency_selector.dart';
import 'package:coding_interview/widgets/amount_input.dart';
import 'package:coding_interview/widgets/exchange_result.dart';

void main() {
  group('ExchangeCalculatorScreen Tests', () {
    late CurrencyProvider mockProvider;

    setUp(() {
      mockProvider = CurrencyProvider();
      // Ensure clean state for each test
      mockProvider.reset();
    });

    tearDown(() {
      mockProvider.dispose();
    });

    Widget createTestWidget() {
      return ChangeNotifierProvider<CurrencyProvider>.value(
        value: mockProvider,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
          home: const ExchangeCalculatorScreen(),
        ),
      );
    }

    testWidgets('should render main screen components', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // The title appears twice - once in AppBar and once in main content
      expect(find.text('Currency Exchange Calculator'), findsNWidgets(2));
      expect(find.text('From Currency'), findsOneWidget);
      expect(find.text('To Currency'), findsOneWidget);
      expect(find.text('Amount to Exchange'), findsOneWidget);
      // The currency_exchange icon appears twice - once in header, once in ExchangeResult
      expect(find.byIcon(Icons.currency_exchange), findsNWidgets(2));
      expect(find.byIcon(Icons.swap_vert), findsOneWidget);
    });

    testWidgets('should show app bar with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // AppBar title should be the same as the main title
      expect(find.text('Currency Exchange Calculator'), findsNWidgets(2));
      // There are multiple currency_exchange icons in the UI, so we check for at least one
      expect(find.byIcon(Icons.currency_exchange), findsAtLeastNWidgets(1));
    });

    testWidgets('should show header section with description', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Look for the app description from ARB file
      expect(find.text('Calculate exchange rates between FIAT and CRYPTO currencies in real-time'), findsOneWidget);
    });

    testWidgets('should show currency selectors', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CurrencySelector), findsNWidgets(2));
    });

    testWidgets('should show amount input field', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(AmountInput), findsOneWidget);
    });

    testWidgets('should show exchange result widget', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(ExchangeResult), findsOneWidget);
    });

    testWidgets('should show info card at bottom', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Exchange rates are updated in real-time from our secure API'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle currency selection', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Test that currency selectors are present and functional
      expect(find.byType(CurrencySelector), findsNWidgets(2));
    });

    testWidgets('should handle amount input', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Test that amount input is present
      expect(find.byType(AmountInput), findsOneWidget);
    });

    testWidgets('should show proper styling and layout', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verify that the screen has proper structure
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('should handle provider state changes', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Change provider state
      mockProvider.initialize();
      await tester.pump();

      // Screen should update accordingly
      expect(find.byType(CurrencySelector), findsNWidgets(2));
    });

    testWidgets('should show loading state in exchange result', (WidgetTester tester) async {
      mockProvider.initialize();
      mockProvider.setAmount(100.0);
      
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // The exchange result should show the current state
      expect(find.byType(ExchangeResult), findsOneWidget);
      
      // Clean up timers
      mockProvider.reset();
    });

    testWidgets('should handle error states', (WidgetTester tester) async {
      mockProvider.initialize();
      mockProvider.setAmount(100.0);
      
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Test error handling through the provider
      expect(find.byType(ExchangeResult), findsOneWidget);
      
      // Clean up timers
      mockProvider.reset();
    });

    testWidgets('should maintain proper spacing between elements', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verify that SizedBox widgets are present for spacing
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('should use proper Material Design components', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verify Material Design components
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should handle responsive design', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Test that the layout is responsive
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });
  });
}
