import 'package:prodavnica_muzickih_instrumenata/models/instrument.dart';

/// Skripta za migraciju postojećih instrumenata iz statičke liste u Firestore
/// 
/// Kako koristiti:
/// 1. Pokreni aplikaciju
/// 2. Pozovi ovu funkciju jednom (npr. iz admin panela ili jednom pri pokretanju)
/// 3. Nakon migracije, ova funkcija neće dodavati duplikate (proverava da li već postoji)
Future<void> migrateInstrumentsToFirestore() async {
  try {
    print('🚀 Počinje migracija instrumenata u Firestore...');
    
    // Učitaj postojeće instrumente iz Firestore-a
    final existingInstruments = await Instrument.loadFromFirestore();
    final existingIds = existingInstruments.map((inst) => inst.id).toSet();
    
    int added = 0;
    int skipped = 0;
    
    // Prođi kroz sve instrumente iz statičke liste
    for (final instrument in Instrument.instruments) {
      // Proveri da li već postoji u Firestore-u
      if (existingIds.contains(instrument.id)) {
        print('⏭️  Preskočen: ${instrument.naziv} (već postoji)');
        skipped++;
        continue;
      }
      
      // Dodaj u Firestore
      await instrument.saveToFirestore();
      print('✅ Dodato: ${instrument.naziv}');
      added++;
    }
    
    print('\n📊 Migracija završena:');
    print('   ✅ Dodato: $added instrumenata');
    print('   ⏭️  Preskočeno: $skipped instrumenata');
    print('   📦 Ukupno u Firestore-u: ${existingInstruments.length + added}');
  } catch (e) {
    print('❌ Greška pri migraciji: $e');
    rethrow;
  }
}
