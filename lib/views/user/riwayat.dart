import 'package:flutter/material.dart';
import '../../widgets/user/bottom_nav.dart';
import '../../widgets/user/list_room_riwayat.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(254, 247, 255, 0.886),
          elevation: 0,
          title: const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Riwayat",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SearchBarWidget(),
            SizedBox(height: 16),
            Expanded(child: ListRoomRiwayat()),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }
}
