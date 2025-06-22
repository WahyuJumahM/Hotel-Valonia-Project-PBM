import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'lokasi.dart';
import '../../viewmodels/admin/admin_profile_viewmodel.dart'; // Sesuaikan path dengan struktur project Anda

class BantuanPage extends StatefulWidget {
  const BantuanPage({super.key});

  @override
  State<BantuanPage> createState() => _BantuanPageState();
}

class _BantuanPageState extends State<BantuanPage> {
  static const Color _primaryColor = Colors.blue;
  static const Color _backgroundColor = Color(0xFFF8F9FA);
  static const Color _cardColor = Colors.white;
  static const double _borderRadius = 16.0;
  static const double _spacing = 20.0;

  @override
  void initState() {
    super.initState();
    // Load admin profile saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<AdminProfileViewModel>(
        context,
        listen: false,
      );
      if (viewModel.adminProfile == null) {
        viewModel.loadAdminProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Consumer<AdminProfileViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(_spacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeCard(),
                  const SizedBox(height: _spacing),
                  _buildContactSection(context, viewModel),
                  const SizedBox(height: _spacing),
                  _buildFAQSection(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      backgroundColor: _cardColor,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: const Text(
        'Pusat Bantuan',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.support_agent,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Butuh Bantuan?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tim kami siap membantu Anda 24/7',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(
    BuildContext context,
    AdminProfileViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'Hubungi Kami',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        _buildContactCard(
          icon: Icons.email_outlined,
          iconColor: Colors.red,
          title: 'Email Customer Service',
          subtitle:
              viewModel.isLoading
                  ? 'Memuat...'
                  : (viewModel.adminEmail.isNotEmpty
                      ? viewModel.adminEmail
                      : 'AdminHotel@gmail.com'), // Fallback jika kosong
          description: 'Kirim email untuk pertanyaan detail',
          onTap: () => _showEmailDialog(context, viewModel),
          isLoading: viewModel.isLoading,
        ),
        const SizedBox(height: 12),
        _buildContactCard(
          icon: Icons.phone_outlined,
          iconColor: Colors.green,
          title: 'Kontak Kami',
          subtitle:
              viewModel.isLoading
                  ? 'Memuat...'
                  : (viewModel.adminPhone.isNotEmpty
                      ? viewModel.adminPhone
                      : '+62 1232 3847 213'), // Fallback jika kosong
          description: 'Hubungi langsung untuk bantuan cepat',
          onTap: () => _showPhoneDialog(context, viewModel),
          isLoading: viewModel.isLoading,
        ),
        const SizedBox(height: 12),
        _buildContactCard(
          icon: Icons.location_on_outlined,
          iconColor: _primaryColor,
          title: 'Lokasi Kami',
          subtitle: 'Temukan kami dari lokasi Anda',
          description: 'Lihat lokasi hotel dan sekitarnya',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LokasiPage()),
            );
          },
          showArrow: true,
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String description,
    required VoidCallback onTap,
    bool showArrow = false,
    bool isLoading = false,
  }) {
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap, // Disable tap saat loading
          borderRadius: BorderRadius.circular(_borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      isLoading &&
                              (title.contains('Email') ||
                                  title.contains('Telepon'))
                          ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                iconColor,
                              ),
                            ),
                          )
                          : Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: isLoading ? Colors.grey : iconColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (showArrow)
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[400],
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'FAQ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        _buildContactCard(
          icon: Icons.help_outline,
          iconColor: Colors.orange,
          title: 'Pertanyaan Umum',
          subtitle: 'Lihat jawaban dari pertanyaan yang sering ditanyakan',
          description: 'Informasi umum seputar layanan hotel',
          onTap: () => _showComingSoonDialog(context, 'FAQ'),
        ),
      ],
    );
  }

  void _showEmailDialog(BuildContext context, AdminProfileViewModel viewModel) {
    final email =
        viewModel.adminEmail.isNotEmpty
            ? viewModel.adminEmail
            : 'AdminHotel@gmail.com';

    _showInfoDialog(
      context,
      'Email Customer Service',
      email,
      'Email telah disalin ke clipboard',
    );
  }

  void _showPhoneDialog(BuildContext context, AdminProfileViewModel viewModel) {
    final phone =
        viewModel.adminPhone.isNotEmpty
            ? viewModel.adminPhone
            : '+62 1232 3847 213';

    _showInfoDialog(
      context,
      'Telepon Admin',
      phone,
      'Nomor telepon telah disalin ke clipboard',
    );
  }

  void _showInfoDialog(
    BuildContext context,
    String title,
    String content,
    String message,
  ) {
    Clipboard.setData(ClipboardData(text: content));
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white, // Menambahkan warna putih pada card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87, // Memastikan text berwarna gelap
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: TextStyle(
                    color: _primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: _primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: const Text('Tutup'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white, // Menambahkan warna putih pada card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              feature,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87, // Memastikan text berwarna gelap
              ),
            ),
            content: const Text(
              'Fitur ini akan segera tersedia.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87, // Memastikan text berwarna gelap
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: _primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: const Text('Tutup'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }
}
