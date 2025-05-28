import 'package:flutter/material.dart';
import 'register.dart';
import 'kebijakan_privasi.dart'; // import halaman kebijakan_privasi

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight - MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Masuk',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Masuk untuk mulai booking hotel favoritmu.',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Text("Email", style: TextStyle(fontFamily: 'Roboto')),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Masukkan alamat email Anda',
                        hintStyle: TextStyle(fontFamily: 'Roboto'),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Password", style: TextStyle(fontFamily: 'Roboto')),
                    SizedBox(height: 8),
                    TextField(
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Masukkan kata sandi Anda',
                        hintStyle: TextStyle(fontFamily: 'Roboto'),
                        filled: true,
                        fillColor: Colors.grey[200],
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Setelah login berhasil, arahkan ke homepage
                          Navigator.pushReplacementNamed(
                            context,
                            '/homepage', // pastikan route ini sudah ada di main.dart
                          );
                        },
                        child: Text(
                          'Masuk',
                          style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterPage()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Belum punya akun? ",
                            style: TextStyle(color: Colors.black, fontFamily: 'Roboto'),
                            children: [
                              TextSpan(
                                text: "Daftar Sekarang",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: "Dengan mendaftar, Anda setuju dengan ",
                          style: TextStyle(fontSize: 12, color: Colors.black54, fontFamily: 'Roboto'),
                          children: [
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => KebijakanPrivasiPage()),
                                  );
                                },
                                child: Text(
                                  "Syarat & Ketentuan",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                            TextSpan(text: " kami."),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
