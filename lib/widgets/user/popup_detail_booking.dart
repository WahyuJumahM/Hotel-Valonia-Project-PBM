//lib/widgets/user/popup_detail_booking.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user/mybooking.dart';
import '../../viewmodels/user/mybooking_riwayat_viewmodel.dart';
import '../../views/user/mybooking.dart'; // Import halaman MyBookingPage
import 'package:intl/intl.dart';

class BookingDetailPopup extends StatefulWidget {
  final Booking booking;

  const BookingDetailPopup({
    super.key,
    required this.booking,
  });

  @override
  State<BookingDetailPopup> createState() => _BookingDetailPopupState();
}

class _BookingDetailPopupState extends State<BookingDetailPopup> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<BookingViewModel>();
    
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.95,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.receipt_long,
                    color: Color(0xFF2563EB),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Detail Booking',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Room Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.hotel,
                              color: Color(0xFF2563EB),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.booking.namaKamar,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(widget.booking.namaStatus),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    widget.booking.namaStatus,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: _getStatusTextColor(widget.booking.namaStatus),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Detail Information
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informasi Detail',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(Icons.layers_outlined, 'Lantai', widget.booking.lantai.toString()),
                          _buildDetailRow(Icons.meeting_room_outlined, 'Jenis Kamar', widget.booking.namaJenisKamar),
                          _buildDetailRow(
                            Icons.calendar_today_outlined, 
                            'Check-in', 
                            DateFormat('dd MMM yyyy', 'id_ID').format(widget.booking.cekIn)
                          ),
                          _buildDetailRow(
                            Icons.calendar_today_outlined, 
                            'Check-out', 
                            DateFormat('dd MMM yyyy', 'id_ID').format(widget.booking.cekOut)
                          ),
                          _buildDetailRow(Icons.bed_outlined, 'Tipe Kasur', widget.booking.tipeKasur),
                          _buildDetailRow(Icons.group_outlined, 'Kapasitas', '${widget.booking.kapasitas} orang'),
                          _buildDetailRow(
                            Icons.note_outlined, 
                            'Catatan', 
                            widget.booking.catatan.isEmpty ? '-' : widget.booking.catatan
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    
                    // Detail Harga - Redesigned
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF2563EB).withOpacity(0.05),
                            const Color(0xFF3B82F6).withOpacity(0.02),
                          ],
                        ),
                        border: Border.all(color: const Color(0xFF2563EB).withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2563EB).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.attach_money,
                                  color: Color(0xFF2563EB),
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Detail Harga',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Harga per malam
                          _buildPriceCard(
                            'Harga per malam',
                            viewModel.formatCurrency(widget.booking.harga),
                            Icons.nights_stay_outlined,
                            false,
                          ),
                          
                          if (widget.booking.totalHarga != null) ...[
                            const SizedBox(height: 12),
                            _buildPriceCard(
                              'Total Harga',
                              viewModel.formatCurrency(widget.booking.totalHarga!),
                              Icons.receipt,
                              true,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Actions
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                border: Border(
                  top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Tampilkan tombol cancel hanya jika status adalah "Menunggu"
                  if (widget.booking.namaStatus.toLowerCase() == 'menunggu')
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : () {
                          _showCancelConfirmation(context, widget.booking.idBooking);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                ),
                              )
                            : const Text(
                                'Batalkan',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  if (widget.booking.namaStatus.toLowerCase() == 'menunggu')
                    const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF60A5FA),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
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
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu':
        return const Color(0xFFFEF3C7);
      case 'dikonfirmasi':
        return const Color(0xFFD1FAE5);
      case 'dibatalkan':
        return const Color(0xFFFEE2E2);
      case 'selesai':
        return const Color(0xFFDDD6FE);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu':
        return const Color(0xFF92400E);
      case 'dikonfirmasi':
        return const Color(0xFF065F46);
      case 'dibatalkan':
        return const Color(0xFF991B1B);
      case 'selesai':
        return const Color(0xFF5B21B6);
      default:
        return const Color(0xFF374151);
    }
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF9CA3AF)),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF111827),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard(String label, String value, IconData icon, bool isTotal) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isTotal ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB),
          width: isTotal ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isTotal ? const Color(0xFF2563EB) : const Color(0xFF6B7280)).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: isTotal ? const Color(0xFF2563EB) : const Color(0xFF6B7280),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: isTotal ? 18 : 16,
                    fontWeight: FontWeight.w700,
                    color: isTotal ? const Color(0xFF2563EB) : const Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context, int bookingId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
              SizedBox(width: 12),
              Text(
                'Konfirmasi Pembatalan',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: const Text(
            'Apakah Anda yakin ingin membatalkan booking? Tindakan ini tidak dapat diulang.',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Batal',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog konfirmasi
                _handleCancelBooking(context, bookingId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text(
                'Ya, Batalkan',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleCancelBooking(BuildContext context, int bookingId) async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final viewModel = context.read<BookingViewModel>();
      final success = await viewModel.cancelBooking(bookingId);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Tutup popup detail booking terlebih dahulu
        Navigator.of(context).pop();
        
        // Langsung navigate ke MyBookingPage baik berhasil atau gagal
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MyBookingPage()),
          (Route<dynamic> route) => false,
        );
        
        // Tampilkan snackbar sesuai hasil
        if (success) {
          _showSnackbar(context, 'Booking berhasil dibatalkan!', Colors.green);
        } else {
          _showSnackbar(context, viewModel.errorMessage.isNotEmpty 
            ? viewModel.errorMessage 
            : 'Gagal membatalkan booking. Silakan coba lagi.', Colors.red);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Tutup popup dan navigate ke MyBookingPage
        Navigator.of(context).pop();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MyBookingPage()),
          (Route<dynamic> route) => false,
        );
        _showSnackbar(context, 'Terjadi kesalahan. Silakan coba lagi.', Colors.red);
      }
    }
  }



  void _showSnackbar(BuildContext context, String message, Color backgroundColor) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              fontFamily: 'Roboto',
              color: Colors.white,
            ),
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}