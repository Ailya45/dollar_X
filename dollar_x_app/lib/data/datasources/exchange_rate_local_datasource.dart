import 'package:dollar_x_app/core/utils/business_day.dart';
import 'package:dollar_x_app/data/database/app_database.dart';
import 'package:dollar_x_app/domain/entities/currency_type.dart';
import 'package:drift/drift.dart';

/// Fuente de datos local que persiste las tasas en SQLite mediante Drift.
class ExchangeRateLocalDataSource {
  final AppDatabase db;

  ExchangeRateLocalDataSource(this.db);

  /// Obtiene la tasa "vigente" para una fecha: la ltima publicada en un
  /// d¡a h bil <= [date]. Para fines de semana devuelve el viernes.
  Future<Map<CurrencyType, double>?> getRatesAsOf(DateTime date) async {
    final record = await db.getLatestRateOnOrBefore(date);
    if (record == null) return null;
    return {
      CurrencyType.usd: record.usdRate,
      CurrencyType.eur: record.eurRate,
      CurrencyType.usdt: record.usdtRate,
    };
  }

  /// Guarda las tasas bajo el d¡a h bil correspondiente a [date]
  /// (el s bado/domingo se guarda bajo el viernes). Usa upsert.
  Future<void> saveRates(Map<CurrencyType, double> rates, DateTime date) async {
    final effective = getEffectiveRateDate(date);
    final formatted = formatSqlDate(effective);
    final now = DateTime.now().toIso8601String();
    await db.upsertRates(ExchangeRatesCompanion(
      date: Value(formatted),
      usdRate: Value(rates[CurrencyType.usd] ?? 0.0),
      eurRate: Value(rates[CurrencyType.eur] ?? 0.0),
      usdtRate: Value(rates[CurrencyType.usdt] ?? 0.0),
      createdAt: Value(now),
    ));
  }

  /// Fecha h bil anterior con registros.
  Future<DateTime?> getPreviousDateWithRates(DateTime date) =>
      db.getPreviousDateWithRates(date);

  /// Fecha h bil posterior con registros.
  Future<DateTime?> getNextDateWithRates(DateTime date) =>
      db.getNextDateWithRates(date);

  /// Todas las fechas con registros.
  Future<List<DateTime>> getAllDates() => db.getAllDates();
}
