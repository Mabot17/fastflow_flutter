import 'package:get/get.dart';
import 'views/master_scan_produk_view.dart';
import 'views/master_scan_produk_edit_view.dart';
import 'controllers/master_scan_produk_controller.dart';
import '../../../routes/app_routes_constant.dart'; // Import konstanta

class MasterScanProdukModule {
  static final routes = [
    GetPage(
      name: AppRoutesConstants.scanProduk,
      page: () => MasterScanProdukView(), // This is now valid
      binding: BindingsBuilder(() {
        Get.put(MasterScanProdukController());
      }),
    ),
    GetPage(
      name: '/master/scan_produk/edit',
      page: () => MasterScanProdukEditView(),
      binding: BindingsBuilder(() {
        Get.put(MasterScanProdukController());
      }),
    ),
  ];
}
