import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Currency Exchange Calculator'**
  String get appTitle;

  /// Description of what the app does
  ///
  /// In en, this message translates to:
  /// **'Calculate exchange rates between FIAT and CRYPTO currencies in real-time'**
  String get appDescription;

  /// Label for currency selection dropdown
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get selectCurrency;

  /// Label for amount input field
  ///
  /// In en, this message translates to:
  /// **'Amount to Exchange'**
  String get amountToExchange;

  /// Hint text for amount input field
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get amountHint;

  /// Text shown when calculating exchange rate
  ///
  /// In en, this message translates to:
  /// **'Calculating exchange rate...'**
  String get calculatingExchangeRate;

  /// Text shown when no amount is entered
  ///
  /// In en, this message translates to:
  /// **'Enter amount to see exchange rate'**
  String get enterAmountToSeeExchangeRate;

  /// Error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Label for exchange rate display
  ///
  /// In en, this message translates to:
  /// **'Exchange Rate'**
  String get exchangeRate;

  /// Label for amount being sent
  ///
  /// In en, this message translates to:
  /// **'You send'**
  String get youSend;

  /// Label for amount being received
  ///
  /// In en, this message translates to:
  /// **'You receive'**
  String get youReceive;

  /// Format for displaying exchange rate
  ///
  /// In en, this message translates to:
  /// **'1 {fromCurrency} = {exchangeRate} {toCurrency}'**
  String exchangeRateFormat(
    String fromCurrency,
    String exchangeRate,
    String toCurrency,
  );

  /// Display format for exchange rate
  ///
  /// In en, this message translates to:
  /// **'1 {fromCurrency} = {exchangeRate} {toCurrency}'**
  String exchangeRateDisplay(
    String fromCurrency,
    String exchangeRate,
    String toCurrency,
  );

  /// Title for the info card
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get infoCardTitle;

  /// Description of how the app works
  ///
  /// In en, this message translates to:
  /// **'Select your currencies, enter an amount, and get real-time exchange rates. The calculation happens automatically as you type.'**
  String get infoCardDescription;

  /// Validation message for empty amount
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get pleaseEnterAmount;

  /// Validation message for invalid amount
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get pleaseEnterValidAmount;

  /// Error message when exchange calculation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to calculate exchange: {error}'**
  String failedToCalculateExchange(String error);

  /// Error message when required data is missing
  ///
  /// In en, this message translates to:
  /// **'Please select currencies and enter a valid amount'**
  String get pleaseSelectCurrenciesAndEnterValidAmount;

  /// Label for the source currency selector
  ///
  /// In en, this message translates to:
  /// **'From Currency'**
  String get fromCurrency;

  /// Label for the target currency selector
  ///
  /// In en, this message translates to:
  /// **'To Currency'**
  String get toCurrency;

  /// Tooltip for the swap currencies button
  ///
  /// In en, this message translates to:
  /// **'Swap Currencies'**
  String get swapCurrencies;

  /// Tooltip for the reset button
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Description in the info card about API updates
  ///
  /// In en, this message translates to:
  /// **'Exchange rates are updated in real-time from our secure API'**
  String get exchangeRatesUpdated;

  /// Info text shown below amount input about automatic updates
  ///
  /// In en, this message translates to:
  /// **'Exchange rate updates automatically'**
  String get exchangeRateUpdatesAutomatically;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
