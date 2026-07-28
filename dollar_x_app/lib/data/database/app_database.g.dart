// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ExchangeRatesTable extends ExchangeRates
    with TableInfo<$ExchangeRatesTable, ExchangeRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExchangeRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _usdRateMeta = const VerificationMeta(
    'usdRate',
  );
  @override
  late final GeneratedColumn<double> usdRate = GeneratedColumn<double>(
    'usd_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eurRateMeta = const VerificationMeta(
    'eurRate',
  );
  @override
  late final GeneratedColumn<double> eurRate = GeneratedColumn<double>(
    'eur_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usdtRateMeta = const VerificationMeta(
    'usdtRate',
  );
  @override
  late final GeneratedColumn<double> usdtRate = GeneratedColumn<double>(
    'usdt_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    usdRate,
    eurRate,
    usdtRate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exchange_rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExchangeRate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('usd_rate')) {
      context.handle(
        _usdRateMeta,
        usdRate.isAcceptableOrUnknown(data['usd_rate']!, _usdRateMeta),
      );
    } else if (isInserting) {
      context.missing(_usdRateMeta);
    }
    if (data.containsKey('eur_rate')) {
      context.handle(
        _eurRateMeta,
        eurRate.isAcceptableOrUnknown(data['eur_rate']!, _eurRateMeta),
      );
    } else if (isInserting) {
      context.missing(_eurRateMeta);
    }
    if (data.containsKey('usdt_rate')) {
      context.handle(
        _usdtRateMeta,
        usdtRate.isAcceptableOrUnknown(data['usdt_rate']!, _usdtRateMeta),
      );
    } else if (isInserting) {
      context.missing(_usdtRateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExchangeRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExchangeRate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      usdRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}usd_rate'],
      )!,
      eurRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}eur_rate'],
      )!,
      usdtRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}usdt_rate'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ExchangeRatesTable createAlias(String alias) {
    return $ExchangeRatesTable(attachedDatabase, alias);
  }
}

class ExchangeRate extends DataClass implements Insertable<ExchangeRate> {
  final int id;
  final String date;
  final double usdRate;
  final double eurRate;
  final double usdtRate;
  final String createdAt;
  const ExchangeRate({
    required this.id,
    required this.date,
    required this.usdRate,
    required this.eurRate,
    required this.usdtRate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['usd_rate'] = Variable<double>(usdRate);
    map['eur_rate'] = Variable<double>(eurRate);
    map['usdt_rate'] = Variable<double>(usdtRate);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  ExchangeRatesCompanion toCompanion(bool nullToAbsent) {
    return ExchangeRatesCompanion(
      id: Value(id),
      date: Value(date),
      usdRate: Value(usdRate),
      eurRate: Value(eurRate),
      usdtRate: Value(usdtRate),
      createdAt: Value(createdAt),
    );
  }

  factory ExchangeRate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExchangeRate(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      usdRate: serializer.fromJson<double>(json['usdRate']),
      eurRate: serializer.fromJson<double>(json['eurRate']),
      usdtRate: serializer.fromJson<double>(json['usdtRate']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'usdRate': serializer.toJson<double>(usdRate),
      'eurRate': serializer.toJson<double>(eurRate),
      'usdtRate': serializer.toJson<double>(usdtRate),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  ExchangeRate copyWith({
    int? id,
    String? date,
    double? usdRate,
    double? eurRate,
    double? usdtRate,
    String? createdAt,
  }) => ExchangeRate(
    id: id ?? this.id,
    date: date ?? this.date,
    usdRate: usdRate ?? this.usdRate,
    eurRate: eurRate ?? this.eurRate,
    usdtRate: usdtRate ?? this.usdtRate,
    createdAt: createdAt ?? this.createdAt,
  );
  ExchangeRate copyWithCompanion(ExchangeRatesCompanion data) {
    return ExchangeRate(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      usdRate: data.usdRate.present ? data.usdRate.value : this.usdRate,
      eurRate: data.eurRate.present ? data.eurRate.value : this.eurRate,
      usdtRate: data.usdtRate.present ? data.usdtRate.value : this.usdtRate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRate(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('usdRate: $usdRate, ')
          ..write('eurRate: $eurRate, ')
          ..write('usdtRate: $usdtRate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, usdRate, eurRate, usdtRate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExchangeRate &&
          other.id == this.id &&
          other.date == this.date &&
          other.usdRate == this.usdRate &&
          other.eurRate == this.eurRate &&
          other.usdtRate == this.usdtRate &&
          other.createdAt == this.createdAt);
}

class ExchangeRatesCompanion extends UpdateCompanion<ExchangeRate> {
  final Value<int> id;
  final Value<String> date;
  final Value<double> usdRate;
  final Value<double> eurRate;
  final Value<double> usdtRate;
  final Value<String> createdAt;
  const ExchangeRatesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.usdRate = const Value.absent(),
    this.eurRate = const Value.absent(),
    this.usdtRate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExchangeRatesCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required double usdRate,
    required double eurRate,
    required double usdtRate,
    required String createdAt,
  }) : date = Value(date),
       usdRate = Value(usdRate),
       eurRate = Value(eurRate),
       usdtRate = Value(usdtRate),
       createdAt = Value(createdAt);
  static Insertable<ExchangeRate> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<double>? usdRate,
    Expression<double>? eurRate,
    Expression<double>? usdtRate,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (usdRate != null) 'usd_rate': usdRate,
      if (eurRate != null) 'eur_rate': eurRate,
      if (usdtRate != null) 'usdt_rate': usdtRate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExchangeRatesCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<double>? usdRate,
    Value<double>? eurRate,
    Value<double>? usdtRate,
    Value<String>? createdAt,
  }) {
    return ExchangeRatesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      usdRate: usdRate ?? this.usdRate,
      eurRate: eurRate ?? this.eurRate,
      usdtRate: usdtRate ?? this.usdtRate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (usdRate.present) {
      map['usd_rate'] = Variable<double>(usdRate.value);
    }
    if (eurRate.present) {
      map['eur_rate'] = Variable<double>(eurRate.value);
    }
    if (usdtRate.present) {
      map['usdt_rate'] = Variable<double>(usdtRate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRatesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('usdRate: $usdRate, ')
          ..write('eurRate: $eurRate, ')
          ..write('usdtRate: $usdtRate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExchangeRatesTable exchangeRates = $ExchangeRatesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [exchangeRates];
}

typedef $$ExchangeRatesTableCreateCompanionBuilder =
    ExchangeRatesCompanion Function({
      Value<int> id,
      required String date,
      required double usdRate,
      required double eurRate,
      required double usdtRate,
      required String createdAt,
    });
typedef $$ExchangeRatesTableUpdateCompanionBuilder =
    ExchangeRatesCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<double> usdRate,
      Value<double> eurRate,
      Value<double> usdtRate,
      Value<String> createdAt,
    });

class $$ExchangeRatesTableFilterComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get usdRate => $composableBuilder(
    column: $table.usdRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get eurRate => $composableBuilder(
    column: $table.eurRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get usdtRate => $composableBuilder(
    column: $table.usdtRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExchangeRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get usdRate => $composableBuilder(
    column: $table.usdRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get eurRate => $composableBuilder(
    column: $table.eurRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get usdtRate => $composableBuilder(
    column: $table.usdtRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExchangeRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get usdRate =>
      $composableBuilder(column: $table.usdRate, builder: (column) => column);

  GeneratedColumn<double> get eurRate =>
      $composableBuilder(column: $table.eurRate, builder: (column) => column);

  GeneratedColumn<double> get usdtRate =>
      $composableBuilder(column: $table.usdtRate, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ExchangeRatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExchangeRatesTable,
          ExchangeRate,
          $$ExchangeRatesTableFilterComposer,
          $$ExchangeRatesTableOrderingComposer,
          $$ExchangeRatesTableAnnotationComposer,
          $$ExchangeRatesTableCreateCompanionBuilder,
          $$ExchangeRatesTableUpdateCompanionBuilder,
          (
            ExchangeRate,
            BaseReferences<_$AppDatabase, $ExchangeRatesTable, ExchangeRate>,
          ),
          ExchangeRate,
          PrefetchHooks Function()
        > {
  $$ExchangeRatesTableTableManager(_$AppDatabase db, $ExchangeRatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExchangeRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExchangeRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExchangeRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<double> usdRate = const Value.absent(),
                Value<double> eurRate = const Value.absent(),
                Value<double> usdtRate = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => ExchangeRatesCompanion(
                id: id,
                date: date,
                usdRate: usdRate,
                eurRate: eurRate,
                usdtRate: usdtRate,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                required double usdRate,
                required double eurRate,
                required double usdtRate,
                required String createdAt,
              }) => ExchangeRatesCompanion.insert(
                id: id,
                date: date,
                usdRate: usdRate,
                eurRate: eurRate,
                usdtRate: usdtRate,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExchangeRatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExchangeRatesTable,
      ExchangeRate,
      $$ExchangeRatesTableFilterComposer,
      $$ExchangeRatesTableOrderingComposer,
      $$ExchangeRatesTableAnnotationComposer,
      $$ExchangeRatesTableCreateCompanionBuilder,
      $$ExchangeRatesTableUpdateCompanionBuilder,
      (
        ExchangeRate,
        BaseReferences<_$AppDatabase, $ExchangeRatesTable, ExchangeRate>,
      ),
      ExchangeRate,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExchangeRatesTableTableManager get exchangeRates =>
      $$ExchangeRatesTableTableManager(_db, _db.exchangeRates);
}
