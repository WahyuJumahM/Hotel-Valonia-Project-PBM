import 'package:flutter/material.dart';

class KebijakanPrivasiPage extends StatelessWidget {
  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Syarat & Ketentuan',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white, // Warna teks AppBar jadi putih
          ),
        ),
        backgroundColor: Colors.indigo,
        iconTheme: IconThemeData(color: Colors.white), // Kalau ada icon back nanti tetap putih
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Syarat & Ketentuan Hotel Valonia',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '''
Selamat datang di Aplikasi Reservasi Hotel Valonia. Dengan menggunakan aplikasi ini, Anda menyetujui syarat dan ketentuan berikut:

1. **Reservasi Kamar**
   - Reservasi dilakukan melalui aplikasi dan hanya berlaku setelah pembayaran dikonfirmasi.
   - Data pemesanan wajib diisi dengan benar.

2. **Pembatalan & Pengembalian Dana**
   - Pembatalan dilakukan maksimal 24 jam sebelum waktu check-in.
   - Pengembalian dana mengikuti ketentuan hotel dan dipotong biaya administrasi jika berlaku.

3. **Data Pribadi**
   - Data Anda hanya digunakan untuk keperluan reservasi dan pelayanan hotel.
   - Kami menjaga kerahasiaan data Anda sesuai kebijakan privasi yang berlaku.

4. **Hak & Kewajiban**
   - Hotel Valonia berhak menolak reservasi apabila terdapat pelanggaran syarat & ketentuan.
   - Pengguna wajib mematuhi seluruh ketentuan selama menginap.

5. **Perubahan Ketentuan**
   - Hotel Valonia berhak mengubah syarat & ketentuan tanpa pemberitahuan sebelumnya.

Dengan melanjutkan penggunaan aplikasi ini, Anda dianggap telah membaca dan menyetujui seluruh syarat & ketentuan di atas.

''',
                style: TextStyle(fontFamily: 'Roboto', fontSize: 14),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Pindah ke halaman login admin
                    Navigator.pushNamed(context, '/login_admin');
                  },
                  child: Text(
                    'Admin Login',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.white, // Teks putih
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Tombol hijau
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
