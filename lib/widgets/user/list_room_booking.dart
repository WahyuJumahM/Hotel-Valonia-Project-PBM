// lib/widgets/user/list_room_booking.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'popup_detail_booking.dart';
import '../../viewmodels/user/mybooking_riwayat_viewmodel.dart';
import '../../models/user/mybooking.dart';

class ListRoomBooking extends StatefulWidget {
  const ListRoomBooking({super.key});

  @override
  State<ListRoomBooking> createState() => _ListRoomBookingState();
}

class _ListRoomBookingState extends State<ListRoomBooking> {
  @override
  void initState() {
    super.initState();
    // Load data booking saat widget pertama kali dibuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingViewModel>().loadBookings();
    });
  }

  void showBookingDetailDialog(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (context) => BookingDetailPopup(booking: booking),
    );
  }

  Widget bookingCard({
    required BuildContext context,
    required Booking booking,
  }) {
    final viewModel = context.read<BookingViewModel>();
    
    return GestureDetector(
      onTap: () => showBookingDetailDialog(context, booking),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 16),
        color: Colors.white.withOpacity(0.95),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.9),
                const Color(0xFFF8FBFF).withOpacity(0.8),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    booking.fotoKamar,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 40,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: viewModel.getStatusColor(booking.namaStatus),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: viewModel.getStatusColor(booking.namaStatus).withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          booking.namaStatus,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        booking.namaKamar,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      Text(
                        '${viewModel.formatCurrency(booking.harga)} /malam',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF34495E),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Color(0xFF7F8C8D)),
                          const SizedBox(width: 6),
                          Text(
                            viewModel.formatDateRange(booking.cekIn, booking.cekOut),
                            style: const TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.person, size: 16, color: Color(0xFF7F8C8D)),
                          const SizedBox(width: 6),
                          Text(
                            viewModel.getGuestInfo(booking.tipeKasur, booking.kapasitas),
                            style: const TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (viewModel.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'Terjadi Kesalahan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    viewModel.errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    viewModel.clearError();
                    viewModel.loadBookings();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
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
                  Icons.roofing,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum Ada Booking',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Booking kamar Anda akan muncul di sini',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => viewModel.refreshBookings(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => viewModel.refreshBookings(),
          child: ListView.builder(
            itemCount: viewModel.bookings.length,
            itemBuilder: (context, index) {
              final booking = viewModel.bookings[index];
              return bookingCard(
                context: context,
                booking: booking,
              );
            },
          ),
        );
      },
    );
  }
}