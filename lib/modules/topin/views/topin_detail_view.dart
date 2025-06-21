import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/topin_model.dart';
import '../controllers/topin_controller.dart';
import 'topin_detail_item_view.dart';

class DetailProdukPage extends StatefulWidget {
  final MenuItemModel item;

  const DetailProdukPage({Key? key, required this.item}) : super(key: key);

  @override
  State<DetailProdukPage> createState() => _DetailProdukPageState();
}

class _DetailProdukPageState extends State<DetailProdukPage> {
  final TopinController controller = Get.put(TopinController());

  @override
  void initState() {
    super.initState();
    controller.groupItems.clear(); // 🧹 reset/bersihkan terlebih dahulu
    controller.loadGroupProduk(widget.item.keyword); // lalu muat ulang
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item.title)),
      body: Obx(() {
        if (controller.groupItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.groupItems.length,
          itemBuilder: (context, index) {
            final group = controller.groupItems[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                leading: Icon(group.icon, size: 32, color: Colors.blue),
                title: Text(group.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(group.keyword),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Get.to(() => DetailSubProdukPage(item: group)),
              ),
            );
          },
        );
      }),
    );
  }
}
