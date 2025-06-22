// lib/services/booking_detail_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/admin/booking_model.dart';
import '../ipconfig.dart';

class BookingDetailService {
  static const String baseUrl = '${IpConfig.baseUrl}api/Booking';

  /// Mengambil detail booking berdasarkan ID
  static Future<Map<String, dynamic>> getBookingDetail(int bookingId) async {
    try {
      // Ambil token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'data': null,
          'message': 'Token tidak ditemukan, silakan login kembali'
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/Detail/$bookingId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      Map<String, dynamic>? responseData;
      try {
        responseData = json.decode(response.body);
      } catch (e) {
        responseData = null;
      }

      if (response.statusCode == 200) {
        if (responseData != null && responseData['success'] == true) {
          return {
            'success': true,
            'data': responseData['data'],
            'message': 'Data booking berhasil diambil'
          };
        } else {
          return {
            'success': false,
            'data': null,
            'message': responseData?['message'] ?? 'Data booking tidak ditemukan'
          };
        }
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'data': null,
          'message': 'Token tidak valid, silakan login kembali'
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'data': null,
          'message': 'Booking tidak ditemukan'
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': responseData != null
              ? (responseData['message'] ?? 'Gagal mengambil data booking')
              : 'Gagal mengambil data booking'
        };
      }
    } catch (e) {
      print("Error getBookingDetail: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  /// Convert response data ke BookingAdminDetail object
  static BookingAdminDetail? parseBookingDetail(Map<String, dynamic>? data) {
    if (data == null) return null;
    
    try {
      return BookingAdminDetail(
        idBooking: data['id_Booking'] ?? 0,
        idUser: data['id_User'] ?? 0,
        idAdmin: data['id_Admin'],
        catatan: data['catatan'],
        cekIn: DateTime.parse(data['cek_In'] ?? DateTime.now().toIso8601String()),
        cekOut: DateTime.parse(data['cek_Out'] ?? DateTime.now().toIso8601String()),
        totalHarga: data['total_Harga']?.toDouble(),
        namaLengkap: data['nama_Lengkap'] ?? '',
        email: data['email'] ?? '',
        nik: data['nik'] ?? 0,
        noHandphone: data['no_Handphone'] ?? 0,
        idKamar: data['id_Kamar'] ?? 0,
        namaKamar: data['nama_Kamar'] ?? '',
        lantai: data['lantai'] ?? 0,
        jumlahDireservasi: data['jumlah_Direservasi'],
        idJenisKamar: data['id_Jenis_Kamar'] ?? 0,
        namaJenisKamar: data['nama_Jenis_Kamar'] ?? '',
        harga: data['harga']?.toDouble() ?? 0.0,
        kapasitas: data['kapasitas'] ?? 0,
        fotoKamar: data['foto_Kamar'],
        idTipeKasur: data['id_Tipe_Kasur'] ?? 0,
        tipeKasur: data['tipe_Kasur'] ?? '',
        idStatus: data['id_Status'] ?? 0,
        namaStatus: data['nama_Status'] ?? '',
      );
    } catch (e) {
      print("Error parsing booking detail: $e");
      return null;
    }
  }

  // ignore: unused_element
  static Future<bool> _isTokenValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null || token.isEmpty) return false;

      final parts = token.split('.');
      if (parts.length != 3) return false;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> payloadMap = json.decode(decoded);

      if (payloadMap.containsKey('exp')) {
        final exp = payloadMap['exp'];
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        if (exp <= now) {
          print("Token expired");
          return false;
        }
      }
      return true;
    } catch (e) {
      print("Error validating token: $e");
      return false;
    }
  }
}