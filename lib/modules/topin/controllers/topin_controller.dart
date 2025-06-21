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

  var groupedMenuList =
      <MenuGroupModel>[
        MenuGroupModel(
          groupTitle: 'Top Services',
          items: [
            MenuItemModel(
              title: 'Pulsa Nasional',
              keyword: 'pulsa',
              icon: Icons.phone_android,
            ),
            MenuItemModel(title: 'Sms & Telp', keyword: 'sms', icon: Icons.sms),
            MenuItemModel(
              title: 'Uang Elektronik',
              keyword: 'uang',
              icon: Icons.account_balance_wallet,
            ),
            MenuItemModel(
              title: 'Token PLN',
              keyword: 'pln',
              icon: Icons.flash_on,
            ),
          ],
        ),
        MenuGroupModel(
          groupTitle: 'Operator',
          items: [
            MenuItemModel(title: 'Axis', keyword: 'axis', icon: Icons.sim_card),
            MenuItemModel(
              title: 'Indosat',
              keyword: 'indosat',
              icon: Icons.sim_card_alert,
            ),
            MenuItemModel(
              title: 'Smartfren',
              keyword: 'smartfren',
              icon: Icons.settings_cell,
            ),
            MenuItemModel(
              title: 'Telkomsel',
              keyword: 'telkomsel',
              icon: Icons.network_cell,
            ),
            MenuItemModel(
              title: 'Tri',
              keyword: 'tri',
              icon: Icons.phone_iphone,
            ),
            MenuItemModel(
              title: 'XL',
              keyword: 'xl',
              icon: Icons.signal_cellular_alt,
            ),
            MenuItemModel(
              title: 'By.U',
              keyword: 'byu',
              icon: Icons.mobile_friendly,
            ),
          ],
        ),
        MenuGroupModel(
          groupTitle: 'Lainnya',
          items: [
            MenuItemModel(
              title: 'Game',
              keyword: 'mobile',
              icon: Icons.videogame_asset,
            ),
          ],
        ),
      ].obs;

  void onItemTap(MenuItemModel item) {
    Get.to(() => DetailProdukPage(item: item));
  }

  var groupItems = <MenuItemModel>[].obs;
  var subItems = <MenuItemModel>[].obs;

  Future<void> loadGroupProduk(String keyword) async {
    final rawData = await _service.fetchProdukGroup(keyword);
    print(rawData);

    groupItems.value =
        rawData.map((item) {
          final group = item["produk_digital_group"] ?? "Tanpa Group";
          return MenuItemModel(
            title: group,
            keyword: group,
            icon: Icons.category,
          );
        }).toList();
  }

  Future<void> loadSubGroupProduk(String keyword) async {
    final rawData = await _service.fetchProdukSubGroup(keyword);

    subItems.value =
        rawData.map((item) {
          return MenuItemModel(
            title: item["produk_digital_nama"] ?? "-",
            keyword: item["produk_digital_kode"] ?? "-",
            icon: Icons.sim_card,
          );
        }).toList();
  }
}
