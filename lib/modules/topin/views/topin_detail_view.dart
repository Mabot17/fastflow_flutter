import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/topin_model.dart';
import '../controllers/topin_controller.dart';

class DetailProdukPage extends StatelessWidget {
  final MenuItemModel item;

  const DetailProdukPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TopinController controller = Get.put(TopinController());

    // Jika produk belum dimuat, panggil load
    if (controller.produkItems.isEmpty) {
      controller.loadProdukItems(item.keyword); // load berdasarkan keyword
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final produkDetail = controller.produkItems.firstWhereOrNull(
            (e) => e.keyword == item.keyword,
          );

          if (produkDetail == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(produkDetail.icon, size: 48),
              const SizedBox(height: 16),
              Text(
                produkDetail.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text("Kode: ${produkDetail.keyword}"),
              const SizedBox(height: 16),
              const Text(
                "Detail tambahan bisa dimuat di sini...",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          );
        }),
      ),
    );
  }
}
