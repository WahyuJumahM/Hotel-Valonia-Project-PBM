import 'package:flutter/material.dart';
import '../views/start/splash_screen.dart';
import '../views/start/on_boarding1.dart';
import '../views/start/on_boarding2.dart';
import '../views/start/get_started.dart';
import '../views/auth/login.dart';  
import '../views/auth/register.dart';  
import '../views/auth/login_admin.dart';  
import '../views/user/homepage.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => SplashScreen(),
    '/on_boarding1': (context) => OnBoarding1(),
    '/on_boarding2': (context) => OnBoarding2(),
    '/get_started': (context) => GetStarted(),
    '/login': (context) => LoginPage(),
    '/register': (context) => RegisterPage(),
    '/login_admin': (context) => LoginAdminPage(),  
    '/homepage': (context) => HomePage(),
  };
}
