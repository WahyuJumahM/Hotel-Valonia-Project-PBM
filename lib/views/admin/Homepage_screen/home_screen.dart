import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/admin/bottom_navbar.dart';
import '../../../widgets/admin/page_slider.dart';
import '../../../viewmodels/admin/admin_profile_viewmodel.dart';
import 'daftar_booking_screen.dart';
import 'daftar_permohonan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  final List<String> pageTitles = ['Daftar Booking', 'Permohonan'];

  @override
  void initState() {
    super.initState();
    // Load admin profile saat screen pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adminProfileViewModel = Provider.of<AdminProfileViewModel>(context, listen: false);
      if (adminProfileViewModel.adminProfile == null) {
        adminProfileViewModel.loadAdminProfile();
      }
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      currentPageIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildProfileImage(String? photoUrl, double radius) {
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(photoUrl),
        onBackgroundImageError: (exception, stackTrace) {
          // Jika gagal load dari network, fallback ke asset
          print('Error loading profile image: $exception');
        },
        child: photoUrl.isEmpty
            ? Icon(
                Icons.person,
                size: radius * 1.2,
                color: Colors.grey[600],
              )
            : null,
      );
    } else {
      // Default avatar jika tidak ada foto
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.blue.shade100,
        child: Icon(
          Icons.person,
          size: radius * 1.2,
          color: Colors.blue.shade600,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double avatarRadius = constraints.maxWidth > 600 ? 30 : 24;
        double titleFontSize = constraints.maxWidth > 600 ? 18 : 16;
        double subtitleFontSize = constraints.maxWidth > 600 ? 14 : 12;
        double sidePadding = constraints.maxWidth > 600 ? 24 : 16;
        
        // Cek orientasi
        final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
        final screenHeight = MediaQuery.of(context).size.height;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white,
                  Colors.blue.shade50.withOpacity(0.3),
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
            child: SafeArea(
              child: isLandscape 
                  ? _buildLandscapeLayout(constraints, avatarRadius, titleFontSize, subtitleFontSize, sidePadding, screenHeight)
                  : _buildPortraitLayout(constraints, avatarRadius, titleFontSize, subtitleFontSize, sidePadding),
            ),
          ),
          bottomNavigationBar: const BottomNavbar(currentIndex: 2),
        );
      },
    );
  }

  Widget _buildLandscapeLayout(BoxConstraints constraints, double avatarRadius, double titleFontSize, double subtitleFontSize, double sidePadding, double screenHeight) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          // Profile Section
          Padding(
            padding: EdgeInsets.fromLTRB(sidePadding + 8, 16, sidePadding, 8),
            child: _buildProfileSection(avatarRadius, titleFontSize, subtitleFontSize),
          ),
          const SizedBox(height: 6),
          
          // Page Slider
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sidePadding + 4),
            child: PageSlider(
              currentIndex: currentPageIndex,
              onPageChanged: _onPageChanged,
              titles: pageTitles,
            ),
          ),
          const SizedBox(height: 6),
          
          // Page Content dengan height yang fixed untuk landscape
          Container(
            margin: EdgeInsets.symmetric(horizontal: sidePadding),
            height: screenHeight * 0.7, // Tinggi yang cukup untuk konten
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPageIndex = index;
                  });
                },
                children: const [
                  DaftarBookingScreen(),
                  DaftarPermohonanScreen(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20), // Extra padding di bawah
        ],
      ),
    );
  }

  Widget _buildPortraitLayout(BoxConstraints constraints, double avatarRadius, double titleFontSize, double subtitleFontSize, double sidePadding) {
    return Column(
      children: [
        // Profile Section
        Padding(
          padding: EdgeInsets.fromLTRB(sidePadding + 8, 16, sidePadding, 8),
          child: _buildProfileSection(avatarRadius, titleFontSize, subtitleFontSize),
        ),
        const SizedBox(height: 6),
        
        // Page Slider
        Padding(
          padding: EdgeInsets.symmetric(horizontal: sidePadding + 4),
          child: PageSlider(
            currentIndex: currentPageIndex,
            onPageChanged: _onPageChanged,
            titles: pageTitles,
          ),
        ),
        const SizedBox(height: 6),
        
        // Page Content yang expandable untuk portrait
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: sidePadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPageIndex = index;
                  });
                },
                children: const [
                  DaftarBookingScreen(),
                  DaftarPermohonanScreen(),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildProfileSection(double avatarRadius, double titleFontSize, double subtitleFontSize) {
    return Consumer<AdminProfileViewModel>(
      builder: (context, adminProfileVM, child) {
        // Tampilkan loading indicator jika sedang memuat
        if (adminProfileVM.isLoading) {
          return Row(
            children: [
              CircleAvatar(
                radius: avatarRadius,
                backgroundColor: Colors.grey.shade200,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: titleFontSize,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 160,
                    height: subtitleFontSize,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        // Tampilkan error jika ada
        if (adminProfileVM.errorMessage != null) {
          return Row(
            children: [
              CircleAvatar(
                radius: avatarRadius,
                backgroundColor: Colors.red.shade100,
                child: Icon(
                  Icons.error,
                  color: Colors.red.shade600,
                  size: avatarRadius * 1.2,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Error',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: titleFontSize,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      adminProfileVM.errorMessage!,
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.red.shade700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  adminProfileVM.loadAdminProfile();
                },
                icon: Icon(
                  Icons.refresh,
                  color: Colors.red.shade600,
                ),
              ),
            ],
          );
        }

        // Tampilkan data profil admin
        return Row(
          children: [
            _buildProfileImage(adminProfileVM.adminPhoto, avatarRadius),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adminProfileVM.adminName.isNotEmpty
                        ? adminProfileVM.adminName
                        : 'Administrator',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleFontSize,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    adminProfileVM.adminEmail.isNotEmpty
                        ? adminProfileVM.adminEmail
                        : 'admin@valonia.com',
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      color: Colors.black54,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}