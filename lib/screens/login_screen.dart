import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prodavnica_muzickih_instrumenata/models/user.dart';
import 'package:prodavnica_muzickih_instrumenata/screens/root_screen.dart';
import 'package:prodavnica_muzickih_instrumenata/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Naslov
                const Text(
                  "Prijava",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Prijavi se svojim nalogom.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),
                // Email adresa
                const Text(
                  "Email adresa",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'ime@primer.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Molimo unesite email';
                    }
                    if (!value.contains('@')) {
                      return 'Unesite validan email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Lozinka
                const Text(
                  "Lozinka",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Lozinka',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Molimo unesite lozinku';
                    }
                    if (value.length < 3) {
                      return 'Lozinka mora imati najmanje 3 karaktera';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Remember me
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text(
                      "Remember me?",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Dugme za prijavu
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _login();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A574), 
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Prijavi se",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Zaboravljena lozinka
                Center(
                  child: TextButton(
                    onPressed: () {
                      _showMessage("Funkcionalnost 'Zaboravljena lozinka' je u toku.");
                    },
                    child: const Text(
                      "Zaboravljena lozinka?",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFD4A574), 
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Razdelnik
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[300])),
                  ],
                ),
                const SizedBox(height: 24),
                // Registracija
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Nemaš nalog? ",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        "Registruj se",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD4A574), // Zlatkasta boja
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

    Future<void> _login() async {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      if(email.isEmpty || password.isEmpty){
        _showMessage("Popunite sva polja!");
        return;
      }

      try {
        // Firebase autentifikacija prijava kor
        final credential = await fb_auth.FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Uzmi user ID iz Firebase Auth
        final firebaseUser = credential.user;
        if (firebaseUser == null) {
          _showMessage("Greška pri prijavi. Pokušajte ponovo.");
          return;
        }

        // Učitaj korisničke podatke (role) iz Firestore-a
        final appUser = await User.loadUserFromFirestore(firebaseUser.uid);
        
        // Proveri da li je admin email - uvek postavi admin role
        final isAdminEmail = email.toLowerCase() == "admin@admin.com";
        final shouldBeAdmin = isAdminEmail;
        
        if (appUser != null) {
          // Korisnik postoji u Firestore-u
          User finalUser = appUser;
          
          // Ako je admin email, uvek postavi admin role (čak i ako je u bazi user)
          if (shouldBeAdmin && appUser.role != UserRole.admin) {
            // Ažuriraj role u Firestore-u
            finalUser = User(
              id: appUser.id,
              email: appUser.email,
              role: UserRole.admin,
            );
            
            await FirebaseFirestore.instance
                .collection('users')
                .doc(firebaseUser.uid)
                .update({'role': 'admin'});
          }
          
          // Postavi trenutnog korisnika
          User.currentUser = finalUser;
          
          // Vrati se nazad (da navbar ostane vidljiv)
          if (mounted) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const RootScreen()),
              );
          }
        } else {
          // Ako korisnik ne postoji u Firestore-u, kreiraj ga
          final newUser = User(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? email,
            role: shouldBeAdmin ? UserRole.admin : UserRole.user,
          );
          
          // Sačuvaj u Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(firebaseUser.uid)
              .set(newUser.toMap());
          
          User.currentUser = newUser;
          
          if (mounted) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const RootScreen()),
              );
          }
        }
      } on fb_auth.FirebaseAuthException catch (e) {
        // Firebase greske
        String errorMessage = "Greška pri prijavi.";
        final isAdminEmail = email.toLowerCase() == "admin@admin.com";
        
        if (e.code == 'user-not-found') {
          // Korisnik sa ovim email-om ne postoji - treba da se registruje
          final message = isAdminEmail
              ? "Admin nalog ne postoji. Molimo registrujte se sa admin@admin.com da biste kreirali admin nalog."
              : "Korisnik sa ovim email-om ne postoji. Molimo registrujte se da biste kreirali novi nalog.";
          
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(isAdminEmail ? "Admin nalog ne postoji" : "Korisnik ne postoji"),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Otkaži"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Zatvori ovaj dijalog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A574),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Registruj se"),
                ),
              ],
            ),
          );
          return; // Ne prikazuj dodatnu poruku
        } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
          errorMessage = isAdminEmail
              ? "Pogrešna lozinka za admin nalog. Proverite lozinku ili registrujte se ponovo."
              : "Pogrešna lozinka. Proverite lozinku i pokušajte ponovo.";
        } else if (e.code == 'invalid-email') {
          errorMessage = "Nevalidan email format.";
        } else if (e.code == 'user-disabled') {
          errorMessage = "Korisnički nalog je onemogućen.";
        } else {
          errorMessage = "Greška: ${e.message ?? e.code}";
        }
        _showMessage(errorMessage);
      } catch (e) {
        _showMessage("Greška: ${e.toString()}");
      }
    }

    void _showMessage(String msg){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
}