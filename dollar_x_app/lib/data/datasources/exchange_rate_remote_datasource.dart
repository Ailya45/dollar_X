import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:html/parser.dart' as parser;

class ExchangeRateRemoteDataSource {
  Future<double?> _fetchBcvRate(String selector) async {
    try {
      final httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
      final ioClient = IOClient(httpClient);
      final response =
          await ioClient.get(Uri.parse('https://www.bcv.org.ve/'));

      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        final element = document.querySelector(selector);
        if (element != null) {
          String rateString = element.text.trim();
          rateString = rateString.replaceAll(',', '.');
          return double.tryParse(rateString);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<double?> getDollarRate() async {
    return _fetchBcvRate('#dolar strong');
  }

  Future<double?> getEuroRate() async {
    return _fetchBcvRate('#euro strong');
  }

  Future<double?> getUsdtRate() async {
    try {
      final client = HttpClient();
      final request = await client.postUrl(
        Uri.parse(
            'https://p2p.binance.com/bapi/c2c/v2/friendly/c2c/adv/search'),
      );
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('Accept', '*/*');
      request.write(jsonEncode({
        "asset": "USDT",
        "fiat": "VES",
        "tradeType": "SELL",
        "page": 1,
        "rows": 5,
        "payTypes": [],
        "countries": [],
        "publisherType": null,
      }));
      final response = await request.close();

      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final offers = data['data'] as List<dynamic>;
        if (offers.isNotEmpty) {
          final best = offers[0] as Map<String, dynamic>;
          final adv = best['adv'] as Map<String, dynamic>;
          final price = double.tryParse(adv['price'].toString());
          if (price != null) return price;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
