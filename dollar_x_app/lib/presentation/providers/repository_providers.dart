import 'package:dollar_x_app/data/database/app_database.dart';
import 'package:dollar_x_app/data/datasources/exchange_rate_local_datasource.dart';
import 'package:dollar_x_app/data/datasources/exchange_rate_remote_datasource.dart';
import 'package:dollar_x_app/data/repositories/exchange_rate_repository_impl.dart';
import 'package:dollar_x_app/domain/repositories/exchange_rate_repository.dart';
import 'package:dollar_x_app/domain/usecases/get_rates_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// -----------------------------------------------------------------------------
// Proveedores de infraestructura (DI)
// -----------------------------------------------------------------------------

/// Proveedor singleton de la base de datos Drift.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('AppDatabase debe ser inicializado antes de usarse');
});

/// Fuente de datos remota (scraping BCV + Binance).
final remoteDataSourceProvider = Provider<ExchangeRateRemoteDataSource>((ref) {
  return ExchangeRateRemoteDataSource();
});

/// Fuente de datos local (SQLite).
final localDataSourceProvider = Provider<ExchangeRateLocalDataSource>((ref) {
  return ExchangeRateLocalDataSource(ref.watch(appDatabaseProvider));
});

/// Repositorio que combina fuente remota y local.
final exchangeRateRepositoryProvider = Provider<ExchangeRateRepository>((ref) {
  return ExchangeRateRepositoryImpl(
    remoteDataSource: ref.watch(remoteDataSourceProvider),
    localDataSource: ref.watch(localDataSourceProvider),
  );
});

/// Caso de uso para obtener tasas actuales.
final getRatesUseCaseProvider = Provider<GetRatesUseCase>((ref) {
  return GetRatesUseCase(ref.watch(exchangeRateRepositoryProvider));
});
