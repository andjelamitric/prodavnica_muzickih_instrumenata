import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {guest,user,admin}

class User{
  final String id;
  final String email;
  final UserRole role;

  User({
    required this.id,
    required this.email,
    required this.role,
  });

  // Konvertuje UserRole enum u String za Firestore
  String get roleString {
    switch (role) {
      case UserRole.guest:
        return 'guest';
      case UserRole.user:
        return 'user';
      case UserRole.admin:
        return 'admin';
    }
  }

  // Konvertuje String iz Firestore-a u UserRole enum
  static UserRole roleFromString(String roleString) {
    switch (roleString) {
      case 'admin':
        return UserRole.admin;
      case 'user':
        return UserRole.user;
      default:
        return UserRole.guest;
    }
  }

  // Konvertuje User u Map za Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'role': roleString,
    };
  }

  // Kreira User iz Firestore dokumenta
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      role: roleFromString(map['role'] ?? 'user'),
    );
  }

  // Privremena lista korisnika (za kompatibilnost, ali ne koristi se više)
  static List <User> users =[
    User(id: "1", email:"admin@admin.com", role:UserRole.admin),
  ];
  
  static User? currentUser;

  // Učitava korisnika iz Firestore-a na osnovu user ID-a
  static Future<User?> loadUserFromFirestore(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      
      if (doc.exists) {
        final data = doc.data()!;
        return User(
          id: userId,
          email: data['email'] ?? '',
          role: roleFromString(data['role'] ?? 'user'),
        );
      }
      return null;
    } catch (e) {
      print('Greška pri učitavanju korisnika: $e');
      return null;
    }
  }
}