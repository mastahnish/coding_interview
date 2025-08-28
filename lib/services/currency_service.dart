import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../models/currency.dart';
import '../models/exchange_rate_response.dart';

class CurrencyService {
  static const String _baseUrl =
      'https://74j6q7lg6a.execute-api.eu-west-1.amazonaws.com/stage/orderbook/public/recommendations';
  static final Logger _logger = Logger();
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  // Available currencies based on the assets
  static final List<Currency> availableCurrencies = [
    const Currency(
      id: 'TATUM-TRON-USDT',
      name: 'TATUM TRON USDT',
      symbol: 'USDT',
      type: CurrencyType.crypto,
      imagePath: 'assets/cripto_currencies/TATUM-TRON-USDT.png',
    ),

    const Currency(
      id: 'BRL',
      name: 'Brazilian Real',
      symbol: 'BRL',
      type: CurrencyType.fiat,
      imagePath: 'assets/fiat_currencies/BRL.png',
    ),
    const Currency(
      id: 'COP',
      name: 'Colombian Peso',
      symbol: 'COP',
      type: CurrencyType.fiat,
      imagePath: 'assets/fiat_currencies/COP.png',
    ),
    const Currency(
      id: 'PEN',
      name: 'Peruvian Sol',
      symbol: 'PEN',
      type: CurrencyType.fiat,
      imagePath: 'assets/fiat_currencies/PEN.png',
    ),
    const Currency(
      id: 'VES',
      name: 'Venezuelan Bolívar',
      symbol: 'VES',
      type: CurrencyType.fiat,
      imagePath: 'assets/fiat_currencies/VES.png',
    ),
  ];

  static List<Currency> getCryptoCurrencies() {
    return availableCurrencies.where((currency) => currency.type == CurrencyType.crypto).toList();
  }

  static List<Currency> getFiatCurrencies() {
    return availableCurrencies.where((currency) => currency.type == CurrencyType.fiat).toList();
  }

  static Future<ExchangeRateResponse> getExchangeRate({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required double amount,
    required String amountCurrencyId,
  }) async {
    _logger.i('Fetching exchange rate: type=$type, crypto=$cryptoCurrencyId, fiat=$fiatCurrencyId, amount=$amount');

    try {
      final queryParameters = {
        'type': type.toString(),
        'cryptoCurrencyId': cryptoCurrencyId,
        'fiatCurrencyId': fiatCurrencyId,
        'amount': amount.toString(),
        'amountCurrencyId': amountCurrencyId,
      };

      _logger.d('API request parameters: $queryParameters');

      final response = await _dio.get(_baseUrl, queryParameters: queryParameters);

      _logger.d('API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        _logger.i('Exchange rate fetched successfully');
        return ExchangeRateResponse.fromJson(jsonResponse);
      } else {
        _logger.e('API request failed: status=${response.statusCode}');
        throw Exception('Failed to load exchange rate: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _logger.e('Dio error fetching exchange rate', error: e);
      if (e.response != null) {
        throw Exception('API error: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      _logger.e('Unexpected error fetching exchange rate', error: e);
      throw Exception('Error fetching exchange rate: $e');
    }
  }

  static double calculateExchangeAmount({
    required double inputAmount,
    required double exchangeRate,
    required bool isCryptoToFiat,
  }) {
    final result = isCryptoToFiat ? inputAmount * exchangeRate : inputAmount / exchangeRate;

    _logger.d('Exchange calculation: $inputAmount * $exchangeRate = $result (cryptoToFiat: $isCryptoToFiat)');

    return result;
  }
}
