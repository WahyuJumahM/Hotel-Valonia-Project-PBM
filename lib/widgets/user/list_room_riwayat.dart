import 'package:flutter/material.dart';
import '/widgets/user/popup_detail.dart';  // pastikan widget ini ada

class ListRoomRiwayat extends StatelessWidget {
  const ListRoomRiwayat({super.key});

  void showBookingDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const BookingDetailPopup(),
    );
  }

  Widget bookingCard({
    required BuildContext context,
    required String imageUrl,
    required String status,
    required Color statusColor,
    required String roomName,
    required String price,
    required String dateRange,
    required String guestInfo,
  }) {
    return GestureDetector(
      onTap: () => showBookingDetailDialog(context),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 16),
        color: Colors.white.withOpacity(0.95),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.9),
                const Color(0xFFF8FBFF).withOpacity(0.8),
              ],
            ),
          ),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status badge with gradient & shadow
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: statusColor.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        roomName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF34495E),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Color(0xFF7F8C8D)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              dateRange,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.person, size: 16, color: Color(0xFF7F8C8D)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              guestInfo,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Column(
          children: [
            bookingCard(
              context: context,
              imageUrl: 'assets/images/hotel.jpg',
              status: 'Selesai',
              statusColor: Colors.green,
              roomName: 'Kamar Superior Twin',
              price: 'Rp.1,433,270 /malam',
              dateRange: 'Tanggal 12 - 14 Nov 2024',
              guestInfo: '2 Tamu (1 Ruangan)',
            ),
            bookingCard(
              context: context,
              imageUrl: 'assets/images/hotel.jpg',
              status: 'Selesai',
              statusColor: Colors.green,
              roomName: 'Kamar Superior Twin',
              price: 'Rp.1,433,270 /malam',
              dateRange: 'Tanggal 12 - 14 Nov 2024',
              guestInfo: '2 Tamu (1 Ruangan)',
            ),
            bookingCard(
              context: context,
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
