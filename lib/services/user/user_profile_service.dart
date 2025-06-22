import 'dart:convert';
import 'dart:io';
import 'package:apphotel_valonia/models/user/user_update_password.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user/user_profile.dart';
import '../../models/user/user_update_profile.dart';
import '../ipconfig.dart';
import 'cloudinary_profile_service.dart';

class UserProfileService {
  static const String baseUrl = '${IpConfig.baseUrl}api';
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

  Future<UserProfile?> getUserProfile() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Token tidak ditemukan');

      final response = await http.get(
        Uri.parse('$baseUrl/UserRole'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData is List && jsonData.isNotEmpty) {
          return UserProfile.fromJson(jsonData[0]);
        } else if (jsonData is Map<String, dynamic>) {
          return UserProfile.fromJson(jsonData);
        } else {
          throw Exception('Format response tidak valid');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Token tidak valid atau expired');
      } else if (response.statusCode == 404) {
        throw Exception('Data user tidak ditemukan');
      } else {
        throw Exception('Gagal mengambil data profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getUserProfile: $e');
      rethrow;
    }
  }

  Future<UserProfile?> updateUserProfile(UserUpdateProfile updateData) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Token tidak ditemukan');

      final jsonData = updateData.toJsonOnlyUpdated();
      if (jsonData.isEmpty) throw Exception('Tidak ada data yang diupdate');

      final response = await http.put(
        Uri.parse('$baseUrl/UserRole/update-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(jsonData),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return await getUserProfile();
      } else if (response.statusCode == 401) {
        throw Exception('Token tidak valid atau expired');
      } else if (response.statusCode == 404) {
        throw Exception('User tidak ditemukan');
      } else if (response.statusCode == 400) {
        final responseData = json.decode(response.body);
        final errorMessage = responseData['message'] ?? 'Data tidak valid';
        throw Exception(errorMessage);
      } else {
        throw Exception('Gagal mengupdate profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in updateUserProfile: $e');
      rethrow;
    }
  }

  Future<UserProfile?> updateProfileWithImage({
    required UserUpdateProfile updateData,
    File? imageFile,
  }) async {
    try {
      String? imageUrl;

      if (imageFile != null) {
        imageUrl = await _cloudinaryService.uploadImageUnsigned(imageFile);
        if (imageUrl == null) throw Exception('Gagal upload gambar ke Cloudinary');
      }

      final finalUpdateData = updateData.copyWith(
        fotoProfil: imageUrl ?? updateData.fotoProfil,
      );

      return await updateUserProfile(finalUpdateData);
    } catch (e) {
      print('Error in updateProfileWithImage: $e');
      rethrow;
    }
  }

  Future<UserProfile?> updateProfilePhoto(File imageFile) async {
    try {
      final imageUrl = await _cloudinaryService.uploadImageUnsigned(imageFile);
      if (imageUrl == null) throw Exception('Gagal upload gambar ke Cloudinary');

      final updateData = UserUpdateProfile(fotoProfil: imageUrl);

      return await updateUserProfile(updateData);
    } catch (e) {
      print('Error in updateProfilePhoto: $e');
      rethrow;
    }
  }

  Future<UserProfile?> updateProfileField({
    String? namaLengkap,
    String? email,
    String? password,
    int? nik,
    int? noHandphone,
  }) async {
    try {
      final updateData = UserUpdateProfile(
        namaLengkap: namaLengkap,
        email: email,
        nik: nik,
        noHandphone: noHandphone,
      );

      return await updateUserProfile(updateData);
    } catch (e) {
      print('Error in updateProfileField: $e');
      rethrow;
    }
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isValidPhoneNumber(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    return RegExp(r'^(0|62|\+62)?8[1-9][0-9]{6,11}$').hasMatch(cleanPhone);
  }

  bool isValidNIK(String nik) {
    final cleanNik = nik.replaceAll(RegExp(r'[^\d]'), '');
    return cleanNik.length == 16 && RegExp(r'^[0-9]{16}$').hasMatch(cleanNik);
  }

  String formatPhoneNumber(String phone) {
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.startsWith('62')) {
      cleanPhone = '0${cleanPhone.substring(2)}';
    }
    if (!cleanPhone.startsWith('0')) {
      cleanPhone = '0$cleanPhone';
    }
    return cleanPhone;
  }

  Future<bool> updatePassword(UserUpdatePasswordDto dto) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token tidak ditemukan. Harap login ulang.');
      }

      final url = Uri.parse('$baseUrl/UserRole/update-password');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        final msg = data['message'] ?? 'Permintaan tidak valid';
        throw Exception(msg);
      } else {
        throw Exception('Gagal update password: ${response.body}');
      }
    } catch (e) {
      print('Error in updatePassword: $e');
      rethrow;
    }
  }
}
