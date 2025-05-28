import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pembayaran.dart';

class DetailBooking extends StatefulWidget {
  const DetailBooking({super.key});

  @override
  State<DetailBooking> createState() => _DetailBookingState();
}

class _DetailBookingState extends State<DetailBooking> {
  DateTime? checkInDate;
  DateTime? checkOutDate;

  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn
          ? (checkInDate ?? DateTime.now())
          : (checkOutDate ?? DateTime.now().add(const Duration(days: 1))),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
          if (checkOutDate != null && checkOutDate!.isBefore(checkInDate!)) {
            checkOutDate = checkInDate!.add(const Duration(days: 1));
          }
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  void _handleBooking() {
    if (checkInDate == null || checkOutDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal Check-In dan Check-Out dulu.')),
      );
      return;
    }

    int hargaPerMalam = 1433270;
    int jumlahMalam = checkOutDate!.difference(checkInDate!).inDays;
    int adminFee = 15000;
    int totalBayar = (hargaPerMalam * jumlahMalam) + adminFee;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PembayaranPage(
          checkInDate: checkInDate!,
          checkOutDate: checkOutDate!,
          totalBayar: totalBayar,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemesanan'),
        centerTitle: true,
        actions: const [Icon(Icons.more_vert)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildDateBox(
                    'Check - In',
                    checkInDate != null ? _dateFormat.format(checkInDate!) : 'Pilih',
                    true),
                const SizedBox(width: 12),
                _buildDateBox(
                    'Check - Out',
                    checkOutDate != null ? _dateFormat.format(checkOutDate!) : 'Pilih',
                    false),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Text('Status :', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Text('Tersedia', style: TextStyle(color: Colors.green)),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Detail Kamar', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildRoomDetail(),
            const SizedBox(height: 20),
            const Text('Detail Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildPaymentDetail(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Booking', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDateBox(String label, String date, bool isCheckIn) {
    return Expanded(
      child: InkWell(
        onTap: () => _selectDate(context, isCheckIn),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Icon(Icons.calendar_today, size: 20),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomDetail() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/images/room.jpg',
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Kamar 101', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Superior Twin'),
              Text('Single bed - 2 orang', style: TextStyle(fontSize: 12, color: Colors.grey)),
              SizedBox(height: 6),
              Text('Rp.1,433,270 /malam', style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blueAccent.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text('lantai 2', style: TextStyle(color: Color.fromARGB(255, 240, 241, 241))),
        )
      ],
    );
  }

  Widget _buildPaymentDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total : 2 Malam'),
            Text('Rp.1,433,270 /malam'),
          ],
        ),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Biaya Admin'),
            Text('Rp.15,000,00'),
          ],
        ),
        Divider(height: 20, thickness: 1),
      ],
    );
  }
}
