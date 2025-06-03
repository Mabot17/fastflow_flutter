import 'package:get/get.dart';
import '../services/master_scan_produk_service.dart';
import '../../../../routes/app_routes_constant.dart';

class MasterScanProdukController extends GetxController {
  final MasterScanProdukService _service = MasterScanProdukService();
  var isLoading = false.obs;
  var product = {}.obs;

  void processBarcode(String barcode) {
    if (barcode.isNotEmpty) {
      fetchProductByBarcode(barcode);
    }
  }

  Future<void> fetchProductByBarcode(String barcode) async {
    try {
      isLoading(true);
      var fetchedProduct = await _service.fetchProductByBarcode(barcode);

      if (fetchedProduct.isEmpty) {
        // Product not found, navigate to add product screen with barcode
        Get.back(); // Go back from scan screen
        Get.toNamed(AppRoutesConstants.produkGlobalAdd, arguments: barcode);
      } else {
        // Product found, update the observable
        product.assignAll(fetchedProduct);
      }
    } catch (e) {
      print("❌ [Controller] Error fetching product: $e");
      // Optionally show an error snackbar
      Get.snackbar('Error', 'Gagal mencari produk: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  void goToDetail() {
    if (product.isNotEmpty) {
      Get.toNamed("${AppRoutesConstants.produkGlobal}/${product['productId']}");
    }
  }
}
