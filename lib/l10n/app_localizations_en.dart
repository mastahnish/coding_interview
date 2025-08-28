// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Currency Exchange Calculator';

  @override
  String get appDescription =>
      'Calculate exchange rates between FIAT and CRYPTO currencies in real-time';

  @override
  String get selectCurrency => 'Select Currency';

  @override
  String get amountToExchange => 'Amount to Exchange';

  @override
  String get amountHint => '0.00';

  @override
  String get calculatingExchangeRate => 'Calculating exchange rate...';

  @override
  String get enterAmountToSeeExchangeRate =>
      'Enter amount to see exchange rate';

  @override
  String get error => 'Error';

  @override
  String get exchangeRate => 'Exchange Rate';

  @override
  String get youSend => 'You send';

  @override
  String get youReceive => 'You receive';

  @override
  String exchangeRateFormat(
    String fromCurrency,
    String exchangeRate,
    String toCurrency,
  ) {
    return '1 $fromCurrency = $exchangeRate $toCurrency';
  }

  @override
  String exchangeRateDisplay(
    String fromCurrency,
    String exchangeRate,
    String toCurrency,
  ) {
    return '1 $fromCurrency = $exchangeRate $toCurrency';
  }

  @override
  String get infoCardTitle => 'How it works';

  @override
  String get infoCardDescription =>
      'Select your currencies, enter an amount, and get real-time exchange rates. The calculation happens automatically as you type.';

  @override
  String get pleaseEnterAmount => 'Please enter an amount';

  @override
  String get pleaseEnterValidAmount => 'Please enter a valid amount';

  @override
  String failedToCalculateExchange(String error) {
    return 'Failed to calculate exchange: $error';
  }

  @override
  String get pleaseSelectCurrenciesAndEnterValidAmount =>
      'Please select currencies and enter a valid amount';

  @override
  String get fromCurrency => 'From Currency';

  @override
  String get toCurrency => 'To Currency';

  @override
  String get swapCurrencies => 'Swap Currencies';

  @override
  String get reset => 'Reset';

  @override
  String get exchangeRatesUpdated =>
      'Exchange rates are updated in real-time from our secure API';

  @override
  String get exchangeRateUpdatesAutomatically =>
      'Exchange rate updates automatically';
}
