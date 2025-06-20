import 'package:get/get.dart';
import '../services/master_scan_produk_service.dart';
import '../../../../routes/app_routes_constant.dart';
import '../../../home/controllers/home_controller.dart';

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
        // Product found, fetch user-specific price (harga beli)
        final userData = Get.find<HomeController>().userData;
        dynamic userIdRaw = userData['user_id'];
        dynamic productIdRaw = fetchedProduct['productId'];
        int? userId = userIdRaw is int ? userIdRaw : int.tryParse(userIdRaw?.toString() ?? '');
        int? productId = productIdRaw is int ? productIdRaw : int.tryParse(productIdRaw?.toString() ?? '');

        Map<String, dynamic> userPrice = {};
        if (userId != null && productId != null) {
          try {
            userPrice = await _service.fetchUserProductPrice(
              userId: userId,
              productId: productId,
            );
          } catch (_) {
            // ignore error, fallback to basePrice
          }
        }
        // If userPrice is empty or does not contain produk_harga_beli, use basePrice
        if (userPrice['produk_harga_beli'] == null && fetchedProduct['basePrice'] != null) {
          userPrice['produk_harga_beli'] = fetchedProduct['basePrice'];
        }
        // Optionally, also set produk_harga_jual to finalPrice if needed
        if (userPrice['produk_harga_jual'] == null && fetchedProduct['finalPrice'] != null) {
          userPrice['produk_harga_jual'] = fetchedProduct['finalPrice'];
        }
        // Merge userPrice fields into fetchedProduct (harga beli, harga jual, etc)
        fetchedProduct.addAll(userPrice);
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

  Future<void> editProductPrice({
    required int productId,
    required int hargaBeli,
    required int hargaJual,
  }) async {
    try {
      isLoading(true);
      // Get userId from userData
      final userData = Get.find<HomeController>().userData;
      dynamic userIdRaw = userData['user_id'];
      int? userId = userIdRaw is int ? userIdRaw : int.tryParse(userIdRaw?.toString() ?? '');

      if (userId == null) throw Exception("User ID tidak valid");

      await _service.patchProductPrice(
        userId: userId,
        productId: productId,
        hargaBeli: hargaBeli,
        hargaJual: hargaJual,
      );
      // Refresh product after edit from database
      await fetchProductByBarcode(product['barcode'] ?? '');
      Get.back(); // Back to scan view
      Get.snackbar('Success', 'Harga produk berhasil diubah');
    } catch (e) {
      print("❌ [Controller] Error editing product: $e");
      Get.snackbar('Error', 'Gagal mengubah harga produk: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  void goToDetail() {
    if (product.isNotEmpty) {
      Get.toNamed("${AppRoutesConstants.produkGlobal}/${product['productId']}");
    }
  }

  void goToEdit() {
    if (product.isNotEmpty) {
      Get.toNamed(
        '/master/scan_produk/edit',
        arguments: Map<String, dynamic>.from(product),
      );
    }
  }
}
