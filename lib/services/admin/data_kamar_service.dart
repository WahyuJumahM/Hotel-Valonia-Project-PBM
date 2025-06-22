// lib/services/admin/kamar_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/admin/data_kamar_model.dart';
import '../ipconfig.dart';

class DataKamarService {
  static const String baseUrl = '${IpConfig.baseUrl}api/Kamar';

  // Helper method untuk mendapatkan token
  static Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      print("Error getting token: $e");
      return null;
    }
  }

  // Helper method untuk membuat headers dengan token
  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // GET - Fetch semua kamar
  static Future<Map<String, dynamic>> getAllKamar() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: headers,
      );

      print('GET Kamar Response Status: ${response.statusCode}');
      print('GET Kamar Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<Kamar> kamarList = jsonList
            .map((json) => Kamar.fromJson(json))
            .toList();

        return {
          'success': true,
          'data': kamarList,
          'message': 'Data kamar berhasil dimuat'
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': 'Gagal memuat data kamar'
        };
      }
    } catch (e) {
      print("Error getAllKamar: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  // GET - Fetch kamar by ID
  static Future<Map<String, dynamic>> getKamarById(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: headers,
      );

      print('GET Kamar by ID Response Status: ${response.statusCode}');
      print('GET Kamar by ID Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final Kamar kamar = Kamar.fromJson(jsonData);

        return {
          'success': true,
          'data': kamar,
          'message': 'Detail kamar berhasil dimuat'
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': 'Gagal memuat detail kamar'
        };
      }
    } catch (e) {
      print("Error getKamarById: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  // POST - Create kamar baru
  static Future<Map<String, dynamic>> createKamar(KamarCreateRequest request) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: headers,
        body: json.encode(request.toJson()),
      );

      print('POST Create Kamar Response Status: ${response.statusCode}');
      print('POST Create Kamar Response Body: ${response.body}');

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
          'message': 'Kamar berhasil ditambahkan'
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': responseData != null
              ? (responseData['message'] ?? 'Gagal menambahkan kamar')
              : 'Gagal menambahkan kamar'
        };
      }
    } catch (e) {
      print("Error createKamar: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  // PUT - Update kamar
  static Future<Map<String, dynamic>> updateKamar(int id, KamarCreateRequest request) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/update/$id'),
        headers: headers,
        body: json.encode(request.toJson()),
      );

      print('PUT Update Kamar Response Status: ${response.statusCode}');
      print('PUT Update Kamar Response Body: ${response.body}');

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
          'message': 'Kamar berhasil diperbarui'
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': responseData != null
              ? (responseData['message'] ?? 'Gagal memperbarui kamar')
              : 'Gagal memperbarui kamar'
        };
      }
    } catch (e) {
      print("Error updateKamar: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  // GET - Fetch semua jenis kamar (untuk dropdown)
  static Future<Map<String, dynamic>> getAllJenisKamar() async {
    try {
      final headers = await _getHeaders();
      // Asumsi endpoint untuk jenis kamar
      final response = await http.get(
        Uri.parse('${IpConfig.baseUrl}api/JenisKamar'),
        headers: headers,
      );

      print('GET Jenis Kamar Response Status: ${response.statusCode}');
      print('GET Jenis Kamar Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<JenisKamar> jenisKamarList = jsonList
            .map((json) => JenisKamar.fromJson(json))
            .toList();

        return {
          'success': true,
          'data': jenisKamarList,
          'message': 'Data jenis kamar berhasil dimuat'
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': 'Gagal memuat data jenis kamar'
        };
      }
    } catch (e) {
      print("Error getAllJenisKamar: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }
}