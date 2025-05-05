import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../models/home_model.dart';

class HomeMenuGrid extends StatelessWidget {
  final HomeController controller;

  const HomeMenuGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
          itemCount: controller.menuData.length,
          itemBuilder: (context, sectionIndex) {
            var section = controller.menuData[sectionIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section['title'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E), // Deep Blue
                  ),
                ),
                const SizedBox(height: 12),
                _buildGrid(section['items']),
                const SizedBox(height: 16),
              ],
            );
          },
        ));
  }

  Widget _buildGrid(List items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
          color: const Color(0xFFE8EAF6), // Light Indigo
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              HomeModel.getIconData(item['icon']),
              size: 40,
              color: const Color(0xFF7C4DFF), // Electric Violet
            ),
            const SizedBox(height: 8),
            Text(
              item['title'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A237E), // Deep Blue
              ),
            ),
          ],
        ),
      ),
    );
  }
}
