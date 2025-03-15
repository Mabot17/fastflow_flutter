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
}
