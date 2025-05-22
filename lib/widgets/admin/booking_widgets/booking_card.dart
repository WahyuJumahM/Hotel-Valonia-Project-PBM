import 'package:flutter/material.dart';
import '../../../widgets/admin/status_badge.dart';
import '../../../views/admin/booking_screen/detail_booking_screen.dart'; // Pastikan DetailBookingScreen diimpor

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking; // Gunakan data statis Map
  final int index;
  final void Function(int, String) onUpdateStatus;

  const BookingCard({
    super.key,
    required this.booking,
    required this.index,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman DetailBookingScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailBookingScreen(booking: booking),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: Image.asset(
                      booking['image'] ?? 'assets/images/room.jpg',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking['name'] ?? 'Kamar Tidak Ditemukan',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              StatusBadge(status: booking['status'] ?? 'Menunggu'),
                              if (booking['status'] == 'Berlangsung' || booking['status'] == 'Selesai') ...[
                                const SizedBox(width: 6),
                                const StatusBadge(status: 'Disetujui'),
                              ],
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rp ${booking['price'].toStringAsFixed(0)} /malam',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Tanggal ${booking['date'] ?? 'Tidak Tersedia'}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (booking['status'] == 'Menunggu')
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => onUpdateStatus(index, 'Berlangsung'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Disetujui',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => onUpdateStatus(index, 'Dibatalkan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(
                            Icons.clear,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Dibatalkan',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
