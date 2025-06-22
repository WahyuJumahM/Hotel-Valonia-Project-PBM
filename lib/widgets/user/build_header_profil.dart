//lib/widgets/user/build_header_profil.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/user/user_profile_viewmodel.dart';

class BuildHeaderProfil extends StatelessWidget {
  const BuildHeaderProfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileViewModel>(
      builder: (context, userProfileViewModel, child) {
        // Ambil data dari ViewModel
        final userProfile = userProfileViewModel.userProfile;

        // Set default values
        String name = "";
        String email = "";
        String photoUrl = "";

        // Jika data user tersedia, gunakan data tersebut
        if (userProfile != null) {
          name =
              userProfile.namaLengkap.isNotEmpty
                  ? userProfile.namaLengkap
                  : "Nama belum diisi";
          email =
              userProfile.email.isNotEmpty
                  ? userProfile.email
                  : "Email belum diisi";
          photoUrl = userProfile.fotoProfil;
        }

        return Row(
          children: [
            // Profile Image
            _buildProfileImage(photoUrl),
            const SizedBox(width: 12),

            // User Information - Expanded untuk mengambil semua ruang yang tersisa
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama - menggunakan LayoutBuilder untuk responsif
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        maxLines:
                            name.length > 25
                                ? 2
                                : 1, // Dinamis berdasarkan panjang
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  // Email - menggunakan LayoutBuilder untuk responsif
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Text(
                        email,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                        maxLines:
                            email.length > 30
                                ? 2
                                : 1, // Dinamis berdasarkan panjang
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileImage(String photoUrl) {
    if (photoUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 22,
        backgroundImage: NetworkImage(photoUrl),
        onBackgroundImageError: (exception, stackTrace) {
          print('Error loading profile image: $exception');
        },
        child: Container(), // Empty container as fallback
      );
    } else {
      return const CircleAvatar(
        radius: 22,
        backgroundImage: AssetImage('assets/images/profile-user-default.png'),
      );
    }
  }
}