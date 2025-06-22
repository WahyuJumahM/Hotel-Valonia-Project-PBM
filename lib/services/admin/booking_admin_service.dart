// lib/services/booking_admin_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/admin/booking_model.dart';
import '../ipconfig.dart';

class BookingAdminService {
  static const String baseUrl = '${IpConfig.baseUrl}api/Booking';

  // Custom exception classes for better error handling
  static const Duration timeoutDuration = Duration(seconds: 30);

  static Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      return token;
    } catch (e) {
      throw Exception('Gagal mengambil token autentikasi');
    }
  }

  // GET: Ambil semua booking yang perlu konfirmasi
  static Future<List<BookingAdminDetail>> getNeedConfirmBookings() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/NeedConfirm'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(timeoutDuration);

      return _handleBookingResponse(response);
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Koneksi timeout. Periksa koneksi internet Anda.');
      }
      rethrow;
    }
  }

  // GET: Ambil semua booking dengan permohonan pembatalan (status 4)
  static Future<List<BookingAdminDetail>> getCancelRequestBookings() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/CancelRequest'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(timeoutDuration);

      return _handleBookingResponse(response);
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Koneksi timeout. Periksa koneksi internet Anda.');
      }
      rethrow;
    }
  }

  // Helper method untuk handle response booking
  static List<BookingAdminDetail> _handleBookingResponse(
    http.Response response,
  ) {
    switch (response.statusCode) {
      case 200:
        try {
          final Map<String, dynamic> responseData = json.decode(response.body);

          if (responseData['success'] == true && responseData['data'] != null) {
            final List<dynamic> bookingsJson = responseData['data'];
            return bookingsJson
                .map((json) => BookingAdminDetail.fromJson(json))
                .toList();
          } else {
            throw Exception(
              responseData['message'] ?? 'Gagal mengambil data booking',
            );
          }
        } catch (e) {
          if (e is FormatException) {
            throw Exception('Format response tidak valid dari server');
          }
          rethrow;
        }
      case 401:
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      case 403:
        throw Exception('Anda tidak memiliki akses untuk melihat data ini');
      case 404:
        throw Exception('Data booking tidak ditemukan');
      case 500:
        throw Exception('Terjadi kesalahan pada server. Coba lagi nanti.');
      default:
        throw Exception('Gagal terhubung ke server (${response.statusCode})');
    }
  }
    // GET: Ambil semua riwayat booking (semua status)
  static Future<List<BookingAdminDetail>> getBookingHistory() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/Riwayat'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(timeoutDuration);

      return _handleBookingResponse(response);
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Koneksi timeout. Periksa koneksi internet Anda.');
      }
      rethrow;
    }
  }

  // PUT: Update status booking
  static Future<Map<String, dynamic>> updateBookingStatus({
    required int bookingId,
    required int status,
    String? catatan,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      }

      final Map<String, dynamic> requestBody = {
        'status': status,
        if (catatan != null && catatan.isNotEmpty) 'catatan': catatan,
      };

      final response = await http
          .put(
            Uri.parse('$baseUrl/$bookingId/status'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode(requestBody),
          )
          .timeout(timeoutDuration);

      return _handleUpdateResponse(response);
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Koneksi timeout. Periksa koneksi internet Anda.');
      }
      rethrow;
    }
  }

  // Helper method untuk handle update response
  static Map<String, dynamic> _handleUpdateResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        try {
          final responseData = json.decode(response.body);
          return {
            'success': true,
            'message':
                responseData['message'] ?? 'Status booking berhasil diperbarui',
            'data': responseData['data'],
          };
        } catch (e) {
          return {
            'success': true,
            'message': 'Status booking berhasil diperbarui',
            'data': null,
          };
        }
      case 400:
        final responseData = json.decode(response.body);
        throw Exception(
          responseData['message'] ?? 'Data yang dikirim tidak valid',
        );
      case 401:
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      case 403:
        throw Exception(
          'Anda tidak memiliki akses untuk mengubah status booking ini',
        );
      case 404:
        throw Exception('Booking tidak ditemukan atau sudah dihapus');
      case 409:
        throw Exception(
          'Status booking tidak dapat diubah karena konflik data',
        );
      case 500:
        throw Exception('Terjadi kesalahan pada server. Coba lagi nanti.');
      default:
        throw Exception(
          'Gagal mengubah status booking (${response.statusCode})',
        );
    }
  }

  // Method helper untuk mendapatkan nama status berdasarkan ID
  static String getStatusName(int statusId) {
    switch (statusId) {
      case 1:
        return 'Menunggu Konfirmasi';
      case 2:
        return 'Disetujui';
      case 3:
        return 'Selesai';
      case 4:
        return 'Pembatalan Diproses';
      case 5:
        return 'Pembatalan Ditolak';
      case 6:
        return 'Pembatalan Disetujui';
      default:
        return 'Status Tidak Dikenal';
    }
  }

  // Method helper untuk validasi status transition - DIPERBAIKI DAN DITAMBAH UNTUK CANCEL REQUEST
  static bool canUpdateStatus(int currentStatus, int newStatus) {
    switch (currentStatus) {
      case 1: // Menunggu Konfirmasi
        return newStatus == 2; // Hanya bisa ke Disetujui
      case 2: // Disetujui
        return newStatus == 3; // Hanya bisa ke Selesai
      case 4: // Pembatalan Diproses - BARU: bisa ditolak atau disetujui
        return newStatus == 5 || newStatus == 6; // Bisa ke Pembatalan Ditolak atau Disetujui
      case 5: // Pembatalan Ditolak - bisa ke Selesai
        return newStatus == 3; // Bisa ke Selesai
      default:
        return false;
    }
  }

  // Method helper untuk cek apakah bisa reject cancel request
  static bool canRejectCancelRequest(int currentStatus) {
    return currentStatus == 4; // Pembatalan Diproses
  }

  // Method helper untuk cek apakah bisa approve cancel request
  static bool canApproveCancelRequest(int currentStatus) {
    return currentStatus == 4; // Pembatalan Diproses
  }

  // Method helper untuk mendapatkan status color
  static String getStatusColor(int statusId) {
    switch (statusId) {
      case 1:
        return 'orange';
      case 2:
        return 'green';
      case 3:
        return 'blue';
      case 4:
        return 'purple';
      case 5:
        return 'red';
      case 6:
        return 'grey';
      default:
        return 'grey';
    }
  }
}