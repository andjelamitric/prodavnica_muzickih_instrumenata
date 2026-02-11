import 'package:flutter/material.dart';
import 'package:prodavnica_muzickih_instrumenata/models/instrument.dart';
import 'package:prodavnica_muzickih_instrumenata/models/cart.dart';
import 'package:prodavnica_muzickih_instrumenata/models/user.dart';
import 'package:prodavnica_muzickih_instrumenata/screens/login_screen.dart';
import 'package:prodavnica_muzickih_instrumenata/widgets/instrument_image.dart';
import 'package:prodavnica_muzickih_instrumenata/screens/edit_instrument_screen.dart';
import 'package:prodavnica_muzickih_instrumenata/utils/exchange_rate_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InstrumentDetailScreen extends StatelessWidget {
  final Instrument instrument;

  const InstrumentDetailScreen({
    super.key,
    required this.instrument,
  });

  @override
  Widget build(BuildContext context) {
    // Koristi StreamBuilder da automatski osvežava podatke iz Firestore-a
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('instruments')
          .doc(instrument.id)
          .snapshots(),
      builder: (context, snapshot) {
        // Ako ima podatke iz Firestore-a, koristi ih, inače koristi originalni instrument
        Instrument currentInstrument = instrument;
        if (snapshot.hasData && snapshot.data!.exists) {
          try {
            currentInstrument = Instrument.fromMap(
              snapshot.data!.data() as Map<String, dynamic>,
              snapshot.data!.id,
            );
          } catch (e) {
            // Ako ima grešku pri parsiranju, koristi originalni instrument
            currentInstrument = instrument;
          }
        }
        
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: Text(
              currentInstrument.naziv,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
        elevation: 0,
        backgroundColor: const Color(0xFFD4A574),
        foregroundColor: Colors.white,
        actions: [
          // Admin akcije
          if (User.currentUser?.role == UserRole.admin) ...[
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(context, currentInstrument),
              tooltip: "Obriši instrument",
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditInstrumentScreen(instrument: currentInstrument),
                  ),
                );
              },
              tooltip: "Izmeni instrument",
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slika instrumenta
            InstrumentImage(
              instrument: currentInstrument,
              width: double.infinity,
              height: 300,
            ),
            
            // Informacije
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Naziv
                  Text(
                    currentInstrument.naziv,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Cena u eur
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4A574).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFD4A574).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.euro,
                          color: Color(0xFFD4A574),
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          currentInstrument.cena.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD4A574),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Približna cena u RSD spoljni API
                  FutureBuilder<double?>(
                    future: ExchangeRateService.getEurToRsd(),
                    builder: (context, rateSnapshot) {
                      if (rateSnapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: LinearProgressIndicator(
                            minHeight: 3,
                          ),
                        );
                      }

                      if (!rateSnapshot.hasData || rateSnapshot.data == null) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "Nije moguće učitati kurs EUR/RSD (spoljni API).",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      }

                      final rate = rateSnapshot.data!;
                      final cenaRsd = currentInstrument.cena * rate;

                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "Približna cena: ${cenaRsd.toStringAsFixed(0)} RSD (kurs EUR/RSD sa spoljnog API-ja)",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Proizvodjac
                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Proizvođač: ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        currentInstrument.proizvodjac,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Kategorija
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: currentInstrument.categoryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          currentInstrument.icon,
                          color: currentInstrument.categoryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          currentInstrument.kategorija.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: currentInstrument.categoryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Opis
                  const Text(
                    "Opis proizvoda:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      currentInstrument.opis,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                    // Dugme za dodavanje u korpu
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Provera da li je kor prijavljen
                          if (User.currentUser == null || User.currentUser?.role == UserRole.guest) {
                            // Ako nije prijavljen prikazi dijalog
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Prijava potrebna"),
                                content: const Text(
                                  "Morate biti prijavljeni da biste mogli da poručujete proizvode. "
                                  "Molimo prijavite se ili registrujte.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Otkaži"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const LoginScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFD4A574),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text("Prijavi se"),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }

                          // prijavljen dodaj u korpu
                          Cart.addItem(currentInstrument);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  const Icon(Icons.check_circle, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "${currentInstrument.naziv} je dodat u korpu",
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
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart, size: 24),
                        label: const Text(
                          "Dodaj u korpu",
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
      ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Instrument instrumentToDelete) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Obriši instrument"),
        content: Text(
          "Da li ste sigurni da želite da obrišete '${instrumentToDelete.naziv}'?\n\nOva akcija se ne može poništiti.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Otkaži"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                // Obriši instrument iz Firestore-a
                await instrumentToDelete.deleteFromFirestore();
                
                if (context.mounted) {
                  Navigator.pop(context); // Zatvori dijalog
                  Navigator.pop(context); // Vrati se nazad
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "${instrumentToDelete.naziv} je obrisan",
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
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context); // Zatvori dijalog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Greška pri brisanju: ${e.toString()}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Obriši"),
          ),
        ],
      ),
    );
  }
}
