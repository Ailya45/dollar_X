import '../entities/currency_type.dart';
import '../repositories/exchange_rate_repository.dart';

/// Caso de uso para obtener las tasas actuales desde la fuente remota.
class GetRatesUseCase {
  final ExchangeRateRepository repository;

  GetRatesUseCase(this.repository);

  /// Ejecuta la obtenci¢n de las tres tasas en paralelo y las guarda localmente.
  Future<Map<CurrencyType, double>> execute() async {
    final rates = await repository.fetchAllRates();
    await repository.saveRates(rates, DateTime.now());
    return rates;
  }
}
