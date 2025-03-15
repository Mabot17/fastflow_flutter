import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/master_produk_detail_controller.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../core/config/api_config.dart';

class MasterProdukDetailView extends StatelessWidget {
  final MasterProdukDetailController _controller = Get.put(MasterProdukDetailController());

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(product["image"]),
                    fit: BoxFit.cover,
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
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Rp ${product["finalPrice"]}",
                      style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Kategori: ${product["categoryNameLvl2"] ?? "Tidak tersedia"}",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Stok: ${product["stock"]}",
                      style: TextStyle(fontSize: 16, color: product["stock"] > 0 ? Colors.blue : Colors.red),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("${ApiConfig.baseUrl}${product["productBarcodeImage"] ?? ''}"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Tambahkan ke Keranjang"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
