import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/auth/user_register.dart';
import '../ipconfig.dart';

class ApiService {
  static const String baseUrl = '${IpConfig.baseUrl}api';

  // Register user
  static Future<Map<String, dynamic>> registerUser(
    RegisterRequest request,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Berhasil register
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'message': 'Registrasi berhasil',
          'data': responseData,
        };
      } else {
        // Error dari server
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message':
              responseData['message'] ?? 'Terjadi kesalahan saat registrasi',
          'data': null,
        };
      }
    } catch (e) {
      print('Error during registration: $e');
      return {
        'success': false,
        'message':
            'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
        'data': null,
      };
    }
  }
}

// Response model untuk standardisasi response
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({required this.success, required this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json, T? data) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: data,
    );
  }
}
