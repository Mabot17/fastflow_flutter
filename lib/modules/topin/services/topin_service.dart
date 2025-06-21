import '../../../../core/services/api_services.dart';

class TopinService {
  final ApiService _apiService = ApiService();

  /// Ambil raw list group
  Future<List<Map<String, dynamic>>> fetchProdukGroup(String keyword) async {
    try {
      final response = await _apiService.get(
        "/master/produk_digital_group_by_kode",
        params: {"keyword": keyword},
      );

      final raw = response.data;
      final data = raw["data"]; // 👈 ambil array-nya di sini

      print("📦 Parsed Group Data: $data");

      if (data is! List) return [];
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      print("❌ [fetchProdukGroup] Error: $e");
      return [];
    }
  }


  /// Ambil raw list sub group
  Future<List<Map<String, dynamic>>> fetchProdukSubGroup(String keyword) async {
    try {
      final response = await _apiService.get(
        "/master/produk_digital_group_sub_by_kode",
        params: {"keyword": keyword},
      );

      final raw = response.data;
      final data = raw["data"]; // Ambil list dari key "data"
      if (data is! List) return [];

      print("📦 Parsed SubGroup Data: $data");
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      print("❌ [fetchProdukSubGroup] Error: $e");
      return [];
    }
  }

}
