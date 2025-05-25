import 'package:get/get.dart';
import '../../../../routes/app_routes_constant.dart'; // Import konstanta
import '../../../../core/database/database_helper.dart';
import '../models/transaksi_pos_model.dart';

class TransaksiPosController extends GetxController {
  final DatabaseHelper _dbHelper =
      DatabaseHelper(); // Menggunakan instance dari DatabaseHelper
  var isLoading = true.obs;
  var transaksiList = <TransaksiModel>[].obs;
  var transaksiById = Rxn<Map<String, dynamic>>();
  var cartItems = <String, Map<String, dynamic>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadTransaksi();
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
      cartItems[id] = {"product": product, "qty": qty};
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

  Future<String> generateNoFaktur() async {
    final db = await DatabaseHelper().database;
    final result = await db.rawQuery(
      'SELECT no_faktur FROM transaksi ORDER BY id DESC LIMIT 1',
    );

    if (result.isNotEmpty && result[0]['no_faktur'] != null) {
      final lastFaktur = result[0]['no_faktur'] as String;
      // Format no faktur contoh: INV-00001
      final numberPart = lastFaktur.replaceAll(RegExp(r'[^0-9]'), '');
      final nextNumber = (int.tryParse(numberPart) ?? 0) + 1;
      return 'INV-${nextNumber.toString().padLeft(5, '0')}';
    } else {
      return 'INV-00001';
    }
  }

  Future<void> loadTransaksi() async {
    final data = await getTransaksiList();
    transaksiList.assignAll(data);
  }

  Future<List<TransaksiModel>> getTransaksiList() async {
    final data = await _dbHelper.getDataFromTable('transaksi');
    return data.map((e) => TransaksiModel.fromMap(e)).toList();
  }

  Future<int> insertTransaksiWithDetails(
    Map<String, dynamic> transaksiData,
    List<Map<String, dynamic>> detailList,
  ) async {
    final db = await _dbHelper.database;
    return await db.transaction((txn) async {
      final idTransaksi = await txn.insert('transaksi', transaksiData);

      for (var detail in detailList) {
        detail['id_transaksi'] = idTransaksi;
        await txn.insert('transaksi_detail', detail);
      }
      goToDetail(idTransaksi);
      return idTransaksi;
    });
  }

  Future<void> submitTransaksi({String caraBayar = 'Tunai'}) async {
    if (cartItems.isEmpty) return;

    final noFaktur = await generateNoFaktur();

    final totalBayar = cartItems.entries.fold<double>(
      0,
      (sum, e) =>
          sum +
          ((e.value["product"]["finalPrice"] as num) * (e.value["qty"] as int)),
    );

    final transaksiData = {
      'no_faktur': noFaktur,
      'tanggal': DateTime.now().toIso8601String(),
      'total_bayar': totalBayar,
      'cara_bayar': caraBayar,
    };

    final detailList =
        cartItems.entries.map((e) {
          final p = e.value["product"];
          final qty = e.value["qty"];
          final harga = (p["finalPrice"] as num).toDouble();
          return {
            'produk_id': int.tryParse(p["productId"].toString()) ?? 0,
            'produk_barcode': p["productBarcode"],
            'produk_nama': p["productName"],
            'produk_sku': p["sku"],
            'produk_plu': p["plu"],
            'harga': harga,
            'qty': qty,
            'total': harga * qty,
            'url_image': p["image"],
          };
        }).toList();

    try {
      insertTransaksiWithDetails(transaksiData, detailList);
      clearCart();
      loadTransaksi();
      print("✅ TransaksiModel berhasil disimpan dengan no_faktur: $noFaktur");
    } catch (e) {
      print("❌ Gagal submit transaksi: $e");
    }
  }

  Future<void> goToDetail(int transactionId) async {
    print(transactionId);
    await loadTransaksiById(transactionId);
    print('🟢 TRANSAKSI: ${transaksiById}');
    Get.toNamed('${AppRoutesConstants.pos}/$transactionId');
  }

  Future<void> loadTransaksiById(int id) async {
    try {
      final db = await DatabaseHelper().database;
      final transaksi = await db.query(
        'transaksi',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (transaksi.isNotEmpty) {
        final idTransaksi = transaksi.first['id'];
        final detail = await db.query(
          'transaksi_detail',
          where: 'id_transaksi = ?',
          whereArgs: [idTransaksi],
        );

        transaksiById.value = {...transaksi.first, 'detail': detail};
      } else {
        transaksiById.value = null;
      }
    } catch (e) {
      print('❌ Error loadTransaksiById: $e');
    }
  }
}
