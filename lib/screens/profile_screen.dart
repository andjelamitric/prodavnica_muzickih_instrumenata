import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget { //nema promene stanja samo prik podatke
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")), 
      body: Center(
        child: ElevatedButton(onPressed: () {}, child: const Text("Login"),
        ),
      ),
    );
  }
}