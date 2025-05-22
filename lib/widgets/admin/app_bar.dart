import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // background transparan
      elevation: 0, // hilangkan bayangan
      automaticallyImplyLeading: false, // tidak otomatis buat tombol back
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
              color: Colors.black, // opsional: agar tombol back tetap terlihat
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(color: Colors.black), // teks tetap terlihat
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
