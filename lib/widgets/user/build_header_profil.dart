import 'package:flutter/material.dart';

class BuildHeaderProfil extends StatelessWidget {
  const BuildHeaderProfil({super.key});

  @override
  Widget build(BuildContext context) {
    // Data yang sebelumnya statis
    final String name = "Wahyu Jum'ah M";
    final String location = "San Diego, CA";

    return Row(
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage('assets/images/profile-user.png'),
          radius: 20,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(location, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        const Spacer(),
        IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
        // IconButton(icon: const Icon(Icons.search), onPressed: () {}),
      ],
    );
  }
}
