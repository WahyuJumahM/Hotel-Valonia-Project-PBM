import 'package:flutter/material.dart';
import '../../../models/admin/kamar_model.dart';
import '../../../views/admin/home_screen/add_room_screen.dart';
import '../../../widgets/admin/home_widgets/delete_alert.dart';

class DetailScreen extends StatelessWidget {
  final Kamar kamar;

  const DetailScreen({super.key, required this.kamar});

  @override
  Widget build(BuildContext context) {
    final jenisKamar = kamar.jenisKamar;
    final kasur = jenisKamar.formattedKasur;

    const roboto = TextStyle(fontFamily: 'Roboto');
    const robotoBold = TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Image.asset(
                        jenisKamar.fotoKamar ?? 'assets/images/room.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kamar.jenisKamar.deskripsi,
                          style: robotoBold.copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.bed, size: 18, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              kasur,
                              style: roboto.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.person, size: 18, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              '${jenisKamar.kapasitas} orang',
                              style: roboto.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.inventory, size: 18, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              'Stok ${kamar.stok}',
                              style: roboto.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text('Deskripsi', style: robotoBold),
                        const SizedBox(height: 8),
                        Text(
                          jenisKamar.deskripsi,
                          style: roboto.copyWith(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 20),
                        Text('Fasilitas:', style: robotoBold),
                        const SizedBox(height: 8),
                        ...jenisKamar.tipeKasur.tipeKasur.map(
                          (f) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                const Icon(Icons.check, size: 18, color: Colors.blue),
                                const SizedBox(width: 8),
                                Text(f, style: roboto),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, -1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rp ${jenisKamar.harga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}',
                          style: robotoBold.copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 4),
                        const Text('per malam', style: roboto),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddRoomScreen(
                            kamar: kamar,
                            isEditMode: true,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteRoomDialog(
                            room: kamar,
                            onDelete: () {
                              // TODO: Ganti dengan logika penghapusan sesungguhnya
                              print('Kamar telah dihapus');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Kamar berhasil dihapus.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              Navigator.pop(context); // Keluar dari halaman detail
                            },
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Hapus',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
