import 'package:flutter/material.dart';

PageRouteBuilder linearSlideRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.linear, // Linear animation
      );

      final offsetAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0), // Geser dari kanan
        end: Offset.zero,
      ).animate(curvedAnimation);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
