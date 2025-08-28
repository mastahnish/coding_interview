import 'package:flutter_test/flutter_test.dart';
import 'package:coding_interview/models/currency.dart';
import 'package:coding_interview/services/currency_service.dart';

void main() {
  group('Currency Model Tests', () {
    test('should create currency from JSON', () {
      final json = {
        'id': 'USDT',
        'name': 'Tether',
        'symbol': 'USDT',
        'type': 'crypto',
        'imagePath': 'assets/crypto/usdt.png',
      };

      final currency = Currency.fromJson(json);

      expect(currency.id, 'USDT');
      expect(currency.name, 'Tether');
      expect(currency.symbol, 'USDT');
      expect(currency.type, CurrencyType.crypto);
      expect(currency.imagePath, 'assets/crypto/usdt.png');
    });

    test('should convert currency to JSON', () {
      const currency = Currency(
        id: 'BRL',
        name: 'Brazilian Real',
        symbol: 'BRL',
        type: CurrencyType.fiat,
        imagePath: 'assets/fiat/brl.png',
      );

      final json = currency.toJson();

      expect(json['id'], 'BRL');
      expect(json['name'], 'Brazilian Real');
      expect(json['symbol'], 'BRL');
      expect(json['type'], 'fiat');
      expect(json['imagePath'], 'assets/fiat/brl.png');
    });
  });

  group('Currency Service Tests', () {
    test('should return crypto currencies', () {
      final cryptoCurrencies = CurrencyService.getCryptoCurrencies();
      
      expect(cryptoCurrencies.isNotEmpty, true);
      expect(cryptoCurrencies.every((c) => c.type == CurrencyType.crypto), true);
    });

    test('should return fiat currencies', () {
      final fiatCurrencies = CurrencyService.getFiatCurrencies();
      
      expect(fiatCurrencies.isNotEmpty, true);
      expect(fiatCurrencies.every((c) => c.type == CurrencyType.fiat), true);
    });

    test('should calculate exchange amount correctly for crypto to fiat', () {
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

    test('should calculate exchange amount correctly for fiat to crypto', () {
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
  });
}

