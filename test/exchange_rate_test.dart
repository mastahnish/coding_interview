import 'package:flutter_test/flutter_test.dart';
import 'package:coding_interview/models/exchange_rate_response.dart';

void main() {
  group('ExchangeRateResponse Tests', () {
    test('should parse response with numeric exchange rate', () {
      final json = <String, dynamic>{
        'data': <String, dynamic>{
          'byPrice': <String, dynamic>{
            'fiatToCryptoExchangeRate': 5.43,
          },
        },
      };

      final response = ExchangeRateResponse.fromJson(json);
      expect(response.data.byPrice.fiatToCryptoExchangeRate, 5.43);
    });

    test('should parse response with string exchange rate', () {
      final json = <String, dynamic>{
        'data': <String, dynamic>{
          'byPrice': <String, dynamic>{
            'fiatToCryptoExchangeRate': '5.43',
          },
        },
      };

      final response = ExchangeRateResponse.fromJson(json);
      expect(response.data.byPrice.fiatToCryptoExchangeRate, 5.43);
    });

    test('should handle null exchange rate', () {
      final json = <String, dynamic>{
        'data': <String, dynamic>{
          'byPrice': <String, dynamic>{
            'fiatToCryptoExchangeRate': null,
          },
        },
      };

      final response = ExchangeRateResponse.fromJson(json);
      expect(response.data.byPrice.fiatToCryptoExchangeRate, 0.0);
    });

    test('should handle missing exchange rate', () {
      final json = <String, dynamic>{
        'data': <String, dynamic>{
          'byPrice': <String, dynamic>{},
        },
      };

      final response = ExchangeRateResponse.fromJson(json);
      expect(response.data.byPrice.fiatToCryptoExchangeRate, 0.0);
    });

    test('should handle invalid string exchange rate', () {
      final json = <String, dynamic>{
        'data': <String, dynamic>{
          'byPrice': <String, dynamic>{
            'fiatToCryptoExchangeRate': 'invalid',
          },
        },
      };

      final response = ExchangeRateResponse.fromJson(json);
      expect(response.data.byPrice.fiatToCryptoExchangeRate, 0.0);
    });
  });
}
