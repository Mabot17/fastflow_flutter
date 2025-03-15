import '../../../../core/services/api_services.dart';
import '../../../../core/services/storage_service.dart';

class AuthLoginService {
  final ApiService _apiService = ApiService();
  final StorageService _storage = StorageService(); // Pakai StorageService

  Future<bool> login(String username, String password) async {
    try {
      final response = await _apiService.post(
        '/login',
        {
          'grant_type': '',
          'username': username,
          'password': password,
          'client_id': '',
          'client_secret': '',
        },
        headers: {'Content-Type': 'application/x-www-form-urlencoded', 'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print("Data : $data['access_token']");

        // Simpan token dan data user
        if (data['access_token'] != null) {
          _storage.write('access_token', data['access_token'].toString());
        } else {
          print("❌ Token tidak ditemukan!");
        }
        _storage.write('user_data', data['data']);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("❌ Error saat login: $e");
      return false;
    }
  }

  void logout() {
    _storage.remove('access_token');
    _storage.remove('user_data');
  }

  bool isLoggedIn() {
    return _storage.has('access_token');
  }
}
