import '../entities/currency_type.dart';

/// Repositorio de tasas de cambio con soporte remoto y local.
abstract class ExchangeRateRepository {
  /// Obtiene las tres tasas desde la fuente remota y las devuelve en un mapa.
  Future<Map<CurrencyType, double>> fetchAllRates();

  /// Guarda las tasas en la base de datos local para la fecha indicada.
  Future<void> saveRates(Map<CurrencyType, double> rates, DateTime date);

  /// Obtiene las tasas guardadas para una fecha concreta.
  Future<Map<CurrencyType, double>?> getRatesForDate(DateTime date);

  /// Devuelve la fecha anterior m s cercana que tenga registros, o null.
  Future<DateTime?> getPreviousDateWithRates(DateTime date);

  /// Devuelve la fecha posterior m s cercana que tenga registros, o null.
  Future<DateTime?> getNextDateWithRates(DateTime date);
}
