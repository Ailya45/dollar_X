import 'package:dollar_x_app/domain/entities/currency_type.dart';
import 'package:dollar_x_app/domain/entities/rate_change.dart';
import 'package:dollar_x_app/presentation/providers/repository_providers.dart';
import 'package:dollar_x_app/presentation/providers/ui_state_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// -----------------------------------------------------------------------------
// Proveedor de cambio de tasas entre fechas
// -----------------------------------------------------------------------------

/// Calcula la diferencia (absoluta y porcentual) entre la tasa de la fecha
/// seleccionada y la tasa de la fecha anterior disponible.
final rateChangeProvider = FutureProvider<Map<CurrencyType, RateChange>>((ref) async {
  final selectedDate = ref.watch(selectedDateProvider);
  final repository = ref.watch(exchangeRateRepositoryProvider);

  // Obtiene las tasas de la fecha seleccionada
  final currentRates = await repository.getRatesForDate(selectedDate);
  if (currentRates == null) return {};

  // Busca la fecha anterior con registros
  final previousDate = await repository.getPreviousDateWithRates(selectedDate);
  if (previousDate == null) return {};

  final previousRates = await repository.getRatesForDate(previousDate);
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
