import 'package:dollar_x_app/core/utils/business_day.dart';
import 'package:dollar_x_app/domain/entities/currency_type.dart';
import 'package:dollar_x_app/presentation/providers/repository_providers.dart';
import 'package:dollar_x_app/presentation/providers/ui_state_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// -----------------------------------------------------------------------------
// Proveedores de tasas de cambio
// -----------------------------------------------------------------------------

/// Obtiene las tasas actuales desde la fuente remota y las guarda localmente.
/// Se invalida con [ref.invalidate] para forzar una recarga.
final currentRatesProvider = FutureProvider<Map<CurrencyType, double>>((ref) async {
  final useCase = ref.watch(getRatesUseCaseProvider);
  return useCase.execute();
});

/// Carga la tasa "vigente" (ltima publicada => a la fecha) desde la base
/// de datos local. Devuelve null si no hay ninguno registro.
final historicalRatesProvider =
    FutureProvider.family<Map<CurrencyType, double>?, DateTime>(
  (ref, date) async {
    final repository = ref.watch(exchangeRateRepositoryProvider);
    return repository.getRatesAsOf(date);
  },
);

/// Tasas de la fecha seleccionada: hoy usa [currentRatesProvider], otras fechas
/// usan [historicalRatesProvider]. Devuelve null si no hay datos.
final displayRatesProvider = FutureProvider<Map<CurrencyType, double>?>((ref) async {
  final selectedDate = ref.watch(selectedDateProvider);
  final today = DateTime.now();

  if (isSameDay(selectedDate, today)) {
    final rates = ref.watch(currentRatesProvider).valueOrNull;
    if (rates != null) return rates;
  }
  return ref.watch(historicalRatesProvider(selectedDate)).valueOrNull;
});

/// Indica si existe un registro en un d¡a h bil anterior a la fecha seleccionada.
/// Se usa para habilitar la flecha de retroceso.
final hasPreviousDateProvider = FutureProvider<bool>((ref) async {
  final selectedDate = ref.watch(selectedDateProvider);
  final repository = ref.watch(exchangeRateRepositoryProvider);
  final prev = await repository.getPreviousDateWithRates(selectedDate);
  return prev != null;
});
