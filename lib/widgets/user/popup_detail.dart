import 'package:flutter/material.dart';

class BookingDetailPopup extends StatelessWidget {
  const BookingDetailPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFE6F0FA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Detail Booking',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black87,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _BookingNamaKamar(value: '101'),
            SizedBox(height: 8),
            _BookingDetailItem(label: 'Lantai', value: '2'),
            _BookingDetailItem(label: 'Jenis Kamar', value: 'Deluxe'),
            _BookingDetailItem(label: 'Check-in', value: '12 Nov 2024'),
            _BookingDetailItem(label: 'Check-out', value: '14 Nov 2024'),
            _BookingDetailItem(label: 'Status', value: 'Menunggu'),
            _BookingDetailItem(label: 'Harga', value: 'Rp1,433,270 /malam'),
            _BookingDetailItem(label: 'Tipe Kasur', value: 'Single bed'),
            _BookingDetailItem(label: 'Kapasitas', value: '2 orang'),
            _BookingDetailItem(label: 'Catatan', value: '-'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _showCancelConfirmation(context);
          },
          child: const Text(
            'Batalkan Booking',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Tutup',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Konfirmasi Pembatalan'),
          content: const Text(
            'Apakah Anda yakin ingin membatalkan booking? Tindakan ini tidak dapat diulang.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog konfirmasi
                Navigator.of(context).pop(); // Tutup dialog detail
                _showSnackbar(context); // Tampilkan snackbar
              },
              child: const Text(
                'Ya, Batalkan',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Proses pembatalan booking Anda sedang dalam pengajuan.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }
}

class _BookingNamaKamar extends StatelessWidget {
  final String value;

  const _BookingNamaKamar({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF4FC3F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Nama Kamar: $value',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _BookingDetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _BookingDetailItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 16),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
