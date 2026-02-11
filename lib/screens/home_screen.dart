import 'package:flutter/material.dart';
import 'package:prodavnica_muzickih_instrumenata/models/instrument.dart';
import 'package:prodavnica_muzickih_instrumenata/screens/instrument_detail_screen.dart';
import 'package:prodavnica_muzickih_instrumenata/screens/search_screen.dart';
import 'package:prodavnica_muzickih_instrumenata/widgets/instrument_image.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Hero sekcija
          SliverToBoxAdapter(
            child: _buildHeroSection(context),
          ),
          // Kategorije
          SliverToBoxAdapter(
            child: _buildCategoriesSection(context),
          ),
          // Najpopularniji instrumenti
          SliverToBoxAdapter(
            child: _buildPopularInstrumentsSection(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Pozadinska slika
          Image.asset(
            'assets/images/hero-guitar.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Ako slika ne postoji, prik gradient
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFB8945F), 
                      const Color(0xFFD4A574), 
                    ],
                  ),
                ),
              );
            },
          ),
          // Tamni overlay 
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),
          // Sadrzaj
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Dobrodošli",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Prodavnica instrumenata",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Vaša destinacija za gitare, klavijature i savršen zvuk 🎶",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    final categories = [
      {
        'name': 'Gitare',
        'description': 'Električne, akustične i bas gitare svetskih brendova.',
        'icon': Icons.music_note,
        'color': Colors.orange,
        'kategorija': 'gitara',
        'slika': 'assets/images/guitars.jpg',
      },
      {
        'name': 'Klavijature',
        'description': 'Digitalni pijanini i sintisajzeri za profesionalce i početnike.',
        'icon': Icons.piano_outlined,
        'color': Colors.blue,
        'kategorija': 'klavijature',
        'slika': 'assets/images/keyboards.jpg',
      },
      {
        'name': 'Bubnjevi',
        'description': 'Akustični i elektronski setovi, palice i dodatna oprema.',
        'icon': Icons.album,
        'color': Colors.red,
        'kategorija': 'bubnjevi',
        'slika': 'assets/images/drums.jpg',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Kategorije instrumenata",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ...categories.map((category) => _buildCategoryCard(
                context,
                category['name'] as String,
                category['description'] as String,
                category['icon'] as IconData,
                category['color'] as Color,
                category['kategorija'] as String,
                category['slika'] as String,
              )),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String name,
    String description,
    IconData icon,
    Color color,
    String kategorija,
    String slika,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Navigacija na pretragu sa filterom kategorije
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SearchScreen(initialCategory: kategorija),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Pozadinska slika
            Image.asset(
              slika,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Ako slika ne postoji, prikaži gradient
                return Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withOpacity(0.3),
                        color.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: Icon(icon, color: color, size: 40),
                );
              },
            ),
            // Tamni overlay 
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Sadrzaj
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        "Istraži",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 16,
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
  }

  Widget _buildPopularInstrumentsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Najpopularniji instrumenti",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 240,
            child: StreamBuilder<List<Instrument>>(
              stream: Instrument.streamFromFirestore(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  print('Greška u StreamBuilder: ${snapshot.error}');
                  return const Center(
                    child: Text('Greška pri učitavanju instrumenata iz baze.'),
                  );
                }

                final instruments = snapshot.data ?? [];
                final popularInstruments = instruments.take(4).toList();

                if (popularInstruments.isEmpty) {
                  return const Center(
                    child: Text('Nema dostupnih instrumenata u bazi.'),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularInstruments.length,
                  itemBuilder: (context, index) {
                    final instrument = popularInstruments[index];
                    return _buildInstrumentCard(context, instrument);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstrumentCard(BuildContext context, Instrument instrument) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
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
                  instrument: instrument,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Slika/Ikona
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: InstrumentImage(
                  instrument: instrument,
                  width: double.infinity,
                  height: 100,
                ),
              ),
              // Informacije
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        instrument.naziv,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        instrument.proizvodjac,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Text(
                        "${instrument.cena.toStringAsFixed(0)} €",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD4A574),
                        ),
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InstrumentDetailScreen(
                                  instrument: instrument,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4A574),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            minimumSize: const Size(0, 28),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            "Detaljnije",
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}