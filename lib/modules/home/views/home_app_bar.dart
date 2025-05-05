import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onOpenDrawer;

  const HomeAppBar({
    super.key,
    required this.onOpenDrawer,
  });

  void _showInfoDialog() {
    Get.defaultDialog(
      title: "Tentang Aplikasi",
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A237E),
      ),
      middleText: "FastFlow\nVersi 0.0.5",
      middleTextStyle: const TextStyle(fontSize: 16),
      textConfirm: "Tutup",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF1A237E),
      onConfirm: Get.back,
    );
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    return AppBar(
      elevation: 6,
      backgroundColor: const Color(0xFF1A237E),
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: onOpenDrawer,
      ),
      title: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(6),
            child: const Icon(Icons.person, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Obx(() {
              return Text(
                "Hai, ${controller.username}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
                overflow: TextOverflow.ellipsis,
              );
            }),
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
