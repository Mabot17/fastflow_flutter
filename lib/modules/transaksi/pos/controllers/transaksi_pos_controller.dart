import 'package:get/get.dart';
import '../../../../routes/app_routes_constant.dart'; // Import konstanta

class Transaksi {
  final int id;
  final double total;
  final String tanggal;

  Transaksi({required this.id, required this.total, required this.tanggal});
}

class TransaksiPosController extends GetxController {
  var isLoading = true.obs;
  var transaksiList = <Transaksi>[].obs;
  var cartItems = <String, Map<String, dynamic>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Dummy data, nanti bisa diganti dari API
    transaksiList.value = [
      Transaksi(id: 1, total: 120000, tanggal: '2025-05-25'),
      Transaksi(id: 2, total: 89000, tanggal: '2025-05-24'),
    ];
  }

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

  void goToDetail(int transactionId) {
    Get.toNamed('${AppRoutesConstants.pos}/$transactionId');
  }
}
