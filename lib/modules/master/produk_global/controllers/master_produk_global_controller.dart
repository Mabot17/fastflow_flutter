import 'package:get/get.dart';
import '../services/master_produk_global_service.dart';
import '../../../../routes/app_routes_constant.dart'; // Import konstanta

class MasterProdukGlobalController extends GetxController {
  final MasterProdukGlobalService _service = MasterProdukGlobalService();

  var isLoading = false.obs;
  var products = <Map<String, dynamic>>[].obs;
  var page = 1.obs;
  var isLastPage = false.obs;
  var currentKeywords = "".obs;

  void fetchProducts({bool isInitialLoad = false, String keywords = ""}) async {
    if (isLoading.value || (isLastPage.value && keywords == currentKeywords.value)) return;

    try {
      isLoading(true);
      if (isInitialLoad) {
        products.clear();
        page.value = 1;
        isLastPage(false);
        currentKeywords.value = keywords;
      }

      var newProducts = (await _service.fetchProductsService(page: page.value, keywords: keywords))
          .cast<Map<String, dynamic>>();

      if (newProducts.isEmpty) {
        isLastPage(true);
      } else {
        final existingIds = products.map((p) => p["productId"]).toSet();
        final uniqueProducts =
            newProducts.where((p) => !existingIds.contains(p["productId"])).toList();

        if (isInitialLoad) {
          products.assignAll(uniqueProducts);
        } else {
          products.addAll(uniqueProducts);
        }

        page.value++;
      }
    } catch (e) {
      print("❌ [Controller] Error fetching products: $e");
    } finally {
      isLoading(false);
    }
  }

  void goToDetailProduct(String productId) {
    Get.toNamed('${AppRoutesConstants.produkGlobal}/$productId');
  }
}
