import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../home/controllers/home_controller.dart';
import '../../../../widgets/custom_app_bar.dart';

class TransaksiPosView extends StatelessWidget {
  final HomeController _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Keranjang Belanja'),
      body: Obx(() {
        if (_homeController.cartItems.isEmpty) {
          return Center(child: Text('Keranjang masih kosong'));
        }
        return Column(
          children: [
            Expanded(child: _buildCartList()),
            _buildTotalSection(),
          ],
        );
      }),
    );
  }

  Widget _buildCartList() {
    final cartMap = _homeController.cartItems;

    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: cartMap.length,
      separatorBuilder: (_, __) => SizedBox(height: 10),
      itemBuilder: (context, index) {
        final productId = cartMap.keys.elementAt(index);
        final item = cartMap[productId]!;
        final product = item["product"];
        final qty = item["qty"];

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product["image"] ?? "",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.image_not_supported, size: 50),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product["productName"] ?? "Tanpa Nama",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Rp ${product["finalPrice"]}",
                        style: TextStyle(color: Colors.green[700]),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        _homeController.decreaseQty(productId);
                      },
                    ),
                    Text(qty.toString(), style: TextStyle(fontSize: 16)),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        _homeController.increaseQty(productId);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotalSection() {
    return Obx(() {
      final total = _homeController.cartItems.values.fold<double>(
        0.0,
        (sum, item) {
          final price = item["product"]["finalPrice"] ?? 0;
          final qty = item["qty"] ?? 0;
          return sum + (price * qty);
        },
      );

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Total: Rp ${total.toInt()}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (total == 0) {
                  Get.snackbar("Kosong", "Tidak ada item untuk dibayar");
                  return;
                }
                Get.defaultDialog(
                  title: "Konfirmasi",
                  content: Text("Total: Rp ${total.toInt()}"),
                  textConfirm: "OK",
                  onConfirm: () {
                    _homeController.clearCart();
                    Get.back();
                    Get.snackbar("Sukses", "Pembayaran selesai");
                  },
                );
              },
              icon: Icon(Icons.attach_money),
              label: Text("Bayar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      );
    });
  }
}
