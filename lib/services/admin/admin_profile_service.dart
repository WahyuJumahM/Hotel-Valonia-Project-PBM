// Flutter AdminProfileService - DIPERBAIKI
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../ipconfig.dart';
import '../admin/profile_cloudinary_service.dart';
import '../../models/admin/admin_model.dart';

class AdminProfileService {
  static const String baseUrl = '${IpConfig.baseUrl}api/AdminRole';
  final CloudinaryService _cloudinaryService = CloudinaryService();

  Future<String?> _getToken() async {
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

  // GET - Ambil profil admin
  Future<Map<String, dynamic>> getAdminProfile() async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'data': null,
          'message': 'Token tidak ditemukan'
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Get profile response status: ${response.statusCode}');
      print('Get profile response body: ${response.body}');

      Map<String, dynamic>? responseData;
      try {
        responseData = json.decode(response.body);
      } catch (e) {
        responseData = null;
      }

      if (response.statusCode == 200) {
        Admin? admin;
        if (responseData != null) {
          admin = Admin.fromJson(responseData);
        }

        return {
          'success': true,
          'data': admin,
          'message': 'Profil berhasil dimuat'
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': responseData != null
              ? (responseData['message'] ?? 'Gagal mengambil profil')
              : 'Gagal mengambil profil'
        };
      }
    } catch (e) {
      print("Error getAdminProfile: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  // PUT - Update profil admin - DIPERBAIKI
  Future<Map<String, dynamic>> updateAdminProfile(Admin admin) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'data': null,
          'message': 'Token tidak ditemukan'
        };
      }

      final requestBody = admin.toJson();
      
      print('Update profile request body: ${json.encode(requestBody)}');

      final response = await http.put(
        Uri.parse('$baseUrl/profile/update'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('Update profile response status: ${response.statusCode}');
      print('Update profile response body: ${response.body}');

      // PERBAIKAN: Handle berbagai status code yang mungkin berhasil
      if (response.statusCode == 200 || response.statusCode == 204) {
        Map<String, dynamic>? responseData;
        Admin? updatedAdmin;

        // Jika ada response body, parse sebagai JSON
        if (response.body.isNotEmpty) {
          try {
            responseData = json.decode(response.body);
            if (responseData != null) {
              updatedAdmin = Admin.fromJson(responseData);
            }
          } catch (e) {
            print('Error parsing response JSON: $e');
            // Jika gagal parse, gunakan data yang kita kirim
            updatedAdmin = admin;
          }
        } else {
          // Jika response kosong (204 No Content), gunakan data yang kita kirim
          updatedAdmin = admin;
        }

        return {
          'success': true,
          'data': updatedAdmin ?? admin,
          'message': 'Profil berhasil diperbarui'
        };
      } 
      
      // Handle error responses
      Map<String, dynamic>? errorData;
      try {
        errorData = json.decode(response.body);
      } catch (e) {
        errorData = null;
      }

      return {
        'success': false,
        'data': null,
        'message': errorData != null
            ? (errorData['message'] ?? 'Gagal memperbarui profil')
            : 'Gagal memperbarui profil (Status: ${response.statusCode})'
      };
    } catch (e) {
      print("Error updateAdminProfile: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  // PUT - Update password admin - DIPERBAIKI
  Future<Map<String, dynamic>> updateAdminPassword(UpdatePasswordRequest request) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'data': null,
          'message': 'Token tidak ditemukan'
        };
      }

      final requestBody = request.toJson();

      print('Update password request body: ${json.encode(requestBody)}');

      final response = await http.put(
        Uri.parse('$baseUrl/password'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('Update password response status: ${response.statusCode}');
      print('Update password response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic>? responseData;
        try {
          responseData = json.decode(response.body);
        } catch (e) {
          responseData = {'message': 'Password berhasil diperbarui'};
        }

        return {
          'success': true,
          'data': responseData,
          'message': responseData?['message'] ?? 'Password berhasil diperbarui'
        };
      } else {
        Map<String, dynamic>? errorData;
        try {
          errorData = json.decode(response.body);
        } catch (e) {
          errorData = null;
        }

        return {
          'success': false,
          'data': null,
          'message': errorData != null
              ? (errorData['message'] ?? 'Gagal memperbarui password')
              : 'Gagal memperbarui password'
        };
      }
    } catch (e) {
      print("Error updateAdminPassword: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  // Upload foto profil ke Cloudinary
  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      print('Uploading profile image to Cloudinary...');
      
      final imageUrl = await _cloudinaryService.uploadImageUnsigned(
        imageFile,
        uploadPreset: 'admin_profile_pictures',
        folder: 'valonia/adminrole',
      );

      if (imageUrl != null) {
        print('Profile image uploaded successfully: $imageUrl');
        return imageUrl;
      } else {
        print('Failed to upload profile image');
        return null;
      }
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }
}