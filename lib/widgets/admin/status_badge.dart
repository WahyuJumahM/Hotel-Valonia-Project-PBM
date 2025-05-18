import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    switch (status) {
      case 'Menunggu':
        bgColor = Colors.amber;
        break;
      case 'Berlangsung':
      case 'Selesai':
        bgColor = Colors.grey;
        break;
      case 'Disetujui':
        bgColor = Colors.green;
        break;
      case 'Dibatalkan':
        bgColor = Colors.red;
        break;
      default:
        bgColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
