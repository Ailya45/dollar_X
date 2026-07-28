import 'dart:ui' as ui;

import 'package:dollar_x_app/domain/entities/currency_type.dart';
import 'package:dollar_x_app/presentation/constants/colors.dart';
import 'package:dollar_x_app/presentation/widgets/currency_selector.dart';
import 'package:dollar_x_app/presentation/widgets/currency_textfield.dart';
import 'package:dollar_x_app/presentation/widgets/swap_divider.dart';
import 'package:flutter/material.dart';

/// Tarjeta de conversi¢n que contiene los campos de texto, selector de moneda
/// y el bot¢n de intercambio.
class ConversionCard extends StatelessWidget {
  final CurrencyType selectedCurrency;
  final TextEditingController dollarController;
  final TextEditingController bsController;
  final String? dollarError;
  final String? bsError;
  final ValueChanged<String> onDollarChanged;
  final ValueChanged<String> onBsChanged;
  final VoidCallback onSwap;
  final ValueChanged<CurrencyType> onCurrencyChanged;
  final Future<void> Function(BuildContext) onCopyDollar;
  final Future<void> Function(BuildContext) onCopyBs;

  const ConversionCard({
    super.key,
    required this.selectedCurrency,
    required this.dollarController,
    required this.bsController,
    this.dollarError,
    this.bsError,
    required this.onDollarChanged,
    required this.onBsChanged,
    required this.onSwap,
    required this.onCurrencyChanged,
    required this.onCopyDollar,
    required this.onCopyBs,
  });

  @override
  Widget build(BuildContext context) {
    final currency = selectedCurrency;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.cardGradient,
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: CurrencyTextField(
                      key: ValueKey(currency),
                      label: currency.label,
                      currencyCode: currency.code,
                      leadingIcon: currency.icon,
                      getErrorText: () => dollarError,
                      textController: dollarController,
                      onChanged: onDollarChanged,
                      onCopy: onCopyDollar,
                    ),
                  ),
                  SwapDivider(onSwap: onSwap),
                  CurrencyTextField(
                    label: 'Bolivares',
                    currencyCode: 'Bs',
                    leadingIcon: Icons.monetization_on_outlined,
                    getErrorText: () => bsError,
                    textController: bsController,
                    onChanged: onBsChanged,
                    onCopy: onCopyBs,
                  ),
                  const SizedBox(height: 16),
                  CurrencySelector(
                    selected: selectedCurrency,
                    onChanged: onCurrencyChanged,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
