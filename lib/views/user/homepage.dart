import 'package:flutter/material.dart';
import '../../../widgets/user/bottom_nav.dart';
import '../../../widgets/user/rekomendasi_card.dart';
import '../../../widgets/user/list_room.dart';
import '../../../widgets/user/build_header_profil.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: isLandscape
              ? SingleChildScrollView(child: buildContent(context, isLandscape))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === Profil dengan Padding ===
                    Padding(
                      padding: const EdgeInsets.only(top: 16),  // Memberikan padding atas
                      child: const BuildHeaderProfil(),
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      "Rekomendasi untuk Anda",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: size.height * 0.25,
                      child: const RekomendasiCard(),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Kamar Tersedia",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    // === ListRoom Scroll di Portrait ===
                    const Expanded(child: ListRoom()),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }

  Widget buildContent(BuildContext context, bool isLandscape) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // === Profil dengan Padding ===
        Padding(
          padding: const EdgeInsets.only(top: 16),  // Memberikan padding atas
          child: const BuildHeaderProfil(),
        ),

        const SizedBox(height: 20),
        const Text(
          "Rekomendasi untuk Anda",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: size.height * 0.25,
          child: const RekomendasiCard(),
        ),
        const SizedBox(height: 20),
        const Text(
          "Kamar Tersedia",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // === ListRoom Scroll di Landscape (scroll semua) ===
        const ListRoom(),
        const SizedBox(height: 16),
      ],
    );
  }
}
