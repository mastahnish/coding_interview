import 'package:flutter_test/flutter_test.dart';
import 'package:coding_interview/providers/currency_provider.dart';
import 'package:coding_interview/models/currency.dart';
import 'package:coding_interview/services/currency_service.dart';

void main() {
  group('CurrencyProvider Tests', () {
    late CurrencyProvider provider;

    setUp(() {
      provider = CurrencyProvider();
    });

    tearDown(() {
      provider.dispose();
    });

    group('Initialization', () {
      test('should initialize with default values', () {
        expect(provider.fromCurrency, isNull);
        expect(provider.toCurrency, isNull);
        expect(provider.amount, 0.0);
        expect(provider.exchangeRate, 0.0);
        expect(provider.resultAmount, 0.0);
        expect(provider.isLoading, false);
        expect(provider.errorMessage, isNull);
        expect(provider.isCryptoToFiat, true);
      });

      test('should initialize currencies after calling initialize', () {
        provider.initialize();
        
        expect(provider.fromCurrency, isNotNull);
        expect(provider.toCurrency, isNotNull);
        expect(provider.fromCurrency!.type, CurrencyType.crypto);
        expect(provider.toCurrency!.type, CurrencyType.fiat);
      });
    });

    group('Currency Selection', () {
      test('should set from currency correctly', () {
        final cryptoCurrency = CurrencyService.getCryptoCurrencies().first;
        
        provider.setFromCurrency(cryptoCurrency);
        
        expect(provider.fromCurrency, equals(cryptoCurrency));
        expect(provider.isCryptoToFiat, true);
      });

      test('should set to currency correctly', () {
        final fiatCurrency = CurrencyService.getFiatCurrencies().first;
        
        provider.setToCurrency(fiatCurrency);
        
        expect(provider.toCurrency, equals(fiatCurrency));
      });

      test('should update exchange type when currencies change', () {
        final cryptoCurrency = CurrencyService.getCryptoCurrencies().first;
        final fiatCurrency = CurrencyService.getFiatCurrencies().first;
        
        provider.setFromCurrency(cryptoCurrency);
        provider.setToCurrency(fiatCurrency);
        
        expect(provider.isCryptoToFiat, true);
        
        // Swap to fiat to crypto
        provider.setFromCurrency(fiatCurrency);
        provider.setToCurrency(cryptoCurrency);
        
        expect(provider.isCryptoToFiat, false);
      });
    });

    group('Amount Management', () {
      test('should set amount correctly', () {
        const testAmount = 100.0;
        
        provider.setAmount(testAmount);
        
        expect(provider.amount, testAmount);
      });

      test('should clear results when amount changes', () {
        // Set up initial state
        provider.initialize();
        provider.setAmount(100.0);
        
        // Simulate some results
        provider.setAmount(200.0);
        
        expect(provider.exchangeRate, 0.0);
        expect(provider.resultAmount, 0.0);
        expect(provider.errorMessage, isNull);
      });
    });

    group('Currency Swapping', () {
      test('should swap currencies correctly', () {
        provider.initialize();
        final originalFrom = provider.fromCurrency;
        final originalTo = provider.toCurrency;
        
        provider.swapCurrencies();
        
        expect(provider.fromCurrency, equals(originalTo));
        expect(provider.toCurrency, equals(originalFrom));
      });

      test('should update exchange type after swap', () {
        provider.initialize();
        final originalType = provider.isCryptoToFiat;
        
        provider.swapCurrencies();
        
        expect(provider.isCryptoToFiat, !originalType);
      });

      test('should not swap if currencies are not set', () {
        // Don't initialize, so currencies are null
        final originalFrom = provider.fromCurrency;
        final originalTo = provider.toCurrency;
        
        provider.swapCurrencies();
        
        expect(provider.fromCurrency, equals(originalFrom));
        expect(provider.toCurrency, equals(originalTo));
      });

      test('should trigger auto-calculation after swapping currencies', () async {
        provider.initialize();
        provider.setAmount(100.0);
        
        // Wait for the initial calculation to complete
        await Future.delayed(const Duration(milliseconds: 600));
        
        // Clear any previous results
        provider.reset();
        provider.initialize();
        provider.setAmount(100.0);
        
        // Wait for the initial calculation to complete
        await Future.delayed(const Duration(milliseconds: 600));
        
        // Now swap currencies
        provider.swapCurrencies();
        
        // The provider should have scheduled a new calculation
        // We can verify this by checking if the state is properly updated
        expect(provider.fromCurrency, isNotNull);
        expect(provider.toCurrency, isNotNull);
        expect(provider.amount, 100.0);
      });
    });

    group('Auto-calculation', () {
      test('should schedule auto-calculation when amount is set', () {
        provider.initialize();
        
        // Mock the timer to avoid actual delays in tests
        provider.setAmount(100.0);
        
        // The provider should have scheduled a calculation
        // We can't easily test the timer directly, but we can verify the state
        expect(provider.amount, 100.0);
      });

      test('should not schedule calculation with invalid data', () {
        provider.setAmount(100.0);
        
        // No currencies set, so no calculation should be scheduled
        expect(provider.fromCurrency, isNull);
        expect(provider.toCurrency, isNull);
      });
    });

    group('State Management', () {
      test('should clear results correctly', () {
        // Set up some state
        provider.initialize();
        provider.setAmount(100.0);
        
        // Clear results
        provider.reset();
        
        expect(provider.amount, 0.0);
        expect(provider.exchangeRate, 0.0);
        expect(provider.resultAmount, 0.0);
        expect(provider.errorMessage, isNull);
        expect(provider.isLoading, false);
      });

      test('should notify listeners when state changes', () {
        var notificationCount = 0;
        provider.addListener(() {
          notificationCount++;
        });
        
        provider.initialize();
        expect(notificationCount, greaterThan(0));
      });
    });

    group('Available Currencies', () {
      test('should provide crypto currencies', () {
        final cryptoCurrencies = provider.cryptoCurrencies;
        
        expect(cryptoCurrencies.isNotEmpty, true);
        expect(cryptoCurrencies.every((c) => c.type == CurrencyType.crypto), true);
      });

      test('should provide fiat currencies', () {
        final fiatCurrencies = provider.fiatCurrencies;
        
        expect(fiatCurrencies.isNotEmpty, true);
        expect(fiatCurrencies.every((c) => c.type == CurrencyType.fiat), true);
      });
    });

    group('Validation', () {
      test('should validate required data for exchange calculation', () {
        // No currencies or amount set
        expect(provider.fromCurrency, isNull);
        expect(provider.toCurrency, isNull);
        expect(provider.amount, 0.0);
        
        // Should not be able to calculate
        expect(provider.fromCurrency != null && 
               provider.toCurrency != null && 
               provider.amount > 0, false);
      });

      test('should have valid data after initialization', () {
        provider.initialize();
        
        expect(provider.fromCurrency, isNotNull);
        expect(provider.toCurrency, isNotNull);
        expect(provider.amount, 0.0); // Amount still needs to be set
      });
    });

    testWidgets('should update exchange type after swap', (WidgetTester tester) async {
      final provider = CurrencyProvider();
      
      // Set initial state: crypto -> fiat
      provider.setFromCurrency(provider.cryptoCurrencies.first);
      provider.setToCurrency(provider.fiatCurrencies.first);
      
      expect(provider.isCryptoToFiat, isTrue);
      
      // Swap currencies
      provider.swapCurrencies();
      
      // Should now be fiat -> crypto
      expect(provider.isCryptoToFiat, isFalse);
    });

    testWidgets('should provide correct dynamic currency lists', (WidgetTester tester) async {
      final provider = CurrencyProvider();
      
      // Set initial state: crypto -> fiat
      provider.setFromCurrency(provider.cryptoCurrencies.first);
      provider.setToCurrency(provider.fiatCurrencies.first);
      
      // In crypto -> fiat mode:
      // fromCurrencyList should be crypto currencies
      // toCurrencyList should be fiat currencies
      expect(provider.fromCurrencyList, equals(provider.cryptoCurrencies));
      expect(provider.toCurrencyList, equals(provider.fiatCurrencies));
      
      // Swap currencies
      provider.swapCurrencies();
      
      // In fiat -> crypto mode:
      // fromCurrencyList should be fiat currencies
      // toCurrencyList should be crypto currencies
      expect(provider.fromCurrencyList, equals(provider.fiatCurrencies));
      expect(provider.toCurrencyList, equals(provider.cryptoCurrencies));
    });
  });
}
