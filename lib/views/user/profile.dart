import 'package:flutter/material.dart';
import '../../widgets/user/bottom_nav.dart';
import 'edit_password.dart';
import 'bantuan.dart'; // <--- ini tambahan import ke bantuan.dart

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showEditDialog(BuildContext context, String field, String currentValue) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Ubah $field',
          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Masukkan $field baru',
            hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          style: const TextStyle(color: Color.fromARGB(255, 107, 107, 107)),
          cursorColor: const Color.fromARGB(255, 0, 0, 0),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.blue)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$field berhasil diubah')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text(
              'Simpan',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final contentPadding = mediaQuery.size.width * 0.05;

    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: contentPadding, vertical: 16),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Profil',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ProfileItem(
                  icon: Icons.person,
                  title: 'Nama',
                  subtitle: 'Wahyu Jum’ah maulidan',
                  onTap: () => _showEditDialog(context, 'Nama', 'Wahyu Jum’ah maulidan'),
                ),
                ProfileItem(
                  icon: Icons.email,
                  title: 'Email',
                  subtitle: 'wahyujumahm@gmail.com',
                  onTap: () => _showEditDialog(context, 'Email', 'wahyujumahm@gmail.com'),
                ),
                ProfileItem(
                  icon: Icons.phone,
                  title: 'No. Handphone',
                  subtitle: '+62 1232 3847 213',
                  onTap: () => _showEditDialog(context, 'No. Handphone', '+62 1232 3847 213'),
                ),
                ProfileItem(
                  icon: Icons.lock,
                  title: 'Ganti Password',
                  subtitle: 'Ketuk untuk mengubah sandi Anda',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditPasswordPage()),
                    );
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BantuanPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text('BANTUAN'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Keluar',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                if (isLandscape) const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const ProfileItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.black87)),
      trailing: const Icon(Icons.edit, size: 18, color: Colors.blue),
    );
  }
}
