import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/currency_provider.dart';
import '../widgets/amount_input.dart';
import '../widgets/currency_selector.dart';
import '../widgets/exchange_result.dart';

class ExchangeCalculatorScreen extends StatefulWidget {
  const ExchangeCalculatorScreen({super.key});

  @override
  State<ExchangeCalculatorScreen> createState() => _ExchangeCalculatorScreenState();
}

class _ExchangeCalculatorScreenState extends State<ExchangeCalculatorScreen> {
  static const double _spacing = 24.0;
  static const double _padding = 20.0;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CurrencyProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(context),
      body: Consumer<CurrencyProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(_padding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeaderSection(),
                  const SizedBox(height: _spacing),
                  _CurrencySelectionSection(provider: provider),
                  const SizedBox(height: _spacing),
                  _SwapButtonSection(provider: provider),
                  const SizedBox(height: _spacing),
                  _AmountInputSection(provider: provider),
                  const SizedBox(height: _spacing),
                  _ExchangeResultSection(provider: provider),
                  const SizedBox(height: _spacing),
                  _InfoCard(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        AppLocalizations.of(context)!.appTitle,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      backgroundColor: Colors.blue,
    );
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Icon(Icons.currency_exchange, size: 48, color: Colors.blue.shade400),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.appTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.appDescription,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CurrencySelectionSection extends StatelessWidget {
  final CurrencyProvider provider;

  const _CurrencySelectionSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CurrencySelector(
          title: AppLocalizations.of(context)!.fromCurrency,
          selectedCurrency: provider.fromCurrency,
          currencies: provider.fromCurrencyList,
          onCurrencySelected: provider.setFromCurrency,
        ),
        const SizedBox(height: 24),
        CurrencySelector(
          title: AppLocalizations.of(context)!.toCurrency,
          selectedCurrency: provider.toCurrency,
          currencies: provider.toCurrencyList,
          onCurrencySelected: provider.setToCurrency,
        ),
      ],
    );
  }
}

class _SwapButtonSection extends StatelessWidget {
  final CurrencyProvider provider;

  const _SwapButtonSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: IconButton(
          onPressed: provider.swapCurrencies,
          icon: const Icon(Icons.swap_vert),
          color: Colors.blue,
          tooltip: AppLocalizations.of(context)!.swapCurrencies,
        ),
      ),
    );
  }
}

class _AmountInputSection extends StatelessWidget {
  final CurrencyProvider provider;

  const _AmountInputSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    return AmountInput(
      label: AppLocalizations.of(context)!.amountToExchange,
      value: provider.amount,
      onChanged: provider.setAmount,
      errorText: provider.errorMessage,
    );
  }
}

class _ExchangeResultSection extends StatelessWidget {
  final CurrencyProvider provider;

  const _ExchangeResultSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    return ExchangeResult(
      amount: provider.amount,
      exchangeRate: provider.exchangeRate,
      resultAmount: provider.resultAmount,
      fromCurrencySymbol: provider.fromCurrency?.symbol ?? '',
      toCurrencySymbol: provider.toCurrency?.symbol ?? '',
      isLoading: provider.isLoading,
      errorMessage: provider.errorMessage,
    );
  }
}

class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade600, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.exchangeRatesUpdated,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.blue.shade700),
            ),
          ),
        ],
      ),
    );
  }
}
