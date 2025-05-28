import 'package:flutter/material.dart';

class RekomendasiCard extends StatelessWidget {
  const RekomendasiCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          RekomendasiItem(image: 'assets/images/view2.png', title: 'Immortal Twin'),
          RekomendasiItem(image: 'assets/images/view1.png', title: 'Superior Twin'),
          RekomendasiItem(image: 'assets/images/view2.png', title: 'Immortal Twin'),
          RekomendasiItem(image: 'assets/images/view1.png', title: 'Superior Twin'),
        ],
      ),
    );
  }
}

class RekomendasiItem extends StatelessWidget {
  final String image;
  final String title;

  const RekomendasiItem({required this.image, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // CircleAvatar sudah dihapus di sini
          Positioned(
            bottom: 12,
            left: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                const Text('Rp.1.433.270/malam',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
