import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../l10n/app_localizations.dart';

class ExchangeResult extends StatelessWidget {
  static const double _height = 200.0;
  static const double _padding = 24.0;
  static const double _borderRadius = 16.0;
  static const double _iconSize = 48.0;
  static const double _spacing = 16.0;
  static const double _smallSpacing = 8.0;
  static const double _tinySpacing = 4.0;

  final double amount;
  final double exchangeRate;
  final double resultAmount;
  final String fromCurrencySymbol;
  final String toCurrencySymbol;
  final bool isLoading;
  final String? errorMessage;

  const ExchangeResult({
    super.key,
    required this.amount,
    required this.exchangeRate,
    required this.resultAmount,
    required this.fromCurrencySymbol,
    required this.toCurrencySymbol,
    required this.isLoading,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _LoadingState();
    }

    if (errorMessage != null) {
      return _ErrorState(errorMessage: errorMessage!);
    }

    if (amount > 0 && exchangeRate > 0 && resultAmount > 0) {
      return _ResultState(
        exchangeRate: exchangeRate,
        resultAmount: resultAmount,
        fromCurrencySymbol: fromCurrencySymbol,
        toCurrencySymbol: toCurrencySymbol,
        amount: amount,
      );
    }

    return _EmptyState();
  }
}

class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ExchangeResult._height,
      child: Container(
        padding: const EdgeInsets.all(ExchangeResult._padding),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(ExchangeResult._borderRadius),
          border: Border.all(color: Colors.blue.shade200, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600)),
            const SizedBox(height: ExchangeResult._spacing),
            Text(
              AppLocalizations.of(context)!.calculatingExchangeRate,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.blue.shade700, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String errorMessage;

  const _ErrorState({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ExchangeResult._height,
      child: Container(
        padding: const EdgeInsets.all(ExchangeResult._padding),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(ExchangeResult._borderRadius),
          border: Border.all(color: Colors.red.shade200, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: ExchangeResult._iconSize, color: Colors.red.shade600),
            const SizedBox(height: ExchangeResult._spacing),
            Text(
              AppLocalizations.of(context)!.error,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.red.shade700),
            ),
            const SizedBox(height: ExchangeResult._smallSpacing),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ExchangeResult._height,
      child: Container(
        padding: const EdgeInsets.all(ExchangeResult._padding),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(ExchangeResult._borderRadius),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.currency_exchange, size: ExchangeResult._iconSize, color: Colors.grey.shade400),
            const SizedBox(height: ExchangeResult._spacing),
            Text(
              AppLocalizations.of(context)!.enterAmountToSeeExchangeRate,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultState extends StatelessWidget {
  final double exchangeRate;
  final double resultAmount;
  final String fromCurrencySymbol;
  final String toCurrencySymbol;
  final double amount;

  const _ResultState({
    required this.exchangeRate,
    required this.resultAmount,
    required this.fromCurrencySymbol,
    required this.toCurrencySymbol,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = intl.NumberFormat.currency(symbol: '', decimalDigits: 2);

    return SizedBox(
      height: ExchangeResult._height,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(ExchangeResult._borderRadius),
          border: Border.all(color: Colors.blue.shade200, width: 1),
          boxShadow: [
            BoxShadow(color: Colors.blue.shade100.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _ExchangeRateText(
              exchangeRate: exchangeRate,
              fromCurrencySymbol: fromCurrencySymbol,
              toCurrencySymbol: toCurrencySymbol,
              formatter: formatter,
            ),
            const SizedBox(height: ExchangeResult._spacing),
            _CurrencyPairHeader(fromCurrencySymbol: fromCurrencySymbol, toCurrencySymbol: toCurrencySymbol),
            const SizedBox(height: ExchangeResult._tinySpacing),
            _ExchangeResultColumn(amount: amount, resultAmount: resultAmount, formatter: formatter),
          ],
        ),
      ),
    );
  }
}

class _ExchangeRateText extends StatelessWidget {
  final double exchangeRate;
  final String fromCurrencySymbol;
  final String toCurrencySymbol;
  final intl.NumberFormat formatter;

  const _ExchangeRateText({
    required this.exchangeRate,
    required this.fromCurrencySymbol,
    required this.toCurrencySymbol,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.exchangeRate,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: ExchangeResult._tinySpacing),
        Text(
          '1 $fromCurrencySymbol = ${formatter.format(exchangeRate)} $toCurrencySymbol',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _CurrencyPairHeader extends StatelessWidget {
  final String fromCurrencySymbol;
  final String toCurrencySymbol;

  const _CurrencyPairHeader({required this.fromCurrencySymbol, required this.toCurrencySymbol});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$fromCurrencySymbol - $toCurrencySymbol',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
    );
  }
}

class _ExchangeResultColumn extends StatelessWidget {
  final double amount;
  final double resultAmount;
  final intl.NumberFormat formatter;

  const _ExchangeResultColumn({required this.amount, required this.resultAmount, required this.formatter});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          formatter.format(amount),
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.blue.shade700),
        ),
        const SizedBox(height: ExchangeResult._tinySpacing),
        Icon(Icons.arrow_downward, color: Colors.grey.shade400, size: 16),
        const SizedBox(height: ExchangeResult._tinySpacing),
        Text(
          formatter.format(resultAmount),
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.blue.shade600),
        ),
      ],
    );
  }
}
