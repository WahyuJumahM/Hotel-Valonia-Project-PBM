import 'package:flutter/material.dart';
import '../../../widgets/admin/app_bar.dart';
import '../../../widgets/admin/bottom_navbar.dart';
import '../../../widgets/admin/booking_widgets/booking_card.dart';
import '../../../widgets/admin/search_bar.dart'; // pastikan path benar

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _currentIndex = 1;

  List<Map<String, dynamic>> bookings = [
    {
      'name': 'Kamar Superior Twin',
      'price': 1500000,
      'image': 'assets/images/room.jpg',
      'status': 'Menunggu',
      'date': '12 - 14 Nov 2025'
    },
    {
      'name': 'Kamar Superior Twin',
      'price': 1500000,
      'image': 'assets/images/room.jpg',
      'status': 'Berlangsung',
      'date': '12 - 14 Nov 2025'
    },
    {
      'name': 'Kamar Superior Twin',
      'price': 1500000,
      'image': 'assets/images/room.jpg',
      'status': 'Selesai',
      'date': '12 - 14 Nov 2025'
    },
  ];

  void updateStatus(int index, String newStatus) {
    setState(() {
      bookings[index]['status'] = newStatus;
    });
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/homepage_admin');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/laporan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // background putih murni
      appBar: CustomAppBar(
        title: 'Booking',
        showBackButton: true,
        onBack: () => Navigator.pushReplacementNamed(context, '/homepage_admin'),
      ),
      bottomNavigationBar: BottomNavbar(currentIndex: _currentIndex),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomSearchBar(),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daftar Reservasi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'See All',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return BookingCard(
                    booking: booking,
                    index: index,
                    onUpdateStatus: updateStatus,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
