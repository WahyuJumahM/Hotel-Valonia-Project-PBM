import 'package:flutter/material.dart';
import '../../../models/admin/kamar_model.dart';
import '../../../views/admin/home_screen/detail_screen.dart';  // Import DetailScreen

class RoomCard extends StatelessWidget {
  final Kamar room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final jenisKamar = room.jenisKamar;
    final kasur = jenisKamar.formattedKasur;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          // Arahkan ke DetailScreen dengan membawa data kamar
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(kamar: room), // Mengarahkan ke DetailScreen
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto kamar
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                jenisKamar.fotoKamar ?? 'assets/images/room.jpg',
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            // Info kamar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kamar ${jenisKamar.idJenisKamar}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(kasur, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('Kapasitas: ${jenisKamar.kapasitas} orang'),
                  const SizedBox(height: 4),
                  Text('Stok: ${room.stok} kamar tersedia'),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${jenisKamar.harga.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
