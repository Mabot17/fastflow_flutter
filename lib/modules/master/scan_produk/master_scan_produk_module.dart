import 'package:get/get.dart';
import 'views/master_scan_produk_view.dart';
import 'controllers/master_scan_produk_controller.dart';
import '../../../routes/app_routes_constant.dart'; // Import konstanta

class MasterScanProdukModule {
  static final routes = [
    GetPage(
      name: AppRoutesConstants.scanProduk,
      page: () => MasterScanProdukView(),
      binding: BindingsBuilder(() {
        Get.put(MasterScanProdukController());
      }),
    )
  ];
}
