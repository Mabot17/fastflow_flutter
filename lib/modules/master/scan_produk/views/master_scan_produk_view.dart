import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controllers/master_scan_produk_controller.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../home/controllers/home_controller.dart';
import '../../../transaksi/pos/controllers/transaksi_pos_controller.dart';

// Change to StatefulWidget
class MasterScanProdukView extends StatefulWidget {
  final Function(String)? onBarcodeScanned;

  const MasterScanProdukView({Key? key, this.onBarcodeScanned})
      : super(key: key);

  @override
  _MasterScanProdukViewState createState() => _MasterScanProdukViewState();
}

class _MasterScanProdukViewState extends State<MasterScanProdukView> {
  // Add MobileScannerController
  final MobileScannerController _scannerController = MobileScannerController();

  // Access controllers in the state
  late final MasterScanProdukController controller;
  late final TransaksiPosController posController;
  late final HomeController homeController;

  @override
  void initState() {
    super.initState();
    // Find controllers in initState
    controller = Get.find<MasterScanProdukController>();
    posController = Get.find<TransaksiPosController>();
    homeController = Get.find<HomeController>();
  }

  // Override dispose to dispose the scanner controller
  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Scan Produk"),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: MobileScanner(
              controller: _scannerController, // Pass the controller
              onDetect: (BarcodeCapture capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final String? code = barcodes.first.rawValue;
                  if (code != null) {
                    // Stop the scanner immediately after detection
                    _scannerController.stop();

                    if (widget.onBarcodeScanned != null) { // Access parameter via widget
                      // If callback is provided, use it and go back
                      widget.onBarcodeScanned!(code);
                      Get.back();
                    } else {
                      // If no callback, process with controller (for standalone route)
                      controller.processBarcode(code);
                    }
                  }
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.product.isEmpty) {
                // If no product is found or scanned yet, show message
                 return Center(child: Text("Scan barcode untuk melihat produk"));
              }

              // Product is found, display it and offer options
              return Column( // Use a Column to add the Scan Again button
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Image.network(
                      controller.product["image"] ?? "",
                      width: 60,
                      height: 60,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              Icon(Icons.image_not_supported, size: 60),
                    ),
                    title: Text(
                      controller.product["productName"] ??
                          "Produk Tidak Ditemukan",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Rp ${controller.product["finalPrice"] ?? 0}"),
                    trailing: IconButton(
                      icon: Icon(Icons.add_shopping_cart), // Changed icon to add to cart
                      onPressed: () {
                        // Capture the product data before clearing the observable
                        final productMap = Map<String, dynamic>.from(controller.product);
                        
                        if (productMap.isNotEmpty) {
                           posController.addToCart(productMap, 1);
                        }
                       
                        // After adding to cart, clear the displayed product and restart scan
                        controller.product.clear(); // Clear the displayed product
                        _scannerController.start(); // Restart the scanner
                        // Removed: homeController.handleMenuTap({'route': '/home'});
                      },
                    ),
                  ),
                  // Add a button to scan again if a product is displayed (standalone route)
                  if (widget.onBarcodeScanned == null) // Only show this button for the standalone route
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Clear the displayed product and restart the scanner
                          controller.product.clear();
                          _scannerController.start();
                        },
                        child: Text('Scan Produk Lain'),
                      ),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
      // Add FloatingActionButton conditionally
      floatingActionButton: Obx(() {
        // Show button only when not loading and product is empty
        if (!controller.isLoading.value && controller.product.isEmpty) {
          return FloatingActionButton.extended(
            onPressed: () {
              // Navigate to the POS screen
              Get.back(); // Go back from scan screen
              homeController.handleMenuTap({'route': '/pos'}); // Navigate to POS
            },
            label: Text('Open Cart'),
            icon: Icon(Icons.shopping_cart),
          );
        }
        return Container(); // Return an empty container when button is not needed
      }),
    );
  }
}
