import 'package:flutter/material.dart';
import '../../views/user/homepage.dart';  
import '../../views/user/mybooking.dart';  
import '../../views/user/riwayat.dart';  
import '../../views/user/profile.dart';  

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    // Membuat transisi fade
    PageRouteBuilder pageRouteBuilder(Widget page) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child); // Efek fade
        },
        transitionDuration: const Duration(milliseconds: 300), // Durasi transisi
      );
    }

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, pageRouteBuilder(const HomePage()));
        break;
      case 1:
        Navigator.pushReplacement(context, pageRouteBuilder(const MyBookingPage()));
        break;
      case 2:
        Navigator.pushReplacement(context, pageRouteBuilder( const RiwayatPage()));
        break;
      case 3:
        Navigator.pushReplacement(context, pageRouteBuilder( ProfilePage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'My Booking'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
