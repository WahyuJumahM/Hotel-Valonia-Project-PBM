import 'package:flutter/material.dart';

class ListRoomBooking extends StatelessWidget {
  const ListRoomBooking({super.key});

  Widget bookingCard({
    required String imageUrl,
    required String status,
    required Color statusColor,
    required String roomName,
    required String price,
    required String dateRange,
    required String guestInfo,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    roomName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(price, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(dateRange, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(guestInfo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        bookingCard(
          imageUrl: 'assets/images/hotel.jpg',
          status: 'Menunggu',
          statusColor: Colors.orange,
          roomName: 'Kamar Superior Twin',
          price: 'Rp1,433,270 /malam',
          dateRange: '12 – 14 Nov 2024',
          guestInfo: '2 Tamu(1 Ruangan)',
        ),
        bookingCard(
          imageUrl: 'assets/images/hotel.jpg',
          status: 'Disetujui',
          statusColor: Colors.blue,
          roomName: 'Kamar Superior Twin',
          price: 'Rp1,433,270 /malam',
          dateRange: '12 – 14 Nov 2024',
          guestInfo: '2 Tamu(1 Ruangan)',
        ),
        bookingCard(
          imageUrl: 'assets/images/hotel.jpg',
          status: 'Menunggu',
          statusColor: Colors.orange,
          roomName: 'Kamar Superior Twin',
          price: 'Rp1,433,270 /malam',
          dateRange: '12 – 14 Nov 2024',
          guestInfo: '2 Guests (1 Room)',
        ),
      ],
    );
  }
}
