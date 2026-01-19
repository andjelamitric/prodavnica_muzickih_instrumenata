import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget { //nema promene stanja samo prik podatke
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text ("Prodavnica instrumenata")), //naziv app
      body: ListView(
          padding: const EdgeInsets.all(16), //vertikalno skrolovanje
          children: const[
            Card(child: ListTile(
              title: Text("Gitara"),
              subtitle: Text("300e"),
              ),
              ),
            Card(
              child: ListTile(
                title: Text("Klavir"),
                subtitle: Text("1200e"),
                ),
                ),
            Card(
            child: ListTile(
              title: Text("Bubnjevi"),
              subtitle: Text("800 €"),
            ),
          ),
        ],
      ),
    );
  }
}