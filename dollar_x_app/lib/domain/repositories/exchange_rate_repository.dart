import '../entities/currency_type.dart';

/// Repositorio de tasas de cambio con soporte remoto y local.
abstract class ExchangeRateRepository {
  /// Obtiene las tres tasas desde la fuente remota y las devuelve en un mapa.
  Future<Map<CurrencyType, double>> fetchAllRates();

  /// Guarda las tasas en la base de datos local bajo su d¡a h bil.
  Future<void> saveRates(Map<CurrencyType, double> rates, DateTime date);

  /// Obtiene la tasa "vigente" para una fecha: la ltima publicada en un
  /// d¡a h bil <= [date]. Para fines de semana devuelve el viernes.
  Future<Map<CurrencyType, double>?> getRatesAsOf(DateTime date);

  /// Devuelve la fecha h bil anterior que tenga registros, o null.
  Future<DateTime?> getPreviousDateWithRates(DateTime date);

  /// Devuelve la fecha h bil posterior que tenga registros, o null.
  Future<DateTime?> getNextDateWithRates(DateTime date);
}
