import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          // Logo Hotel
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          const SizedBox(width: 12),
          // Nama dan Lokasi Hotel
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Hotel Valonia',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    'San Diego, CA',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          // Icon keluar
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.logout, size: 20, color: Colors.red),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login_admin');
              },
            ),
          ),
        ],
      ),
    );
  }
}
