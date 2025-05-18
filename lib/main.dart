import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const HotelValoniaApp());
}

class HotelValoniaApp extends StatelessWidget {
  const HotelValoniaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Valonia',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: AppRoutes.routes,
    );
  }
}
