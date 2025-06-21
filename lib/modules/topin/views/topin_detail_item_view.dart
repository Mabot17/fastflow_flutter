import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/topin_model.dart';
import '../controllers/topin_controller.dart';

class DetailSubProdukPage extends StatefulWidget {
  final MenuItemModel item;

  const DetailSubProdukPage({Key? key, required this.item}) : super(key: key);

  @override
  State<DetailSubProdukPage> createState() => _DetailSubProdukPageState();
}

class _DetailSubProdukPageState extends State<DetailSubProdukPage> {
  late TopinController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TopinController());
    controller.subItems.clear(); // 🔄 Reset dulu
    controller.loadSubGroupProduk(widget.item.title); // 🔃 Load baru
  }

  void _showBeliDialog(BuildContext context, String kodeProduk) {
    final tujuanController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item.title)),
      body: Obx(() {
        if (controller.subItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.subItems.length,
          itemBuilder: (context, index) {
            final produk = controller.subItems[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 2,
              child: ListTile(
                leading: Icon(produk.icon, color: Colors.blueAccent),
                title: Text(produk.title),
                subtitle: Text("Kode: ${produk.keyword}"),
                trailing: const Icon(Icons.shopping_cart),
                onTap: () => _showBeliDialog(context, produk.keyword),
              ),
            );
          },
        );
      }),
    );
  }
}
