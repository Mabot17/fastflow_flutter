import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../views/home_app_bar.dart';
import '../views/home_drawer.dart';
import '../views/home_menu_grid.dart';
import '../views/receipt_view.dart';
import '../views/notification_view.dart';
import '../views/profile_view.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomeView({super.key});

  Widget _buildBottomNavBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: const Color(0xFFE8EAF6), // Soft Indigo background
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(icon: Icons.home, index: 0),
          _buildNavItem(icon: Icons.receipt, index: 1),
          const SizedBox(width: 40),
          _buildNavItem(icon: Icons.notifications, index: 2),
          _buildNavItem(icon: Icons.person, index: 3),
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    return Obx(() => IconButton(
          icon: Icon(
            icon,
            size: 28,
            color: controller.currentIndex.value == index
                ? const Color(0xFF1A237E) // Deep blue saat aktif
                : Colors.grey.shade500,
          ),
          onPressed: () => controller.changePage(index),
        ));
  }

  Widget _buildBody() {
    return Obx(() {
      switch (controller.currentIndex.value) {
        case 0:
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: HomeMenuGrid(controller: controller),
          );
        case 1:
          return const ReceiptView();
        case 2:
          return const NotificationView();
        case 3:
          return const ProfileView();
        default:
          return const Center(child: Text('Halaman tidak ditemukan'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const HomeDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: HomeAppBar(
          username: controller.username.value,
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.handleMenuTap({'route': '/scan_produk'}),
        backgroundColor: const Color(0xFF1A237E),
        child: const Icon(
          Icons.qr_code_2_rounded,
          color: Colors.white,
          size: 30,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }
}
