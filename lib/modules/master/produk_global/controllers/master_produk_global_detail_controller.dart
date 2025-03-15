import 'package:get/get.dart';
import '../services/master_produk_global_service.dart';

class MasterProdukGlobalDetailController extends GetxController {
  final MasterProdukGlobalService _service = MasterProdukGlobalService();

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
