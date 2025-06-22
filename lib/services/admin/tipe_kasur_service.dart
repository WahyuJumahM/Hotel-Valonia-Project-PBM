// lib/services/admin/tipe_kasur_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/admin/tipe_kasur_model.dart';
import '../ipconfig.dart';

class TipeKasurService {
  static const String baseUrl = '${IpConfig.baseUrl}api/TipeKasur';

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

  // GET - Ambil semua tipe kasur
  static Future<Map<String, dynamic>> getAllTipeKasur() async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'data': null,
          'message': 'Token tidak ditemukan. Silakan login kembali.',
        };
      }

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('GET TipeKasur Status: ${response.statusCode}');
      print('GET TipeKasur Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<TipeKasur> tipeKasurList =
            jsonList.map((json) => TipeKasur.fromJson(json)).toList();

        return {
          'success': true,
          'data': tipeKasurList,
          'message': 'Data tipe kasur berhasil diambil',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'data': null,
          'message': 'Token tidak valid. Silakan login kembali.',
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': 'Gagal mengambil data tipe kasur',
        };
      }
    } catch (e) {
      print("Error getAllTipeKasur: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // POST - Tambah tipe kasur baru
  static Future<Map<String, dynamic>> createTipeKasur(
    TipeKasur tipeKasur,
  ) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'data': null,
          'message': 'Token tidak ditemukan. Silakan login kembali.',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(tipeKasur.toCreateJson()),
      );

      print('POST TipeKasur Status: ${response.statusCode}');
      print('POST TipeKasur Body: ${response.body}');

      Map<String, dynamic>? responseData;
      try {
        responseData = json.decode(response.body);
      } catch (e) {
        responseData = null;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': responseData,
          'message': 'Tipe kasur berhasil ditambahkan',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'data': null,
          'message': 'Token tidak valid. Silakan login kembali.',
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message':
              responseData != null
                  ? (responseData['message'] ?? 'Gagal menambahkan tipe kasur')
                  : 'Gagal menambahkan tipe kasur',
        };
      }
    } catch (e) {
      print("Error createTipeKasur: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // PUT - Update tipe kasur
  static Future<Map<String, dynamic>> updateTipeKasur(
    TipeKasur tipeKasur,
  ) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'data': null,
          'message': 'Token tidak ditemukan. Silakan login kembali.',
        };
      }

      final response = await http.put(
        Uri.parse('$baseUrl/update/${tipeKasur.idTipeKasur}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(tipeKasur.toUpdateJson()),
      );

      print('PUT TipeKasur Status: ${response.statusCode}');
      print('PUT TipeKasur Body: ${response.body}');

      Map<String, dynamic>? responseData;
      try {
        responseData = json.decode(response.body);
      } catch (e) {
        responseData = null;
      }

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData,
          'message': 'Tipe kasur berhasil diperbarui',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'data': null,
          'message': 'Token tidak valid. Silakan login kembali.',
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message':
              responseData != null
                  ? (responseData['message'] ?? 'Gagal memperbarui tipe kasur')
                  : 'Gagal memperbarui tipe kasur',
        };
      }
    } catch (e) {
      print("Error updateTipeKasur: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // DELETE - Hapus tipe kasur
  static Future<Map<String, dynamic>> deleteTipeKasur(int idTipeKasur) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'data': null,
          'message': 'Token tidak ditemukan. Silakan login kembali.',
        };
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/delete/$idTipeKasur'), // Menggunakan ID di URL path
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        // Menghapus body karena ID sudah ada di URL
      );

      print('DELETE TipeKasur Status: ${response.statusCode}');
      print('DELETE TipeKasur Body: ${response.body}');

      Map<String, dynamic>? responseData;
      try {
        responseData = json.decode(response.body);
      } catch (e) {
        responseData = null;
      }

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData,
          'message': 'Tipe kasur berhasil dihapus',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'data': null,
          'message': 'Token tidak valid. Silakan login kembali.',
        };
      } else if (response.statusCode == 400) {
        return {
          'success': false,
          'data': null,
          'message':
              'Tidak dapat menghapus tipe kasur. Pastikan tipe kasur belum digunakan dalam kamar manapun.',
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message':
              responseData != null
                  ? (responseData['message'] ?? 'Gagal menghapus tipe kasur')
                  : 'Gagal menghapus tipe kasur',
        };
      }
    } catch (e) {
      print("Error deleteTipeKasur: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }
}
