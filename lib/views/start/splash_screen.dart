import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth/user_auth_viewmodel.dart';
import 'on_boarding.dart';
import 'get_started.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Tunggu minimal 2 detik untuk splash screen
    await Future.delayed(Duration(seconds: 2));
    
    // Cek status login
    await _checkAuthenticationStatus();
  }

  Future<void> _checkAuthenticationStatus() async {
    try {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      
      // Tunggu sampai UserViewModel selesai load stored user
      // UserViewModel sudah otomatis load user di constructor
      while (userViewModel.isLoading) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      
      if (userViewModel.isLoggedIn) {
        // User sudah login, cek apakah admin atau user biasa
        if (userViewModel.isAdmin) {
          // Arahkan ke homepage admin
          Navigator.pushNamedAndRemoveUntil(
            context, 
            '/HomeAdmin', 
            (route) => false
          );
        } else {
          // Arahkan ke homepage user
          Navigator.pushNamedAndRemoveUntil(
            context, 
            '/homepage', 
            (route) => false
          );
        }
      } else {
        // User belum login, cek apakah first launch
        await _checkFirstLaunch();
      }
    } catch (e) {
      print("Error checking authentication: $e");
      // Jika terjadi error, fallback ke first launch check
      await _checkFirstLaunch();
    }
  }

  Future<void> _checkFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool? isFirstLaunch = prefs.getBool('is_first_launch');

      if (isFirstLaunch == null || isFirstLaunch == true) {
        // Pertama kali launch app
        await prefs.setBool('is_first_launch', false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnBoarding()),
        );
      } else {
        // Bukan pertama kali buka, langsung ke GetStarted
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GetStarted()),
        );
      }
    } catch (e) {
      print("Error checking first launch: $e");
      // Fallback ke OnBoarding jika terjadi error
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnBoarding()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF205295),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Hotel Valonia',
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Temukan Penginapan Kapan Saja & di Mana Saja.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 30),
            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}