import 'package:flutter/material.dart';
import 'package:prodavnica_muzickih_instrumenata/models/cart.dart';
import 'package:prodavnica_muzickih_instrumenata/models/order.dart';
import 'package:prodavnica_muzickih_instrumenata/models/user.dart';
import 'package:prodavnica_muzickih_instrumenata/screens/instrument_detail_screen.dart';
import 'package:prodavnica_muzickih_instrumenata/screens/login_screen.dart';
import 'package:prodavnica_muzickih_instrumenata/widgets/instrument_image.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    // Provera da li je korisnik prijavljen
    final currentUser = User.currentUser;
    final isGuest = currentUser == null || currentUser.role == UserRole.guest;

    // Ako je gost, prikaži poruku za prijavu
    if (isGuest) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            "Korpa",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: const Color(0xFFD4A574),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 24),
                const Text(
                  "Prijava potrebna",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Morate biti prijavljeni da biste mogli da koristite korpu i poručujete proizvode.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.login, size: 24),
                    label: const Text(
                      "Prijavi se",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: const Color(0xFFD4A574),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Ako je korisnik prijavljen, prikaži normalnu korpu
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Korpa",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFFD4A574),
        foregroundColor: Colors.white,
        actions: [
          if (!Cart.isEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                _showClearCartDialog();
              },
              tooltip: "Isprazni korpu",
            ),
        ],
      ),
      body: Cart.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Korpa je prazna",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: Cart.items.length,
                    itemBuilder: (context, index) {
                      final item = Cart.items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InstrumentDetailScreen(
                                  instrument: item.instrument,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Slika/Ikona instrumenta
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: InstrumentImage(
                                    instrument: item.instrument,
                                    width: 70,
                                    height: 70,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Informacije
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.instrument.naziv,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "${item.instrument.cena.toStringAsFixed(2)} €",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove_circle_outline),
                                            color: const Color(0xFFD4A574),
                                            onPressed: () {
                                              setState(() {
                                                if (item.kolicina > 1) {
                                                  Cart.updateQuantity(
                                                    item.instrument.id,
                                                    item.kolicina - 1,
                                                  );
                                                } else {
                                                  Cart.removeItem(item.instrument.id);
                                                }
                                              });
                                            },
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFD4A574).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "${item.kolicina}",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add_circle_outline),
                                            color: const Color(0xFFD4A574),
                                            onPressed: () {
                                              setState(() {
                                                Cart.updateQuantity(
                                                  item.instrument.id,
                                                  item.kolicina + 1,
                                                );
                                              });
                                            },
                                          ),
                                          const Spacer(),
                                          Flexible(
                                            child: Text(
                                              "${item.ukupnaCena.toStringAsFixed(2)} €",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFD4A574),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Dugme za brisanje
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      Cart.removeItem(item.instrument.id);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Ukupna cena i dugme za kupovinu
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Ukupno:",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4A574).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${Cart.ukupnaCena.toStringAsFixed(2)} €",
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFD4A574),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showPurchaseDialog();
                          },
                          icon: const Icon(Icons.shopping_bag, size: 24),
                          label: const Text(
                            "Kupi",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            backgroundColor: const Color(0xFFD4A574),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Isprazni korpu"),
        content: const Text("Da li ste sigurni da želite da ispraznite korpu?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Otkaži"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                Cart.clear();
              });
              Navigator.pop(context);
            },
            child: const Text("Isprazni", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog() {
    final currentUser = User.currentUser;
    if (currentUser == null || currentUser.role == UserRole.guest) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Morate biti prijavljeni da biste poručivali."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.shopping_bag,
              color: const Color(0xFFD4A574),
            ),
            const SizedBox(width: 8),
            const Text("Potvrda kupovine"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ukupna cena: ${Cart.ukupnaCena.toStringAsFixed(2)} €",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text("Broj stavki: ${Cart.ukupanBrojStavki}"),
            const SizedBox(height: 16),
            const Text(
              "Da li želite da potvrdite kupovinu?",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Otkaži"),
          ),
          ElevatedButton(
            onPressed: () async {
              // Kreiranje porudžbine
              final order = Order.createFromCart(
                currentUser.id,
                Cart.items,
              );

              // Sačuvaj u Firestore
              try {
                await order.saveToFirestore();
                
                // Čišćenje korpe
                setState(() {
                  Cart.clear();
                });

                if (context.mounted) {
                  Navigator.pop(context);
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Greška pri kreiranju porudžbine: ${e.toString()}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
              }

              // uspesna porudzbina
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Porudžbina #${order.id.substring(order.id.length - 6)} je uspešno kreirana!",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4A574),
              foregroundColor: Colors.white,
            ),
            child: const Text("Potvrdi"),
          ),
        ],
      ),
    );
  }
}