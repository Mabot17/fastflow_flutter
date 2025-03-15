import '../../../../core/services/api_services.dart';

class MasterProdukService {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> fetchProductsService({
    required int page,
    int resultsPerPage = 20,
    String keywords = "",
    String aktif = "Semua",
    String category = "Semua",
    bool timestampData = false,
  }) async {
    try {
      final response = await _apiService.get(
        "/master/produk",
        params: {
          "keywords": keywords,
          "page": page,
          "results_per_page": resultsPerPage,
          "aktif": aktif,
          "category": category
        },
      );

      print("📥 [API Produk Service Response] ${response.statusCode} ${response.data}");
      return response.data["data"] ?? [];
    } catch (e) {
      print("❌ [ProdukService] Error fetching products: $e");
      return [];
    }

  }

  Future<Map<String, dynamic>?> fetchProductByIdService(String productId) async {
  try {
    final response = await _apiService.get("/master/produk_barcode/$productId");

    print("📥 [API Produk Detail Service Response] ${response.statusCode} ${response.data}");
    return response.data["data"];
  } catch (e) {
    print("❌ [ProdukService] Error fetching product: $e");
    return null;
  }
}

}
