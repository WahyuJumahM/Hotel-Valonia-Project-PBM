import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'mybooking.dart';
// import 'bottom_nav.dart'; // pastikan file bottom_nav.dart ini sesuai nama file kamu ya

class PembayaranPage extends StatefulWidget {
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int totalBayar;

  const PembayaranPage({
    super.key,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalBayar,
  });

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  int? _selectedMetode;

  final List<Map<String, dynamic>> metodePembayaran = [
    {
      "icon": Icons.account_balance_wallet,
      "title": "GoPay",
      "subtitle": "Saldo: Rp1.000.000",
      "utama": true,
    },
    {
      "icon": Icons.payments,
      "title": "PayLater",
      "subtitle": "Saldo: Rp500.000",
      "utama": false,
    },
    {
      "icon": Icons.credit_card,
      "title": "Debit BCA",
      "subtitle": "**2602",
      "utama": false,
    },
    {
      "icon": Icons.credit_card,
      "title": "XX 2602",
      "subtitle": "",
      "utama": false,
    },
  ];

  void _navigateToSuccess() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PembayaranBerhasilPage(
          totalBayar: widget.totalBayar,
          checkInDate: widget.checkInDate,
          checkOutDate: widget.checkOutDate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Metode Pembayaran')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: metodePembayaran.length,
              itemBuilder: (context, index) {
                final metode = metodePembayaran[index];
                return ListTile(
                  leading: Icon(metode["icon"]),
                  title: Row(
                    children: [
                      Text(metode["title"]),
                      if (metode["utama"] == true)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Utama',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  subtitle:
                      metode["subtitle"] != '' ? Text(metode["subtitle"]) : null,
                  trailing: Radio(
                    value: index,
                    groupValue: _selectedMetode,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedMetode = value;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _selectedMetode = index;
                    });
                  },
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.add_card),
            title: const Text("Kartu kredit atau debit"),
            subtitle: const Text("Visa, Mastercard, AMEX, dan JCB"),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: _selectedMetode != null ? _navigateToSuccess : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.lightBlueAccent, // warna biru muda
                foregroundColor: Colors.white, // teks putih
              ),
              child: const Text("Bayar"),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class PembayaranBerhasilPage extends StatelessWidget {
  final int totalBayar;
  final DateTime checkInDate;
  final DateTime checkOutDate;

  const PembayaranBerhasilPage({
    super.key,
    required this.totalBayar,
    required this.checkInDate,
    required this.checkOutDate,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 100),
                const SizedBox(height: 20),
                const Text(
                  "Pembayaran Berhasil",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          "Total Pembayaran",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Rp.${totalBayar.toString()}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        _buildDetailRow(
                          "Check-In",
                          dateFormat.format(checkInDate),
                        ),
                        _buildDetailRow(
                          "Check-Out",
                          dateFormat.format(checkOutDate),
                        ),
                        _buildDetailRow("Nomor Pesanan", "2303060059V-0002"),
                        _buildDetailRow(
                          "Tanggal Pembayaran",
                          DateFormat(
                            'dd MMM yyyy, HH:mm',
                          ).format(DateTime.now()),
                        ),
                        _buildDetailRow("Nama Kasir", "Valonia Front Desk"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Navigasi ke halaman utama dengan BottomNavigationBar di index 1
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyBookingPage(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    foregroundColor: Colors.white, // teks putih
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Lanjutkan"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value)],
      ),
    );
  }
}
