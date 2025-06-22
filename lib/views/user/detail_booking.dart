//lib/views/user/detail_booking.dart - ENHANCED VERSION WITH REFRESH FUNCTIONALITY
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/user/booking_viewmodel.dart';
import '../../viewmodels/user/kamar_viewmodel.dart';
import 'pembayaran.dart';

class DetailBooking extends StatefulWidget {
  const DetailBooking({super.key});

  @override
  State<DetailBooking> createState() => _DetailBookingState();
}

class _DetailBookingState extends State<DetailBooking> {
  DateTime? checkInDate;
  DateTime? checkOutDate;

  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    // Clear booking data when entering this page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetailBookingViewModel>().clearBookingData();
    });
  }

  // Refresh function to reset all data
  void _refreshPage() {
    setState(() {
      checkInDate = null;
      checkOutDate = null;
    });
    
    // Clear booking data
    context.read<DetailBookingViewModel>().clearBookingData();
    
    // Show refresh confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Halaman telah di-refresh',
          style: TextStyle(fontSize: 13),
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Show refresh confirmation dialog
  void _showRefreshDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Refresh Halaman',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'Apakah Anda yakin ingin me-refresh halaman? Semua data yang telah diisi akan dihapus.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _refreshPage();
              },
              child: Text(
                'Refresh',
                style: TextStyle(
                  color: Colors.blue.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isCheckIn
              ? (checkInDate ?? DateTime.now())
              : (checkOutDate ?? DateTime.now().add(const Duration(days: 1))),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
          if (checkOutDate != null && checkOutDate!.isBefore(checkInDate!)) {
            checkOutDate = checkInDate!.add(const Duration(days: 1));
          }
        } else {
          checkOutDate = picked;
        }
      });

      // Clear availability check when dates change
      context.read<DetailBookingViewModel>().clearBookingData();
    }
  }

  void _checkAvailability(BuildContext context) {
    final kamarViewModel = context.read<KamarViewModel>();
    final bookingViewModel = context.read<DetailBookingViewModel>();

    if (checkInDate == null || checkOutDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Pilih tanggal Check-In dan Check-Out terlebih dahulu.',
            style: TextStyle(fontSize: 13),
          ),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    if (kamarViewModel.selectedKamar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Data kamar tidak ditemukan.',
            style: TextStyle(fontSize: 13),
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    // Check availability
    bookingViewModel.checkRoomAvailability(
      kamarViewModel.selectedKamar!.idKamar,
      checkInDate!,
      checkOutDate!,
    );
  }

  void _handleBooking() {
    final bookingViewModel = context.read<DetailBookingViewModel>();
    final kamarViewModel = context.read<KamarViewModel>();

    if (checkInDate == null || checkOutDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Pilih tanggal Check-In dan Check-Out dulu.',
            style: TextStyle(fontSize: 13),
          ),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    // Check if availability was checked and room is available
    if (bookingViewModel.roomAvailability == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Silakan cek ketersediaan kamar terlebih dahulu.',
            style: TextStyle(fontSize: 13),
          ),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    if (!bookingViewModel.roomAvailability!.isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            bookingViewModel.roomAvailability!.message,
            style: const TextStyle(fontSize: 13),
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    // Get actual room price from selected kamar
    double hargaPerMalam = kamarViewModel.selectedKamar?.harga ?? 0.0;
    int jumlahMalam = checkOutDate!.difference(checkInDate!).inDays;

    // Ensure minimum 1 night if same day selected
    if (jumlahMalam <= 0) {
      jumlahMalam = 1;
    }

    // No admin fee - total is just room price * nights
    double totalBayar = hargaPerMalam * jumlahMalam;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PembayaranPage(
              checkInDate: checkInDate!,
              checkOutDate: checkOutDate!,
              totalBayar: totalBayar.toInt(), // Convert to int if needed
            ),
      ),
    );
  }

  // Helper widget for image with null handling
  Widget _buildRoomImage(String? imageUrl, {double width = 80, double height = 80}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: imageUrl != null && imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholderImage(width, height);
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: width,
                  height: height,
                  color: Colors.grey.shade200,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
            )
          : _buildPlaceholderImage(width, height),
    );
  }

  Widget _buildPlaceholderImage(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey.shade400,
        size: width * 0.25, // Scale icon size based on container size
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        elevation: 0,
        title: const Text(
          'Pemesanan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 20, color: Colors.white),
            onSelected: (String value) {
              if (value == 'refresh') {
                _showRefreshDialog();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(
                      Icons.refresh,
                      size: 20,
                      color: Colors.blue.shade600,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Refresh',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
          ),
        ],
      ),
      body: Consumer2<KamarViewModel, DetailBookingViewModel>(
        builder: (context, kamarViewModel, bookingViewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Selection Section
                _buildSectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pilih Tanggal',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Info note about check-in and check-out times
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          border: Border.all(color: Colors.blue.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade600,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Informasi Waktu:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '• Check-in dapat dimulai dari pukul 14:00 WIB di hari awal booking',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.blue.shade700,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '• Check-out maksimal di pukul 12:00 WIB di hari terakhir booking',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.blue.shade700,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateBox(
                              'Check - In',
                              checkInDate != null
                                  ? _dateFormat.format(checkInDate!)
                                  : 'Pilih Tanggal',
                              true,
                              Icons.login,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDateBox(
                              'Check - Out',
                              checkOutDate != null
                                  ? _dateFormat.format(checkOutDate!)
                                  : 'Pilih Tanggal',
                              false,
                              Icons.logout,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Availability Check Section
                _buildSectionCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                const Text(
                                  'Status:',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    bookingViewModel.getAvailabilityStatusText(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: bookingViewModel.getAvailabilityStatusColor(),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed:
                                bookingViewModel.isCheckingAvailability
                                    ? null
                                    : () => _checkAvailability(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: bookingViewModel.isCheckingAvailability
                                ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : const Text(
                                  'Cek',
                                  style: TextStyle(fontSize: 12),
                                ),
                          ),
                        ],
                      ),

                      // Show error message if any
                      if (bookingViewModel.errorMessage.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(color: Colors.red.shade200),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.shade600,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  bookingViewModel.errorMessage,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Show success message if any
                      if (bookingViewModel.successMessage.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            border: Border.all(color: Colors.green.shade200),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.green.shade600,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  bookingViewModel.successMessage,
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Room Detail Section
                _buildSectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detail Kamar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildRoomDetail(kamarViewModel),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Payment Detail Section
                _buildSectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detail Pembayaran',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildPaymentDetail(kamarViewModel),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Booking Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        bookingViewModel.isCreatingBooking
                            ? null
                            : _handleBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: bookingViewModel.isCreatingBooking
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Text(
                          'Lanjutkan Pemesanan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildDateBox(String label, String date, bool isCheckIn, IconData icon) {
    return InkWell(
      onTap: () => _selectDate(context, isCheckIn),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          border: Border.all(color: Colors.blue.shade200),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: Colors.blue.shade600,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomDetail(KamarViewModel kamarViewModel) {
    final kamar = kamarViewModel.selectedKamar;

    if (kamar == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Data kamar tidak tersedia',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Use the helper method for image handling
        _buildRoomImage(kamar.fotoKamar, width: 80, height: 80),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kamar.namaKamar,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                kamar.namaJenisKamar,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '${kamar.tipeKasur} bed • ${kamar.kapasitas} orang',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                '${kamarViewModel.formatHarga(kamar.harga)}/malam',
                style: TextStyle(
                  fontSize: 13,
                  color: const Color.fromARGB(255, 61, 167, 101),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.shade600,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Lt. ${kamar.lantai}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetail(KamarViewModel kamarViewModel) {
    if (checkInDate == null || checkOutDate == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Pilih tanggal untuk melihat detail pembayaran',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      );
    }

    final kamar = kamarViewModel.selectedKamar;
    if (kamar == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Data kamar tidak tersedia',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      );
    }

    int jumlahMalam = checkOutDate!.difference(checkInDate!).inDays;

    // Ensure minimum 1 night if same day selected
    if (jumlahMalam <= 0) {
      jumlahMalam = 1;
    }

    double hargaPerMalam = kamar.harga;
    double totalBayar = hargaPerMalam * jumlahMalam;

    return Column(
      children: [
        _buildPaymentRow(
          'Total: $jumlahMalam Malam',
          '${kamarViewModel.formatHarga(hargaPerMalam)}/malam',
          false,
        ),
        const SizedBox(height: 8),
        _buildPaymentRow(
          'Biaya Admin',
          'GRATIS',
          false,
          isGreen: true,
        ),
        const SizedBox(height: 12),
        Container(
          height: 1,
          width: double.infinity,
          color: Colors.grey.shade200,
        ),
        const SizedBox(height: 12),
        _buildPaymentRow(
          'Total Bayar',
          kamarViewModel.formatHarga(totalBayar),
          true,
        ),
      ],
    );
  }

  Widget _buildPaymentRow(String label, String value, bool isBold, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            color: isGreen 
                ? Colors.green.shade600 
                : isBold 
                    ? Colors.black87 
                    : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}