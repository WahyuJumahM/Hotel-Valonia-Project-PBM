import 'package:flutter/material.dart';

class ListRoom extends StatelessWidget {
  const ListRoom({super.key});

  @override
  Widget build(BuildContext context) {
    final rooms = [
      {
        "image": "assets/images/room-view1.png",
        "name": "Kamar Superior Twin",
        "price": "Rp.1.433.270",
        "rating": 4.0
      },
      {
        "image": "assets/images/room-view2.png",
        "name": "Kamar Immortal Twin",
        "price": "Rp.1.433.270",
        "rating": 3.8
      },
      {
        "image": "assets/images/room-view1.png",
        "name": "Kamar Glory Twin",
        "price": "Rp.1.433.270",
        "rating": 3.9
      },
      {
        "image": "assets/images/room-view1.png",
        "name": "Kamar Superior Twin",
        "price": "Rp.1.433.270",
        "rating": 4.0
      },
      {
        "image": "assets/images/room-view2.png",
        "name": "Kamar Immortal Twin",
        "price": "Rp.1.433.270",
        "rating": 3.8
      },
      {
        "image": "assets/images/room-view1.png",
        "name": "Kamar Glory Twin",
        "price": "Rp.1.433.270",
        "rating": 3.9
      },
      {
        "image": "assets/images/room-view1.png",
        "name": "Kamar Superior Twin",
        "price": "Rp.1.433.270",
        "rating": 4.0
      },
      {
        "image": "assets/images/room-view2.png",
        "name": "Kamar Immortal Twin",
        "price": "Rp.1.433.270",
        "rating": 3.8
      },
      {
        "image": "assets/images/room-view1.png",
        "name": "Kamar Glory Twin",
        "price": "Rp.1.433.270",
        "rating": 3.9
      },
      {
        "image": "assets/images/room-view1.png",
        "name": "Kamar Superior Twin",
        "price": "Rp.1.433.270",
        "rating": 4.0
      },
      {
        "image": "assets/images/room-view2.png",
        "name": "Kamar Immortal Twin",
        "price": "Rp.1.433.270",
        "rating": 3.8
      },
      {
        "image": "assets/images/room-view1.png",
        "name": "Kamar Glory Twin",
        "price": "Rp.1.433.270",
        "rating": 3.9
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(), // biar bisa discroll
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              room['image'] as String,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(room['name'] as String),
          subtitle: Text('${room['price']}/malam'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text(room['rating'].toString()),
            ],
          ),
        );
      },
    );
  }
}
