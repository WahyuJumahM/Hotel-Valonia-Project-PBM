//lib/views/admin/profile_screen/profile_admin.dart
// ignore_for_file: unused_element

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/admin/admin_profile_viewmodel.dart';
import '../../../widgets/admin/bottom_navbar.dart';
import '../../../services/auth/auth_service.dart';
import 'edit_password_admin.dart';

class ProfileAdminPage extends StatefulWidget {
  const ProfileAdminPage({super.key});

  @override
  State<ProfileAdminPage> createState() => _ProfileAdminPageState();
}

class _ProfileAdminPageState extends State<ProfileAdminPage> {
  final ImagePicker _picker = ImagePicker();

  static const Color _primaryColor = Colors.blue; // Light blue color
  static const Color _textColor = Colors.black;
  static const double _borderRadius = 16.0;
  static const double _spacing = 24.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProfileViewModel>(context, listen: false).loadAdminProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        title: const Text(
          'Profil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<AdminProfileViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading && viewModel.adminProfile == null) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                ),
              );
            }

            if (viewModel.errorMessage != null && viewModel.adminProfile == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => viewModel.loadAdminProfile(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => viewModel.refreshProfile(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _buildProfilePicture(viewModel),
                    const SizedBox(height: _spacing * 1.5),
                    _buildProfileInfo(viewModel),
                    const SizedBox(height: _spacing),
                    _buildActionButtons(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNavbar(currentIndex: 4),
    );
  }

  Widget _buildProfilePicture(AdminProfileViewModel viewModel) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[300],
            backgroundImage: _getProfileImage(viewModel.adminPhoto),
            child: _getProfileImage(viewModel.adminPhoto) == null
                ? const Icon(
                    Icons.admin_panel_settings,
                    size: 70,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: GestureDetector(
            onTap: viewModel.isUpdating ? null : () => _showImagePicker(viewModel),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: viewModel.isUpdating ? Colors.grey : Colors.blue[700],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: viewModel.isUpdating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  ImageProvider? _getProfileImage(String? fotoProfil) {
    if (fotoProfil != null && fotoProfil.isNotEmpty && fotoProfil != 'null') {
      // Check if it's a local path (starts with /) or URL
      if (fotoProfil.startsWith('/')) {
        return FileImage(File(fotoProfil));
      } else {
        return NetworkImage(fotoProfil);
      }
    }
    return null;
  }

  Widget _buildProfileInfo(AdminProfileViewModel viewModel) {
    return Container(
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
        children: [
          _buildProfileItem(
            icon: Icons.person_outline,
            title: 'Nama Admin',
            subtitle: viewModel.adminName.isNotEmpty 
                ? viewModel.adminName 
                : 'Belum diisi',
            onTap: viewModel.isUpdating
                ? null
                : () => _showEditDialog(
                    'Nama Admin',
                    viewModel.adminName,
                    (value) => viewModel.updateField('nama', value),
                  ),
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: viewModel.adminEmail.isNotEmpty 
                ? viewModel.adminEmail 
                : 'Belum diisi',
            onTap: viewModel.isUpdating
                ? null
                : () => _showEditDialog(
                    'Email',
                    viewModel.adminEmail,
                    (value) => viewModel.updateField('email', value),
                    inputType: TextInputType.emailAddress,
                  ),
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.phone_outlined,
            title: 'No. Handphone',
            subtitle: viewModel.adminPhone.isNotEmpty 
                ? viewModel.adminPhone 
                : 'Belum diisi',
            onTap: viewModel.isUpdating
                ? null
                : () => _showEditDialog(
                    'No. Handphone',
                    viewModel.adminPhone,
                    (value) => viewModel.updateField('no_handphone', value),
                    inputType: TextInputType.phone,
                    placeholder: 'Contoh: 08123456789',
                  ),
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.lock_outline,
            title: 'Ganti Password',
            subtitle: 'Ketuk untuk mengubah kata sandi',
            onTap: () => _navigateToEditPassword(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue[700], size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: _textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: subtitle == 'Belum diisi' ? Colors.red[300] : Colors.grey[600],
          fontSize: 14,
        ),
      ),
      trailing: onTap != null
          ? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400])
          : null,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
      indent: 70,
      endIndent: 20,
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () => _showLogoutDialog(),
          icon: const Icon(Icons.logout, color: Colors.red),
          label: const Text(
            'Keluar',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      ],
    );
  }

  void _showImagePicker(AdminProfileViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_borderRadius),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pilih Foto Profil Admin',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildImageOption(
                      icon: Icons.camera_alt,
                      label: 'Kamera',
                      onTap: () => _pickImage(ImageSource.camera, viewModel),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildImageOption(
                      icon: Icons.photo_library,
                      label: 'Galeri',
                      onTap: () => _pickImage(ImageSource.gallery, viewModel),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _primaryColor.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: _primaryColor, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage(ImageSource source, AdminProfileViewModel viewModel) async {
    Navigator.pop(context);

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final File imageFile = File(image.path);
        final success = await viewModel.updateProfilePhoto(imageFile);

        if (success) {
          if (mounted) {
            _showSuccessSnackBar('Foto profil berhasil diperbarui');
          }
        } else {
          if (mounted) {
            _showErrorSnackBar(
              viewModel.errorMessage ?? 'Gagal memperbarui foto profil'
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Gagal memilih foto: ${e.toString()}');
      }
    }
  }

  void _showEditDialog(
    String field,
    String currentValue,
    Function(String) onSave, {
    TextInputType? inputType,
    String? placeholder,
    int? maxLength,
  }) {
    final controller = TextEditingController(text: currentValue);
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          title: Text(
            'Ubah $field',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          content: TextField(
            controller: controller,
            keyboardType: inputType,
            maxLength: maxLength,
            inputFormatters: inputType == TextInputType.number
                ? [FilteringTextInputFormatter.digitsOnly]
                : null,
            decoration: InputDecoration(
              labelText: placeholder ?? 'Masukkan $field baru',
              labelStyle: const TextStyle(
                color: Color.fromARGB(255, 102, 102, 102),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: _primaryColor,
                  width: 2,
                ),
              ),
              counterText: '',
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.red)),
              
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final value = controller.text.trim();

                      // Validation
                      if (value.isNotEmpty) {
                        if (field == 'Email' && !_isValidEmail(value)) {
                          _showErrorSnackBar('Format email tidak valid');
                          return;
                        }

                        if (field == 'No. Handphone' && !_isValidPhoneNumber(value)) {
                          _showErrorSnackBar(
                            'Format nomor handphone tidak valid (contoh: 08123456789)',
                          );
                          return;
                        }
                      }

                      setState(() => isLoading = true);

                      try {
                        final success = await onSave(value);
                        if (mounted) {
                          Navigator.pop(context);
                          if (success) {
                            _showSuccessSnackBar('$field berhasil diperbarui');
                          } else {
                            final viewModel = Provider.of<AdminProfileViewModel>(
                              context, 
                              listen: false
                            );
                            _showErrorSnackBar(
                              viewModel.errorMessage ?? 'Gagal memperbarui $field'
                            );
                          }
                        }
                      } catch (e) {
                        if (mounted) {
                          _showErrorSnackBar('Gagal memperbarui $field');
                        }
                      } finally {
                        if (mounted) {
                          setState(() => isLoading = false);
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  // Validation methods
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhoneNumber(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    return RegExp(r'^(0|62|\+62)?8[1-9][0-9]{6,11}$').hasMatch(cleanPhone);
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        title: const Text('Konfirmasi Keluar'),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari panel admin?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              try {
                // Clear ViewModel data
                final viewModel = Provider.of<AdminProfileViewModel>(
                  context, 
                  listen: false
                );
                viewModel.clearData();

                // Use AuthService logout method to clear shared preferences
                await AuthService.logout();

                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              } catch (e) {
                _showErrorSnackBar('Gagal logout: ${e.toString()}');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void _navigateToEditPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditPasswordAdminPage(),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void _showInfoSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }
}