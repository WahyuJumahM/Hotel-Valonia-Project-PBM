// lib/views/admin/riwayat_screen/riwayat_booking_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/admin/booking_admin_viewmodel.dart';
import '../../../widgets/admin/daftar_riwayat_booking_card.dart';
import '../../../widgets/admin/bottom_navbar.dart'; // Import bottom navbar

class RiwayatBookingScreen extends StatefulWidget {
  const RiwayatBookingScreen({Key? key}) : super(key: key);

  @override
  State<RiwayatBookingScreen> createState() => _RiwayatBookingScreenState();
}

class _RiwayatBookingScreenState extends State<RiwayatBookingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    // Load data saat widget pertama kali dibuat
    Provider.of<BookingAdminViewModel>(
      context,
      listen: false,
    ).loadBookingHistory();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        elevation: 0, 
        title: const Text(
          'Riwayat',
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Nama Tamu',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Expanded(
            child: Consumer<BookingAdminViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (viewModel.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Terjadi Kesalahan: ${viewModel.errorMessage}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            viewModel.loadBookingHistory();
                          },
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                } else {
                  final filteredBookings =
                      viewModel.bookingHistory
                          .where(
                            (booking) => booking.namaLengkap
                                .toLowerCase()
                                .contains(_searchText.toLowerCase()),
                          )
                          .toList();

                  return RefreshIndicator(
                    onRefresh: () => viewModel.refreshHistory(),
                    child:
                        filteredBookings.isEmpty
                            ? const Center(
                              child: Text('Tidak ada riwayat booking.'),
                            )
                            : ListView.builder(
                              itemCount: filteredBookings.length,
                              itemBuilder: (context, index) {
                                final booking = filteredBookings[index];
                                return DaftarRiwayatBookingCard(
                                  booking: booking,
                                );
                              },
                            ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavbar(
        currentIndex: 1,
      ), // Gunakan bottom navbar
    );
  }
}
