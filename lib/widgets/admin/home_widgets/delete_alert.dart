import 'package:flutter/material.dart';
import '../../../models/admin/kamar_model.dart';

class DeleteRoomDialog extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteRoomDialog({super.key, required this.onDelete, required Kamar room});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Hapus Kamar'),
      content: Text('Apakah Anda yakin ingin menghapus kamar ?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Tutup dialog jika dibatalkan
          },
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            onDelete(); // Jalankan callback onDelete untuk menghapus kamar
            Navigator.pop(context); // Tutup dialog setelah penghapusan
          },
          child: const Text('Hapus'),
        ),
      ],
    );
  }
}
