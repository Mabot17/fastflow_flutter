import 'package:get/get.dart';
import '../services/auth_login_service.dart';
import '../../../../routes/app_routes_constant.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  final AuthLoginService _authService = AuthLoginService();

  void login(String username, String password) async {
    bool success = await _authService.login(username, password);
    if (success) {
      isLoggedIn.value = true;
      Get.offAllNamed(AppRoutesConstants.home);
    } else {
      Get.snackbar("Login Gagal", "Periksa kembali kredensial Anda",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void logout() {
    _authService.logout();
    isLoggedIn.value = false;
    Get.offAllNamed(AppRoutesConstants.login);
  }

  @override
  void onInit() {
    isLoggedIn.value = _authService.isLoggedIn();
    super.onInit();
  }
}
