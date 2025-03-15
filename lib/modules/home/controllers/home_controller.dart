import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/storage_service.dart';
import '../../../routes/app_routes_constant.dart'; // Import konstanta
import '../../../core/config/menu_config.dart';

class HomeController extends GetxController {
  final StorageService _storage = StorageService(); // Pakai StorageService

  var username = ''.obs;
  var menuData = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    final userData = _storage.read('user_data') ?? {};
    username.value = userData['user_name'] ?? 'Unknown';
    menuData.value = jsonDecode(menuJson)['sections'];
  }

  void logout() {
    _storage.remove('user_data');
    Get.offAllNamed(AppRoutesConstants.login);
  }

  void handleMenuTap(Map<String, dynamic> item) {
    print("✅ Click Menu :  ${item['route']}");
    
    if (item['route'] == null) {
      Get.snackbar("Info", "Fitur belum tersedia", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      Get.toNamed(item['route']);
    } catch (e) {
      print("❌ Error navigating to ${item['route']}: $e");
      Get.toNamed(AppRoutesConstants.maintenance);
      Get.snackbar("Error", "Halaman tidak ditemukan atau belum terdaftar.", snackPosition: SnackPosition.BOTTOM);
    }
  }
}
