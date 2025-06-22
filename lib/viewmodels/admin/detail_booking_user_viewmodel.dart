// lib/viewmodels/admin/booking_detail_viewmodel.dart
import 'package:flutter/material.dart';
import '../../models/admin/booking_model.dart';
import '../../services/admin/detail_booking_user_service.dart';

class BookingDetailViewModel extends ChangeNotifier {
  BookingAdminDetail? _bookingDetail;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  BookingAdminDetail? get bookingDetail => _bookingDetail;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Mengambil detail booking berdasarkan ID
  Future<bool> fetchBookingDetail(int bookingId) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await BookingDetailService.getBookingDetail(bookingId);
      
      if (result['success']) {
        _bookingDetail = BookingDetailService.parseBookingDetail(result['data']);
        if (_bookingDetail == null) {
          _setError('Gagal memproses data booking');
          return false;
        }
        _setLoading(false);
        return true;
      } else {
        _setError(result['message'] ?? 'Gagal mengambil data booking');
        return false;
      }
    } catch (e) {
      _setError('Terjadi kesalahan: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh data booking
  Future<bool> refreshBookingDetail() async {
    if (_bookingDetail?.idBooking != null) {
      return await fetchBookingDetail(_bookingDetail!.idBooking);
    }
    return false;
  }

  /// Format tanggal untuk tampilan
  String formatDate(DateTime date) {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Format harga untuk tampilan
  String formatPrice(double? price) {
    if (price == null) return 'Rp 0';
    return 'Rp ${price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]}.',
    )}';
  }

  /// Menghitung jumlah malam menginap
  int calculateNights() {
    if (_bookingDetail == null) return 0;
    return _bookingDetail!.cekOut.difference(_bookingDetail!.cekIn).inDays;
  }

  /// Mendapatkan warna status berdasarkan ID status
  Color getStatusColor(int statusId) {
    switch (statusId) {
      case 1: // Menunggu
        return const Color(0xFFFF9800); // Orange
      case 2: // Disetujui
        return const Color(0xFF4CAF50); // Green
      case 3: // Selesai
        return const Color(0xFF2196F3); // Blue
      case 4: // Pembatalan di proses
        return const Color(0xFFFFC107); // Amber
      case 5: // Pembatalan Ditolak
        return const Color(0xFFF44336); // Red
      case 6: // Pembatalan Disetujui
        return const Color(0xFF9C27B0); // Purple
      default:
        return const Color(0xFF757575); // Grey
    }
  }

  /// Mendapatkan icon status berdasarkan nama status
  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu':
        return Icons.access_time;
      case 'disetujui':
        return Icons.check_circle;
      case 'selesai':
        return Icons.task_alt;
      case 'pembatalan di proses':
      case 'pembatalan diproses':
        return Icons.hourglass_empty;
      case 'pembatalan ditolak':
        return Icons.cancel;
      case 'pembatalan disetujui':
        return Icons.check_circle_outline;
      default:
        return Icons.info;
    }
  }

  /// Reset data
  void clearData() {
    _bookingDetail = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}