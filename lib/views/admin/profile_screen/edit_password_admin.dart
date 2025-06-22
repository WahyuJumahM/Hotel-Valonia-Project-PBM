//lib/views/admin/profile_screen/edit_password_admin.dart
import 'package:apphotel_valonia/viewmodels/auth/user_auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/admin/admin_profile_viewmodel.dart';

class EditPasswordAdminPage extends StatefulWidget {
  const EditPasswordAdminPage({super.key});

  @override
  State<EditPasswordAdminPage> createState() => _EditPasswordAdminPageState();
}

class _EditPasswordAdminPageState extends State<EditPasswordAdminPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  static const double _borderRadius = 12.0;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        title: const Text(
          'Ganti Password',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<AdminProfileViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView( // Tambahkan ini
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      _buildInfoCard(),
                      const SizedBox(height: 24),
                      _buildPasswordForm(),
                      const SizedBox(height: 20),
                      _buildSaveButton(viewModel),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),

    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Pastikan password baru Anda aman dan mudah diingat. Password harus minimal 6 karakter.',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Informasi Password',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          _buildPasswordField(
            controller: _oldPasswordController,
            label: 'Password Lama',
            hintText: 'Masukkan password lama Anda',
            isVisible: _isOldPasswordVisible,
            onToggleVisibility: () => setState(() => _isOldPasswordVisible = !_isOldPasswordVisible),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password lama tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            controller: _newPasswordController,
            label: 'Password Baru',
            hintText: 'Masukkan password baru Anda',
            isVisible: _isNewPasswordVisible,
            onToggleVisibility: () => setState(() => _isNewPasswordVisible = !_isNewPasswordVisible),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password baru tidak boleh kosong';
              }
              if (value.length < 6) {
                return 'Password baru minimal 6 karakter';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            controller: _confirmPasswordController,
            label: 'Konfirmasi Password Baru',
            hintText: 'Masukkan ulang password baru Anda',
            isVisible: _isConfirmPasswordVisible,
            onToggleVisibility: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Konfirmasi password tidak boleh kosong';
              }
              if (value != _newPasswordController.text) {
                return 'Konfirmasi password tidak cocok';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400]),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[600],
              ),
              onPressed: onToggleVisibility,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(AdminProfileViewModel viewModel) {
    return ElevatedButton(
      onPressed: viewModel.isUpdating ? null : _handleSavePassword,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        elevation: 2,
      ),
      child: viewModel.isUpdating
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text('Memperbarui Password...'),
              ],
            )
          : const Text(
              'Ubah',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  Future<void> _handleSavePassword() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = Provider.of<AdminProfileViewModel>(context, listen: false);
      
      final success = await viewModel.updatePassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (mounted) {
        if (success) {
          _showSuccessDialog();
        } else {
          _showErrorSnackBar(viewModel.errorMessage ?? 'Gagal memperbarui password');
        }
      }
    }
  }

  void _showSuccessDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      icon: const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 48,
      ),
      title: const Text(
        'Password Berhasil Diperbarui',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      content: const Text(
        'Password Anda telah berhasil diperbarui.\nSilakan login kembali.',
        textAlign: TextAlign.center,
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop(); // Tutup dialog

            // Lakukan logout dan navigasi ke halaman login
            final userViewModel = Provider.of<UserViewModel>(context, listen: false);
            await userViewModel.logout();

            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login', // Pastikan ini adalah route halaman login kamu
                (route) => false,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}


  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}