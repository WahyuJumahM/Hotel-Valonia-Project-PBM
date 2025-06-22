// lib/services/booking_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user/mybooking.dart';
import '../ipconfig.dart';

class BookingService {
  static const String baseUrl = '${IpConfig.baseUrl}api/Booking';

  // Ambil token dari SharedPreferences
  static Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      print('Token retrieved: ${token != null ? 'Found' : 'Not found'}');
      return token;
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  // Ambil user ID dari SharedPreferences
  static Future<int?> _getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');

      if (userData != null && userData.isNotEmpty) {
        final data = json.decode(userData);
        print('User data: $data');

        // Cek berbagai kemungkinan key untuk user ID
        int? userId;
        if (data.containsKey('id_User')) {
          userId = data['id_User'];
        } else if (data.containsKey('idUser')) {
          userId = data['idUser'];
        } else if (data.containsKey('id')) {
          userId = data['id'];
        } else if (data.containsKey('userId')) {
          userId = data['userId'];
        }

        print('User ID retrieved: $userId');
        return userId;
      }
      return null;
    } catch (e) {
      print('Error getting user ID: $e');
      return null;
    }
  }

  // GET api/Booking/User - Ambil semua booking user
  static Future<Map<String, dynamic>> getUserBookings() async {
    try {
      final token = await _getToken();
      final userId = await _getUserId();

      if (token == null) {
        return {
          'success': false,
          'data': <Booking>[],
          'message': 'Token tidak ditemukan. Silakan login kembali.',
        };
      }

      if (userId == null) {
        return {
          'success': false,
          'data': <Booking>[],
          'message': 'User ID tidak ditemukan. Silakan login kembali.',
        };
      }

      print('Getting user bookings from: $baseUrl/User');
      print('User ID: $userId');

      final response = await http.get(
        Uri.parse('$baseUrl/User'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get bookings response status: ${response.statusCode}');
      print('Get bookings response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        List<Booking> bookings = [];

        // Handle different response formats
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
          // Response format: {"data": [...]}
          final data = jsonData['data'] as List<dynamic>;
          bookings =
              data
                  .where(
                    (item) => item['id_User'] == userId,
                  ) // Filter by user ID
                  .map((item) => Booking.fromJson(item as Map<String, dynamic>))
                  .toList();
        } else if (jsonData is List<dynamic>) {
          // Response format: [...]
          bookings =
              jsonData
                  .where(
                    (item) => item['id_User'] == userId,
                  ) // Filter by user ID
                  .map((item) => Booking.fromJson(item as Map<String, dynamic>))
                  .toList();
        }

        print('Bookings loaded: ${bookings.length} items');

        return {
          'success': true,
          'data': bookings,
          'message': 'Data booking berhasil dimuat',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'data': <Booking>[],
          'message': 'Token tidak valid atau expired. Silakan login kembali.',
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'data': <Booking>[],
          'message': 'Data booking tidak ditemukan',
        };
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'data': <Booking>[],
          'message':
              errorData['message'] ??
              'Gagal mengambil data booking: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error in getUserBookings: $e');
      return {
        'success': false,
        'data': <Booking>[],
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // POST api/Booking/{id}/cancel - Cancel booking
  static Future<Map<String, dynamic>> cancelBooking(int bookingId) async {
    try {
      final token = await _getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Token tidak ditemukan. Silakan login kembali.',
        };
      }

      print('Canceling booking ID: $bookingId');
      print('Cancel URL: $baseUrl/$bookingId/cancel');

      final response = await http.post(
        Uri.parse('$baseUrl/$bookingId/cancel'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Cancel booking response status: ${response.statusCode}');
      print('Cancel booking response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {'success': true, 'message': 'Booking berhasil dibatalkan'};
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Token tidak valid atau expired. Silakan login kembali.',
        };
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'Booking tidak ditemukan'};
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Booking tidak dapat dibatalkan',
        };
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message':
              errorData['message'] ??
              'Gagal membatalkan booking: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error in cancelBooking: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // GET api/Booking/{id} - Get booking detail by ID
  static Future<Map<String, dynamic>> getBookingDetail(int bookingId) async {
    try {
      final token = await _getToken();

      if (token == null) {
        return {
          'success': false,
          'data': null,
          'message': 'Token tidak ditemukan. Silakan login kembali.',
        };
      }

      print('Getting booking detail ID: $bookingId');

      final response = await http.get(
        Uri.parse('$baseUrl/$bookingId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get booking detail response status: ${response.statusCode}');
      print('Get booking detail response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final booking = Booking.fromJson(jsonData);

        return {
          'success': true,
          'data': booking,
          'message': 'Detail booking berhasil dimuat',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'data': null,
          'message': 'Token tidak valid atau expired. Silakan login kembali.',
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'data': null,
          'message': 'Booking tidak ditemukan',
        };
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'data': null,
          'message':
              errorData['message'] ??
              'Gagal mengambil detail booking: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error in getBookingDetail: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // GET api/Booking/Riwayat/User - Ambil riwayat booking user
  static Future<Map<String, dynamic>> getUserBookingHistory() async {
    try {
      final token = await _getToken();
      final userId = await _getUserId();

      if (token == null) {
        return {
          'success': false,
          'data': <Booking>[],
          'message': 'Token tidak ditemukan. Silakan login kembali.',
        };
      }

      if (userId == null) {
        return {
          'success': false,
          'data': <Booking>[],
          'message': 'User ID tidak ditemukan. Silakan login kembali.',
        };
      }

      print('Getting user booking history from: $baseUrl/Riwayat/User');
      print('User ID: $userId');

      final response = await http.get(
        Uri.parse('$baseUrl/Riwayat/User'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get booking history response status: ${response.statusCode}');
      print('Get booking history response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        List<Booking> bookings = [];

        // Handle different response formats
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('data')) {
          // Response format: {"data": [...]}
          final data = jsonData['data'] as List<dynamic>;
          bookings =
              data
                  .where(
                    (item) => item['id_User'] == userId,
                  ) // Filter by user ID
                  .map((item) => Booking.fromJson(item as Map<String, dynamic>))
                  .toList();
        } else if (jsonData is List<dynamic>) {
          // Response format: [...]
          bookings =
              jsonData
                  .where(
                    (item) => item['id_User'] == userId,
                  ) // Filter by user ID
                  .map((item) => Booking.fromJson(item as Map<String, dynamic>))
                  .toList();
        }

        print('Booking history loaded: ${bookings.length} items');

        return {
          'success': true,
          'data': bookings,
          'message': 'Data riwayat booking berhasil dimuat',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'data': <Booking>[],
          'message': 'Token tidak valid atau expired. Silakan login kembali.',
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'data': <Booking>[],
          'message': 'Data riwayat booking tidak ditemukan',
        };
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'data': <Booking>[],
          'message':
              errorData['message'] ??
              'Gagal mengambil data riwayat booking: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error in getUserBookingHistory: $e');
      return {
        'success': false,
        'data': <Booking>[],
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Helper method untuk debug user data
  static Future<void> debugUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      final token = prefs.getString('auth_token');

      print('=== DEBUG USER DATA ===');
      print('Token: ${token != null ? 'Available' : 'Null'}');
      print('User Data Raw: $userData');

      if (userData != null) {
        final data = json.decode(userData);
        print('User Data Parsed: $data');
        print('Available Keys: ${data.keys.toList()}');
      }
      print('========================');
    } catch (e) {
      print('Error debugging user data: $e');
    }
  }
}
