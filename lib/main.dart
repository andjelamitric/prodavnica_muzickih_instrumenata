import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/root_screen.dart';

//poziva se prilikom pokretanja aplikacije, INICIJALIZACIJA FIREBASE-A
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prodavnica instrumenata',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4A574), // Zlatkasta boja
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const RootScreen(),
    );
  }
}
