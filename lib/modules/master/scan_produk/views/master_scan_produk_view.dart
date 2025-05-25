import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controllers/master_scan_produk_controller.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../home/controllers/home_controller.dart';
import '../../../transaksi/pos/controllers/transaksi_pos_controller.dart';

class MasterScanProdukView extends StatelessWidget {
  final MasterScanProdukController _controller = Get.put(
    MasterScanProdukController(),
  );
  final TransaksiPosController _pos_controller =
      Get.find<TransaksiPosController>();
  final HomeController _home_controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Scan Produk"),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: MobileScanner(
              onDetect: (BarcodeCapture capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final String? code = barcodes.first.rawValue;
                  if (code != null) {
                    _controller.processBarcode(code);
                  }
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Obx(() {
              if (_controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (_controller.product.isEmpty) {
                return Center(child: Text("Scan barcode untuk melihat produk"));
              }

              return ListTile(
                leading: Image.network(
                  _controller.product["image"] ?? "",
                  width: 60,
                  height: 60,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Icon(Icons.image_not_supported, size: 60),
                ),
                title: Text(
                  _controller.product["productName"] ??
                      "Produk Tidak Ditemukan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Rp ${_controller.product["finalPrice"] ?? 0}"),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    final productMap = _controller.product.toJson();
                    _pos_controller.addToCart(productMap, 1);
                    _home_controller.handleMenuTap({'route': '/home'});
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
