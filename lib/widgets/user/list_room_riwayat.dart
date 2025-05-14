import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }
}

class ListRoomRiwayat extends StatelessWidget {
  const ListRoomRiwayat({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            // Biar dia nggak overflow, kasih Expanded di child kedua
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // status badge
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
                      Expanded(
                        child: Text(dateRange,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(guestInfo,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                            overflow: TextOverflow.ellipsis),
                      ),
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
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            bookingCard(
              imageUrl: 'assets/images/hotel.jpg',
              status: 'Selesai',
              statusColor: Colors.green,
              roomName: 'Kamar Superior Twin',
              price: 'Rp.1,433,270 /malam',
              dateRange: 'Tanggal 12 - 14 Nov 2024',
              guestInfo: '2 Tamu (1 Ruangan)',
            ),
            bookingCard(
              imageUrl: 'assets/images/hotel.jpg',
              status: 'Selesai',
              statusColor: Colors.green,
              roomName: 'Kamar Superior Twin',
              price: 'Rp.1,433,270 /malam',
              dateRange: 'Tanggal 12 - 14 Nov 2024',
              guestInfo: '2 Tamu (1 Ruangan)',
            ),
            bookingCard(
              imageUrl: 'assets/images/hotel.jpg',
              status: 'Ditolak',
              statusColor: Colors.red,
              roomName: 'Kamar Superior Twin',
              price: 'Rp.1,433,270 /malam',
              dateRange: 'Tanggal 12 - 14 Nov 2024',
              guestInfo: '2 Tamu (1 Ruangan)',
            ),
          ],
        ),
      ),
    );
  }
}
