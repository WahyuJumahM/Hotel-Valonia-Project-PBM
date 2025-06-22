import 'package:flutter/material.dart';

class KebijakanPrivasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Syarat & Ketentuan',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.indigo[700],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.indigo[700]!,
                    Colors.indigo[500]!,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 48,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Syarat & Ketentuan',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Hotel Valonia',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Content Section
            Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat datang di Aplikasi Reservasi Hotel Valonia. Dengan menggunakan aplikasi ini, Anda menyetujui syarat dan ketentuan berikut:',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 15,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    _buildTermsItem(
                      icon: Icons.hotel,
                      title: 'Reservasi Kamar',
                      content: '• Reservasi dilakukan melalui aplikasi dan hanya berlaku setelah pembayaran dikonfirmasi.\n• Data pemesanan wajib diisi dengan benar.',
                    ),
                    
                    _buildTermsItem(
                      icon: Icons.cancel_outlined,
                      title: 'Pembatalan & Pengembalian Dana',
                      content: '• Pembatalan dilakukan maksimal 24 jam sebelum waktu check-in.\n• Pengembalian dana mengikuti ketentuan hotel dan dipotong biaya administrasi jika berlaku.',
                    ),
                    
                    _buildTermsItem(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Data Pribadi',
                      content: '• Data Anda hanya digunakan untuk keperluan reservasi dan pelayanan hotel.\n• Kami menjaga kerahasiaan data Anda sesuai kebijakan privasi yang berlaku.',
                    ),
                    
                    _buildTermsItem(
                      icon: Icons.gavel_outlined,
                      title: 'Hak & Kewajiban',
                      content: '• Hotel Valonia berhak menolak reservasi apabila terdapat pelanggaran syarat & ketentuan.\n• Pengguna wajib mematuhi seluruh ketentuan selama menginap.',
                    ),
                    
                    _buildTermsItem(
                      icon: Icons.update_outlined,
                      title: 'Perubahan Ketentuan',
                      content: '• Hotel Valonia berhak mengubah syarat & ketentuan tanpa pemberitahuan sebelumnya.',
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),
            
            // Footer Section
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 24),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue[700],
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Dengan melanjutkan penggunaan aplikasi ini, Anda dianggap telah membaca dan menyetujui seluruh syarat & ketentuan di atas.',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: Colors.blue[800],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsItem({
    required IconData icon,
    required String title,
    required String content,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.indigo[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.indigo[600],
                size: 20,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    content,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          SizedBox(height: 20),
          Divider(color: Colors.grey[200]),
          SizedBox(height: 20),
        ],
      ],
    );
  }
}