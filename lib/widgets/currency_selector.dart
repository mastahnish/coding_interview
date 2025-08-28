import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/currency.dart';

class CurrencySelector extends StatelessWidget {
  final String title;
  final Currency? selectedCurrency;
  final List<Currency> currencies;
  final Function(Currency) onCurrencySelected;
  final bool isEnabled;

  const CurrencySelector({
    super.key,
    required this.title,
    required this.selectedCurrency,
    required this.currencies,
    required this.onCurrencySelected,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selectedCurrency != null ? Colors.blue : Colors.grey.shade300, width: 2),
            color: Colors.white,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: isEnabled ? () => _showCurrencyPicker(context) : null,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (selectedCurrency != null) ...[
                      Image.asset(
                        selectedCurrency!.imagePath,
                        width: 32,
                        height: 32,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              selectedCurrency!.type == CurrencyType.crypto
                                  ? Icons.currency_bitcoin
                                  : Icons.attach_money,
                              color: Colors.grey.shade600,
                              size: 20,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedCurrency!.symbol,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              selectedCurrency!.name,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Icon(Icons.add_circle_outline, color: Colors.grey.shade400, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context)!.selectCurrency,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade400),
                      ),
                    ],
                    const Spacer(),
                    Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CurrencyPickerSheet(
        currencies: currencies,
        selectedCurrency: selectedCurrency,
        onCurrencySelected: onCurrencySelected,
      ),
    );
  }
}

class _CurrencyPickerSheet extends StatelessWidget {
  final List<Currency> currencies;
  final Currency? selectedCurrency;
  final Function(Currency) onCurrencySelected;

  const _CurrencyPickerSheet({
    required this.currencies,
    required this.selectedCurrency,
    required this.onCurrencySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.selectCurrency,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                final currency = currencies[index];
                final isSelected = selectedCurrency?.id == currency.id;

                return ListTile(
                  leading: Image.asset(
                    currency.imagePath,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
                        child: Icon(
                          currency.type == CurrencyType.crypto ? Icons.currency_bitcoin : Icons.attach_money,
                          color: Colors.grey.shade600,
                        ),
                      );
                    },
                  ),
                  title: Text(
                    currency.symbol,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    currency.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                  ),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blue) : null,
                  onTap: () {
                    onCurrencySelected(currency);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
