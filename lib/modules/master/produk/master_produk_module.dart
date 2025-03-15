import 'package:get/get.dart';
import 'views/master_produk_view.dart';
import 'views/master_produk_detail_view.dart'; // Import detail view
import 'controllers/master_produk_controller.dart';
import '../../../routes/app_routes_constant.dart'; // Import konstanta

class MasterProdukModule {
  static final routes = [
    GetPage(
      name: AppRoutesConstants.produk,
      page: () => MasterProdukView(),
      binding: BindingsBuilder(() {
        Get.put(MasterProdukController());
      }),
    ),
    GetPage(
      name: "${AppRoutesConstants.produk}/:id", // Route untuk detail transaksi
      page: () => MasterProdukDetailView(),
    ),
  ];
}
