import '../../../../core/services/api_services.dart';

class MasterScanProdukService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> fetchProductByBarcode(String barcode) async {
    try {
      final response = await _apiService.get("/master/produk_barcode/by_barcode/$barcode");
      
      print("📥 [API Scan Produk Response] ${response.statusCode} ${response.data}");
      return response.data["data"] ?? {};
    } catch (e) {
      print("❌ [ScanProdukService] Error fetching product: $e");
      return {};
    }
  }

  Future<void> patchProductPrice({
    required int userId,
    required int productId,
    required int hargaBeli,
    required int hargaJual,
  }) async {
    try {
      final response = await _apiService.patch(
        "/master/produk_users/$userId/$productId",
        data: {
          "produk_harga_beli": hargaBeli,
          "produk_harga_jual": hargaJual,
        },
      );
      print("📤 [API PATCH Produk] ${response.statusCode} ${response.data}");
    } catch (e) {
      print("❌ [ScanProdukService] Error patching product: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchUserProductPrice({
    required int userId,
    required int productId,
  }) async {
    try {
      final response = await _apiService.get("/master/produk_users/$userId/$productId");
      print("📥 [API Produk User Price] ${response.statusCode} ${response.data}");
      return response.data["data"] ?? {};
    } catch (e) {
      print("❌ [ScanProdukService] Error fetching user product price: $e");
      return {};
    }
  }
}
