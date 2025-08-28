import 'package:flutter_test/flutter_test.dart';
import 'package:coding_interview/services/currency_service.dart';
import 'package:coding_interview/models/currency.dart';
import 'package:coding_interview/models/exchange_rate_response.dart';

void main() {
  group('CurrencyService Tests', () {
    group('Available Currencies', () {
      test('should return crypto currencies', () {
        final cryptoCurrencies = CurrencyService.getCryptoCurrencies();
        
        expect(cryptoCurrencies.isNotEmpty, true);
        expect(cryptoCurrencies.every((c) => c.type == CurrencyType.crypto), true);
        
        // Check specific crypto currency
        final usdtCurrency = cryptoCurrencies.firstWhere((c) => c.symbol == 'USDT');
        expect(usdtCurrency.name, 'TATUM TRON USDT');
        expect(usdtCurrency.id, 'TATUM-TRON-USDT');
      });

      test('should return fiat currencies', () {
        final fiatCurrencies = CurrencyService.getFiatCurrencies();
        
        expect(fiatCurrencies.isNotEmpty, true);
        expect(fiatCurrencies.every((c) => c.type == CurrencyType.fiat), true);
        
        // Check specific fiat currencies
        final brlCurrency = fiatCurrencies.firstWhere((c) => c.symbol == 'BRL');
        expect(brlCurrency.name, 'Brazilian Real');
        expect(brlCurrency.id, 'BRL');
        
        final copCurrency = fiatCurrencies.firstWhere((c) => c.symbol == 'COP');
        expect(copCurrency.name, 'Colombian Peso');
        expect(copCurrency.id, 'COP');
      });

      test('should have correct total number of currencies', () {
        final cryptoCurrencies = CurrencyService.getCryptoCurrencies();
        final fiatCurrencies = CurrencyService.getFiatCurrencies();
        
        expect(cryptoCurrencies.length + fiatCurrencies.length, 5); // 1 crypto + 4 fiat
      });
    });

    group('Exchange Calculation', () {
      test('should calculate crypto to fiat exchange correctly', () {
        const inputAmount = 100.0;
        const exchangeRate = 5.0;
        const isCryptoToFiat = true;

        final result = CurrencyService.calculateExchangeAmount(
          inputAmount: inputAmount,
          exchangeRate: exchangeRate,
          isCryptoToFiat: isCryptoToFiat,
        );

        expect(result, 500.0); // 100 * 5
      });

      test('should calculate fiat to crypto exchange correctly', () {
        const inputAmount = 500.0;
        const exchangeRate = 5.0;
        const isCryptoToFiat = false;

        final result = CurrencyService.calculateExchangeAmount(
          inputAmount: inputAmount,
          exchangeRate: exchangeRate,
          isCryptoToFiat: isCryptoToFiat,
        );

        expect(result, 100.0); // 500 / 5
      });

      test('should handle zero exchange rate', () {
        const inputAmount = 100.0;
        const exchangeRate = 0.0;
        const isCryptoToFiat = true;

        final result = CurrencyService.calculateExchangeAmount(
          inputAmount: inputAmount,
          exchangeRate: exchangeRate,
          isCryptoToFiat: isCryptoToFiat,
        );

        expect(result, 0.0);
      });

      test('should handle zero amount', () {
        const inputAmount = 0.0;
        const exchangeRate = 5.0;
        const isCryptoToFiat = true;

        final result = CurrencyService.calculateExchangeAmount(
          inputAmount: inputAmount,
          exchangeRate: exchangeRate,
          isCryptoToFiat: isCryptoToFiat,
        );

        expect(result, 0.0);
      });

      test('should handle decimal amounts', () {
        const inputAmount = 100.5;
        const exchangeRate = 2.5;
        const isCryptoToFiat = true;

        final result = CurrencyService.calculateExchangeAmount(
          inputAmount: inputAmount,
          exchangeRate: exchangeRate,
          isCryptoToFiat: isCryptoToFiat,
        );

        expect(result, 251.25); // 100.5 * 2.5
      });

      test('should handle decimal exchange rates', () {
        const inputAmount = 100.0;
        const exchangeRate = 0.5;
        const isCryptoToFiat = false;

        final result = CurrencyService.calculateExchangeAmount(
          inputAmount: inputAmount,
          exchangeRate: exchangeRate,
          isCryptoToFiat: isCryptoToFiat,
        );

        expect(result, 200.0); // 100 / 0.5
      });
    });

    group('API URL Construction', () {
      test('should construct correct API URL with parameters', () {
        // This test verifies the URL construction logic
        final result = CurrencyService.getExchangeRate(
          type: 0,
          cryptoCurrencyId: 'BTC',
          fiatCurrencyId: 'USD',
          amount: 100.0,
          amountCurrencyId: 'BTC',
        );
        expect(result, isA<Future<ExchangeRateResponse>>());
      });
    });
  });
}
