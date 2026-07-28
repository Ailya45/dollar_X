import 'package:dollar_x_app/data/database/app_database.dart';
import 'package:dollar_x_app/domain/entities/currency_type.dart';
import 'package:drift/drift.dart';

/// Fuente de datos local que persiste las tasas en SQLite mediante Drift.
class ExchangeRateLocalDataSource {
  final AppDatabase db;

  ExchangeRateLocalDataSource(this.db);

  /// Obtiene las tasas guardadas para una fecha.
  Future<Map<CurrencyType, double>?> getRatesForDate(DateTime date) async {
    final record = await db.getRatesByDate(date);
    if (record == null) return null;
    return {
      CurrencyType.usd: record.usdRate,
      CurrencyType.eur: record.eurRate,
      CurrencyType.usdt: record.usdtRate,
    };
  }

  /// Guarda las tasas para una fecha (upsert).
  Future<void> saveRates(Map<CurrencyType, double> rates, DateTime date) async {
    final formatted = _formatDate(date);
    final now = DateTime.now().toIso8601String();
    await db.upsertRates(ExchangeRatesCompanion(
      date: Value(formatted),
      usdRate: Value(rates[CurrencyType.usd] ?? 0.0),
      eurRate: Value(rates[CurrencyType.eur] ?? 0.0),
      usdtRate: Value(rates[CurrencyType.usdt] ?? 0.0),
      createdAt: Value(now),
    ));
  }

  /// Fecha anterior con registros.
  Future<DateTime?> getPreviousDateWithRates(DateTime date) =>
      db.getPreviousDateWithRates(date);

  /// Fecha posterior con registros.
  Future<DateTime?> getNextDateWithRates(DateTime date) =>
      db.getNextDateWithRates(date);

  /// Todas las fechas con registros.
  Future<List<DateTime>> getAllDates() => db.getAllDates();

  String _formatDate(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
