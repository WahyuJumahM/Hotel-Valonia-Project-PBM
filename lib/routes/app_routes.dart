import 'package:flutter/material.dart';

// Start & Auth
import '../views/start/splash_screen.dart';
import '../views/start/on_boarding.dart';
// import '../views/start/on_boarding2.dart';
import '../views/start/get_started.dart';
import '../views/auth/login.dart';  
import '../views/auth/register.dart';  

// User
import '../views/user/homepage.dart';

// Admin
import '../views/admin/Homepage_screen/home_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    // Start & Auth
    '/': (context) => SplashScreen(),
    '/on_boarding': (context) => OnBoarding(),
    // '/on_boarding2': (context) => OnBoarding2(),
    '/get_started': (context) => GetStarted(),
    '/login': (context) => LoginPage(),
    '/register': (context) => RegisterPage(),

    // User
    '/homepage': (context) => HomePage(),

    // Admin
    '/HomeAdmin': (context) => const HomeScreen(),
  };
}
