// controller/topin_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/topin_model.dart';
import 'package:fastflow_flutter/core/services/storage_service.dart';
import '../views/topin_detail_view.dart';

class TopinController extends GetxController {
  final StorageService _storage = StorageService();

  var groupedMenuList = <MenuGroupModel>[
    MenuGroupModel(groupTitle: 'Top Services', items: [
      MenuItemModel(title: 'Pulsa Nasional', icon: Icons.phone_android),
      MenuItemModel(title: 'Sms & Telp', icon: Icons.sms),
      MenuItemModel(title: 'Uang Elektronik', icon: Icons.account_balance_wallet),
      MenuItemModel(title: 'Token PLN', icon: Icons.flash_on),
    ]),
    MenuGroupModel(groupTitle: 'Operator', items: [
      MenuItemModel(title: 'Axis', icon: Icons.sim_card),
      MenuItemModel(title: 'Indosat', icon: Icons.sim_card_alert),
      MenuItemModel(title: 'Smartfren', icon: Icons.settings_cell),
      MenuItemModel(title: 'Telkomsel', icon: Icons.network_cell),
      MenuItemModel(title: 'Tri', icon: Icons.phone_iphone),
      MenuItemModel(title: 'XL', icon: Icons.signal_cellular_alt),
      MenuItemModel(title: 'By.U', icon: Icons.mobile_friendly),
    ]),
    MenuGroupModel(groupTitle: 'Lainnya', items: [
      MenuItemModel(title: 'Digital', icon: Icons.videogame_asset),
    ])
  ].obs;

  void onItemTap(MenuItemModel item) {
    Get.to(() => DetailPage(item: item));
  }
}