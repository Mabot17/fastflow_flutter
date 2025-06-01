import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/database_helper.dart';

class MasterProdukGlobalAddController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // TextEditingControllers for form fields
  final TextEditingController namaController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController skuController = TextEditingController();
  final TextEditingController pluController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();
  final TextEditingController hargaBeliController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final TextEditingController satuanController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  
  var isAktif = true.obs;
  var isLoading = false.obs;

  @override
  void onClose() {
    namaController.dispose();
    barcodeController.dispose();
    skuController.dispose();
    pluController.dispose();
    kategoriController.dispose();
    hargaBeliController.dispose();
    hargaJualController.dispose();
    stokController.dispose();
    satuanController.dispose();
    imageUrlController.dispose();
    deskripsiController.dispose();
    super.onClose();
  }

  String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    if (double.tryParse(value) == null) {
      return '$fieldName harus berupa angka';
    }
    return null;
  }

  String? validateInteger(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    if (int.tryParse(value) == null) {
      return '$fieldName harus berupa angka bulat';
    }
    return null;
  }


  Future<void> saveProduct() async {
    print('[MasterProdukGlobalAddController] saveProduct called');
    if (formKey.currentState!.validate()) {
      print('[MasterProdukGlobalAddController] Form validation passed');
      isLoading.value = true;
      try {
        final now = DateTime.now().toIso8601String();
        final productData = {
          'produk_nama': namaController.text,
          'produk_barcode': barcodeController.text.isEmpty ? null : barcodeController.text,
          'produk_sku': skuController.text.isEmpty ? null : skuController.text,
          'produk_plu': pluController.text.isEmpty ? null : pluController.text,
          'kategori_nama': kategoriController.text.isEmpty ? null : kategoriController.text,
          'harga_beli': double.tryParse(hargaBeliController.text) ?? 0.0,
          'harga_jual': double.tryParse(hargaJualController.text) ?? 0.0,
          'stok': int.tryParse(stokController.text) ?? 0,
          'satuan': satuanController.text.isEmpty ? null : satuanController.text,
          'url_image': imageUrlController.text.isEmpty ? null : imageUrlController.text,
          'deskripsi_produk': deskripsiController.text.isEmpty ? null : deskripsiController.text,
          'is_aktif': isAktif.value ? 1 : 0,
          'created_at': now,
          'updated_at': now,
        };

        print('[MasterProdukGlobalAddController] Attempting to insert product data: $productData');
        int id = await _dbHelper.insertData('produk', productData);
        print('[MasterProdukGlobalAddController] Database insert returned ID: $id');

        if (id > 0) {
          print('[MasterProdukGlobalAddController] Insert successful, ID > 0');
          Get.snackbar(
            'Sukses',
            'Produk berhasil ditambahkan',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.back(); // Go back to the previous screen
          // Optionally, refresh the product list if it's showing local products
        } else {
          print('[MasterProdukGlobalAddController] Insert failed, ID <= 0');
          Get.snackbar(
            'Gagal',
            'Produk gagal ditambahkan. Barcode/SKU mungkin sudah ada.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        print("[MasterProdukGlobalAddController] Error saving product: $e");
        Get.snackbar(
          'Error',
          'Terjadi kesalahan: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
        print('[MasterProdukGlobalAddController] isLoading set to false');
      }
    } else {
      // Validation failed
      print('[MasterProdukGlobalAddController] Form validation failed');
      Get.snackbar(
        'Validasi Gagal',
        'Mohon periksa kembali isian form Anda.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }
}