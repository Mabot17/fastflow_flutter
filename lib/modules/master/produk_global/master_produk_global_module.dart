import 'package:get/get.dart';
import 'views/master_produk_global_view.dart';
import 'views/master_produk_global_detail_view.dart'; // Import detail view
import 'controllers/master_produk_global_controller.dart';
import '../../../routes/app_routes_constant.dart'; // Import konstanta

class MasterProdukGlobalModule {
  static final routes = [
    GetPage(
      name: AppRoutesConstants.produkGlobal,
      page: () => MasterProdukGlobalView(),
      binding: BindingsBuilder(() {
        Get.put(MasterProdukGlobalController());
      }),
    ),
    GetPage(
      name: "${AppRoutesConstants.produkGlobal}/:id", // Route untuk detail transaksi
      page: () => MasterProdukGlobalDetailView(),
    ),
  ];
}
