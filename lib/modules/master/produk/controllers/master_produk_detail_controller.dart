import 'package:get/get.dart';
import '../services/master_produk_service.dart';

class MasterProdukDetailController extends GetxController {
  final MasterProdukService _service = MasterProdukService();

  var isLoading = false.obs;
  var product = {}.obs;

  void fetchProductById(String productId) async {
    try {
      isLoading(true);
      var fetchedProduct = await _service.fetchProductByIdService(productId);
      product.assignAll(fetchedProduct ?? {});
    } catch (e) {
      print("❌ [Controller] Error fetching product by ID: $e");
    } finally {
      isLoading(false);
    }
  }
}
