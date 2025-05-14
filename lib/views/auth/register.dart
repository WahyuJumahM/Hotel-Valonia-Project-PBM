import 'package:flutter/material.dart';
import 'login.dart'; // Pastikan file login.dart tersedia dan sudah di-route

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Buat Akun',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Daftar untuk mulai booking hotel favoritmu.',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(label: 'Nama Lengkap', hint: 'Masukkan nama lengkap Anda'),
              _buildTextField(label: 'Email', hint: 'Masukkan alamat email Anda'),
              _buildTextField(label: 'NIK', hint: 'Masukkan NIK Anda'),
              _buildTextField(label: 'No. Handphone', hint: 'Masukkan No. Handphone Anda'),
              _buildPasswordField(
                label: 'Password',
                hint: 'Masukkan kata sandi Anda',
                obscure: _obscurePassword,
                toggle: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              _buildPasswordField(
                label: 'Konfirmasi Password',
                hint: 'Konfirmasi kata sandi Anda',
                obscure: _obscureConfirmPassword,
                toggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: _agreeTerms,
                    onChanged: (value) {
                      setState(() => _agreeTerms = value ?? false);
                    },
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Dengan mendaftar, Anda setuju dengan ',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Syarat & Ketentuan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          TextSpan(
                            text: ' kami.',
                            style: TextStyle(fontFamily: 'Roboto'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _agreeTerms ? () {
                    // TODO: Implement register action
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Buat Akun',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontFamily: 'Roboto'),
          ),
          const SizedBox(height: 6),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontFamily: 'Roboto'),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontFamily: 'Roboto'),
          ),
          const SizedBox(height: 6),
          TextField(
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontFamily: 'Roboto'),
              filled: true,
              fillColor: Colors.grey[200],
              suffixIcon: IconButton(
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: toggle,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
