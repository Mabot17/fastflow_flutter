// controller/topin_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/topin_model.dart';
import 'package:fastflow_flutter/core/services/storage_service.dart';
import '../views/topin_detail_view.dart';
import '../services/topin_service.dart';

class TopinController extends GetxController {
  final StorageService _storage = StorageService();
  final TopinService _service = TopinService();
  var produkItems = <MenuItemModel>[].obs;

  var groupedMenuList = <MenuGroupModel>[
    MenuGroupModel(groupTitle: 'Top Services', items: [
      MenuItemModel(title: 'Pulsa Nasional', keyword: 'pulsa', icon: Icons.phone_android),
      MenuItemModel(title: 'Sms & Telp', keyword: 'sms', icon: Icons.sms),
      MenuItemModel(title: 'Uang Elektronik', keyword: 'uang', icon: Icons.account_balance_wallet),
      MenuItemModel(title: 'Token PLN', keyword: 'pln', icon: Icons.flash_on),
    ]),
    MenuGroupModel(groupTitle: 'Operator', items: [
      MenuItemModel(title: 'Axis', keyword: 'axis', icon: Icons.sim_card),
      MenuItemModel(title: 'Indosat', keyword: 'indosat', icon: Icons.sim_card_alert),
      MenuItemModel(title: 'Smartfren', keyword: 'smartfren', icon: Icons.settings_cell),
      MenuItemModel(title: 'Telkomsel', keyword: 'telkomsel', icon: Icons.network_cell),
      MenuItemModel(title: 'Tri', keyword: 'tri', icon: Icons.phone_iphone),
      MenuItemModel(title: 'XL', keyword: 'xl', icon: Icons.signal_cellular_alt),
      MenuItemModel(title: 'By.U', keyword: 'byu', icon: Icons.mobile_friendly),
    ]),
    MenuGroupModel(groupTitle: 'Lainnya', items: [
      MenuItemModel(title: 'Game', keyword: 'mobile', icon: Icons.videogame_asset),
    ])
  ].obs;

  void onItemTap(MenuItemModel item) {
    Get.to(() => DetailProdukPage(item: item));
  }

  Future<void> loadProdukItems(String keyword) async {
    final groupedData = await _service.fetchGroupedProdukDigitalRaw(keyword);

    final items = groupedData
        .expand((group) => group["items"] as List)
        .map((item) {
          final kode = (item["produk_digital_kode"] ?? "").toString().toLowerCase();

          // Tentukan icon berdasarkan kode atau nama
          IconData icon = Icons.sim_card;
          if (kode.contains("axis")) icon = Icons.signal_cellular_alt;
          else if (kode.contains("telp") || kode.contains("nelpon")) icon = Icons.call;
          else if (kode.contains("sms")) icon = Icons.sms;
          else if (kode.contains("data") || kode.contains("paket")) icon = Icons.wifi;
          else if (kode.contains("game")) icon = Icons.videogame_asset;
          else if (kode.contains("pln")) icon = Icons.flash_on;

          return MenuItemModel(
            title: item["produk_digital_nama"],
            keyword: item["produk_digital_kode"],
            icon: icon,
          );
        })
        .toList();

    produkItems.assignAll(items);
  }
}