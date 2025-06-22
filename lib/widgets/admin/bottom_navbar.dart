//lib/widgets/admin/bottom_navbar.dart
import 'package:flutter/material.dart';
import '../../views/admin/Homepage_screen/home_screen.dart';
import '../../views/admin/riwayat_screen/riwayat_booking_screen.dart';
import '../../views/admin/kamar_screen/kamar_screen.dart';
import '../../views/admin/laporan_screen/laporan_screen.dart';
import '../../views/admin/profile_screen/profile_admin.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
  });

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    // Membuat transisi fade
    PageRouteBuilder pageRouteBuilder(Widget page) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      );
    }

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, pageRouteBuilder(const LaporanPage()));
        break;
      case 1:
        Navigator.pushReplacement(context, pageRouteBuilder(const RiwayatBookingScreen()));
        break;
      case 2:
        Navigator.pushReplacement(context, pageRouteBuilder(const HomeScreen()));
        break;
      case 3:
        Navigator.pushReplacement(context, pageRouteBuilder(const KamarScreen()));
        break;
      case 4:
        Navigator.pushReplacement(context, pageRouteBuilder(const ProfileAdminPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onTap(context, index),
          selectedItemColor: Colors.blue[700],
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          items: [
            // Left side items (now Laporan first)
            const BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              label: 'Laporan'
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined), 
              label: 'Riwayat'
            ),
            // Center Home item with circle
            BottomNavigationBarItem(
              icon: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == 2 ? Colors.blue[700] : Colors.transparent,
                ),
                child: Icon(
                  Icons.home,
                  color: currentIndex == 2 ? Colors.white : Colors.grey,
                  size: 28,
                ),
              ),
              label: 'Home',
            ),
            // Right side items
            const BottomNavigationBarItem(
              icon: Icon(Icons.bed_outlined), 
              label: 'Kamar'
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), 
              label: 'Profile'
            ),
          ],
        ),
      ),
    );
  }
}