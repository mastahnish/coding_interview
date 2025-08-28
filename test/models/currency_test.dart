import 'package:flutter_test/flutter_test.dart';
import 'package:coding_interview/models/currency.dart';

void main() {
  group('Currency Model Tests', () {
    test('should create currency with all properties', () {
      const currency = Currency(
        id: 'USDT',
        name: 'Tether',
        symbol: 'USDT',
        type: CurrencyType.crypto,
        imagePath: 'assets/crypto/usdt.png',
      );

      expect(currency.id, 'USDT');
      expect(currency.name, 'Tether');
      expect(currency.symbol, 'USDT');
      expect(currency.type, CurrencyType.crypto);
      expect(currency.imagePath, 'assets/crypto/usdt.png');
    });

    test('should create fiat currency', () {
      const currency = Currency(
        id: 'BRL',
        name: 'Brazilian Real',
        symbol: 'BRL',
        type: CurrencyType.fiat,
        imagePath: 'assets/fiat/brl.png',
      );

      expect(currency.type, CurrencyType.fiat);
    });

    test('should create crypto currency', () {
      const currency = Currency(
        id: 'BTC',
        name: 'Bitcoin',
        symbol: 'BTC',
        type: CurrencyType.crypto,
        imagePath: 'assets/crypto/btc.png',
      );

      expect(currency.type, CurrencyType.crypto);
    });

    test('should create currency from JSON', () {
      final json = {
        'id': 'ETH',
        'name': 'Ethereum',
        'symbol': 'ETH',
        'type': 'crypto',
        'imagePath': 'assets/crypto/eth.png',
      };

      final currency = Currency.fromJson(json);

      expect(currency.id, 'ETH');
      expect(currency.name, 'Ethereum');
      expect(currency.symbol, 'ETH');
      expect(currency.type, CurrencyType.crypto);
      expect(currency.imagePath, 'assets/crypto/eth.png');
    });

    test('should create fiat currency from JSON', () {
      final json = {
        'id': 'EUR',
        'name': 'Euro',
        'symbol': 'EUR',
        'type': 'fiat',
        'imagePath': 'assets/fiat/eur.png',
      };

      final currency = Currency.fromJson(json);

      expect(currency.type, CurrencyType.fiat);
    });

    test('should handle missing JSON values', () {
      final json = {
        'id': 'TEST',
        'name': null,
        'symbol': null,
        'type': null,
        'imagePath': null,
      };

      final currency = Currency.fromJson(json);

      expect(currency.id, 'TEST');
      expect(currency.name, '');
      expect(currency.symbol, '');
      expect(currency.type, CurrencyType.fiat); // Default when type is null
      expect(currency.imagePath, '');
    });

    test('should convert currency to JSON', () {
      const currency = Currency(
        id: 'JPY',
        name: 'Japanese Yen',
        symbol: 'JPY',
        type: CurrencyType.fiat,
        imagePath: 'assets/fiat/jpy.png',
      );

      final json = currency.toJson();

      expect(json['id'], 'JPY');
      expect(json['name'], 'Japanese Yen');
      expect(json['symbol'], 'JPY');
      expect(json['type'], 'fiat');
      expect(json['imagePath'], 'assets/fiat/jpy.png');
    });

    test('should handle equality correctly', () {
      const currency1 = Currency(
        id: 'USD',
        name: 'US Dollar',
        symbol: 'USD',
        type: CurrencyType.fiat,
        imagePath: 'assets/fiat/usd.png',
      );

      const currency2 = Currency(
        id: 'USD',
        name: 'US Dollar',
        symbol: 'USD',
        type: CurrencyType.fiat,
        imagePath: 'assets/fiat/usd.png',
      );

      const currency3 = Currency(
        id: 'EUR',
        name: 'Euro',
        symbol: 'EUR',
        type: CurrencyType.fiat,
        imagePath: 'assets/fiat/eur.png',
      );

      expect(currency1, equals(currency2));
      expect(currency1, isNot(equals(currency3)));
      expect(currency1.hashCode, equals(currency2.hashCode));
    });

    test('should provide meaningful string representation', () {
      const currency = Currency(
        id: 'GBP',
        name: 'British Pound',
        symbol: 'GBP',
        type: CurrencyType.fiat,
        imagePath: 'assets/fiat/gbp.png',
      );

      final stringRep = currency.toString();

      expect(stringRep, contains('GBP'));
      expect(stringRep, contains('British Pound'));
      expect(stringRep, contains('fiat'));
    });
  });
}

