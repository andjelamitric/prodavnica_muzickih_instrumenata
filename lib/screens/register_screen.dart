import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prodavnica_muzickih_instrumenata/models/user.dart';
import 'package:prodavnica_muzickih_instrumenata/screens/root_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  bool _isLoading = false; // Loading indikator

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
                  "Registracija",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Kreirajte novi nalog.",
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
                    if (value.length < 6) {
                      return 'Lozinka mora imati najmanje 6 karaktera';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Potvrda lozinke
                const Text(
                  "Potvrdite lozinku",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Potvrdite lozinku',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Molimo potvrdite lozinku';
                    }
                    if (value != _passwordController.text) {
                      return 'Lozinke se ne poklapaju';
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
                // Dugme za registraciju
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () async {
                      if (_formKey.currentState!.validate()) {
                        await _register();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A574), // Zlatkasta boja
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
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
                            "Registruj se",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Već imaš nalog? ",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        "Prijavi se",
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

  Future<void> _register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Aktiviraj loading
    setState(() {
      _isLoading = true;
    });

    try {
      // Firebase Authentication - kreiraj novog korisnika
      final credential = await fb_auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showMessage("Greška pri registraciji. Pokušajte ponovo.");
        }
        return;
      }

      // Kreiraj User objekat - proveri da li je admin email
      final isAdminEmail = email.toLowerCase() == "admin@admin.com";
      final newUser = User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? email,
        role: isAdminEmail ? UserRole.admin : UserRole.user,
      );

      // Sacuvaj korisnika u Firestore kolekciju "users"
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set(newUser.toMap());
      } catch (firestoreError) {
        // Ako Firestore ne radi, korisnik je već kreiran u Auth, samo prijavi grešku
        print("Firestore greška: $firestoreError");
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showMessage("Korisnik je kreiran, ali ima problem sa bazom podataka. Pokušajte da se prijavite.");
          // Ipak postavi korisnika da može da se prijavi
          User.currentUser = newUser;
          Navigator.pop(context, true);
          return;
        }
      }

      // Postavi trenutnog korisnika
      User.currentUser = newUser;

      // Vrati se nazad sa rezultatom da je registracija uspešna
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context, true); // Vrati true da zna da je registracija uspešna
        _showMessage("Uspešno ste se registrovali!");
      }
    } on fb_auth.FirebaseAuthException catch (e) {
      // Firebase greske
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      
      String errorMessage = "Greška pri registraciji.";
      if (e.code == 'weak-password') {
        errorMessage = "Lozinka je previše slaba. Koristite jaču lozinku.";
        if (mounted) {
          _showMessage(errorMessage);
        }
      } else if (e.code == 'email-already-in-use') {
        // Korisnik postoji u Firebase Auth, ali možda ne postoji u Firestore-u
        // Pokušaj da ga prijaviš i kreiraj u Firestore-u ako ne postoji
        try {
          // Pokušaj da se prijaviš sa unetom lozinkom
          final signInCredential = await fb_auth.FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          
          final firebaseUser = signInCredential.user;
          if (firebaseUser != null) {
            // Proveri da li postoji u Firestore-u
            final existingUser = await User.loadUserFromFirestore(firebaseUser.uid);
            
            if (existingUser == null) {
              // Korisnik postoji u Auth ali ne u Firestore-u - kreiraj ga
              final isAdminEmail = email.toLowerCase() == "admin@admin.com";
              final newUser = User(
                id: firebaseUser.uid,
                email: firebaseUser.email ?? email,
                role: isAdminEmail ? UserRole.admin : UserRole.user,
              );
              
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(firebaseUser.uid)
                  .set(newUser.toMap());
              
              User.currentUser = newUser;
              
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
                Navigator.pop(context, true);
                _showMessage("Uspešno ste se registrovali i prijavili!");
              }
              return;
            } else {
              // Korisnik postoji u oba - samo prijavi ga
              User.currentUser = existingUser;
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
                Navigator.pop(context, true);
                _showMessage("Uspešno ste se prijavili!");
              }
              return;
            }
          }
        } catch (signInError) {
          // Ne može da se prijavi - verovatno pogrešna lozinka
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Korisnik već postoji"),
                content: const Text(
                  "Korisnik sa ovim email-om već postoji. Ako ste vi taj korisnik, prijavite se sa svojom lozinkom. Ako ste zaboravili lozinku, resetujte je preko Firebase Console.",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Otkaži"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Zatvori ovaj dijalog
                      Navigator.pop(context); // Vrati se na login ekran
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A574),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Prijavi se"),
                  ),
                ],
              ),
            );
          }
          return;
        }
      } else if (e.code == 'invalid-email') {
        errorMessage = "Nevalidan email format.";
        if (mounted) {
          _showMessage(errorMessage);
        }
      } else {
        if (mounted) {
          _showMessage(errorMessage);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        print("Opšta greška pri registraciji: $e");
        _showMessage("Greška: ${e.toString()}");
      }
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFFD4A574),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
