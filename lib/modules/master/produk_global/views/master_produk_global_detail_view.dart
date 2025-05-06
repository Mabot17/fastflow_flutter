import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/master_produk_global_detail_controller.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../core/config/api_config.dart';

class MasterProdukGlobalDetailView extends StatelessWidget {
  final MasterProdukGlobalDetailController _controller = Get.put(MasterProdukGlobalDetailController());

  @override
  Widget build(BuildContext context) {
    final String? productId = Get.parameters['id'];
    if (productId != null) {
      _controller.fetchProductById(productId);
    }

    return Scaffold(
      appBar: CustomAppBar(title: "Detail Produk"),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (_controller.product.isEmpty) {
          return Center(child: Text("Produk tidak ditemukan"));
        }

        var product = _controller.product;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      product["image"],
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: Center(child: Icon(Icons.broken_image, size: 48)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product["productName"],
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF7C4DFF)),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Rp ${product["finalPrice"]}",
                          style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Kategori: ${product["categoryNameLvl2"] ?? "Tidak tersedia"}",
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Stok: ${product["stock"]}",
                          style: TextStyle(
                            fontSize: 14,
                            color: product["stock"] > 0 ? Colors.blue : Colors.red,
                          ),
                        ),
                        SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            "${ApiConfig.baseUrl}${product["productBarcodeImage"] ?? ''}",
                            width: double.infinity,
                            height: 100,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 100,
                              color: Colors.grey[200],
                              child: Center(child: Icon(Icons.qr_code_2, size: 40)),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.add_shopping_cart, color: Colors.white),
                            label: Text("Tambahkan ke Keranjang",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF7C4DFF),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
