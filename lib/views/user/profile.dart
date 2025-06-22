// views/user/profile_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth/user_auth_viewmodel.dart';
import '../../viewmodels/user/user_profile_viewmodel.dart';
import '../../widgets/user/bottom_nav.dart';
import 'edit_password.dart';
import 'bantuan.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  static const Color _primaryColor = Colors.blue;
  static const Color _textColor = Colors.black;
  static const double _borderRadius = 16.0;
  static const double _spacing = 24.0;

  @override
  void initState() {
    super.initState();
    // Load user profile saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileViewModel = Provider.of<UserProfileViewModel>(
        context,
        listen: false,
      );
      if (profileViewModel.userProfile == null) {
        profileViewModel.loadUserProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      bottomNavigationBar: const BottomNav(currentIndex: 3),
      body: SafeArea(
        child: Consumer<UserProfileViewModel>(
          builder: (context, profileViewModel, child) {
            // Show success message
            if (profileViewModel.hasSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showSuccessSnackBar(profileViewModel.successMessage!);
                profileViewModel.clearMessages();
              });
            }

            // Show error message
            if (profileViewModel.hasError &&
                profileViewModel.userProfile != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showErrorSnackBar(profileViewModel.errorMessage!);
                profileViewModel.clearMessages();
              });
            }

            // Tampilkan loading jika sedang memuat data
            if (profileViewModel.isLoading &&
                profileViewModel.userProfile == null) {
              return const Center(child: CircularProgressIndicator());
            }

            // Tampilkan error jika ada dan tidak ada data
            if (profileViewModel.hasError &&
                profileViewModel.userProfile == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat profil',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profileViewModel.errorMessage ?? 'Terjadi kesalahan',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => profileViewModel.loadUserProfile(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Tampilkan UI normal
            return RefreshIndicator(
              onRefresh: () => profileViewModel.refreshUserProfile(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _buildProfilePicture(profileViewModel),
                    const SizedBox(height: _spacing * 1.5),
                    _buildProfileInfo(profileViewModel),
                    const SizedBox(height: _spacing),
                    _buildActionButtons(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfilePicture(UserProfileViewModel profileViewModel) {
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
            backgroundImage: _getProfileImage(profileViewModel),
            child:
                _getProfileImage(profileViewModel) == null
                    ? const Icon(Icons.person, size: 70, color: Colors.white)
                    : null,
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: GestureDetector(
            onTap:
                profileViewModel.isUpdating
                    ? null
                    : () => _showImagePicker(profileViewModel),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    profileViewModel.isUpdating ? Colors.grey : _primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child:
                  profileViewModel.isUpdating
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

  // Helper method untuk mendapatkan gambar profil
  ImageProvider? _getProfileImage(UserProfileViewModel profileViewModel) {
    final fotoProfil = profileViewModel.fotoProfil;
    if (fotoProfil.isNotEmpty && fotoProfil != 'null' && fotoProfil != '') {
      return NetworkImage(fotoProfil);
    }
    return null;
  }

  Widget _buildProfileInfo(UserProfileViewModel profileViewModel) {
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
            title: 'Nama Lengkap',
            subtitle: profileViewModel.displayNamaLengkap,
            onTap:
                profileViewModel.isUpdating
                    ? null
                    : () => _showEditDialog(
                      'Nama Lengkap',
                      profileViewModel.namaLengkap,
                      (value) => _updateNamaLengkap(profileViewModel, value),
                    ),
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: profileViewModel.displayEmail,
            onTap:
                profileViewModel.isUpdating
                    ? null
                    : () => _showEditDialog(
                      'Email',
                      profileViewModel.email,
                      (value) => _updateEmail(profileViewModel, value),
                      inputType: TextInputType.emailAddress,
                    ),
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.phone_outlined,
            title: 'No. Handphone',
            subtitle: profileViewModel.displayNoHandphone,
            onTap:
                profileViewModel.isUpdating
                    ? null
                    : () => _showEditDialog(
                      'No. Handphone',
                      profileViewModel.noHandphone == '0'
                          ? ''
                          : profileViewModel.noHandphone,
                      (value) => _updateNoHandphone(profileViewModel, value),
                      inputType: TextInputType.phone,
                      placeholder: 'Contoh: 08123456789',
                    ),
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.credit_card_outlined,
            title: 'NIK',
            subtitle: profileViewModel.displayNik,
            onTap:
                profileViewModel.isUpdating
                    ? null
                    : () => _showEditDialog(
                      'NIK',
                      profileViewModel.nik == '0' ? '' : profileViewModel.nik,
                      (value) => _updateNIK(profileViewModel, value),
                      inputType: TextInputType.number,
                      placeholder: '16 digit NIK',
                      maxLength: 16,
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
        child: Icon(icon, color: _primaryColor, size: 24),
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
      trailing:
          onTap != null
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
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _navigateToBantuan(),
            icon: const Icon(Icons.help_outline, color: Colors.blue),
            label: const Text('BANTUAN'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _primaryColor,
              side: BorderSide(color: _primaryColor, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
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

  void _showImagePicker(UserProfileViewModel profileViewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_borderRadius),
        ),
      ),
      builder:
          (context) => SafeArea(
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
                    'Pilih Foto Profil',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildImageOption(
                          icon: Icons.camera_alt,
                          label: 'Kamera',
                          onTap:
                              () => _pickImage(
                                ImageSource.camera,
                                profileViewModel,
                              ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildImageOption(
                          icon: Icons.photo_library,
                          label: 'Galeri',
                          onTap:
                              () => _pickImage(
                                ImageSource.gallery,
                                profileViewModel,
                              ),
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
          color: _primaryColor.withOpacity(0.1),
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

  void _pickImage(
    ImageSource source,
    UserProfileViewModel profileViewModel,
  ) async {
    Navigator.pop(context);
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final imageFile = File(image.path);
        final success = await profileViewModel.updateProfilePhoto(imageFile);

        if (!success && profileViewModel.hasError) {
          _showErrorSnackBar(profileViewModel.errorMessage!);
        }
      }
    } catch (e) {
      _showErrorSnackBar('Gagal memilih foto: ${e.toString()}');
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
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_borderRadius),
                  ),
                  backgroundColor: Colors.white,
                  title: Text(
                    'Ubah $field',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  content: TextField(
                    controller: controller,
                    keyboardType: inputType,
                    maxLength: maxLength,
                    inputFormatters:
                        inputType == TextInputType.number
                            ? [FilteringTextInputFormatter.digitsOnly]
                            : null,
                    decoration: InputDecoration(
                      labelText: placeholder ?? 'Masukkan $field baru',
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
                      onPressed:
                          isLoading ? null : () => Navigator.pop(context),
                      child: Text(
                        'Batal',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : () async {
                                final value = controller.text.trim();

                                // Skip validation if field is being cleared (empty)
                                if (value.isNotEmpty) {
                                  // Validate specific fields
                                  if (field == 'Email' &&
                                      !_isValidEmail(value)) {
                                    _showErrorSnackBar(
                                      'Format email tidak valid',
                                    );
                                    return;
                                  }

                                  if (field == 'No. Handphone' &&
                                      !_isValidPhoneNumber(value)) {
                                    _showErrorSnackBar(
                                      'Format nomor handphone tidak valid (contoh: 08123456789)',
                                    );
                                    return;
                                  }

                                  if (field == 'NIK' && !_isValidNIK(value)) {
                                    _showErrorSnackBar('NIK harus 16 digit');
                                    return;
                                  }
                                }

                                setState(() => isLoading = true);

                                try {
                                  await onSave(value);
                                  // Close dialog if update is successful and no error
                                  if (mounted) {
                                    final profileViewModel =
                                        Provider.of<UserProfileViewModel>(
                                          context,
                                          listen: false,
                                        );
                                    if (!profileViewModel.hasError) {
                                      Navigator.pop(context);
                                    }
                                  }
                                } catch (e) {
                                  // Error handling sudah dilakukan di ViewModel
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
                      child:
                          isLoading
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

  // Validation helper methods
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhoneNumber(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    return RegExp(r'^(0|62|\+62)?8[1-9][0-9]{6,11}$').hasMatch(cleanPhone);
  }

  bool _isValidNIK(String nik) {
    final cleanNik = nik.replaceAll(RegExp(r'[^\d]'), '');
    return cleanNik.length == 16 && RegExp(r'^[0-9]{16}$').hasMatch(cleanNik);
  }

  // Update methods
  Future<void> _updateNamaLengkap(
    UserProfileViewModel profileViewModel,
    String value,
  ) async {
    await profileViewModel.updateProfileField(
      namaLengkap: value.isEmpty ? null : value,
    );
  }

  Future<void> _updateEmail(
    UserProfileViewModel profileViewModel,
    String value,
  ) async {
    await profileViewModel.updateProfileField(
      email: value.isEmpty ? null : value,
    );
  }

  Future<void> _updateNoHandphone(
    UserProfileViewModel profileViewModel,
    String value,
  ) async {
    if (value.isEmpty) {
      await profileViewModel.updateProfileField(noHandphone: null);
      return;
    }

    final phoneNumber = int.tryParse(value);
    if (phoneNumber == null) {
      _showErrorSnackBar('Nomor handphone harus berupa angka');
      return;
    }
    await profileViewModel.updateProfileField(noHandphone: phoneNumber);
  }

  Future<void> _updateNIK(
    UserProfileViewModel profileViewModel,
    String value,
  ) async {
    if (value.isEmpty) {
      await profileViewModel.updateProfileField(nik: null);
      return;
    }

    final nik = int.tryParse(value);
    if (nik == null) {
      _showErrorSnackBar('NIK harus berupa angka');
      return;
    }
    await profileViewModel.updateProfileField(nik: nik);
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
            ),
            title: const Text('Konfirmasi Keluar'),
            content: const Text(
              'Apakah Anda yakin ingin keluar dari aplikasi?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal', style: TextStyle(color: Colors.blue))  ,
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);

                  try {
                    final userViewModel = Provider.of<UserViewModel>(
                      context,
                      listen: false,
                    );
                    final profileViewModel = Provider.of<UserProfileViewModel>(
                      context,
                      listen: false,
                    );

                    await userViewModel.logout();
                    profileViewModel.clearUserProfile(); // Clear profile data

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
      MaterialPageRoute(builder: (_) => const EditPasswordPage()),
    );
  }

  void _navigateToBantuan() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BantuanPage()),
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
}
