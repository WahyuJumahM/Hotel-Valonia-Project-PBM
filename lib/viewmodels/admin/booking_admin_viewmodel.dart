// lib/viewmodels/admin/booking_admin_viewmodel.dart
import 'package:flutter/material.dart';
import '../../models/admin/booking_model.dart';
import '../../services/admin/booking_admin_service.dart';

enum BookingViewState { idle, loading, updating, error, success }

class BookingAdminViewModel extends ChangeNotifier {
  List<BookingAdminDetail> _bookings = [];
  List<BookingAdminDetail> _cancelRequestBookings = [];
  List<BookingAdminDetail> _bookingHistory = []; 
  BookingViewState _state = BookingViewState.idle;
  String? _errorMessage;
  String? _successMessage;
  bool _isRefreshing = false;

  // Getters
  List<BookingAdminDetail> get bookings => _bookings;
  List<BookingAdminDetail> get cancelRequestBookings => _cancelRequestBookings;
  List<BookingAdminDetail> get bookingHistory => _bookingHistory;
  BookingViewState get state => _state;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isLoading => _state == BookingViewState.loading;
  bool get isUpdating => _state == BookingViewState.updating;
  bool get isRefreshing => _isRefreshing;
  bool get hasError => _state == BookingViewState.error;
  bool get hasSuccess => _state == BookingViewState.success;

  // Load booking data
  Future<void> loadBookings({bool showLoading = true}) async {
    if (showLoading) {
      _setState(BookingViewState.loading);
    } else {
      _isRefreshing = true;
      notifyListeners();
    }

    try {
      _bookings = await BookingAdminService.getNeedConfirmBookings();
      _setState(BookingViewState.idle);
      _clearMessages();
    } catch (e) {
      _setError(e.toString());
    } finally {
      if (!showLoading) {
        _isRefreshing = false;
        notifyListeners();
      }
    }
  }

  // Load cancel request bookings
  Future<void> loadCancelRequestBookings({bool showLoading = true}) async {
    if (showLoading) {
      _setState(BookingViewState.loading);
    } else {
      _isRefreshing = true;
      notifyListeners();
    }

    try {
      _cancelRequestBookings = await BookingAdminService.getCancelRequestBookings();
      _setState(BookingViewState.idle);
      _clearMessages();
    } catch (e) {
      _setError(e.toString());
    } finally {
      if (!showLoading) {
        _isRefreshing = false;
        notifyListeners();
      }
    }
  }
    // Load booking history data
  Future<void> loadBookingHistory({bool showLoading = true}) async {
    if (showLoading) {
      _setState(BookingViewState.loading);
    } else {
      _isRefreshing = true;
      notifyListeners();
    }

    try {
      _bookingHistory = await BookingAdminService.getBookingHistory();
      _setState(BookingViewState.idle);
      _clearMessages();
    } catch (e) {
      _setError(e.toString());
    } finally {
      if (!showLoading) {
        _isRefreshing = false;
        notifyListeners();
      }
    }
  }

  // Refresh history data
  Future<void> refreshHistory() async {
    await loadBookingHistory(showLoading: false);
  }

  // Filter history bookings by status
  List<BookingAdminDetail> getHistoryBookingsByStatus(int statusId) {
    return _bookingHistory.where((booking) => booking.idStatus == statusId).toList();
  }



  // Update booking status - generic method
  Future<bool> updateBookingStatus({
    required int bookingId,
    required int status,
    String? catatan,
  }) async {
    _setState(BookingViewState.updating);

    try {
      final result = await BookingAdminService.updateBookingStatus(
        bookingId: bookingId,
        status: status,
        catatan: catatan,
      );

      if (result['success'] == true) {
        // Update local data
        _updateLocalBookingStatus(bookingId, status, catatan);
        _setSuccess(result['message'] ?? 'Status booking berhasil diperbarui');
        return true;
      } else {
        _setError(result['message'] ?? 'Gagal mengubah status booking');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Approve booking (status 1 -> 2)
  Future<bool> approveBooking({
    required int bookingId,
    String? catatan,
  }) async {
    final booking = getBookingById(bookingId);
    if (booking == null) {
      _setError('Booking tidak ditemukan');
      return false;
    }

    if (!BookingAdminService.canUpdateStatus(booking.idStatus, 2)) {
      _setError('Booking tidak dapat disetujui pada status saat ini');
      return false;
    }

    final success = await updateBookingStatus(
      bookingId: bookingId,
      status: 2,
      catatan: catatan,
    );

    if (success) {
      _setSuccess('Booking berhasil disetujui');
    }

    return success;
  }

  // Complete booking (status 2 -> 3 OR status 5 -> 3)
  Future<bool> completeBooking({
    required int bookingId,
    String? catatan,
  }) async {
    final booking = getBookingById(bookingId);
    if (booking == null) {
      _setError('Booking tidak ditemukan');
      return false;
    }

    if (!BookingAdminService.canUpdateStatus(booking.idStatus, 3)) {
      String errorMsg;
      if (booking.idStatus == 1) {
        errorMsg = 'Booking tidak dapat diselesaikan. Setujui terlebih dahulu.';
      } else {
        errorMsg = 'Booking tidak dapat diselesaikan pada status saat ini.';
      }
      _setError(errorMsg);
      return false;
    }

    final success = await updateBookingStatus(
      bookingId: bookingId,
      status: 3,
      catatan: catatan,
    );

    if (success) {
      _setSuccess('Booking berhasil diselesaikan');
    }

    return success;
  }

  // Reject cancel request (status 4 -> 5)
  Future<bool> rejectCancelRequest({
    required int bookingId,
    String? catatan,
  }) async {
    final booking = getCancelRequestBookingById(bookingId);
    if (booking == null) {
      _setError('Booking tidak ditemukan');
      return false;
    }

    if (!BookingAdminService.canRejectCancelRequest(booking.idStatus)) {
      _setError('Permohonan pembatalan tidak dapat ditolak pada status saat ini');
      return false;
    }

    final success = await updateBookingStatus(
      bookingId: bookingId,
      status: 5, // Status: Pembatalan Ditolak
      catatan: catatan,
    );

    if (success) {
      _setSuccess('Permohonan pembatalan berhasil ditolak');
      // Remove from cancel request list
      _cancelRequestBookings.removeWhere((b) => b.idBooking == bookingId);
    }

    return success;
  }

  // Approve cancel request (status 4 -> 6)
  Future<bool> approveCancelRequest({
    required int bookingId,
    String? catatan,
  }) async {
    final booking = getCancelRequestBookingById(bookingId);
    if (booking == null) {
      _setError('Booking tidak ditemukan');
      return false;
    }

    if (!BookingAdminService.canApproveCancelRequest(booking.idStatus)) {
      _setError('Permohonan pembatalan tidak dapat disetujui pada status saat ini');
      return false;
    }

    final success = await updateBookingStatus(
      bookingId: bookingId,
      status: 6, // Status: Pembatalan Disetujui
      catatan: catatan,
    );

    if (success) {
      _setSuccess('Permohonan pembatalan berhasil disetujui');
      // Remove from cancel request list
      _cancelRequestBookings.removeWhere((b) => b.idBooking == bookingId);
    }

    return success;
  }

  // Helper method untuk update local booking status
  void _updateLocalBookingStatus(int bookingId, int status, String? catatan) {
    // Update in regular bookings list
    final index = _bookings.indexWhere((booking) => booking.idBooking == bookingId);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(
        idStatus: status,
        namaStatus: BookingAdminService.getStatusName(status),
        catatan: catatan,
      );
    }

    // Update in cancel request bookings list
    final cancelIndex = _cancelRequestBookings.indexWhere((booking) => booking.idBooking == bookingId);
    if (cancelIndex != -1) {
      _cancelRequestBookings[cancelIndex] = _cancelRequestBookings[cancelIndex].copyWith(
        idStatus: status,
        namaStatus: BookingAdminService.getStatusName(status),
        catatan: catatan,
      );
    }
  }

  // Check if booking can be approved
  bool canApprove(int bookingId) {
    final booking = getBookingById(bookingId);
    if (booking == null) return false;
    return BookingAdminService.canUpdateStatus(booking.idStatus, 2);
  }

  // Check if booking can be completed
  bool canComplete(int bookingId) {
    final booking = getBookingById(bookingId);
    if (booking == null) return false;
    return BookingAdminService.canUpdateStatus(booking.idStatus, 3);
  }

  // Check if cancel request can be rejected
  bool canRejectCancelRequest(int bookingId) {
    final booking = getCancelRequestBookingById(bookingId);
    if (booking == null) return false;
    return BookingAdminService.canRejectCancelRequest(booking.idStatus);
  }

  // Check if cancel request can be approved
  bool canApproveCancelRequest(int bookingId) {
    final booking = getCancelRequestBookingById(bookingId);
    if (booking == null) return false;
    return BookingAdminService.canApproveCancelRequest(booking.idStatus);
  }

  // Get booking by ID
  BookingAdminDetail? getBookingById(int bookingId) {
    try {
      return _bookings.firstWhere((booking) => booking.idBooking == bookingId);
    } catch (e) {
      return null;
    }
  }

  // Get cancel request booking by ID
  BookingAdminDetail? getCancelRequestBookingById(int bookingId) {
    try {
      return _cancelRequestBookings.firstWhere((booking) => booking.idBooking == bookingId);
    } catch (e) {
      return null;
    }
  }

  // Filter bookings by status
  List<BookingAdminDetail> getBookingsByStatus(int statusId) {
    return _bookings.where((booking) => booking.idStatus == statusId).toList();
  }

  // Filter cancel request bookings by status
  List<BookingAdminDetail> getCancelRequestBookingsByStatus(int statusId) {
    return _cancelRequestBookings.where((booking) => booking.idStatus == statusId).toList();
  }

  // Get statistics
  Map<String, int> getStatistics() {
    return {
      'total': _bookings.length,
      'menunggu': _bookings.where((b) => b.idStatus == 1).length,
      'disetujui': _bookings.where((b) => b.idStatus == 2).length,
      'selesai': _bookings.where((b) => b.idStatus == 3).length,
      'pembatalan': _bookings.where((b) => b.idStatus == 4).length,
      'pembatalan_ditolak': _bookings.where((b) => b.idStatus == 5).length,
    };
  }

  // Get cancel request statistics
  Map<String, int> getCancelRequestStatistics() {
    return {
      'total': _cancelRequestBookings.length,
      'pembatalan_diproses': _cancelRequestBookings.where((b) => b.idStatus == 4).length,
    };
  }
  
  // Get history statistics
  Map<String, int> getHistoryStatistics() {
    return {
      'total': _bookingHistory.length,
      'menunggu': _bookingHistory.where((b) => b.idStatus == 1).length,
      'disetujui': _bookingHistory.where((b) => b.idStatus == 2).length,
      'selesai': _bookingHistory.where((b) => b.idStatus == 3).length,
      'pembatalan': _bookingHistory.where((b) => b.idStatus == 4).length,
      'pembatalan_ditolak': _bookingHistory.where((b) => b.idStatus == 5).length,
      'pembatalan_disetujui': _bookingHistory.where((b) => b.idStatus == 6).length,
    };
  }
  // Refresh data
  Future<void> refresh() async {
    await loadBookings(showLoading: false);
  }

  // Refresh cancel request data
  Future<void> refreshCancelRequests() async {
    await loadCancelRequestBookings(showLoading: false);
  }

  // State management methods
  void _setState(BookingViewState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _successMessage = null;
    _setState(BookingViewState.error);
  }

  void _setSuccess(String message) {
    _successMessage = message;
    _errorMessage = null;
    _setState(BookingViewState.success);
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  // Clear error message
  void clearError() {
    if (_state == BookingViewState.error) {
      _setState(BookingViewState.idle);
    }
    _clearMessages();
    notifyListeners();
  }

  // Clear success message
  void clearSuccess() {
    if (_state == BookingViewState.success) {
      _setState(BookingViewState.idle);
    }
    _clearMessages();
    notifyListeners();
  }

  // Reset state to idle
  void resetState() {
    _setState(BookingViewState.idle);
    _clearMessages();
  }

  @override
  void dispose() {
    super.dispose();
  }
}