//lib/viewmodels/admin/admin_profile_viewmodel.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../services/admin/admin_profile_service.dart';
import '../../models/admin/admin_model.dart';

class AdminProfileViewModel extends ChangeNotifier {
  final AdminProfileService _adminProfileService = AdminProfileService();

  // State variables
  Admin? _adminProfile;
  bool _isLoading = false;
  bool _isUpdating = false;
  String? _errorMessage;

  // Getters
  Admin? get adminProfile => _adminProfile;
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  String? get errorMessage => _errorMessage;

  // Get admin properties safely
  String get adminName => _adminProfile?.nama ?? 'Administrator';
  String get adminEmail => _adminProfile?.email ?? '';
  String get adminPhone => _adminProfile?.noHandphone ?? '';
  String get adminPhoto => _adminProfile?.fotoProfil ?? '';
  int get adminId => _adminProfile?.idAdmin ?? 1;

  // Load admin profile
  Future<void> loadAdminProfile() async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _adminProfileService.getAdminProfile();
      
      if (result['success']) {
        _adminProfile = result['data'] as Admin?;
        print('Admin profile loaded: $_adminProfile');
      } else {
        _setError(result['message'] ?? 'Gagal memuat profil admin');
      }
    } catch (e) {
      _setError('Terjadi kesalahan: ${e.toString()}');
      print('Error loading admin profile: $e');
    }

    _setLoading(false);
  }

  // Update admin profile - FIXED VERSION
  Future<bool> updateAdminProfile({
    required String nama,
    required String email,
    required String noHandphone,
    String? fotoProfil,
  }) async {
    _setUpdating(true);
    _clearError();

    try {
      // PERBAIKAN: Gunakan ID admin yang sebenarnya dari profile yang sudah di-load
      final currentId = _adminProfile?.idAdmin ?? 1;
      
      final updatedAdmin = Admin(
        idAdmin: currentId, // Gunakan ID yang sebenarnya
        nama: nama,
        email: email,
        noHandphone: noHandphone,
        fotoProfil: fotoProfil ?? _adminProfile?.fotoProfil ?? '',
      );

      print('Updating admin profile with ID: $currentId');
      print('Admin data to update: ${updatedAdmin.toJson()}');

      final result = await _adminProfileService.updateAdminProfile(updatedAdmin);

      print('Update result: $result'); // Debug log

      if (result['success']) {
        // PERBAIKAN: Handle different response formats
        final responseData = result['data'];
        
        if (responseData != null) {
          // Jika server mengembalikan data admin yang sudah diupdate
          if (responseData is Admin) {
            _adminProfile = responseData;
          } else {
            // Jika server mengembalikan Map, convert ke Admin
            try {
              _adminProfile = Admin.fromJson(responseData);
            } catch (e) {
              print('Error parsing updated admin data: $e');
              // Fallback: update local data dengan data yang kita kirim
              _adminProfile = updatedAdmin;
            }
          }
        } else {
          // Jika server tidak mengembalikan data, update local data
          _adminProfile = updatedAdmin;
        }
        
        print('Profile updated successfully: $_adminProfile');
        _setUpdating(false);
        return true;
      } else {
        final errorMessage = result['message'] ?? 'Gagal memperbarui profil admin';
        print('Update failed: $errorMessage');
        _setError(errorMessage);
        _setUpdating(false);
        return false;
      }
    } catch (e) {
      final errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      print('Error updating admin profile: $e');
      _setError(errorMessage);
      _setUpdating(false);
      return false;
    }
  }

  // Update single field - IMPROVED VERSION
  Future<bool> updateField(String fieldName, String value) async {
    if (_adminProfile == null) {
      print('Error: Admin profile is null');
      _setError('Profil admin belum dimuat');
      return false;
    }

    final currentProfile = _adminProfile!;
    
    // Create updated admin based on field
    Admin updatedAdmin;
    switch (fieldName) {
      case 'nama':
        updatedAdmin = currentProfile.copyWith(nama: value);
        break;
      case 'email':
        updatedAdmin = currentProfile.copyWith(email: value);
        break;
      case 'no_handphone':
        updatedAdmin = currentProfile.copyWith(noHandphone: value);
        break;
      default:
        print('Error: Unknown field name: $fieldName');
        _setError('Field tidak dikenali: $fieldName');
        return false;
    }

    print('Updating field $fieldName with value: $value');

    return await updateAdminProfile(
      nama: updatedAdmin.nama,
      email: updatedAdmin.email,
      noHandphone: updatedAdmin.noHandphone,
      fotoProfil: updatedAdmin.fotoProfil,
    );
  }

  // Upload and update profile photo
  Future<bool> updateProfilePhoto(File imageFile) async {
    _setUpdating(true);
    _clearError();

    try {
      print('Starting profile photo update...');
      
      // Upload image to Cloudinary
      final imageUrl = await _adminProfileService.uploadProfileImage(imageFile);
      
      if (imageUrl != null) {
        print('Image uploaded successfully: $imageUrl');
        
        // Update profile with new photo URL
        final result = await updateAdminProfile(
          nama: adminName,
          email: adminEmail,
          noHandphone: adminPhone,
          fotoProfil: imageUrl,
        );

        if (result) {
          print('Profile photo updated successfully');
          return true;
        } else {
          _setError('Gagal memperbarui foto profil di server');
          return false;
        }
      } else {
        _setError('Gagal mengunggah foto ke server');
        return false;
      }
    } catch (e) {
      _setError('Terjadi kesalahan: ${e.toString()}');
      print('Error updating profile photo: $e');
      return false;
    } finally {
      _setUpdating(false);
    }
  }

  // Update password
  Future<bool> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    _setUpdating(true);
    _clearError();

    try {
      final request = UpdatePasswordRequest(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      final result = await _adminProfileService.updateAdminPassword(request);

      if (result['success']) {
        _setUpdating(false);
        return true;
      } else {
        _setError(result['message'] ?? 'Gagal memperbarui password');
        _setUpdating(false);
        return false;
      }
    } catch (e) {
      _setError('Terjadi kesalahan: ${e.toString()}');
      print('Error updating password: $e');
      _setUpdating(false);
      return false;
    }
  }

  // Refresh profile data
  Future<void> refreshProfile() async {
    await loadAdminProfile();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setUpdating(bool updating) {
    _isUpdating = updating;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear all data (for logout)
  void clearData() {
    _adminProfile = null;
    _isLoading = false;
    _isUpdating = false;
    _errorMessage = null;
    notifyListeners();
  }
}