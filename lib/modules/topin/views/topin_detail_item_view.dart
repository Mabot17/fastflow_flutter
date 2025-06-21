import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/topin_model.dart';
import '../controllers/topin_controller.dart';

class DetailSubProdukPage extends StatelessWidget {
  final MenuItemModel item;

  const DetailSubProdukPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TopinController controller = Get.put(TopinController());

    // Fetch detail item dari grup yang dipilih
    controller.loadSubGroupProduk(item.title);

    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: Obx(() {
        if (controller.subItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.subItems.length,
          itemBuilder: (context, index) {
            final produk = controller.subItems[index];
            return ListTile(
              title: Text(produk.title),
              subtitle: Text(produk.keyword),
              trailing: const Icon(Icons.check_circle_outline),
            );
          },
        );
      }),
    );
  }
}
