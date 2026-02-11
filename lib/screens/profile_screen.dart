import 'package:flutter/material.dart';
import 'package:prodavnica_muzickih_instrumenata/models/user.dart';
import 'package:prodavnica_muzickih_instrumenata/screens/login_screen.dart';
import 'package:prodavnica_muzickih_instrumenata/screens/register_screen.dart';
import 'package:prodavnica_muzickih_instrumenata/screens/order_history_screen.dart';
import 'package:prodavnica_muzickih_instrumenata/screens/add_instrument_screen.dart';
import 'package:prodavnica_muzickih_instrumenata/screens/admin_orders_screen.dart';
import 'package:prodavnica_muzickih_instrumenata/models/instrument.dart';
import 'package:prodavnica_muzickih_instrumenata/models/order.dart';
import 'package:prodavnica_muzickih_instrumenata/utils/migrate_instruments.dart';

class ProfileScreen extends StatefulWidget { //nema promene stanja samo prik podatke
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Osveži ekran kada se widget kreira
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFFD4A574),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final currentUser = User.currentUser;
    final role = currentUser?.role ?? UserRole.guest;
    
    switch(role){ //na osnovu uloge razlicit ui
      case UserRole.guest:
        return _guestView(context);
      case UserRole.user:
        return _userView(context, currentUser!);
      case UserRole.admin:
        return _adminView(context, currentUser!);
    }
  }

  Widget _guestView(BuildContext context){
    return Column (
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gost",
          style: TextStyle(fontSize:20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text("Molimo vas da se registrujete ili prijavite"),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
            // nakon zatvaranja login ekrana osvezi profil
            setState(() {});
          },
          child: const Text("Prijavi se"),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterScreen()),
            );
            // nakon zatvaranja register ekrana osvezi profil
            if (result == true) {
              // Registracija je uspešna, osveži ekran
              setState(() {});
            }
          },
          child: const Text("Registruj se"),
        ),
      ],
    );
  }

  Widget _userView(BuildContext context, User user){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profil kartica
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4A574).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 30,
                        color: const Color(0xFFD4A574),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Registrovani korisnik",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Informacije
        const Text(
          "Lični podaci",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoRow(Icons.email, "Email", user.email),
        const SizedBox(height: 12),
        _buildInfoRow(Icons.account_circle, "Tip naloga", "Korisnik"),
        const SizedBox(height: 12),
        _buildInfoRow(Icons.shopping_cart, "Status", "Aktivan"),
        const SizedBox(height: 24),
        // Istorija porudžbina
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const OrderHistoryScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4A574).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.history,
                      color: Color(0xFFD4A574),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Istorija porudžbina",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Pregledajte sve vaše porudžbine",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Dugme za odjavu
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // Odjava korisnika i osvežavanje ekrana na "Gost" prikaz
              setState(() {
                User.currentUser = null;
              });
            },
            icon: const Icon(Icons.logout),
            label: const Text("Odjavi se"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFD4A574), size: 20),
        const SizedBox(width: 12),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  Widget _adminView(BuildContext context, User user){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profil kartica
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings,
                        size: 30,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Administrator",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Informacije
        const Text(
          "Lični podaci",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoRow(Icons.email, "Email", user.email),
        const SizedBox(height: 12),
        _buildInfoRow(Icons.admin_panel_settings, "Tip naloga", "Administrator"),
        const SizedBox(height: 12),
        _buildInfoRow(Icons.settings, "Status", "Aktivan"),
        const SizedBox(height: 12),
        // Statistike
        const Text(
          "Statistike",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.music_note,
                        size: 32,
                        color: const Color(0xFFD4A574),
                      ),
                      const SizedBox(height: 8),
                      StreamBuilder<List<Instrument>>(
                        stream: Instrument.streamFromFirestore(),
                        builder: (context, snapshot) {
                          final count = snapshot.hasData 
                              ? snapshot.data!.length 
                              : 0;
                          return Text(
                            "$count",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Instrumenata",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.shopping_bag,
                        size: 32,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 8),
                      StreamBuilder<List<Order>>(
                        stream: Order.streamFromFirestore(),
                        builder: (context, snapshot) {
                          final count = snapshot.hasData 
                              ? snapshot.data!.length 
                              : 0;
                          return Text(
                            "$count",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Porudzbina",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Admin sekcija
        const Text(
          "Admin panel",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // Dodaj instrument
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddInstrumentScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.green,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dodaj novi instrument",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Dodajte novi proizvod u ponudu",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Migriraj instrumente
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () async {
              // Prikaži dijalog za potvrdu
              final shouldMigrate = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Migracija instrumenata"),
                  content: const Text(
                    "Da li želite da migrirate postojeće instrumente iz statičke liste u Firestore?\n\n"
                    "Ova akcija će dodati samo one instrumente koji već ne postoje u bazi.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Otkaži"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4A574),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Migriraj"),
                    ),
                  ],
                ),
              );

              if (shouldMigrate == true && mounted) {
                // Prikaži loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                try {
                  await migrateInstrumentsToFirestore();
                  
                  if (mounted) {
                    Navigator.pop(context); // Zatvori loading
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Migracija uspešno završena!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    Navigator.pop(context); // Zatvori loading
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Greška pri migraciji: ${e.toString()}"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.cloud_upload,
                      color: Colors.orange,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Migriraj instrumente",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Prebaci postojeće instrumente u Firestore",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Sve porudžbine
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminOrdersScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shopping_bag,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sve porudžbine",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Pregledajte sve porudžbine korisnika",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Dugme za odjavu
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // Odjava korisnika i resetovanje na gost
              setState(() {
                User.currentUser = null;
              });
            },
            icon: const Icon(Icons.logout),
            label: const Text("Odjavi se"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}