import 'package:flutter/material.dart';
import '../../widgets/user/bottom_nav.dart';
import '../../widgets/user/list_room_riwayat.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // background scaffold putih
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,  // appbar putih sama dengan scaffold
          elevation: 0,
          surfaceTintColor: Colors.white,  // agar tidak berubah warna saat discroll
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
        child: ListRoomRiwayat(),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }
}
