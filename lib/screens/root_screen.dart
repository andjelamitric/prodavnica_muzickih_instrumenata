import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class RootScreen extends StatefulWidget {  //StateFul jer pamti koji je tab izabran tren
  const RootScreen({super.key});

  @override
State<RootScreen> createState ()=>_RootScreenState(); //povezuje widget sa klasom koja pamti stanje
}

class _RootScreenState extends State <RootScreen> {
  int _selectedIndex=0; //menja se klikom na navbar, pokrece se na home screenu

  final List <Widget> _screens=const[
    HomeScreen(), //index 0
    SearchScreen(), //1
    CartScreen(), //2
    ProfileScreen(), //3
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_screens[_selectedIndex], //prik ekran u zavisnosti od izabr indexa
      bottomNavigationBar: BottomNavigationBar( //navigacija
        currentIndex: _selectedIndex, 
        type: BottomNavigationBarType.fixed,
        onTap: (index){
          setState(() { //ponovo se prik ui
            _selectedIndex=index; //menja se index
          });
        },
        items:const[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search),label:'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Profile')
        ]
      ),
    );
  }
}