import 'package:flutter/material.dart';
import '../../../models/admin/kamar_model.dart';
import '../../../views/admin/home_screen/detail_screen.dart';

class RoomCard extends StatelessWidget {
  final Kamar room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final jenisKamar = room.jenisKamar;
    final kasur = jenisKamar.formattedKasur;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(kamar: room),
            ),
          );
        },
        child: SizedBox(
          height: 140,
          width: MediaQuery.of(context).size.width - 16, // Ukuran tetap
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                  child: Image.asset(
                    jenisKamar.fotoKamar ?? 'assets/images/room.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kamar ${jenisKamar.idJenisKamar}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        kasur,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.person, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'Kapasitas: ${jenisKamar.kapasitas} orang',
                            style: const TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.bed, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'Stok: ${room.stok} kamar tersedia',
                            style: const TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Rp ${jenisKamar.harga.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
