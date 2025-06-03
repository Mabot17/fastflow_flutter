import 'package:get/get.dart';
import 'views/master_produk_global_view.dart';
import 'views/master_produk_global_detail_view.dart';
import 'views/master_produk_global_add_view.dart';
import 'controllers/master_produk_global_controller.dart';
import 'controllers/master_produk_global_add_controller.dart';
import '../../../routes/app_routes_constant.dart';

class MasterProdukGlobalModule {
  static final routes = [
    GetPage(
      name: AppRoutesConstants.produkGlobal,
      page: () => MasterProdukGlobalView(),
      binding: BindingsBuilder(() {
        Get.put(MasterProdukGlobalController());
      }),
    ),
    // Define the "add" route BEFORE the parameterized "detail" route
    GetPage(
      name: AppRoutesConstants.produkGlobalAdd,
      page: () => MasterProdukGlobalAddView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MasterProdukGlobalAddController());
      }),
    ),
    GetPage(
      name: "${AppRoutesConstants.produkGlobal}/:id",
      page: () => MasterProdukGlobalDetailView(),
      // Detail controller is put in its view's Get.put()
    ),
  ];
}