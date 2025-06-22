// lib/views/admin/Homepage_screen/detail_booking_user_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/admin/detail_booking_user_viewmodel.dart';
import '../../../models/admin/booking_model.dart';

class DetailBookingUserScreen extends StatefulWidget {
  final Map<String, dynamic>? booking;
  final int? bookingId;

  const DetailBookingUserScreen({
    super.key,
    this.booking,
    this.bookingId,
  });

  @override
  State<DetailBookingUserScreen> createState() => _DetailBookingUserScreenState();
}

class _DetailBookingUserScreenState extends State<DetailBookingUserScreen> {
  late BookingDetailViewModel _viewModel;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _viewModel = BookingDetailViewModel();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    if (_isInitialized) return;
    
    int? bookingId;
    
    // Prioritas: gunakan bookingId langsung, jika tidak ada ambil dari booking map
    if (widget.bookingId != null) {
      bookingId = widget.bookingId;
    } else if (widget.booking != null) {
      bookingId = widget.booking!['id_Booking'] ?? widget.booking!['idBooking'];
    }

    if (bookingId != null) {
      await _viewModel.fetchBookingDetail(bookingId);
      _isInitialized = true;
    } else {
      _showErrorSnackBar('ID Booking tidak ditemukan');
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    final success = await _viewModel.refreshBookingDetail();
    if (!success && _viewModel.errorMessage != null) {
      _showErrorSnackBar(_viewModel.errorMessage!);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookingDetailViewModel>.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text(
            'Detail Booking',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          actions: [
            Consumer<BookingDetailViewModel>(
              builder: (context, viewModel, child) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: viewModel.isLoading ? null : _refreshData,
                );
              },
            ),
          ],
        ),
        body: Consumer<BookingDetailViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Memuat data booking...'),
                  ],
                ),
              );
            }

            if (viewModel.errorMessage != null) {
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
                      viewModel.errorMessage!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _refreshData,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (viewModel.bookingDetail == null) {
              return const Center(
                child: Text('Data booking tidak ditemukan'),
              );
            }

            return _buildBookingDetail(viewModel, viewModel.bookingDetail!);
          },
        ),
      ),
    );
  }

  Widget _buildBookingDetail(BookingDetailViewModel viewModel, BookingAdminDetail booking) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: viewModel.getStatusColor(booking.idStatus).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: viewModel.getStatusColor(booking.idStatus).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    viewModel.getStatusIcon(booking.namaStatus),
                    color: viewModel.getStatusColor(booking.idStatus),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status Booking',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          booking.namaStatus,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: viewModel.getStatusColor(booking.idStatus),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Room Information Card
            _buildInfoCard(
              title: 'Informasi Kamar',
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: booking.fotoKamar != null && booking.fotoKamar!.isNotEmpty
                        ? Image.network(
                            booking.fotoKamar!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderImage();
                            },
                          )
                        : _buildPlaceholderImage(),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow('Nama Kamar', booking.namaKamar),
                  _buildDetailRow('Jenis Kamar', booking.namaJenisKamar),
                  _buildDetailRow('Lantai', 'Lantai ${booking.lantai}'),
                  _buildDetailRow('Tipe Kasur', booking.tipeKasur),
                  _buildDetailRow('Kapasitas', '${booking.kapasitas} orang'),
                  _buildDetailRow('Harga per Malam', viewModel.formatPrice(booking.harga)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Guest Information Card
            _buildInfoCard(
              title: 'Informasi Tamu',
              child: Column(
                children: [
                  _buildDetailRow('Nama Lengkap', booking.namaLengkap),
                  _buildDetailRow('Email', booking.email),
                  _buildDetailRow('NIK', booking.nik.toString()),
                  _buildDetailRow('No. Handphone', '0${booking.noHandphone}'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Booking Information Card
            _buildInfoCard(
              title: 'Informasi Booking',
              child: Column(
                children: [
                  _buildDetailRow('ID Booking', '#${booking.idBooking}'),
                  _buildDetailRow('Check In', viewModel.formatDate(booking.cekIn)),
                  _buildDetailRow('Check Out', viewModel.formatDate(booking.cekOut)),
                  _buildDetailRow('Jumlah Malam', '${viewModel.calculateNights()} malam'),
                  if (booking.jumlahDireservasi != null)
                    _buildDetailRow('Jumlah Direservasi', '${booking.jumlahDireservasi} kamar'),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Pembayaran',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          viewModel.formatPrice(booking.totalHarga),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Notes Card (if available)
            if (booking.catatan != null && booking.catatan!.isNotEmpty)
              _buildInfoCard(
                title: 'Catatan Admin',
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Text(
                    booking.catatan!,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            color: Colors.grey,
            size: 50,
          ),
          SizedBox(height: 8),
          Text(
            'Foto tidak tersedia',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}