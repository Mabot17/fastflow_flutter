import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../models/home_model.dart';
import '../../../../widgets/custom_app_bar.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  void _confirmLogout(BuildContext context) {
    Get.defaultDialog(
      title: "Konfirmasi",
      middleText: "Apakah Anda yakin ingin logout?",
      textCancel: "Tidak",
      textConfirm: "Ya",
      confirmTextColor: Colors.white,
      onConfirm: controller.logout,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => _buildMenuGrid(controller.menuData)),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      elevation: 4,
      title: Obx(() => Row(
        children: [
          Icon(Icons.person, size: 24, color: Colors.white),
          SizedBox(width: 8),
          Text(controller.username.value,
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      )),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => _confirmLogout(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red, width: 2),
              ),
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 4),
                  Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildMenuGrid(List menuData) {
    return Expanded(
      child: ListView.builder(
        itemCount: menuData.length,
        itemBuilder: (context, sectionIndex) {
          var section = menuData[sectionIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section['title'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 12),
              _buildGrid(section['items']),
              SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGrid(List items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        var item = items[index];
        return _buildMenuItem(item);
      },
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => controller.handleMenuTap(item),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 4,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(HomeModel.getIconData(item['icon']), size: 40, color: Colors.blue),
            SizedBox(height: 8),
            Text(item['title'], textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
