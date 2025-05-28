import 'package:flutter/material.dart';
import '/views/user/detail_kamar.dart'; // ganti dengan nama project kamu

class ListRoom extends StatelessWidget {
  const ListRoom({super.key});

  @override
  Widget build(BuildContext context) {
    final rooms = [
      {
        "image": "assets/images/room-view1.png",
        "name": "Superior Twin",
        "price": "Rp.1.433.270",
      },
      {
        "image": "assets/images/room-view2.png",
        "name": "Immortal Twin",
        "price": "Rp.1.433.270",
      },
      {
        "image": "assets/images/room-view1.png",
        "name": "Glory Twin",
        "price": "Rp.1.433.270",
      },
      {
        "image": "assets/images/room-view1.png",
        "name": "Superior Twin",
        "price": "Rp.1.433.270",
      },
      {
        "image": "assets/images/room-view2.png",
        "name": "Immortal Twin",
        "price": "Rp.1.433.270",
      },
      {
        "image": "assets/images/room-view1.png",
        "name": "Glory Twin",
        "price": "Rp.1.433.270",
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              room['image']!,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(room['name']!),
          subtitle: Text('${room['price']}/malam'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DetailKamar()),
            );
          },
        );
      },
    );
  }
}
