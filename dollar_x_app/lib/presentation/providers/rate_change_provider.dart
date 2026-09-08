import 'package:dollar_x_app/domain/entities/currency_type.dart';
import 'package:dollar_x_app/domain/entities/rate_change.dart';
import 'package:dollar_x_app/presentation/providers/repository_providers.dart';
import 'package:dollar_x_app/presentation/providers/ui_state_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// -----------------------------------------------------------------------------
// Proveedor de cambio de tasas entre fechas
// -----------------------------------------------------------------------------

/// Calcula la diferencia (absoluta y porcentual) entre la tasa "vigente" de la
/// fecha seleccionada y la del d¡a anterior. Si ambas son la misma (por
/// ejemplo, un fin de semana que hereda el viernes), el cambio es 0.
final rateChangeProvider = FutureProvider<Map<CurrencyType, RateChange>>((ref) async {
  final selectedDate = ref.watch(selectedDateProvider);
  final repository = ref.watch(exchangeRateRepositoryProvider);

  // Tasa vigente de la fecha seleccionada (el sab/dom hereda el viernes)
  final currentRates = await repository.getRatesAsOf(selectedDate);
  if (currentRates == null) return {};

  // Tasa vigente del d¡a anterior en calendario
  final previousDate = selectedDate.subtract(const Duration(days: 1));
  final previousRates = await repository.getRatesAsOf(previousDate);
  if (previousRates == null) return {};

  return CurrencyType.values.fold<Map<CurrencyType, RateChange>>({}, (map, currency) {
    final current = currentRates[currency] ?? 0.0;
    final previous = previousRates[currency] ?? 0.0;
    final diff = current - previous;
    final percentage = previous > 0 ? (diff / previous) * 100 : 0.0;
    map[currency] = RateChange(diff: diff, percentage: percentage);
    return map;
  });
});
