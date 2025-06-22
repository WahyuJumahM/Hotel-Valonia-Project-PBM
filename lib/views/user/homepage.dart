//lib/views/user/homepage.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/user/bottom_nav.dart';
import '../../../widgets/user/rekomendasi_card.dart';
import '../../../widgets/user/list_room.dart';
import '../../../widgets/user/build_header_profil.dart';
import '../../viewmodels/user/user_profile_viewmodel.dart';
import '../../viewmodels/user/kamar_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load user profile saat halaman pertama kali dibuka
    _loadUserProfile();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadUserProfile() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfileViewModel = Provider.of<UserProfileViewModel>(context, listen: false);
      // Hanya load jika data belum ada dan tidak sedang loading
      if (userProfileViewModel.userProfile == null && !userProfileViewModel.isLoading) {
        userProfileViewModel.loadUserProfile();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        // Reset search filter
        context.read<KamarViewModel>().searchKamar('');
      }
    });
  }

  void _onSearchChanged(String query) {
    context.read<KamarViewModel>().searchKamar(query);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
          child: Column(
            children: [
              // Fixed Header Section
              Container(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: _buildHeaderSection(),
                ),
              ),
              
              // Scrollable Content
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Content Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            
                            // Rekomendasi Section (hide when searching)
                            if (!_isSearching) ...[
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
                            ],
                            
                            // Kamar Section Title
                            _buildSectionTitle(
                              _isSearching ? "Hasil Pencarian" : "Kamar Tersedia",
                              icon: _isSearching ? Icons.search_rounded : Icons.home_rounded,
                              color: Colors.blue[600]!,
                            ),
                            
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    
                    // List Room Section (Scrollable) - REMOVED WHITE CONTAINER
                    const SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverToBoxAdapter(
                        child: ListRoom(), // Direct ListRoom without container wrapper
                      ),
                    ),
                    
                    // Bottom padding
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 100),
                    ),
                  ],
                ),
              ),
            ],
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

  Widget _buildHeaderSection() {
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
      child: _isSearching ? _buildSearchBar() : _buildProfileHeader(),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        // Profile Section
        const Expanded(child: BuildHeaderProfil()),
        
        // Search Button
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.search_rounded,
              color: Colors.blue[600],
              size: 20,
            ),
          ),
          onPressed: _toggleSearch,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Cari nama kamar...',
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Colors.grey[400],
                size: 20,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: Colors.grey[600],
          ),
          onPressed: _toggleSearch,
        ),
      ],
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
}