// lib/viewmodels/booking_viewmodel.dart - Updated with user validation
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/user/booking_model.dart';
import '../../services/user/booking_service.dart';

class DetailBookingViewModel extends ChangeNotifier {
  final BookingService _bookingService = BookingService();

  List<BookingModel> _bookings = [];
  List<BookingModel> _userBookings = [];
  BookingModel? _currentBooking;
  RoomAvailabilityModel? _roomAvailability;
  bool _isLoading = false;
  bool _isCheckingAvailability = false;
  bool _isCreatingBooking = false;
  String _errorMessage = '';
  String _successMessage = '';

  // Getters
  List<BookingModel> get bookings => _bookings;
  List<BookingModel> get userBookings => _userBookings;
  BookingModel? get currentBooking => _currentBooking;
  RoomAvailabilityModel? get roomAvailability => _roomAvailability;
  bool get isLoading => _isLoading;
  bool get isCheckingAvailability => _isCheckingAvailability;
  bool get isCreatingBooking => _isCreatingBooking;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;

  // Helper method to check if user is logged in
  Future<bool> _isUserLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userData = prefs.getString('user_data');
      
      return token != null && token.isNotEmpty && userData != null;
    } catch (e) {
      print('Error checking user login status: $e');
      return false;
    }
  }

  // Get current user ID
  Future<int?> _getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      
      if (userData != null) {
        final data = json.decode(userData);
        return data['userId'] ?? data['id_User'] ?? data['id'];
      }
      return null;
    } catch (e) {
      print('Error getting current user ID: $e');
      return null;
    }
  }

  // Check room availability
  Future<void> checkRoomAvailability(
    int roomId,
    DateTime checkIn,
    DateTime checkOut,
  ) async {
    // Check if user is logged in
    if (!await _isUserLoggedIn()) {
      _errorMessage = 'Silakan login terlebih dahulu';
      notifyListeners();
      return;
    }

    _setCheckingAvailability(true);
    _clearMessages();
    
    try {
      _roomAvailability = await _bookingService.checkRoomAvailability(
        roomId,
        checkIn,
        checkOut,
      );
      
      if (_roomAvailability?.isAvailable == true) {
        _successMessage = 'Kamar tersedia untuk tanggal yang dipilih';
      } else {
        _errorMessage = _roomAvailability?.message ?? 'Kamar tidak tersedia';
      }
    } catch (e) {
      _errorMessage = e.toString();
      _roomAvailability = null;
      
      // Handle specific authentication errors
      if (e.toString().contains('Unauthorized') || e.toString().contains('401')) {
        _errorMessage = 'Sesi Anda telah berakhir. Silakan login kembali.';
      }
    } finally {
      _setCheckingAvailability(false);
    }
  }

  // Create booking
  Future<bool> createBooking(
    int roomId,
    DateTime checkIn,
    DateTime checkOut,
  ) async {
    // Check if user is logged in
    if (!await _isUserLoggedIn()) {
      _errorMessage = 'Silakan login terlebih dahulu';
      notifyListeners();
      return false;
    }

    // Get user ID to validate
    final userId = await _getCurrentUserId();
    if (userId == null) {
      _errorMessage = 'Data user tidak ditemukan. Silakan login kembali.';
      notifyListeners();
      return false;
    }

    _setCreatingBooking(true);
    _clearMessages();
    
    try {
      final bookingRequest = BookingRequest(
        cekIn: checkIn,
        cekOut: checkOut,
        idKamar: roomId,
      );
      
      _currentBooking = await _bookingService.createBooking(bookingRequest);
      _successMessage = 'Booking berhasil dibuat!';
      
      // Refresh user bookings after creating new booking
      await loadUserBookings();
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _currentBooking = null;
      
      // Handle specific authentication errors
      if (e.toString().contains('Unauthorized') || e.toString().contains('401')) {
        _errorMessage = 'Sesi Anda telah berakhir. Silakan login kembali.';
      } else if (e.toString().contains('User tidak ditemukan')) {
        _errorMessage = 'Data user tidak valid. Silakan login kembali.';
      }
      
      return false;
    } finally {
      _setCreatingBooking(false);
    }
  }

  // Load all bookings (for admin)
  Future<void> loadAllBookings() async {
    if (!await _isUserLoggedIn()) {
      _errorMessage = 'Silakan login terlebih dahulu';
      notifyListeners();
      return;
    }

    _setLoading(true);
    _clearMessages();
    
    try {
      _bookings = await _bookingService.getAllBookings();
    } catch (e) {
      _errorMessage = e.toString();
      _bookings = [];
      
      // Handle specific authentication errors
      if (e.toString().contains('Unauthorized') || e.toString().contains('401')) {
        _errorMessage = 'Sesi Anda telah berakhir. Silakan login kembali.';
      }
    } finally {
      _setLoading(false);
    }
  }

  // Load user bookings (for current user only)
  Future<void> loadUserBookings() async {
    if (!await _isUserLoggedIn()) {
      _errorMessage = 'Silakan login terlebih dahulu';
      notifyListeners();
      return;
    }

    _setLoading(true);
    _clearMessages();
    
    try {
      _userBookings = await _bookingService.getUserBookings();
    } catch (e) {
      _errorMessage = e.toString();
      _userBookings = [];
      
      // Handle specific authentication errors
      if (e.toString().contains('Unauthorized') || e.toString().contains('401')) {
        _errorMessage = 'Sesi Anda telah berakhir. Silakan login kembali.';
      } else if (e.toString().contains('User tidak ditemukan')) {
        _errorMessage = 'Data user tidak valid. Silakan login kembali.';
      }
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setCheckingAvailability(bool checking) {
    _isCheckingAvailability = checking;
    notifyListeners();
  }

  void _setCreatingBooking(bool creating) {
    _isCreatingBooking = creating;
    notifyListeners();
  }

  void _clearMessages() {
    _errorMessage = '';
    _successMessage = '';
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Clear success message
  void clearSuccess() {
    _successMessage = '';
    notifyListeners();
  }

  // Clear all data
  void clearBookingData() {
    _currentBooking = null;
    _roomAvailability = null;
    _clearMessages();
  }

  // Get room availability status text
  String getAvailabilityStatusText() {
    if (_roomAvailability == null) {
      return 'Belum dicek';
    }
    return _roomAvailability!.isAvailable ? 'Tersedia' : 'Tidak Tersedia';
  }

  // Get room availability status color
  dynamic getAvailabilityStatusColor() {
    if (_roomAvailability == null) {
      return const Color(0xFF9E9E9E); // grey
    }
    return _roomAvailability!.isAvailable 
        ? const Color(0xFF4CAF50)  // green
        : const Color(0xFFF44336); // red
  }

  // Check if current user is logged in and return user info
  Future<Map<String, dynamic>?> getCurrentUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      
      if (userData != null) {
        return json.decode(userData);
      }
      return null;
    } catch (e) {
      print('Error getting current user info: $e');
      return null;
    }
  }

  // Validate user session before performing actions
  Future<bool> validateUserSession() async {
    try {
      final isLoggedIn = await _isUserLoggedIn();
      if (!isLoggedIn) {
        _errorMessage = 'Sesi Anda telah berakhir. Silakan login kembali.';
        notifyListeners();
        return false;
      }
      
      final userId = await _getCurrentUserId();
      if (userId == null) {
        _errorMessage = 'Data user tidak valid. Silakan login kembali.';
        notifyListeners();
        return false;
      }
      
      return true;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan validasi user: $e';
      notifyListeners();
      return false;
    }
  }
}