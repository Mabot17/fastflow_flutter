import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final VoidCallback onOpenDrawer;

  const HomeAppBar({
    super.key,
    required this.username,
    required this.onOpenDrawer,
  });

  void _showInfoDialog() {
    Get.defaultDialog(
      title: "Tentang Aplikasi",
      middleText: "FastFlow\nVersi 0.0.2",
      textConfirm: "Tutup",
      confirmTextColor: Colors.white,
      onConfirm: Get.back, // <- Ini memastikan dialog tertutup
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4,
      backgroundColor: Theme.of(context).primaryColor,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: onOpenDrawer,
      ),
      title: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Hai, $username",
              style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.white),
          onPressed: _showInfoDialog,
          tooltip: "Tentang Aplikasi",
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
