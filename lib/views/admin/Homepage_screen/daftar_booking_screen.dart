import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/admin/daftar_booking_card.dart';
import '../../../viewmodels/admin/booking_admin_viewmodel.dart';

class DaftarBookingScreen extends StatefulWidget {
  const DaftarBookingScreen({super.key});

  @override
  State<DaftarBookingScreen> createState() => _DaftarBookingScreenState();
}

class _DaftarBookingScreenState extends State<DaftarBookingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBookings();
    });
  }

  Future<void> _loadBookings() async {
    final viewModel = Provider.of<BookingAdminViewModel>(context, listen: false);
    await viewModel.loadBookings();
  }

  Future<void> _refreshBookings() async {
    await _loadBookings();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsif settings
        double titleFontSize = constraints.maxWidth > 600 ? 24 : 20;
        double emptyIconSize = constraints.maxWidth > 600 ? 80 : 64;
        double errorIconSize = constraints.maxWidth > 600 ? 80 : 64;
        double sidePadding = constraints.maxWidth > 600 ? 24 : 16;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sidePadding, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Daftar Booking',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: titleFontSize,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Consumer<BookingAdminViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (viewModel.errorMessage != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: errorIconSize,
                              color: Colors.red.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error: ${viewModel.errorMessage}',
                              style: TextStyle(
                                fontSize: constraints.maxWidth > 600 ? 18 : 16,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadBookings,
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (viewModel.bookings.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: emptyIconSize,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Belum ada booking',
                              style: TextStyle(
                                fontSize: constraints.maxWidth > 600 ? 18 : 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Booking akan muncul di sini ketika ada pemesanan baru',
                              style: TextStyle(
                                fontSize: constraints.maxWidth > 600 ? 16 : 14,
                                color: Colors.grey.shade500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _refreshBookings,
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: sidePadding),
                        itemCount: viewModel.bookings.length,
                        itemBuilder: (context, index) {
                          final booking = viewModel.bookings[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: sidePadding),
                            child: DaftarBookingCard(
                              booking: booking,
                              onRefresh: _refreshBookings,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
