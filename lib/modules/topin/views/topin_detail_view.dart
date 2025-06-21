import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/topin_model.dart';
import '../controllers/topin_controller.dart';
import 'topin_detail_item_view.dart';

class DetailProdukPage extends StatelessWidget {
  final MenuItemModel item;

  const DetailProdukPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TopinController controller = Get.put(TopinController());

    // Load data kalau kosong
    if (controller.groupItems.isEmpty) {
      controller.loadGroupProduk(item.keyword);
    }

    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: Obx(() {
        if (controller.groupItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.groupItems.length,
          itemBuilder: (context, index) {
            final group = controller.groupItems[index];
            return ListTile(
              leading: Icon(group.icon),
              title: Text(group.title),
              subtitle: Text(group.keyword),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Get.to(() => DetailSubProdukPage(item: group));
              },
            );
          },
        );
      }),
    );
  }
}
