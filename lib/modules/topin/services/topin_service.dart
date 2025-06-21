import '../../../../core/services/api_services.dart';
import '../controllers/topin_controller.dart';
import '../models/topin_model.dart';
class TopinService {
   final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> fetchGroupedProdukDigitalRaw(String keyword) async {
    try {
      final response = await _apiService.get(
        "/master/produk_digital_group_by_kode",
        params: {
          "keyword": keyword,
        },
      );

      print("📥 [API Response] ${response.statusCode} ${response.data}");

      return (response.data["data"] as List).cast<Map<String, dynamic>>();
    } catch (e) {
      print("❌ [fetchGroupedProdukDigitalRaw] Error: $e");
      return [];
    }
  }

}
