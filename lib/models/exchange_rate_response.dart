import 'package:logger/logger.dart';

class ExchangeRateResponse {
  final Data data;

  const ExchangeRateResponse({required this.data});

  factory ExchangeRateResponse.fromJson(Map<String, dynamic> json) {
    return ExchangeRateResponse(data: Data.fromJson(json['data'] ?? {}));
  }
}

class Data {
  final ByPrice byPrice;

  const Data({required this.byPrice});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(byPrice: ByPrice.fromJson(json['byPrice'] ?? {}));
  }
}

class ByPrice {
  static const double _defaultRate = 0.0;
  static final Logger _logger = Logger();

  final double fiatToCryptoExchangeRate;

  const ByPrice({required this.fiatToCryptoExchangeRate});

  factory ByPrice.fromJson(Map<String, dynamic> json) {
    final rateValue = json['fiatToCryptoExchangeRate'];
    final rate = _parseExchangeRate(rateValue);

    _logger.i('Exchange rate parsing completed: $rate');
    return ByPrice(fiatToCryptoExchangeRate: rate);
  }

  static double _parseExchangeRate(dynamic rateValue) {
    if (rateValue == null) {
      _logger.w('Exchange rate is null, using default value');
      return _defaultRate;
    }

    if (rateValue is String) {
      final rate = double.tryParse(rateValue) ?? _defaultRate;
      _logger.d('Parsed string exchange rate: $rateValue -> $rate');
      return rate;
    }

    if (rateValue is num) {
      final rate = rateValue.toDouble();
      _logger.d('Parsed numeric exchange rate: $rateValue -> $rate');
      return rate;
    }

    _logger.w('Unknown exchange rate type: ${rateValue.runtimeType}');
    return _defaultRate;
  }
}
