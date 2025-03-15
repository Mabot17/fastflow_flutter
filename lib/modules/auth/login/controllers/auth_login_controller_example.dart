import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;

  void login(String email, String password) {
    if (email == "mabot" && password == "123456") {
      isLoggedIn.value = true;
      Get.offAllNamed('/home'); // Pindah ke home tanpa bisa kembali ke login
    } else {
      Get.snackbar("Login Gagal", "Periksa kembali kredensial Anda",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void logout() {
    isLoggedIn.value = false;
    Get.offAllNamed('/login'); // Kembali ke halaman login & hapus history
  }
}
