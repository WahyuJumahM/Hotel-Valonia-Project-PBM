import 'package:flutter/foundation.dart';
import '../../models/auth/user_auth.dart';
import '../../services/auth/auth_service.dart';

class UserViewModel extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isInitialized = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn =>
      _user != null && _user!.token != null && _user!.token!.isNotEmpty;
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get isInitialized => _isInitialized;

  UserViewModel() {
    _loadStoredUser();
  }

  Future<void> _loadStoredUser() async {
    _setLoading(true);
    try {
      final storedUser = await AuthService.getStoredUser();
      if (storedUser != null) {
        _user = storedUser;
        print(
          "User loaded from storage: ${_user?.email} (ID: ${_user?.userId})",
        );
      } else {
        print("No stored user found or token expired");
      }
    } catch (e) {
      print("Error loading stored user: $e");
      _setError('Gagal memuat data pengguna');
    } finally {
      _setLoading(false);
      _isInitialized = true;
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _setError('Email dan password tidak boleh kosong');
      return false;
    }

    _setLoading(true);
    clearError();

    try {
      final loginRequest = LoginRequest(email: email, password: password);
      final result = await AuthService.attemptLogin(loginRequest);

      if (result['success']) {
        _user = User.fromJson(result['data']);
        print(
          "Login successful: ${_user?.email}, ID: ${_user?.userId}, isAdmin: ${_user?.isAdmin}",
        );
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(result['message']);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      print("Login error: $e");
      _setError('Terjadi kesalahan tidak terduga');
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await AuthService.logout();
      _user = null;
      clearError();
      print("User logged out successfully");
    } catch (e) {
      print("Logout error: $e");
      _setError('Gagal melakukan logout');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> refreshUserData() async {
    await _loadStoredUser();
  }

  Future<bool> checkUserValidity() async {
    if (!isLoggedIn) return false;

    try {
      // Jika kamu mau cek ke server, bisa diaktifkan:
      // final isValid = await AuthService.verifyTokenWithServer();
      // if (!isValid) {
      //   await logout();
      //   return false;
      // }
      return true;
    } catch (e) {
      print("Error checking user validity: $e");
      return false;
    }
  }
}
