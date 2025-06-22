// lib/widgets/user/list_room.dart (Compact Version with Reduced Height & Spacing)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/user/kamar_viewmodel.dart';
import '/views/user/detail_kamar.dart';

class ListRoom extends StatefulWidget {
  const ListRoom({super.key});

  @override
  State<ListRoom> createState() => _ListRoomState();
}

class _ListRoomState extends State<ListRoom> with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize shimmer animation
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
    
    // Start shimmer animation
    _shimmerController.repeat();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KamarViewModel>().loadAllKamar();
    });
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Widget _buildRoomImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: 80, // Reduced from 100
        height: 60, // Reduced from 70
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10), // Reduced from 12
        ),
        child: const Icon(
          Icons.image_not_supported,
          size: 24, // Reduced from 28
          color: Colors.grey,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          width: 80, // Reduced from 100
          height: 60, // Reduced from 70
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), // Reduced from 12
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06), // Reduced opacity
                spreadRadius: 0,
                blurRadius: 4, // Reduced from 6
                offset: const Offset(0, 1), // Reduced from (0, 2)
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // Reduced from 12
                child: Image.network(
                  imageUrl,
                  width: 80, // Reduced from 100
                  height: 60, // Reduced from 70
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80, // Reduced from 100
                      height: 60, // Reduced from 70
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10), // Reduced from 12
                      ),
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 24, // Reduced from 28
                        color: Colors.grey,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 80, // Reduced from 100
                      height: 60, // Reduced from 70
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10), // Reduced from 12
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                          color: Colors.blue[600],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Shimmer overlay
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Reduced from 12
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [
                          _shimmerAnimation.value - 0.3,
                          _shimmerAnimation.value,
                          _shimmerAnimation.value + 0.3,
                        ],
                        colors: const [
                          Colors.transparent,
                          Colors.white24,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24), // Reduced from 32
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16), // Reduced from 20
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(40), // Reduced from 50
              ),
              child: Icon(
                icon, 
                size: 40, // Reduced from 48
                color: Colors.grey[400]
              ),
            ),
            const SizedBox(height: 16), // Reduced from 20
            Text(
              message,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 15, // Reduced from 16
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KamarViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Container(
            padding: const EdgeInsets.all(24), // Reduced from 32
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.blue[600],
                strokeWidth: 3,
              ),
            ),
          );
        }

        if (viewModel.errorMessage.isNotEmpty) {
          return Container(
            padding: const EdgeInsets.all(24), // Reduced from 32
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12), // Reduced from 16
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(40), // Reduced from 50
                    ),
                    child: Icon(Icons.error_outline, size: 32, color: Colors.red[400]), // Reduced from 40
                  ),
                  const SizedBox(height: 12), // Reduced from 16
                  Text(
                    'Gagal memuat data kamar',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15, // Reduced from 16
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10), // Reduced from 12
                  ElevatedButton(
                    onPressed: () {
                      viewModel.loadAllKamar();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Reduced padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Reduced from 12
                      ),
                    ),
                    child: const Text(
                      'Coba Lagi',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (viewModel.allKamar.isEmpty) {
          return _buildEmptyState(
            viewModel.searchQuery.isNotEmpty 
                ? 'Tidak ada kamar yang cocok dengan pencarian "${viewModel.searchQuery}"'
                : 'Tidak ada kamar tersedia',
            viewModel.searchQuery.isNotEmpty 
                ? Icons.search_off_rounded
                : Icons.home_outlined
          );
        }

        // Compact room list with reduced spacing and height
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10), // Reduced padding
          itemCount: viewModel.allKamar.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8), // Reduced from 12
          itemBuilder: (context, index) {
            final kamar = viewModel.allKamar[index];
            return InkWell(
              onTap: () {
                viewModel.setSelectedKamar(kamar);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailKamar(kamarId: kamar.idKamar),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12), // Reduced from 16
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12), // Reduced from 16
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04), // Reduced opacity
                      spreadRadius: 0,
                      blurRadius: 6, // Reduced from 8
                      offset: const Offset(0, 2), // Reduced from (0, 3)
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Main content with reduced padding
                    Padding(
                      padding: const EdgeInsets.all(12), // Reduced from 16
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Room Image
                          _buildRoomImage(kamar.fotoKamar),
                          
                          const SizedBox(width: 12), // Reduced from 16
                          
                          // Room Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Room Name
                                Text(
                                  kamar.namaKamar,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15, // Reduced from 16
                                    color: Colors.black87,
                                    height: 1.1, // Reduced line height
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                
                                const SizedBox(height: 4), // Reduced from 6
                                
                                // Room Type
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), // Reduced padding
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.blue[50]!, Colors.blue[100]!],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12), // Reduced from 16
                                    border: Border.all(
                                      color: Colors.blue[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    kamar.namaJenisKamar,
                                    style: TextStyle(
                                      fontSize: 10, // Reduced from 11
                                      color: Colors.blue[700],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 6), // Reduced from 8
                                
                                // Floor Information
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(3), // Reduced from 4
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(5), // Reduced from 6
                                      ),
                                      child: Icon(
                                        Icons.layers_outlined,
                                        size: 12, // Reduced from 14
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(width: 5), // Reduced from 6
                                    Text(
                                      'Lantai ${kamar.lantai}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 11, // Reduced from 12
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Full width divider
                    Container(
                      height: 1,
                      color: Colors.grey[200],
                    ),
                    
                    // Price section with reduced padding
                    Padding(
                      padding: const EdgeInsets.all(12), // Reduced from 16
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Harga per malam',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 10, // Reduced from 11
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 1), // Reduced from 2
                              Text(
                                viewModel.formatHarga(kamar.harga),
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 30, 146, 102),
                                  fontSize: 18, // Reduced from 16
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          
                          // Action indicator
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), // Reduced padding
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 70, 167, 236),
                              borderRadius: BorderRadius.circular(8), // Reduced from 10
                              border: Border.all(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Lihat Detail',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontSize: 10, // Reduced from 11
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}