import 'package:flutter/material.dart';
import '../../models/user/user_update_password.dart';
import '../../services/user/user_profile_service.dart';

class UpdatePasswordViewmodel extends ChangeNotifier {
  final UserProfileService _service = UserProfileService();
  bool isLoading = false;
  String? errorMessage;

  Future<bool> updatePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    if (newPassword != confirmPassword) {
      errorMessage = 'Konfirmasi password tidak cocok';
      isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final dto = UserUpdatePasswordDto(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      final result = await _service.updatePassword(dto);

      isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
