// viewmodels/user_profile_viewmodel.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../models/user/user_profile.dart';
import '../../models/user/user_update_profile.dart';
import '../../services/user/user_profile_service.dart';

class UserProfileViewModel extends ChangeNotifier {
  final UserProfileService _userProfileService = UserProfileService();
  
  // State variables
  UserProfile? _userProfile;
  bool _isLoading = false;
  bool _isUpdating = false;
  String? _errorMessage;
  String? _successMessage;

  // Getters
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get hasError => _errorMessage != null;
  bool get hasSuccess => _successMessage != null;

  // Method untuk load user profile
  Future<void> loadUserProfile() async {
    _setLoading(true);
    _clearMessages();
    
    try {
      print('Loading user profile...');
      _userProfile = await _userProfileService.getUserProfile();
      print('User profile loaded successfully');
      notifyListeners();
    } catch (e) {
      print('Error loading profile: $e');
      _setError('Gagal memuat profil: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Method untuk refresh data
  Future<void> refreshUserProfile() async {
    await loadUserProfile();
  }

  // Method untuk update profile lengkap dengan foto
  Future<bool> updateProfileWithImage({
    String? namaLengkap,
    String? email,
    int? nik,
    int? noHandphone,
    File? imageFile,
  }) async {
    _setUpdating(true);
    _clearMessages();
    
    try {
      // Validasi input
      if (email != null && email.isNotEmpty && !_userProfileService.isValidEmail(email)) {
        _setError('Format email tidak valid');
        return false;
      }

      if (noHandphone != null && noHandphone != 0) {
        final phoneStr = noHandphone.toString();
        if (!_userProfileService.isValidPhoneNumber(phoneStr)) {
          _setError('Format nomor handphone tidak valid (contoh: 08123456789)');
          return false;
        }
      }

      if (nik != null && nik != 0) {
        final nikStr = nik.toString();
        if (!_userProfileService.isValidNIK(nikStr)) {
          _setError('NIK harus 16 digit');
          return false;
        }
      }

      final updateData = UserUpdateProfile(
        namaLengkap: namaLengkap?.isNotEmpty == true ? namaLengkap : null,
        email: email?.isNotEmpty == true ? email : null,
        nik: nik != null && nik > 0 ? nik : null,
        noHandphone: noHandphone != null && noHandphone > 0 ? noHandphone : null,
      );

      print('Updating profile with image...');
      _userProfile = await _userProfileService.updateProfileWithImage(
        updateData: updateData,
        imageFile: imageFile,
      );
      
      if (_userProfile != null) {
        _setSuccess('Profil berhasil diperbarui');
        notifyListeners();
        return true;
      } else {
        _setError('Gagal memperbarui profil');
        return false;
      }
    } catch (e) {
      print('Error updating profile with image: $e');
      _setError('Gagal memperbarui profil: ${e.toString()}');
      return false;
    } finally {
      _setUpdating(false);
    }
  }

  // Method untuk update foto profil saja
  Future<bool> updateProfilePhoto(File imageFile) async {
    _setUpdating(true);
    _clearMessages();
    
    try {
      print('Updating profile photo...');
      _userProfile = await _userProfileService.updateProfilePhoto(imageFile);
      
      if (_userProfile != null) {
        _setSuccess('Foto profil berhasil diperbarui');
        notifyListeners();
        return true;
      } else {
        _setError('Gagal memperbarui foto profil');
        return false;
      }
    } catch (e) {
      print('Error updating profile photo: $e');
      _setError('Gagal memperbarui foto profil: ${e.toString()}');
      return false;
    } finally {
      _setUpdating(false);
    }
  }

  // Method untuk update field tertentu
  Future<bool> updateProfileField({
    String? namaLengkap,
    String? email,
    int? nik,
    int? noHandphone,
  }) async {
    _setUpdating(true);
    _clearMessages();
    
    try {
      print('Updating profile field...');
      
      // Validasi input
      if (email != null && email.isNotEmpty && !_userProfileService.isValidEmail(email)) {
        _setError('Format email tidak valid');
        return false;
      }

      if (noHandphone != null && noHandphone != 0) {
        final phoneStr = noHandphone.toString();
        if (!_userProfileService.isValidPhoneNumber(phoneStr)) {
          _setError('Format nomor handphone tidak valid (contoh: 08123456789)');
          return false;
        }
      }

      if (nik != null && nik != 0) {
        final nikStr = nik.toString();
        if (!_userProfileService.isValidNIK(nikStr)) {
          _setError('NIK harus 16 digit');
          return false;
        }
      }

      _userProfile = await _userProfileService.updateProfileField(
        namaLengkap: namaLengkap?.isNotEmpty == true ? namaLengkap : null,
        email: email?.isNotEmpty == true ? email : null,
        nik: nik != null && nik > 0 ? nik : null,
        noHandphone: noHandphone != null && noHandphone > 0 ? noHandphone : null,
      );
      
      if (_userProfile != null) {
        _setSuccess('Profil berhasil diperbarui');
        notifyListeners();
        return true;
      } else {
        _setError('Gagal memperbarui profil');
        return false;
      }
    } catch (e) {
      print('Error updating profile field: $e');
      _setError('Gagal memperbarui profil: ${e.toString()}');
      return false;
    } finally {
      _setUpdating(false);
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setUpdating(bool updating) {
    _isUpdating = updating;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _successMessage = null;
    notifyListeners();
  }

  void _setSuccess(String success) {
    _successMessage = success;
    _errorMessage = null;
    notifyListeners();
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  // Method untuk clear data (saat logout)
  void clearUserProfile() {
    _userProfile = null;
    _errorMessage = null;
    _successMessage = null;
    _isLoading = false;
    _isUpdating = false;
    notifyListeners();
  }

  // Method untuk clear messages
  void clearMessages() {
    _clearMessages();
    notifyListeners();
  }

  // Getter methods untuk individual fields (untuk kemudahan akses di UI)
  String get namaLengkap => _userProfile?.namaLengkap ?? '';
  String get email => _userProfile?.email ?? '';
  String get noHandphone => _userProfile?.noHandphone.toString() ?? '0';
  String get nik => _userProfile?.nik.toString() ?? '0';
  String get fotoProfil => _userProfile?.fotoProfil ?? '';
  int get idUser => _userProfile?.idUser ?? 0;

  // Helper methods untuk validasi
  bool isValidEmail(String email) => _userProfileService.isValidEmail(email);
  bool isValidPhoneNumber(String phone) => _userProfileService.isValidPhoneNumber(phone);
  bool isValidNIK(String nik) => _userProfileService.isValidNIK(nik);

  // Format display untuk UI
  String get displayNoHandphone {
    final phone = noHandphone;
    return phone == '0' ? 'Belum diisi' : phone;
  }

  String get displayNik {
    final nikValue = nik;
    return nikValue == '0' ? 'Belum diisi' : nikValue;
  }

  String get displayEmail {
    return email.isEmpty ? 'Belum diisi' : email;
  }

  String get displayNamaLengkap {
    return namaLengkap.isEmpty ? 'Belum diisi' : namaLengkap;
  }
}
