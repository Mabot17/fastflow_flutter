import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../transaksi/pos/controllers/transaksi_pos_controller.dart';

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
    final TransaksiPosController _pos_controller = Get.find<TransaksiPosController>();

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
          onPressed: () => controller.handleMenuTap({'route': '/pos'}),
          tooltip: "Keranjang Belanja",
          icon: Obx(() {
            int count = _pos_controller.keranjangCount;
            return Stack(
              children: [
                const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                if (count > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),

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
