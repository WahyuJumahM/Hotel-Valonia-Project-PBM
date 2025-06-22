// lib/services/kamar/jenis_kamar_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/admin/jenis_kamar_model.dart';
import '../../models/admin/tipe_kasur_model.dart';
import '../ipconfig.dart';

class JenisKamarService {
  static const String baseUrl = '${IpConfig.baseUrl}api';

  // Helper method untuk mendapatkan authentication headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // GET all jenis kamar
  Future<Map<String, dynamic>> getAllJenisKamar() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/JenisKamar'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<JenisKamar> jenisKamarList = jsonList
            .map((json) => JenisKamar.fromJson(json))
            .toList();

        return {
          'success': true,
          'data': jenisKamarList,
          'message': 'Data jenis kamar berhasil diambil'
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': 'Gagal mengambil data jenis kamar'
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

  // GET jenis kamar by id
  Future<Map<String, dynamic>> getJenisKamarById(int id) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/JenisKamar/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final jenisKamar = JenisKamar.fromJson(json);

        return {
          'success': true,
          'data': jenisKamar,
          'message': 'Data jenis kamar berhasil diambil'
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': 'Jenis kamar tidak ditemukan'
        };
      }
    } catch (e) {
      print("Error getJenisKamarById: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  // POST create jenis kamar
  Future<Map<String, dynamic>> createJenisKamar(CreateJenisKamarRequest request) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/JenisKamar/create'),
        headers: headers,
        body: json.encode(request.toJson()),
      );

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
          'message': 'Jenis kamar berhasil ditambahkan'
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': responseData != null
              ? (responseData['message'] ?? 'Gagal menambahkan jenis kamar')
              : 'Gagal menambahkan jenis kamar'
        };
      }
    } catch (e) {
      print("Error createJenisKamar: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

// PUT update jenis kamar - PERBAIKAN
Future<Map<String, dynamic>> updateJenisKamar(int id, CreateJenisKamarRequest request) async {
  try {
    final headers = await _getAuthHeaders();
    final response = await http.put(
      // PERBAIKAN: Tambahkan parameter ID di URL
      Uri.parse('$baseUrl/JenisKamar/update/$id'),
      headers: headers,
      // PERBAIKAN: Tidak perlu menambahkan id_Jenis_Kamar di body karena sudah ada di URL
      body: json.encode(request.toJson()),
    );

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
        'message': 'Jenis kamar berhasil diupdate'
      };
    } else {
      return {
        'success': false,
        'data': null,
        'message': responseData != null
            ? (responseData['message'] ?? 'Gagal mengupdate jenis kamar')
            : 'Gagal mengupdate jenis kamar'
      };
    }
  } catch (e) {
    print("Error updateJenisKamar: $e");
    return {
      'success': false,
      'data': null,
      'message': 'Terjadi kesalahan: ${e.toString()}'
    };
  }
}

  // DELETE jenis kamar
  Future<Map<String, dynamic>> deleteJenisKamar(int id) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/JenisKamar/delete/$id'),
        headers: headers,
      );

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
          'message': 'Jenis kamar berhasil dihapus'
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': responseData != null
              ? (responseData['message'] ?? 'Gagal menghapus jenis kamar')
              : 'Gagal menghapus jenis kamar'
        };
      }
    } catch (e) {
      print("Error deleteJenisKamar: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  // GET all tipe kasur (untuk dropdown)
  Future<Map<String, dynamic>> getAllTipeKasur() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/TipeKasur'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<TipeKasur> tipeKasurList = jsonList
            .map((json) => TipeKasur.fromJson(json))
            .toList();

        return {
          'success': true,
          'data': tipeKasurList,
          'message': 'Data tipe kasur berhasil diambil'
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': 'Gagal mengambil data tipe kasur'
        };
      }
    } catch (e) {
      print("Error getAllTipeKasur: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }
}