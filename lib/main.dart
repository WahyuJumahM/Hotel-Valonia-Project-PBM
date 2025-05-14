import 'package:flutter/material.dart';
import 'routes/app_routes.dart'; // Tambahkan ini

void main() {
  runApp(HotelValoniaApp());
}

class HotelValoniaApp extends StatelessWidget {
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
