// lib/widgets/user/rekomendasi_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/user/kamar_viewmodel.dart';
import '/views/user/detail_kamar.dart';

class RekomendasiCard extends StatefulWidget {
  const RekomendasiCard({super.key});

  @override
  State<RekomendasiCard> createState() => _RekomendasiCardState();
}

class _RekomendasiCardState extends State<RekomendasiCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KamarViewModel>().loadRecommendedKamar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KamarViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (viewModel.errorMessage.isNotEmpty) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red[300]),
                  const SizedBox(height: 8),
                  const Text('Gagal memuat rekomendasi'),
                  TextButton(
                    onPressed: () => viewModel.loadRecommendedKamar(),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        if (viewModel.recommendedKamar.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text('Tidak ada rekomendasi kamar')),
          );
        }

        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.recommendedKamar.length,
            itemBuilder: (context, index) {
              final kamar = viewModel.recommendedKamar[index];
              return RekomendasiItem(
                image: kamar.safeMainPhoto, // Use safe getter
                title: kamar.namaJenisKamar,
                namaKamar: kamar.namaKamar,
                lantai: kamar.lantai,
                harga: viewModel.formatHarga(kamar.harga),
                hasImage: kamar.hasMainPhoto, // Pass image availability
                onTap: () {
                  viewModel.setSelectedKamar(kamar);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailKamar(kamarId: kamar.idKamar),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class RekomendasiItem extends StatelessWidget {
  final String image;
  final String title;
  final String namaKamar;
  final int lantai;
  final String harga;
  final bool hasImage; // New parameter
  final VoidCallback onTap;

  const RekomendasiItem({
    required this.image,
    required this.title,
    required this.namaKamar,
    required this.lantai,
    required this.harga,
    required this.hasImage, // Required parameter
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              // Background Image or Placeholder
              Positioned.fill(
                child:
                    hasImage && image.isNotEmpty
                        ? Image.network(
                          image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImagePlaceholder();
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                        )
                        : _buildImagePlaceholder(),
              ),

              // Gradient Overlay (only if has image)
              if (hasImage && image.isNotEmpty)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),

              // Room info at top right
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        namaKamar,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Lt. $lantai',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Title and price at bottom
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color:
                            hasImage && image.isNotEmpty
                                ? Colors.white
                                : Colors
                                    .black87, // Adjust text color based on background
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$harga/malam',
                      style: TextStyle(
                        color:
                            hasImage && image.isNotEmpty
                                ? Colors.white
                                : Colors
                                    .black54, // Adjust text color based on background
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade100, Colors.blue.shade200],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bed, color: Colors.blue.shade400, size: 40),
            const SizedBox(height: 8),
            Text(
              'No Image',
              style: TextStyle(
                color: Colors.blue.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
