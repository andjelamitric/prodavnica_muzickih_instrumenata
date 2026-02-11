import 'package:flutter/material.dart';
import 'package:prodavnica_muzickih_instrumenata/models/instrument.dart';

class AddInstrumentScreen extends StatefulWidget {
  const AddInstrumentScreen({super.key});

  @override
  State<AddInstrumentScreen> createState() => _AddInstrumentScreenState();
}

class _AddInstrumentScreenState extends State<AddInstrumentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nazivController = TextEditingController();
  final _cenaController = TextEditingController();
  final _opisController = TextEditingController();
  final _proizvodjacController = TextEditingController();
  final _slikaUrlController = TextEditingController();

  String? _selectedKategorija;

  final List<String> _kategorije = [
    'gitara',
    'klavijature',
    'bubnjevi',
    'gudacki',
    'duvacki',
  ];

  @override
  void dispose() {
    _nazivController.dispose();
    _cenaController.dispose();
    _opisController.dispose();
    _proizvodjacController.dispose();
    _slikaUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Dodaj novi instrument",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFFD4A574),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Naziv
              const Text(
                "Naziv instrumenta",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nazivController,
                decoration: InputDecoration(
                  hintText: "npr. Gibson Les Paul",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unesite naziv instrumenta';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Cena
              const Text(
                "Cena (€)",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _cenaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "npr. 300.0",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unesite cenu';
                  }
                  final cena = double.tryParse(value);
                  if (cena == null || cena <= 0) {
                    return 'Unesite validnu cenu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Kategorija
              const Text(
                "Kategorija",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedKategorija,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                hint: const Text("Izaberite kategoriju"),
                items: _kategorije.map((kategorija) {
                  return DropdownMenuItem(
                    value: kategorija,
                    child: Text(kategorija.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKategorija = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Izaberite kategoriju';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Proizvođač
              const Text(
                "Proizvođač",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _proizvodjacController,
                decoration: InputDecoration(
                  hintText: "npr. Gibson, Fender, Yamaha",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unesite proizvođača';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Opis
              const Text(
                "Opis",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _opisController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Detaljan opis instrumenta...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unesite opis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Slika URL - ne mora
              const Text(
                "Slika URL (opciono)",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _slikaUrlController,
                decoration: InputDecoration(
                  hintText: "assets/images/naziv-slike.jpg",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 32),

              // Dugme za dodavanje
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _dodajInstrument,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A574),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          "Dodaj instrument",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isLoading = false;

  Future<void> _dodajInstrument() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Kreiranje novog instrumenta
        final noviInstrument = Instrument(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          naziv: _nazivController.text.trim(),
          cena: double.parse(_cenaController.text.trim()),
          opis: _opisController.text.trim(),
          kategorija: _selectedKategorija!,
          proizvodjac: _proizvodjacController.text.trim(),
          slikaUrl: _slikaUrlController.text.trim().isEmpty
              ? null
              : _slikaUrlController.text.trim(),
        );

        // Dodavanje u Firestore
        await noviInstrument.saveToFirestore();

        if (mounted) {
          // Poruka o uspehu
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "${noviInstrument.naziv} je uspešno dodat!",
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

          // nazad
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Greška pri dodavanju: ${e.toString()}",
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
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}
