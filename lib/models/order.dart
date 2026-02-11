import 'package:prodavnica_muzickih_instrumenata/models/instrument.dart';
import 'package:prodavnica_muzickih_instrumenata/models/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Status porudžbine
enum OrderStatus {
  pending,    // Na cekanju
  shipped,    // Poslato
  delivered,  // Isporučeno
  cancelled,  // Otkazano
}

// Stavka u porudzbini
class OrderItem {
  final Instrument instrument;
  final int kolicina;
  final double cenaPoKomadu; 

  OrderItem({
    required this.instrument,
    required this.kolicina,
    required this.cenaPoKomadu,
  });

  double get ukupnaCena => cenaPoKomadu * kolicina;

  // Konvertuje OrderItem u Map za Firestore
  Map<String, dynamic> toMap() {
    return {
      'instrumentId': instrument.id,
      'kolicina': kolicina,
      'cenaPoKomadu': cenaPoKomadu,
    };
  }

  // Kreira OrderItem iz Firestore dokumenta (potrebno učitati instrument)
  static Future<OrderItem?> fromMap(Map<String, dynamic> map) async {
    try {
      final instrumentId = map['instrumentId'] as String;
      // Učitaj instrument iz Firestore-a
      final instruments = await Instrument.loadFromFirestore();
      final instrument = instruments.firstWhere(
        (inst) => inst.id == instrumentId,
        orElse: () => throw Exception('Instrument not found'),
      );
      
      return OrderItem(
        instrument: instrument,
        kolicina: map['kolicina'] ?? 0,
        cenaPoKomadu: (map['cenaPoKomadu'] ?? 0.0).toDouble(),
      );
    } catch (e) {
      print('Greška pri kreiranju OrderItem: $e');
      return null;
    }
  }
}

// Porudzbina
class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final DateTime date;
  final OrderStatus status;
  final double totalPrice;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.date,
    this.status = OrderStatus.pending,
    required this.totalPrice,
  });

  // Static lista svih porudžbina
  static List<Order> orders = [];

  // Kreiranje porudzbine iz korpe
  static Order createFromCart(String userId, List<CartItem> cartItems) {
    final orderItems = cartItems.map((cartItem) {
      return OrderItem(
        instrument: cartItem.instrument,
        kolicina: cartItem.kolicina,
        cenaPoKomadu: cartItem.instrument.cena,
      );
    }).toList();

    final totalPrice = orderItems.fold(
      0.0,
      (sum, item) => sum + item.ukupnaCena,
    );

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      items: orderItems,
      date: DateTime.now(),
      status: OrderStatus.pending,
      totalPrice: totalPrice,
    );

    // Ne dodajemo više u statičku listu - sve ide u Firestore
    // orders.add(order); // Uklonjeno - sada se čuva direktno u Firestore-u
    return order;
  }

  // Dobijanje porudžbina određenog korisnika
  static List<Order> getOrdersByUser(String userId) {
    return orders.where((order) => order.userId == userId).toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Najnovije prvo
  }

  // Dobijanje porudzb po idu
  static Order? getOrderById(String orderId) {
    try {
      return orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Azurir statusa porudzbine (za kompatibilnost - koristi updateStatusInFirestore umesto)
  static bool updateOrderStatus(String orderId, OrderStatus newStatus) {
    // Ova metoda se više ne koristi - koristi se updateStatusInFirestore() direktno na Order objektu
    // Zadržana je za kompatibilnost
    final orderIndex = orders.indexWhere((order) => order.id == orderId);
    if (orderIndex >= 0) {
      final order = orders[orderIndex];
      orders[orderIndex] = Order(
        id: order.id,
        userId: order.userId,
        items: order.items,
        date: order.date,
        status: newStatus,
        totalPrice: order.totalPrice,
      );
      return true;
    }
    return false;
  }

  // Broj stavki u porudzb
  int get ukupanBrojStavki {
    return items.fold(0, (sum, item) => sum + item.kolicina);
  }

  // Status porudz
  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return "Na čekanju";
      case OrderStatus.shipped:
        return "Poslato";
      case OrderStatus.delivered:
        return "Isporučeno";
      case OrderStatus.cancelled:
        return "Otkazano";
    }
  }

  // Boja za status
  String get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return "orange";
      case OrderStatus.shipped:
        return "blue";
      case OrderStatus.delivered:
        return "green";
      case OrderStatus.cancelled:
        return "red";
    }
  }

  // Konvertuje OrderStatus enum u String za Firestore
  String get statusString {
    switch (status) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  // Konvertuje String iz Firestore-a u OrderStatus enum
  static OrderStatus statusFromString(String statusString) {
    switch (statusString) {
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  // Konvertuje Order u Map za Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'date': Timestamp.fromDate(date),
      'status': statusString,
      'totalPrice': totalPrice,
    };
  }

  // Kreira Order iz Firestore dokumenta
  static Future<Order?> fromMap(Map<String, dynamic> map, String docId) async {
    try {
      // Učitaj stavke
      final itemsData = map['items'] as List<dynamic>? ?? [];
      final items = <OrderItem>[];
      
      for (final itemData in itemsData) {
        final item = await OrderItem.fromMap(itemData as Map<String, dynamic>);
        if (item != null) {
          items.add(item);
        }
      }

      if (items.isEmpty) {
        return null; // Ako nema validnih stavki, ne kreiraj porudžbinu
      }

      return Order(
        id: docId,
        userId: map['userId'] ?? '',
        items: items,
        date: (map['date'] as Timestamp).toDate(),
        status: statusFromString(map['status'] ?? 'pending'),
        totalPrice: (map['totalPrice'] ?? 0.0).toDouble(),
      );
    } catch (e) {
      print('Greška pri kreiranju Order: $e');
      return null;
    }
  }

  // Dodaje novu porudžbinu u Firestore
  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(id)
        .set(toMap());
  }

  // Ažurira status porudžbine u Firestore-u
  Future<void> updateStatusInFirestore(OrderStatus newStatus) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(id)
        .update({
      'status': Order(
        id: id,
        userId: userId,
        items: items,
        date: date,
        status: newStatus,
        totalPrice: totalPrice,
      ).statusString,
    });
  }

  // Učitava sve porudžbine iz Firestore-a
  static Future<List<Order>> loadFromFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .get();
      
      final orders = <Order>[];
      for (final doc in snapshot.docs) {
        final order = await Order.fromMap(doc.data(), doc.id);
        if (order != null) {
          orders.add(order);
        }
      }
      
      return orders;
    } catch (e) {
      print('Greška pri učitavanju porudžbina: $e');
      return [];
    }
  }

  // Stream porudžbina iz Firestore-a (real-time updates)
  static Stream<List<Order>> streamFromFirestore() {
    return FirebaseFirestore.instance
        .collection('orders')
        .snapshots()
        .asyncMap((snapshot) async {
      final orders = <Order>[];
      for (final doc in snapshot.docs) {
        final order = await Order.fromMap(doc.data(), doc.id);
        if (order != null) {
          orders.add(order);
        }
      }
      return orders;
    });
  }

  // Učitava porudžbine određenog korisnika iz Firestore-a
  static Future<List<Order>> loadOrdersByUserFromFirestore(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();
      
      final orders = <Order>[];
      for (final doc in snapshot.docs) {
        final order = await Order.fromMap(doc.data(), doc.id);
        if (order != null) {
          orders.add(order);
        }
      }
      
      // Sortiraj po datumu (najnovije prvo)
      orders.sort((a, b) => b.date.compareTo(a.date));
      return orders;
    } catch (e) {
      print('Greška pri učitavanju porudžbina korisnika: $e');
      return [];
    }
  }

  // Stream porudžbina određenog korisnika
  static Stream<List<Order>> streamOrdersByUserFromFirestore(String userId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      final orders = <Order>[];
      for (final doc in snapshot.docs) {
        final order = await Order.fromMap(doc.data(), doc.id);
        if (order != null) {
          orders.add(order);
        }
      }
      // Sortiraj po datumu (najnovije prvo)
      orders.sort((a, b) => b.date.compareTo(a.date));
      return orders;
    });
  }
}
