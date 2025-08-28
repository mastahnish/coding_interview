import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../models/currency.dart';
import '../services/currency_service.dart';

class CurrencyProvider extends ChangeNotifier {
  static const Duration _debounceDelay = Duration(milliseconds: 500);
  static final Logger _logger = Logger();

  Currency? _fromCurrency;
  Currency? _toCurrency;
  double _amount = 0.0;
  double _exchangeRate = 0.0;
  double _resultAmount = 0.0;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isCryptoToFiat = true;

  Timer? _debounceTimer;

  Currency? get fromCurrency => _fromCurrency;

  Currency? get toCurrency => _toCurrency;

  double get amount => _amount;

  double get exchangeRate => _exchangeRate;

  double get resultAmount => _resultAmount;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get isCryptoToFiat => _isCryptoToFiat;

  List<Currency> get cryptoCurrencies => CurrencyService.getCryptoCurrencies();

  List<Currency> get fiatCurrencies => CurrencyService.getFiatCurrencies();

  List<Currency> get fromCurrencyList {
    return _isCryptoToFiat ? cryptoCurrencies : fiatCurrencies;
  }

  List<Currency> get toCurrencyList {
    return _isCryptoToFiat ? fiatCurrencies : cryptoCurrencies;
  }

  void initialize() {
    if (_fromCurrency == null && cryptoCurrencies.isNotEmpty) {
      _fromCurrency = cryptoCurrencies.first;
    }
    if (_toCurrency == null && fiatCurrencies.isNotEmpty) {
      _toCurrency = fiatCurrencies.first;
    }
    notifyListeners();
  }

  void setFromCurrency(Currency currency) {
    _logger.i('Setting from currency: ${currency.symbol}');
    _fromCurrency = currency;
    _updateExchangeType();
    _clearResults();
    notifyListeners();

    _triggerAutoCalculation();
  }

  void setToCurrency(Currency currency) {
    _logger.i('Setting to currency: ${currency.symbol}');
    _toCurrency = currency;
    _updateExchangeType();
    _clearResults();
    notifyListeners();

    _triggerAutoCalculation();
  }

  void setAmount(double amount) {
    _logger.d('Setting amount: $amount');
    _amount = amount;
    _clearResults();

    if (amount > 0 && _fromCurrency != null && _toCurrency != null) {
      _isLoading = true;
    } else {
      _isLoading = false;
    }

    notifyListeners();

    _debounceTimer?.cancel();

    if (amount > 0 && _fromCurrency != null && _toCurrency != null) {
      _logger.i('Scheduling auto-calculation: ${_debounceDelay.inMilliseconds}ms');
      _debounceTimer = Timer(_debounceDelay, () {
        calculateExchange();
      });
    }
  }

  void _updateExchangeType() {
    if (_fromCurrency != null && _toCurrency != null) {
      _isCryptoToFiat = _fromCurrency!.type == CurrencyType.crypto && _toCurrency!.type == CurrencyType.fiat;
    }
  }

  void _clearResults() {
    _exchangeRate = 0.0;
    _resultAmount = 0.0;
    _errorMessage = null;
  }

  void _triggerAutoCalculation() {
    _debounceTimer?.cancel();

    if (_amount > 0 && _fromCurrency != null && _toCurrency != null) {
      _logger.d('Triggering auto-calculation');
      _isLoading = true;
      notifyListeners();
      _debounceTimer = Timer(_debounceDelay, () {
        calculateExchange();
      });
    }
  }

  Future<void> calculateExchange() async {
    if (_fromCurrency == null || _toCurrency == null || _amount <= 0) {
      _logger.w(
        'Cannot calculate exchange - missing required data: from=${_fromCurrency?.symbol}, to=${_toCurrency?.symbol}, amount=$_amount',
      );
      _errorMessage = 'Please select currencies and enter a valid amount';
      notifyListeners();
      return;
    }

    _logger.i(
      'Starting exchange calculation: ${_fromCurrency!.symbol} -> ${_toCurrency!.symbol}, amount=$_amount, cryptoToFiat=$_isCryptoToFiat',
    );

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await CurrencyService.getExchangeRate(
        type: _isCryptoToFiat ? 0 : 1,
        cryptoCurrencyId: _isCryptoToFiat ? _fromCurrency!.id : _toCurrency!.id,
        fiatCurrencyId: _isCryptoToFiat ? _toCurrency!.id : _fromCurrency!.id,
        amount: _amount,
        amountCurrencyId: _fromCurrency!.id,
      );

      _exchangeRate = response.data.byPrice.fiatToCryptoExchangeRate;
      _resultAmount = CurrencyService.calculateExchangeAmount(
        inputAmount: _amount,
        exchangeRate: _exchangeRate,
        isCryptoToFiat: _isCryptoToFiat,
      );

      _logger.i('Exchange calculation completed successfully: rate=$_exchangeRate, result=$_resultAmount');

      _errorMessage = null;
    } catch (e) {
      _logger.e('Exchange calculation failed', error: e);
      _errorMessage = e.toString();
      _exchangeRate = 0.0;
      _resultAmount = 0.0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void swapCurrencies() {
    if (_fromCurrency != null && _toCurrency != null) {
      _logger.i('Swapping currencies: ${_fromCurrency!.symbol} <-> ${_toCurrency!.symbol}');
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _updateExchangeType();
      _clearResults();
      notifyListeners();

      // Trigger auto-calculation after swapping currencies
      _triggerAutoCalculation();
    }
  }

  void reset() {
    _logger.i('Resetting currency provider state');
    _fromCurrency = null;
    _toCurrency = null;
    _amount = 0.0;
    _exchangeRate = 0.0;
    _resultAmount = 0.0;
    _errorMessage = null;
    _isLoading = false;
    _isCryptoToFiat = false;

    _debounceTimer?.cancel();

    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
