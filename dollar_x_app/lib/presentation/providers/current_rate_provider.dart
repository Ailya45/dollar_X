import 'package:dollar_x_app/presentation/providers/rates_provider.dart';
import 'package:dollar_x_app/presentation/providers/ui_state_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tasa de la moneda seleccionada para la fecha seleccionada.
/// Combina [displayRatesProvider] y [selectedCurrencyProvider].
final currentRateForCurrencyProvider = Provider<double?>((ref) {
  final displayRates = ref.watch(displayRatesProvider).valueOrNull;
  final currency = ref.watch(selectedCurrencyProvider);
  if (displayRates == null) return null;
  return displayRates[currency];
});
