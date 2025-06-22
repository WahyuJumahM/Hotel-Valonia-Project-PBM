import 'package:flutter/material.dart';
import '../../models/auth/user_register.dart';
import '../../services/auth/register_service.dart';

class RegisterViewModel extends ChangeNotifier {
  // Controllers untuk form
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController noHandphoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // State variables
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;
  String _errorMessage = '';

  // Getters
  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  bool get agreeTerms => _agreeTerms;
  String get errorMessage => _errorMessage;

  // Validation
  bool get isFormValid {
    return namaLengkapController.text.isNotEmpty &&
           emailController.text.isNotEmpty &&
           nikController.text.isNotEmpty &&
           noHandphoneController.text.isNotEmpty &&
           passwordController.text.isNotEmpty &&
           confirmPasswordController.text.isNotEmpty &&
           _agreeTerms &&
           _isPasswordMatch;
  }

  bool get _isPasswordMatch {
    return passwordController.text == confirmPasswordController.text;
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  // Toggle agreement
  void toggleAgreement(bool? value) {
    _agreeTerms = value ?? false;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Validate email format
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate form
  String? validateForm() {
    if (namaLengkapController.text.isEmpty) {
      return 'Nama lengkap tidak boleh kosong';
    }
    
    if (emailController.text.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    
    if (!isValidEmail(emailController.text)) {
      return 'Format email tidak valid';
    }
    
    if (nikController.text.isEmpty) {
      return 'NIK tidak boleh kosong';
    }
    
    if (nikController.text.length != 16) {
      return 'NIK harus terdiri dari 16 digit';
    }
    
    if (noHandphoneController.text.isEmpty) {
      return 'Nomor handphone tidak boleh kosong';
    }
    
    if (passwordController.text.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    
    if (passwordController.text.length < 6) {
      return 'Password minimal 6 karakter';
    }
    
    if (!_isPasswordMatch) {
      return 'Konfirmasi password tidak cocok';
    }
    
    if (!_agreeTerms) {
      return 'Anda harus menyetujui syarat dan ketentuan';
    }
    
    return null;
  }

  // Register function
  Future<bool> register() async {
    // Validate form first
    final validationError = validateForm();
    if (validationError != null) {
      _errorMessage = validationError;
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final registerRequest = RegisterRequest(
        namaLengkap: namaLengkapController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        nik: int.parse(nikController.text),
        noHandphone: int.parse(noHandphoneController.text),
        fotoProfil: '', // Default empty string
      );

      final response = await ApiService.registerUser(registerRequest);

      if (response['success']) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear all form data
  void clearForm() {
    namaLengkapController.clear();
    emailController.clear();
    nikController.clear();
    noHandphoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    _agreeTerms = false;
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    namaLengkapController.dispose();
    emailController.dispose();
    nikController.dispose();
    noHandphoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}