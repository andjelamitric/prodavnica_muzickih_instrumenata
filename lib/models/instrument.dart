import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Instrument {
  final String id;
  final String naziv;
  final double cena;
  final String opis;
  final String kategorija; // gitara, klavir, bubnjevi, itd.
  final String proizvodjac; // Gibson, Fender, Yamaha, itd.
  final String? slikaUrl; 

  Instrument({
    required this.id,
    required this.naziv,
    required this.cena,
    required this.opis,
    required this.kategorija,
    required this.proizvodjac,
    this.slikaUrl,
  });

  // vraca ikonicu na osnovu kategorije
  IconData get icon {
    switch (kategorija.toLowerCase()) {
      case 'gitara':
        return Icons.music_note;
      case 'klavir':
        return Icons.piano_outlined;
      case 'bubnjevi':
        return Icons.album;
      case 'gudacki':
        return Icons.music_note_outlined;
      case 'duvacki':
        return Icons.audiotrack;
      default:
        return Icons.music_note;
    }
  }

  // vraca boju za kategoriju, svaka kat ima svoju boju
  Color get categoryColor {
    switch (kategorija.toLowerCase()) { //u mala slova
      case 'gitara':
        return Colors.orange;
      case 'klavir':
        return Colors.blue;
      case 'bubnjevi':
        return Colors.red;
      case 'gudacki':
        return Colors.purple;
      case 'duvacki':
        return const Color(0xFFD4A574);
      default:
        return Colors.grey;
    }
  }

  // Privremena staticka lista instrumenata
  static List<Instrument> instruments = [
    Instrument(
      id: "1",
      naziv: "Gibson Les Paul",
      cena: 300.0,
      opis: "Les Paul sa sjajnim hvatom od ebanovine je prestižna i elegantna električna gitara iz Gibsonove serije Les Paul. Kombinuje klasične dizajnerske elemente sa modernim karakteristikama kako bi pružila svestran i moćan instrument. ",
      kategorija: "gitara",
      proizvodjac: "Gibson",
      slikaUrl: "assets/images/gibson-lespaul.jpg", 
    ),
    Instrument(
      id: "2",
      naziv: "Korg HICKORY 5B",
      cena: 1200.0,
      opis: "5B je palica za bubanj standardnog prečnika za teške udarače; veća palica opšte namene za rok, pop, pank i pop muziku, savršena kada je 5A premala, a 2B prevelika.",
      kategorija: "bubnjevi",
      proizvodjac: "Korg",
      slikaUrl: "assets/images/drums.jpg",
    ),
    Instrument(
      id: "3",
      naziv: "Pearl River GP150 Grand Piano",
      cena: 800.0,
      opis: "Pearl najkompaktniji i najpristupačniji koncertni klavir, popularan je izbor za lokacije gde je prostor ograničen, ali svojim zvukom podseća na mnoge mnogo veće modele. Neprevaziđeni u svojoj lepoti i muzičkom opsegu, koncertni klaviri predstavljaju vrhunski domet u umetnosti izrade klavira. ",
      kategorija: "klavijature",
      proizvodjac: "Pearl River",
      slikaUrl: "assets/images/keyboards.jpg", 
    ),
    Instrument(
      id: "4",
      naziv: "Roland TD-1DMK",
      cena: 900.0,
      opis: "Roland V-Drums su najpopularniji bubnjevi na svetu, zahvaljujući svom moćnom zvuku, sjajnom osećaju sviranja i legendarnoj izdržljivosti. TD-1DMK pruža potpuno iskustvo sviranja bubnjeva u kompaktnom setu koji se lako montira.",
      kategorija: "bubnjevi",
      proizvodjac: "Roland",
      slikaUrl: "assets/images/roland-drumkit.jpg", 
    ),
    Instrument(
      id: "5",
      naziv: "Yamaha B2",
      cena: 1050.0,
      opis: "Sa svojim većim dimenzijama i masivnijom konstrukcijom, novi Yamaha B2 isporučuje superioran zvuk, dubinu i snagu. Za ambicioznog izvođača koji ima ograničen budžet, nema boljeg instrumenta.",
      kategorija: "klavijature",
      proizvodjac: "Yamaha",
      slikaUrl: "assets/images/keyboard2.jpg", 
    ),
    Instrument(
      id: "6",
      naziv: "Yamaha PSR-E473",
      cena: 600.0,
      opis: "PSR-E473 pruža isti profesionalni kvalitet zvuka koji se nalazi u vrhunskim modelima. Puni su proširenih efekata i širokim spektrom stilova - od najnovijih hitova do žanrova iz celog sveta.",
      kategorija: "klavijature",
      proizvodjac: "Yamaha",
      slikaUrl: "assets/images/yamaha-keyboard.jpg", 
    ),
    Instrument(
      id: "7",
      naziv: "Casio RYDEEN",
      cena: 550.0,
      opis: "Novi RYDEEN (paket od 5 korpusa) je upravo ono što bi svaki početnik ili srednji svirač voleo da svira. Ovaj set bubnjeva koristi Casio hardver sa originalnim Casio stezaljkama za tom i cevi i ima čvrste i šljokice, svaka sa tri opcije boja, za ukupno šest živih, stilskih izgleda.",
      kategorija: "bubnjevi",
      proizvodjac: "Casio",
      slikaUrl: "assets/images/drums1.jpg", 
    ),
    Instrument(
      id: "8",
      naziv: "Fender FA-450CE",
      cena: 380.0,
      opis: "Ne samo još jedan lep bas, inspirativni i iznenađujuće svestrani FA-450CE olakšava ponošenje i osećaj ubitačnog Fender basa gde god da idete. Za pojačane performanse.",
      kategorija: "gitara",
      proizvodjac: "Fender",
      slikaUrl: "assets/images/acoustic-guitar.jpg", 
    ),
    Instrument(
      id: "9",
      naziv: "Fender Stratocaster",
      cena: 1450.0,
      opis: "Opremite se i spremite se da podignete svoje izvođenje na viši nivo uz Stratocaster. Sa ključnim nadogradnjama za modernog gitaristu i basistu, svestrani dizajn stratokastera danas se smatra pravim klasikom u industrijskom dizajnu gitara svih vremena.",
      kategorija: "gitara",
      proizvodjac: "Fender",
      slikaUrl: "assets/images/stratocaster.jpg", 
    ),
  ];

  // pretraga instrumenata
  static List<Instrument> search(String query) { //query pretraga
    if (query.isEmpty) return instruments;  //ako je query prazan, vrati sve instrumenate
    
    //ako u bilo kom tekstualnom polju sadrže uneti tekst
    final lowerQuery = query.toLowerCase(); 
    return instruments.where((instrument) { 
      return instrument.naziv.toLowerCase().contains(lowerQuery) || 
             instrument.kategorija.toLowerCase().contains(lowerQuery) || 
             instrument.proizvodjac.toLowerCase().contains(lowerQuery) || 
             instrument.opis.toLowerCase().contains(lowerQuery); 
    }).toList(); //vrati listu instrumenata koji sadrze query
  }

  // filtriranje po kategoriji
  static List<Instrument> filterByCategory(String? kategorija) {
    if (kategorija == null || kategorija.isEmpty) return instruments;
    return instruments.where((instrument) => instrument.kategorija == kategorija).toList();
  }

  // Konvertuje Instrument u Map za Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'naziv': naziv,
      'cena': cena,
      'opis': opis,
      'kategorija': kategorija,
      'proizvodjac': proizvodjac,
      'slikaUrl': slikaUrl,
    };
  }

  // Kreira Instrument iz Firestore dokumenta
  factory Instrument.fromMap(Map<String, dynamic> map, String docId) {
    return Instrument(
      id: docId, // Koristi document ID kao id
      naziv: map['naziv'] ?? '',
      cena: (map['cena'] ?? 0.0).toDouble(),
      opis: map['opis'] ?? '',
      kategorija: map['kategorija'] ?? '',
      proizvodjac: map['proizvodjac'] ?? '',
      slikaUrl: map['slikaUrl'],
    );
  }

  // Učitava sve instrumente iz Firestore-a
  static Future<List<Instrument>> loadFromFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('instruments')
          .get();
      
      return snapshot.docs.map((doc) {
        return Instrument.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Greška pri učitavanju instrumenata: $e');
      // U slučaju greske vrati praznu listu  UI radi samo sa bazom.
      return [];
    }
  }

  // Stream instrumenata iz Firestore-a (real-time updates)
  static Stream<List<Instrument>> streamFromFirestore() {
    return FirebaseFirestore.instance
        .collection('instruments')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          return Instrument.fromMap(doc.data(), doc.id);
        } catch (e) {
          print('Greška pri parsiranju instrumenta ${doc.id}: $e');
          return null;
        }
      }).whereType<Instrument>().toList();
    });
  }

  // Dodaje novi instrument u Firestore
  Future<void> saveToFirestore() async {
    await FirebaseFirestore.instance
        .collection('instruments')
        .doc(id)
        .set(toMap());
  }

  // Ažurira postojeći instrument u Firestore-u
  Future<void> updateInFirestore() async {
    // Koristi set() sa merge: true umesto update() da osigura da sva polja budu ažurirana
    await FirebaseFirestore.instance
        .collection('instruments')
        .doc(id)
        .set(toMap(), SetOptions(merge: true));
  }

  // Briše instrument iz Firestore-a
  Future<void> deleteFromFirestore() async {
    await FirebaseFirestore.instance
        .collection('instruments')
        .doc(id)
        .delete();
  }
}
