import 'package:prodavnica_muzickih_instrumenata/models/instrument.dart';

class CartItem {
  final Instrument instrument;
  int kolicina;

  CartItem({
    required this.instrument,
    this.kolicina = 1,
  });

  double get ukupnaCena => instrument.cena * kolicina;
}

class Cart {
  static List<CartItem> items = [];

  static void addItem(Instrument instrument) {
    // da li već postoji u korpi
    final existingIndex = items.indexWhere(
      (item) => item.instrument.id == instrument.id,
    );

    if (existingIndex >= 0) {
      // ako postoji, povecaj kolicinu
      items[existingIndex].kolicina++;
    } else {
      // ne postoji, dodaj novi item
      items.add(CartItem(instrument: instrument));
    }
  }

  static void removeItem(String instrumentId) {
    items.removeWhere((item) => item.instrument.id == instrumentId);
  }

  static void updateQuantity(String instrumentId, int novaKolicina) {
    final item = items.firstWhere(
      (item) => item.instrument.id == instrumentId,
      orElse: () => throw Exception("Item not found"),
    );
    
    if (novaKolicina <= 0) {
      removeItem(instrumentId);
    } else {
      item.kolicina = novaKolicina;
    }
  }

  static double get ukupnaCena {
    return items.fold(0.0, (sum, item) => sum + item.ukupnaCena);
  }

  static int get ukupanBrojStavki {
    return items.fold(0, (sum, item) => sum + item.kolicina);
  }

  static void clear() {
    items.clear();
  }

  static bool get isEmpty => items.isEmpty;
}
