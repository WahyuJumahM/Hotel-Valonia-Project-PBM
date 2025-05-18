import 'package:flutter/material.dart';
import '../../../models/admin/kamar_model.dart';
import '../../../models/admin/jenis_kamar_model.dart';
import '../../../models/admin/tipe_kasur_model.dart';
import '../../../widgets/admin/top_bar.dart';
import '../../../widgets/admin/search_bar.dart';
import '../../../widgets/admin/home_widgets/room_card.dart';
import '../../../widgets/admin/bottom_navbar.dart';
import 'add_room_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      Navigator.pushReplacementNamed(context, '/booking');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/laporan');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Kamar> rooms = List.generate(
      5,
      (index) => Kamar(
        idKamar: 'K00$index',
        stok: 10,
        jenisKamar: JenisKamar(
          idJenisKamar: 'JK00$index',
          deskripsi: 'Kamar nyaman dengan fasilitas lengkap.',
          harga: 1433270,
          kapasitas: 3,
          fotoKamar: 'assets/images/room.jpg',
          tipeKasur: TipeKasur(
            idTipeKasur: 'TK00$index',
            tipeKasur: ['Single Bed', 'Single Bed'],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SafeArea(
        child: Column(
          children: [
            const TopBar(),
            const CustomSearchBar(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Daftar Kamar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  return RoomCard(room: rooms[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddRoomScreen()),
          );
        },
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
