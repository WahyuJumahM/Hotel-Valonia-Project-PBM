//lib/services/auth/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/auth/user_auth.dart';
import '../ipconfig.dart';

class AuthService {
  static const String baseUrl = '${IpConfig.baseUrl}api/Auth';

  static Future<Map<String, dynamic>> loginUser(LoginRequest loginRequest) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login-user'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(loginRequest.toJson()),
      );

      Map<String, dynamic>? responseData;
      try {
        responseData = json.decode(response.body);
      } catch (e) {
        responseData = null;
      }

      if (response.statusCode == 200) {
        await _saveAuthData(responseData);
        return {
          'success': true,
          'data': responseData,
          'message': 'Login berhasil'
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': responseData != null
              ? (responseData['message'] ?? 'Login gagal')
              : 'Login gagal'
        };
      }
    } catch (e) {
      print("Error loginUser: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  static Future<Map<String, dynamic>> loginAdmin(LoginRequest loginRequest) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login-admin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(loginRequest.toJson()),
      );

      Map<String, dynamic>? responseData;
      try {
        responseData = json.decode(response.body);
      } catch (e) {
        responseData = null;
      }

      if (response.statusCode == 200) {
        if (responseData != null) {
          responseData['isAdmin'] = true;
        }
        await _saveAuthData(responseData);
        return {
          'success': true,
          'data': responseData,
          'message': 'Login admin berhasil'
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': responseData != null
              ? (responseData['message'] ?? 'Login admin gagal')
              : 'Login admin gagal'
        };
      }
    } catch (e) {
      print("Error loginAdmin: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  static Future<Map<String, dynamic>> attemptLogin(LoginRequest loginRequest) async {
    final userResult = await loginUser(loginRequest);
    if (userResult['success']) return userResult;

    final adminResult = await loginAdmin(loginRequest);
    if (adminResult['success']) return adminResult;

    return {
      'success': false,
      'data': null,
      'message': 'Email atau password salah'
    };
  }

  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
    } catch (e) {
      throw Exception('Gagal melakukan logout');
    }
  }

  static Future<User?> getStoredUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userData = prefs.getString('user_data');

      if (token != null && userData != null && token.isNotEmpty) {
        if (await _isTokenValid(token)) {
          final data = json.decode(userData);
          print("Data user tersimpan: $data");
          return User.fromJson(data);
        } else {
          await logout();
          return null;
        }
      }
      return null;
    } catch (e) {
      print("Error getting stored user: $e");
      return null;
    }
  }

  static Future<bool> _isTokenValid(String token) async {
    try {
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

  static Future<bool> verifyTokenWithServer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) return false;

      final response = await http.get(
        Uri.parse('$baseUrl/verify-token'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) return true;

      await logout();
      return false;
    } catch (e) {
      print("Error verifying token with server: $e");
      return false;
    }
  }

  static Future<void> _saveAuthData(Map<String, dynamic>? data) async {
    if (data == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', data['token'] ?? '');
    await prefs.setString('user_data', json.encode(data));
    print("Menyimpan auth data: ${json.encode(data)}");
  }
  
}
