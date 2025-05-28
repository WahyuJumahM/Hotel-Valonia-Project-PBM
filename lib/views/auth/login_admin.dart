import 'package:flutter/material.dart';

class LoginAdminPage extends StatefulWidget {
  @override
  State<LoginAdminPage> createState() => _LoginAdminPageState();
}

class _LoginAdminPageState extends State<LoginAdminPage> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
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
                              'Masuk (Admin)',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Masuk sebagai admin untuk mengelola sistem.',
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
                          hintText: 'Masukkan email admin',
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
                          hintText: 'Masukkan kata sandi',
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
                            Navigator.pushReplacementNamed(context, '/homepage_admin');
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
                      Spacer(),
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: "Dengan login, Anda setuju dengan ",
                            style: TextStyle(fontSize: 12, color: Colors.black54, fontFamily: 'Roboto'),
                            children: [
                              TextSpan(
                                text: "Syarat & Ketentuan",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
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

            // Tombol back di pojok kiri atas
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.indigo),
                onPressed: () {
                  Navigator.pop(context);
                },
                tooltip: 'Kembali',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
