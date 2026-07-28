import 'dart:io';
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

  /// Obtiene el registro de tasas para una fecha, o null si no existe.
  Future<ExchangeRate?> getRatesByDate(DateTime date) {
    final formatted = _formatDate(date);
    return (select(exchangeRates)
          ..where((t) => t.date.equals(formatted)))
        .getSingleOrNull();
  }

  /// Inserta o actualiza (upsert) las tasas para una fecha.
  Future<void> upsertRates(ExchangeRatesCompanion rates) {
    return into(exchangeRates).insertOnConflictUpdate(rates);
  }

  /// Obtiene la fecha anterior m s cercana que tenga registros.
  Future<DateTime?> getPreviousDateWithRates(DateTime date) async {
    final formatted = _formatDate(date);
    final row = await (select(exchangeRates)
          ..where((t) => t.date.isSmallerThanValue(formatted))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
    if (row == null) return null;
    return DateTime.tryParse(row.date);
  }

  /// Obtiene la fecha posterior m s cercana que tenga registros.
  Future<DateTime?> getNextDateWithRates(DateTime date) async {
    final formatted = _formatDate(date);
    final row = await (select(exchangeRates)
          ..where((t) => t.date.isBiggerThanValue(formatted))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.asc)])
          ..limit(1))
        .getSingleOrNull();
    if (row == null) return null;
    return DateTime.tryParse(row.date);
  }

  /// Obtiene todas las fechas con registros, ordenadas descendente.
  Future<List<DateTime>> getAllDates() async {
    final rows = await (select(exchangeRates)
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
        ).get();
    return rows
        .map((r) => DateTime.tryParse(r.date))
        .whereType<DateTime>()
        .toList();
  }

  /// Formatea una fecha como YYYY-MM-DD.
  String _formatDate(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
