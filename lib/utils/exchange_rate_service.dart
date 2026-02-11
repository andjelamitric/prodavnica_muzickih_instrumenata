import 'dart:convert';

import 'package:http/http.dart' as http;

/// Servis za preuzimanje kursa EUR → RSD sa spoljašnjeg API-ja.
///
/// Koristimo javni API `exchangerate-api.com` koji ne zahteva API ključ.
class ExchangeRateService {
  // Alternativni endpointi ako prvi ne radi
  static const String _endpoint1 =
      'https://api.exchangerate-api.com/v4/latest/EUR';
  static const String _endpoint2 =
      'https://api.exchangerate.host/latest?base=EUR&symbols=RSD';
  static const String _endpoint3 =
      'https://open.er-api.com/v6/latest/EUR';

  /// Vraća trenutni kurs EUR → RSD ili null ako dođe do greške.
  static Future<double?> getEurToRsd() async {
    // Pokušaj sa prvim endpointom
    double? rate = await _tryGetRate(_endpoint1, (data) {
      final rates = data['rates'] as Map<String, dynamic>?;
      return rates?['RSD'];
    });

    if (rate != null) return rate;

    // Pokušaj sa drugim endpointom
    rate = await _tryGetRate(_endpoint2, (data) {
      final rates = data['rates'] as Map<String, dynamic>?;
      return rates?['RSD'];
    });

    if (rate != null) return rate;

    // Pokušaj sa trećim endpointom
    rate = await _tryGetRate(_endpoint3, (data) {
      final rates = data['rates'] as Map<String, dynamic>?;
      return rates?['RSD'];
    });

    return rate;
  }

  /// Pokušava da dobije kurs sa određenog endpointa.
  static Future<double?> _tryGetRate(
    String endpoint,
    dynamic Function(Map<String, dynamic>) extractRate,
  ) async {
    try {
      final response = await http
          .get(Uri.parse(endpoint))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        print('Greška pri pozivu API-ja za kurs ($endpoint): ${response.statusCode}');
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final rsd = extractRate(data);

      if (rsd is num) {
        print('✅ Kurs EUR/RSD uspešno učitán: ${rsd.toDouble()}');
        return rsd.toDouble();
      }

      print('Nevalidan format odgovora API-ja za kurs ($endpoint).');
      return null;
    } catch (e) {
      print('Izuzetak pri pozivu API-ja za kurs ($endpoint): $e');
      return null;
    }
  }
}

