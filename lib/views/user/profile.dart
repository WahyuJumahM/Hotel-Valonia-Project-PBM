import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/user/bottom_nav.dart';
import 'edit_password.dart';
import 'bantuan.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  static const Color _primaryColor = Colors.blue;
  static const Color _textColor = Colors.black;
  static const double _borderRadius = 16.0;
  static const double _spacing = 24.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      bottomNavigationBar: const BottomNav(currentIndex: 3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 8),
              _buildProfilePicture(),
              const SizedBox(height: _spacing * 1.5),
              _buildProfileInfo(),
              const SizedBox(height: _spacing),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
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
            backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
            child: _profileImage == null
                ? const Icon(Icons.person, size: 70, color: Colors.white)
                : null,
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: GestureDetector(
            onTap: () => _showImagePicker(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
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

  Widget _buildProfileInfo() {
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
            subtitle: 'Wahyu Jum\'ah Maulidan',
            onTap: () => _showEditDialog('Nama', 'Wahyu Jum\'ah Maulidan'),
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: 'wahyujumahm@gmail.com',
            onTap: () => _showEditDialog('Email', 'wahyujumahm@gmail.com'),
          ),
          _buildDivider(),
          _buildProfileItem(
            icon: Icons.phone_outlined,
            title: 'No. Handphone',
            subtitle: '+62 1232 3847 213',
            onTap: () => _showEditDialog('No. Handphone', '+62 1232 3847 213'),
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
    required VoidCallback onTap,
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
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
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
            icon: const Icon(Icons.help_outline),
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

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(_borderRadius)),
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
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildImageOption(
                      icon: Icons.photo_library,
                      label: 'Galeri',
                      onTap: () => _pickImage(ImageSource.gallery),
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

  void _pickImage(ImageSource source) async {
    Navigator.pop(context);
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
        _showSuccessSnackBar('Foto berhasil ${source == ImageSource.camera ? 'diambil' : 'dipilih'}');
      }
    } catch (e) {
      _showErrorSnackBar('Gagal memilih foto');
    }
  }

  void _showEditDialog(String field, String currentValue) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        title: Text(
          'Ubah $field',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Masukkan $field baru',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _primaryColor, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar('$field berhasil diubah');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implementasi logout
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
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
