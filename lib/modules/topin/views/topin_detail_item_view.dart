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

    void _showBeliDialog(BuildContext context, String kodeProduk) {
      final tujuanController = TextEditingController();
      final TopinController controller = Get.find();

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("Konfirmasi Pembelian"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Kode Produk: $kodeProduk"),
                  const SizedBox(height: 12),
                  TextField(
                    controller: tujuanController,
                    decoration: const InputDecoration(
                      labelText: "Tujuan ID",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text("Batal"),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: const Text("Beli"),
                  onPressed: () {
                    final tujuanId = tujuanController.text.trim();
                    if (tujuanId.isNotEmpty) {
                      controller.beliProduk(kodeProduk, tujuanId);
                      Navigator.pop(context);
                      Get.snackbar("Transaksi", "Diproses...");
                    }
                  },
                ),
              ],
            ),
      );
    }

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
              onTap: () {
                _showBeliDialog(context, produk.keyword);
              },
            );
          },
        );
      }),
    );
  }
}
