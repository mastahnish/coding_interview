import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';

class AmountInput extends StatelessWidget {
  final String label;
  final double? value;
  final Function(double) onChanged;
  final String? errorText;
  final bool isEnabled;

  const AmountInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.errorText,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
        const SizedBox(height: 8),
        TextFormField(
          enabled: isEnabled,
          initialValue: value != null && value! > 0 ? value!.toString() : '',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.amountHint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: errorText != null ? Colors.red : Colors.grey.shade300, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: errorText != null ? Colors.red : Colors.grey.shade300, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
            suffixIcon: Icon(Icons.auto_awesome, color: Colors.blue.shade400, size: 20),
          ),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,4}(\.\d{0,2})?'))],
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          onChanged: (value) {
            final amount = double.tryParse(value) ?? 0.0;
            onChanged(amount);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.pleaseEnterAmount;
            }
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return AppLocalizations.of(context)!.pleaseEnterValidAmount;
            }
            return null;
          },
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(errorText!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red)),
        ],
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade400, size: 16),
              const SizedBox(width: 6),
              Text(
                AppLocalizations.of(context)!.exchangeRateUpdatesAutomatically,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.blue.shade600, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
