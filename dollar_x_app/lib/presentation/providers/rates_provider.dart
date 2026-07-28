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

/// Carga las tasas guardadas en la base de datos local para una fecha concreta.
final historicalRatesProvider = FutureProvider.family<Map<CurrencyType, double>?, DateTime>(
  (ref, date) async {
    final repository = ref.watch(exchangeRateRepositoryProvider);
    return repository.getRatesForDate(date);
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

/// Indica si existe un registro para la fecha anterior a la seleccionada.
final hasPreviousDateProvider = FutureProvider<bool>((ref) async {
  final selectedDate = ref.watch(selectedDateProvider);
  final repository = ref.watch(exchangeRateRepositoryProvider);
  final prev = await repository.getPreviousDateWithRates(selectedDate);
  return prev != null;
});

/// Indica si existe un registro para la fecha posterior a la seleccionada.
final hasNextDateProvider = FutureProvider<bool>((ref) async {
  final selectedDate = ref.watch(selectedDateProvider);
  final repository = ref.watch(exchangeRateRepositoryProvider);
  final next = await repository.getNextDateWithRates(selectedDate);
  return next != null;
});

/// Indica si la fecha seleccionada es hoy.
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

