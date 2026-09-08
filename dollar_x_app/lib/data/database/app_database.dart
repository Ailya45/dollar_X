import 'dart:io';
import 'package:dollar_x_app/core/utils/business_day.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'app_database.g.dart';

// -----------------------------------------------------------------------------
// Definici¢n de la tabla exchange_rates
// -----------------------------------------------------------------------------

/// Almacena las tasas de cambio para una fecha espec¡fica.
class ExchangeRates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text().unique()(); // Formato YYYY-MM-DD
  RealColumn get usdRate => real().named('usd_rate')();
  RealColumn get eurRate => real().named('eur_rate')();
  RealColumn get usdtRate => real().named('usdt_rate')();
  TextColumn get createdAt => text()(); // ISO 8601
}

// -----------------------------------------------------------------------------
// Base de datos Drift
// -----------------------------------------------------------------------------

@DriftDatabase(tables: [ExchangeRates])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  /// Crea la base de datos en el directorio de documentos.
  static Future<AppDatabase> create() async {
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'dollar_x.db'));
    return AppDatabase(NativeDatabase(file));
  }

  // ---------------------------------------------------------------------------
  // Consultas
  // ---------------------------------------------------------------------------

  /// Obtiene la tasa "vigente" para una fecha: la ltima publicada
  /// en un d¡a h bil <= [date]. Como el BCV s¢lo publica de lunes a
  /// viernes, el s bado y domingo devuelven el precio del viernes.
  Future<ExchangeRate?> getLatestRateOnOrBefore(DateTime date) {
    final effective = getEffectiveRateDate(date);
    final formatted = formatSqlDate(effective);
    return (select(exchangeRates)
          ..where((t) => t.date.isSmallerOrEqualValue(formatted))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Inserta o actualiza (upsert) las tasas para una fecha.
  Future<void> upsertRates(ExchangeRatesCompanion rates) {
    return into(exchangeRates).insertOnConflictUpdate(rates);
  }

  /// Obtiene la fecha h bil anterior que tenga registros, o null si no existe.
  Future<DateTime?> getPreviousDateWithRates(DateTime date) async {
    final effective = getEffectiveRateDate(date);
    final formatted = formatSqlDate(effective);
    final row = await (select(exchangeRates)
          ..where((t) => t.date.isSmallerThanValue(formatted))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
    if (row == null) return null;
    return parseSqlDate(row.date);
  }

  /// Obtiene la fecha h bil posterior que tenga registros, o null si no existe.
  Future<DateTime?> getNextDateWithRates(DateTime date) async {
    final effective = getEffectiveRateDate(date);
    final formatted = formatSqlDate(effective);
    final row = await (select(exchangeRates)
          ..where((t) => t.date.isBiggerThanValue(formatted))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc)])
          ..limit(1))
        .getSingleOrNull();
    if (row == null) return null;
    return parseSqlDate(row.date);
  }

  /// Obtiene todas las fechas con registros, ordenadas descendente.
  Future<List<DateTime>> getAllDates() async {
    final rows = await (select(exchangeRates)
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
        ).get();
    return rows
        .map((r) => parseSqlDate(r.date))
        .whereType<DateTime>()
        .toList();
  }
}
