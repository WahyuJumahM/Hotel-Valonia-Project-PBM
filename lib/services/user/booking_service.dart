// lib/services/booking_service.dart - Fixed Version with Authentication
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user/booking_model.dart';
import '../ipconfig.dart';

class BookingService {
  static const String baseUrl = '${IpConfig.baseUrl}api';

  // Helper method to get authentication headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // Helper method to get current user ID
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

  // Check room availability with better error handling
  Future<RoomAvailabilityModel> checkRoomAvailability(
    int roomId,
    DateTime checkIn,
    DateTime checkOut,
  ) async {
    try {
      // Validate parameters before sending
      if (roomId <= 0) {
        throw Exception('Room ID tidak valid');
      }
      
      if (checkIn.isAfter(checkOut) || checkIn.isAtSameMomentAs(checkOut)) {
        throw Exception('Tanggal check-in harus sebelum check-out');
      }

      final String checkInStr = checkIn.toIso8601String();
      final String checkOutStr = checkOut.toIso8601String();
      
      print('Checking availability for room $roomId from $checkInStr to $checkOutStr');
      
      final headers = await _getAuthHeaders();
      
      final response = await http.get(
        Uri.parse('$baseUrl/Booking/room/$roomId/availability?checkIn=$checkInStr&checkOut=$checkOutStr'),
        headers: headers,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        // Handle the API response structure
        if (jsonData['success'] == true) {
          return RoomAvailabilityModel(
            isAvailable: jsonData['available'] ?? false,
            message: jsonData['message'] ?? '',
          );
        } else {
          throw Exception('API returned success: false - ${jsonData['message'] ?? 'Unknown error'}');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else if (response.statusCode == 400) {
        // Handle bad request
        try {
          final Map<String, dynamic> errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'Bad request');
        } catch (e) {
          throw Exception('Bad request: ${response.body}');
        }
      } else if (response.statusCode == 500) {
        // Handle internal server error
        try {
          final Map<String, dynamic> errorData = json.decode(response.body);
          String errorMessage = errorData['message'] ?? 'Internal server error';
          String? details = errorData['error'];
          
          if (details != null) {
            errorMessage += '\nDetails: $details';
          }
          
          throw Exception(errorMessage);
        } catch (e) {
          throw Exception('Server error (500): ${response.body}');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      // Log the error for debugging
      print('Error in checkRoomAvailability: $e');
      
      if (e is Exception) {
        rethrow;
      } else {
        throw Exception('Unexpected error: $e');
      }
    }
  }

  // Create booking with authentication and user ID
  Future<BookingModel> createBooking(BookingRequest bookingRequest) async {
    try {
      // Get current user ID
      final userId = await _getCurrentUserId();
      if (userId == null) {
        throw Exception('User tidak ditemukan. Silakan login kembali.');
      }

      // Create booking request with user ID
      final bookingData = bookingRequest.toJson();
      bookingData['id_User'] = userId; // Add user ID to the request
      
      print('Creating booking with data: $bookingData');
      
      final headers = await _getAuthHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/Booking'),
        headers: headers,
        body: json.encode(bookingData),
      );

      print('Create booking response status: ${response.statusCode}');
      print('Create booking response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData['success'] == true && jsonData['data'] != null) {
          return BookingModel.fromJson(jsonData['data']);
        } else {
          return BookingModel(
            cekIn: bookingRequest.cekIn,
            cekOut: bookingRequest.cekOut,
            idKamar: bookingRequest.idKamar,
            idUser: userId, // Include user ID in response
            catatan: "Pesanan Anda dalam antrean, akan segera diproses oleh admin.",
          );
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Silakan login kembali');
      } else if (response.statusCode == 400) {
        try {
          final Map<String, dynamic> errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'Bad request');
        } catch (e) {
          throw Exception('Bad request: ${response.body}');
        }
      } else if (response.statusCode == 500) {
        try {
          final Map<String, dynamic> errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'Internal server error');
        } catch (e) {
          throw Exception('Server error: ${response.body}');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error in createBooking: $e');
      
      if (e is Exception) {
        rethrow;
      } else {
        throw Exception('Unexpected error: $e');
      }
    }
  }

  // Get all bookings with authentication
  Future<List<BookingModel>> getAllBookings() async {
    try {
      final headers = await _getAuthHeaders();
      
      final response = await http.get(
        Uri.parse('$baseUrl/Booking'),
        headers: headers,
      );

      print('Get all bookings response status: ${response.statusCode}');
      print('Get all bookings response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final List<dynamic> jsonData = jsonResponse['data'];
          return jsonData.map((json) => BookingModel.fromJson(json)).toList();
        }
        return [];
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Silakan login kembali');
      } else {
        throw Exception('Failed to load bookings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAllBookings: $e');
      throw Exception('Error fetching bookings: $e');
    }
  }

  // Get user bookings (bookings for current user only)
  Future<List<BookingModel>> getUserBookings() async {
    try {
      final userId = await _getCurrentUserId();
      if (userId == null) {
        throw Exception('User tidak ditemukan. Silakan login kembali.');
      }

      final headers = await _getAuthHeaders();
      
      final response = await http.get(
        Uri.parse('$baseUrl/Booking/user/$userId'),
        headers: headers,
      );

      print('Get user bookings response status: ${response.statusCode}');
      print('Get user bookings response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final List<dynamic> jsonData = jsonResponse['data'];
          return jsonData.map((json) => BookingModel.fromJson(json)).toList();
        }
        return [];
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Silakan login kembali');
      } else {
        throw Exception('Failed to load user bookings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getUserBookings: $e');
      throw Exception('Error fetching user bookings: $e');
    }
  }
}