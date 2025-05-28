import 'package:apphotel_valonia/views/user/detail_booking.dart';
import 'package:flutter/material.dart';

class DetailKamar extends StatefulWidget {
  const DetailKamar({super.key});

  @override
  State<DetailKamar> createState() => _DetailKamarState();
}

class _DetailKamarState extends State<DetailKamar> {
  final DraggableScrollableController _scrollController =
      DraggableScrollableController();

  // Minimal size saat tarik ke bawah (tidak bisa kurang dari ini)
  final double minChildSize = 0.62;
  final double maxChildSize = 1.0;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      // Cegah drag ke bawah melebihi minChildSize
      if (_scrollController.size < minChildSize) {
        _scrollController.jumpTo(minChildSize);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gambar Background
          SizedBox(
            height: size.height * 0.4,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/room.jpg', fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                        Colors.black.withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tombol kembali & judul
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const Text(
                    'Detail Kamar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),

          // Bagian bawah draggable full width & height (62% - 100%)
          DraggableScrollableSheet(
            controller: _scrollController,
            initialChildSize: minChildSize,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
            expand: true,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 90),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Handle bar
                            Center(
                              child: Container(
                                width: 40,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(2.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Header Kamar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Kamar 101',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Superior Twin',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Text(
                                    'Lantai 2',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Single Bed • 2 orang',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 24),

                            // Deskripsi & Fasilitas digabung dengan border
                            const Text(
                              'Deskripsi',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Tempat ideal untuk Anda yang mencari pengalaman liburan mewah dan tenang dengan pemandangan laut yang menakjubkan.\n\n'
                                'Fasilitas:\n'
                                '• AC\n'
                                '• Kolam Renang\n'
                                '• Layanan Kamar 24 Jam\n'
                                '• Wi-Fi Gratis\n'
                                '• TV Kabel\n'
                                '• Kamar Mandi Dalam',
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),

                    // Harga & tombol Booking di posisi bottom
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Harga per malam',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Rp 1,433,270',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Navigasi ke halaman pembayaran
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DetailBooking(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Booking',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
