import 'package:get/get.dart';
import '../../../../core/services/storage_service.dart';

class SplashController extends GetxController {
  final StorageService _storage = StorageService(); // Pakai StorageService

  @override
  void onInit() {
    super.onInit();
    _checkLogin();
  }

  void _checkLogin() async {
    await Future.delayed(Duration(seconds: 2)); // Animasi splash
    String? token = _storage.read('access_token');
    if (token != null) {
      Get.offAllNamed('/home'); // Jika sudah login, langsung ke home
    } else {
      Get.offAllNamed('/login'); // Jika belum login, ke halaman login
    }
  }
}
