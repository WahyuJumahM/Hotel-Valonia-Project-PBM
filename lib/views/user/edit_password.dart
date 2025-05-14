import 'package:flutter/material.dart';

class EditPasswordPage extends StatelessWidget {
  const EditPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    // Menggunakan MediaQuery untuk mendapatkan ukuran layar dan orientasi
    var screenSize = MediaQuery.of(context).size;
    var isLandscape = screenSize.width > screenSize.height; // Cek apakah layar dalam mode landscape

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ganti Password',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Nuansa biru muda
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView( // Agar bisa di scroll jika layar kecil
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password Lama',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password Baru',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password Baru',
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // TODO: Validasi & simpan perubahan password
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password berhasil diubah')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade300, // Warna biru muda untuk tombol
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              // Menambahkan padding lebih banyak saat layar dalam mode landscape
              if (isLandscape) ...[
                const SizedBox(height: 40),
                Text(
                  'Arahkan perangkat ke mode potrait untuk tampilan yang lebih baik.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
