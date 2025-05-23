import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/storage_service.dart';
import '../../../routes/app_routes_constant.dart'; // Import konstanta
import '../../../core/config/menu_config.dart';

class HomeController extends GetxController {
  final StorageService _storage = StorageService(); // Pakai StorageService

  var username = ''.obs;
  var menuData = <dynamic>[].obs;
  var currentIndex = 0.obs;

  // Keranjang: key = productId, value = map {product, qty}
  var cartItems = <String, Map<String, dynamic>>{}.obs;

  void increaseQty(String productId) {
    if (cartItems.containsKey(productId)) {
      cartItems[productId]!["qty"] += 1;
      cartItems.refresh();
    }
  }

  void decreaseQty(String productId) {
    if (cartItems.containsKey(productId)) {
      if (cartItems[productId]!["qty"] > 1) {
        cartItems[productId]!["qty"] -= 1;
      } else {
        cartItems.remove(productId);
      }
      cartItems.refresh();
    }
  }

  void updateQtyInCart(String productId, int qty) {
    if (cartItems.containsKey(productId)) {
      cartItems[productId]!["qty"] = qty;
      cartItems.refresh();
    }
  }


  // Getter hitung total qty di keranjang
  int get keranjangCount => cartItems.length; // jumlah jenis barang

  void addToCart(Map<String, dynamic> product, int qty) {
    String id = product["productId"].toString();
    if (cartItems.containsKey(id)) {
      cartItems[id]!["qty"] = (cartItems[id]!["qty"] ?? 0) + qty;
    } else {
      cartItems[id] = {
        "product": product,
        "qty": qty,
      };
    }
    // Observable cartItems sudah otomatis update, tidak perlu update() kecuali pakai update()
    cartItems.refresh();
  }

  void removeFromCart(String productId) {
    if (cartItems.containsKey(productId)) {
      cartItems.remove(productId);
      cartItems.refresh();
    }
  }

  void clearCart() {
    cartItems.clear();
    cartItems.refresh();
  }

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  Future<void> loadUserData() async {
    final userData = await _storage.read('user_data') ?? {};
    username.value = userData['user_name'] ?? 'Unknown';
    menuData.value = jsonDecode(menuJson)['sections'];
  }

  void logout() {
    _storage.clear();
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
