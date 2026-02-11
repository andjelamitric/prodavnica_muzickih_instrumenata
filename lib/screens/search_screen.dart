import 'package:flutter/material.dart';
import 'package:prodavnica_muzickih_instrumenata/models/instrument.dart';
import 'package:prodavnica_muzickih_instrumenata/screens/instrument_detail_screen.dart';
import 'package:prodavnica_muzickih_instrumenata/widgets/instrument_image.dart';

class SearchScreen extends StatefulWidget {
  final String? initialCategory;
  
  const SearchScreen({super.key, this.initialCategory});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  String? _selectedManufacturer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {}); // Rebuild kada se tekst promeni
    });
    
    // Ako je prosledjena kategorija, postavi je
    if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Instrument> _applyFilters(List<Instrument> instruments) {
    var results = instruments;

    // Filter po pretrazi
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      results = results.where((instrument) {
        return instrument.naziv.toLowerCase().contains(lowerQuery) ||
               instrument.kategorija.toLowerCase().contains(lowerQuery) ||
               instrument.proizvodjac.toLowerCase().contains(lowerQuery) ||
               instrument.opis.toLowerCase().contains(lowerQuery);
      }).toList();
    }

    // Filter po kategoriji
    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      results = results.where((instrument) => 
        instrument.kategorija == _selectedCategory
      ).toList();
    }

    // Filter po proizvodjacu
    if (_selectedManufacturer != null && _selectedManufacturer!.isNotEmpty) {
      results = results.where((instrument) => 
        instrument.proizvodjac == _selectedManufacturer
      ).toList();
    }

    return results;
  }

  void _showAllProducts() {
    setState(() {
      _selectedCategory = null;
      _selectedManufacturer = null;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: StreamBuilder<List<Instrument>>(
          stream: Instrument.streamFromFirestore(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text(
                "Ponuda instrumenata",
                style: TextStyle(fontWeight: FontWeight.bold),
              );
            }
            
            final instruments = snapshot.data ?? [];
            final filteredResults = _applyFilters(instruments);
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ponuda instrumenata",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (filteredResults.isNotEmpty)
                  Text(
                    "${filteredResults.length} ${filteredResults.length == 1 ? 'proizvod' : 'proizvoda'}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
              ],
            );
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: StreamBuilder<List<Instrument>>(
        stream: Instrument.streamFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            print('Greška u StreamBuilder: ${snapshot.error}');
            // poruka o gresci podaci iy baze
            return const Center(
              child: Text(
                'Greška pri učitavanju podataka iz baze.\nPokušajte ponovo kasnije.',
                textAlign: TextAlign.center,
              ),
            );
          }
          
          final instruments = snapshot.data ?? [];
          return _buildSearchContent(context, instruments);
        },
      ),
    );
  }

  Widget _buildSearchContent(BuildContext context, List<Instrument> instruments) {
    // Uzmi sve kategorije i proizvođače iz instrumenata
    final categories = instruments
        .map((instrument) => instrument.kategorija)
        .toSet()
        .toList()
      ..sort();
    
    final manufacturers = instruments
        .map((instrument) => instrument.proizvodjac)
        .toSet()
        .toList()
      ..sort();
    
    final filteredResults = _applyFilters(instruments);
    
    return Column(
            children: [
              // Filter sekcija
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
                    // Filter red
                    Row(
                      children: [
                        // Kategorije dropdown
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCategory,
                                hint: const Text("Sve kategorije"),
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: null,
                                    child: Text("Sve kategorije"),
                                  ),
                                  ...categories.map((cat) => DropdownMenuItem<String>(
                                    value: cat,
                                    child: Text(cat.toUpperCase()),
                                  )),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Proizvodjaci dropdown
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedManufacturer,
                                hint: const Text("Svi proizvođači"),
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: null,
                                    child: Text("Svi proizvođači"),
                                  ),
                                  ...manufacturers.map((manufacturer) => DropdownMenuItem<String>(
                                    value: manufacturer,
                                    child: Text(manufacturer),
                                  )),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedManufacturer = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Pretraga
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Pretraži instrumente...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Prikaži sve dugme
                    if (_selectedCategory != null || 
                        _selectedManufacturer != null || 
                        _searchController.text.isNotEmpty)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _showAllProducts,
                          icon: const Icon(Icons.clear_all),
                          label: const Text("Prikaži sve proizvode"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFD4A574),
                            side: const BorderSide(color: Color(0xFFD4A574)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Rezultati pretrage
              Expanded(
                child: filteredResults.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Nema rezultata pretrage",
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredResults.length,
                        itemBuilder: (context, index) {
                          final instrument = filteredResults[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 20),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InstrumentDetailScreen(
                                  instrument: instrument,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Slika
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: InstrumentImage(
                                  instrument: instrument,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Informacije
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      instrument.naziv,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      instrument.proizvodjac,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      instrument.opis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                        height: 1.5,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${instrument.cena.toStringAsFixed(2)} €",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFD4A574),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ),
            ],
    );
  }
}