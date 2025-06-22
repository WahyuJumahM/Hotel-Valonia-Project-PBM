//lib/viewmodels/user/mybooking_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../models/user/mybooking.dart';
import '../../services/user/mybooking_riwayat_service.dart';

class BookingViewModel extends ChangeNotifier {
  List<Booking> _bookings = [];
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isLocaleInitialized = false;

  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Initialize locale for date formatting
  Future<void> _initializeLocale() async {
    if (!_isLocaleInitialized) {
      try {
        await initializeDateFormatting('id_ID', null);
        _isLocaleInitialized = true;
        print('Locale id_ID initialized successfully');
      } catch (e) {
        print('Failed to initialize locale id_ID: $e');
        // Fallback to default locale if id_ID fails
        try {
          await initializeDateFormatting('en_US', null);
          _isLocaleInitialized = true;
          print('Fallback to en_US locale');
        } catch (e) {
          print('Failed to initialize any locale: $e');
        }
      }
    }
  }

  // Load booking data
  Future<void> loadBookings() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Initialize locale first
      await _initializeLocale();

      final result = await BookingService.getUserBookings();

      if (result['success']) {
        _bookings = result['data'] as List<Booking>;
        _errorMessage = '';
        print('Bookings loaded successfully: ${_bookings.length} items');
      } else {
        _bookings = [];
        _errorMessage = result['message'] ?? 'Gagal memuat data booking';
        print('Failed to load bookings: $_errorMessage');
      }
    } catch (e) {
      _bookings = [];
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      print('Error in loadBookings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cancel booking
  Future<bool> cancelBooking(int bookingId) async {
    try {
      print('Attempting to cancel booking ID: $bookingId');
      final result = await BookingService.cancelBooking(bookingId);

      if (result['success']) {
        print('Booking cancelled successfully');
        // Refresh data setelah cancel
        await loadBookings();
        return true;
      } else {
        _errorMessage = result['message'] ?? 'Gagal membatalkan booking';
        print('Failed to cancel booking: $_errorMessage');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      print('Error in cancelBooking: $e');
      notifyListeners();
      return false;
    }
  }

  // Refresh data
  Future<void> refreshBookings() async {
    await loadBookings();
  }

  // Helper methods untuk formatting
  String formatCurrency(double amount) {
    try {
      final formatter = NumberFormat.currency(
        locale: _isLocaleInitialized ? 'id_ID' : 'en_US',
        symbol: 'Rp',
        decimalDigits: 0,
      );
      return formatter.format(amount);
    } catch (e) {
      print('Error formatting currency: $e');
      // Fallback manual formatting
      return 'Rp${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
    }
  }

  String formatDateRange(DateTime checkIn, DateTime checkOut) {
    try {
      final formatter =
          _isLocaleInitialized
              ? DateFormat('dd MMM yyyy', 'id_ID')
              : DateFormat('dd MMM yyyy', 'en_US');
      return '${formatter.format(checkIn)} – ${formatter.format(checkOut)}';
    } catch (e) {
      print('Error formatting date range: $e');
      // Fallback to simple formatting
      return '${checkIn.day}/${checkIn.month}/${checkIn.year} – ${checkOut.day}/${checkOut.month}/${checkOut.year}';
    }
  }

  String formatDate(DateTime date) {
    try {
      final formatter =
          _isLocaleInitialized
              ? DateFormat('dd MMM yyyy', 'id_ID')
              : DateFormat('dd MMM yyyy', 'en_US');
      return formatter.format(date);
    } catch (e) {
      print('Error formatting date: $e');
      // Fallback to simple formatting
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu':
        return Colors.amber; // Kuning
      case 'disetujui':
        return Colors.green; // Hijau
      case 'selesai':
        return Colors.blue; // Biru
      case 'pembatalan di proses':
      case 'pembatalan diproses':
        return Colors.orange; // Oranye
      case 'pembatalan ditolak':
        return Colors.red; // Merah
      case 'pembatalan disetujui':
        return Colors.purple; // Ungu
      default:
        return Colors.grey; // Default abu-abu untuk status yang tidak dikenal
    }
  }

  String getGuestInfo(String tipeKasur, int kapasitas) {
    return '$tipeKasur - $kapasitas orang';
  }

  // Get booking by ID
  Booking? getBookingById(int bookingId) {
    try {
      return _bookings.firstWhere((booking) => booking.idBooking == bookingId);
    } catch (e) {
      print('Booking with ID $bookingId not found');
      return null;
    }
  }

  // Check if booking can be cancelled
  bool canCancelBooking(String status) {
    final lowerStatus = status.toLowerCase();
    return lowerStatus == 'menunggu' || lowerStatus == 'disetujui';
  }

  // Get bookings by status
  List<Booking> getBookingsByStatus(String status) {
    return _bookings
        .where(
          (booking) => booking.namaStatus.toLowerCase() == status.toLowerCase(),
        )
        .toList();
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Debug method
  void debugBookings() {
    print('=== BOOKING DEBUG ===');
    print('Total bookings: ${_bookings.length}');
    print('Is loading: $_isLoading');
    print('Error message: $_errorMessage');
    print('Locale initialized: $_isLocaleInitialized');

    for (var booking in _bookings) {
      print(
        'Booking ${booking.idBooking}: ${booking.namaKamar} - ${booking.namaStatus}',
      );
    }
    print('====================');
  }


  List<Booking> _bookingHistory = [];
  bool _isLoadingHistory = false;

  List<Booking> get bookingHistory => _bookingHistory;
  bool get isLoadingHistory => _isLoadingHistory;

  // Load booking history data
  Future<void> loadBookingHistory() async {
    _isLoadingHistory = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Initialize locale first
      await _initializeLocale();

      final result = await BookingService.getUserBookingHistory();

      if (result['success']) {
        _bookingHistory = result['data'] as List<Booking>;
        _errorMessage = '';
        print(
          'Booking history loaded successfully: ${_bookingHistory.length} items',
        );
      } else {
        _bookingHistory = [];
        _errorMessage =
            result['message'] ?? 'Gagal memuat data riwayat booking';
        print('Failed to load booking history: $_errorMessage');
      }
    } catch (e) {
      _bookingHistory = [];
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      print('Error in loadBookingHistory: $e');
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
    }
  }

  // Refresh booking history
  Future<void> refreshBookingHistory() async {
    await loadBookingHistory();
  }
}
