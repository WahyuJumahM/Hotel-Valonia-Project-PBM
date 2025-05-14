import 'package:flutter/material.dart';
import '../../../widgets/user/bottom_nav.dart';
import '../../../widgets/user/list_room_booking.dart';

class MyBookingPage extends StatelessWidget {
  const MyBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: const Padding(
            padding: EdgeInsets.only(top: 20), 
            child: Text(
              "Booking Saya",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                fontSize: 20,
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: ListRoomBooking(),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}
