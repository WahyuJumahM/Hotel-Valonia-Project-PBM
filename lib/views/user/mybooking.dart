//lib/views/user/mybooking.dart
import 'package:flutter/material.dart';
import '../../../widgets/user/bottom_nav.dart';
import '../../../widgets/user/list_room_booking.dart';

class MyBookingPage extends StatelessWidget {
  const MyBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue[700],
          elevation: 0,
          surfaceTintColor: Colors.white, // Biar nggak berubah pas discroll
          title: const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Booking Saya",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                fontSize: 20,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: const Padding(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
          child: ListRoomBooking(),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}
