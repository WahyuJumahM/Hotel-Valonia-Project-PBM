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
      backgroundColor: Colors.grey[50], // Background yang lebih soft
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[50]!,
                Colors.white,
              ],
              stops: const [0.0, 0.3],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: isLandscape
                ? SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: buildContent(context, isLandscape),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // === Header Profil dengan Card Style ===
                      _buildProfileSection(),
                      
                      const SizedBox(height: 24),
                      
                      // === Section Rekomendasi ===
                      _buildSectionTitle(
                        "Rekomendasi untuk Anda",
                        icon: Icons.star_rounded,
                        color: Colors.amber[600]!,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      SizedBox(
                        height: size.height * 0.28,
                        child: const RekomendasiCard(),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // === Section Kamar Tersedia ===
                      _buildSectionTitle(
                        "Kamar Tersedia",
                        icon: Icons.home_rounded,
                        color: Colors.blue[600]!,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // === ListRoom dengan Enhanced Design ===
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: const ListRoom(),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: const BottomNav(currentIndex: 0),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const BuildHeaderProfil(),
    );
  }

  Widget _buildSectionTitle(String title, {required IconData icon, required Color color}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget buildContent(BuildContext context, bool isLandscape) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // === Profile Section untuk Landscape ===
        _buildProfileSection(),
        
        const SizedBox(height: 24),
        
        // === Rekomendasi Section ===
        _buildSectionTitle(
          "Rekomendasi untuk Anda",
          icon: Icons.star_rounded,
          color: Colors.amber[600]!,
        ),
        
        const SizedBox(height: 16),
        
        Container(
          height: size.height * 0.28,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: const RekomendasiCard(),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // === Kamar Tersedia Section ===
        _buildSectionTitle(
          "Kamar Tersedia",
          icon: Icons.home_rounded,
          color: Colors.blue[600]!,
        ),
        
        const SizedBox(height: 16),
        
        // === ListRoom untuk Landscape ===
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: const ListRoom(),
          ),
        ),
        
        const SizedBox(height: 24),
      ],
    );
  }
}