// lib/widgets/user/bottom_nav.dart
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
        Navigator.pushReplacement(context, pageRouteBuilder(const RiwayatPage()));
        break;
      case 3:
        Navigator.pushReplacement(context, pageRouteBuilder(ProfilePage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.95),
            Colors.white,
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -5),
          ),
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onTap(context, index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF2196F3),
          unselectedItemColor: const Color(0xFF9E9E9E),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          items: [
            _buildNavItem(Icons.home_rounded, Icons.home_outlined, 'Home', 0),
            _buildNavItem(Icons.bookmark_rounded, Icons.bookmark_border_rounded, 'My Booking', 1),
            _buildNavItem(Icons.history_rounded, Icons.history_outlined, 'Riwayat', 2),
            _buildNavItem(Icons.person_rounded, Icons.person_outline_rounded, 'Profile', 3),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData selectedIcon, IconData unselectedIcon, String label, int index) {
    final isSelected = currentIndex == index;
    
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected 
            ? const Color(0xFF2196F3).withOpacity(0.15)
            : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isSelected ? selectedIcon : unselectedIcon,
            key: ValueKey(isSelected),
            size: isSelected ? 26 : 24,
          ),
        ),
      ),
      label: label,
    );
  }
}