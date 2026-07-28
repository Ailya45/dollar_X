import 'package:dollar_x_app/domain/entities/currency_type.dart';
import '../../domain/repositories/exchange_rate_repository.dart';
import '../datasources/exchange_rate_local_datasource.dart';
import '../datasources/exchange_rate_remote_datasource.dart';

class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  final ExchangeRateRemoteDataSource remoteDataSource;
  final ExchangeRateLocalDataSource localDataSource;

  ExchangeRateRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Map<CurrencyType, double>> fetchAllRates() async {
    final results = await Future.wait([
      remoteDataSource.getDollarRate(),
      remoteDataSource.getEuroRate(),
      remoteDataSource.getUsdtRate(),
    ]);
    final usd = results[0] ?? 0.0;
    final eur = results[1] ?? 0.0;
    var usdt = results[2] ?? 0.0;
    if (usdt <= 0) usdt = usd; // fallback a USD si USDT no est  disponible
    return {
      CurrencyType.usd: usd,
      CurrencyType.eur: eur,
      CurrencyType.usdt: usdt,
    };
  }

  @override
  Future<void> saveRates(Map<CurrencyType, double> rates, DateTime date) =>
      localDataSource.saveRates(rates, date);

  @override
  Future<Map<CurrencyType, double>?> getRatesForDate(DateTime date) =>
      localDataSource.getRatesForDate(date);

  @override
  Future<DateTime?> getPreviousDateWithRates(DateTime date) =>
      localDataSource.getPreviousDateWithRates(date);

  @override
  Future<DateTime?> getNextDateWithRates(DateTime date) =>
      localDataSource.getNextDateWithRates(date);
}
