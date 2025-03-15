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
      product.assignAll(fetchedProduct ?? {});
    } catch (e) {
      print("❌ [Controller] Error fetching product: $e");
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
