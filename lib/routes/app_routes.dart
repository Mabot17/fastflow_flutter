import 'package:get/get.dart';
import '../modules/auth/splash/auth_splash_module.dart';
import '../modules/auth/login/auth_login_module.dart';
import '../modules/home/home_module.dart';

// Menu master
import '../modules/master/produk/master_produk_module.dart';
import '../modules/master/produk_global/master_produk_global_module.dart';
import '../modules/master/scan_produk/master_scan_produk_module.dart';

// Menu transaksi
import '../modules/transaksi/pos/transaksi_pos_module.dart';
import '../modules/global/maintenance_view.dart';

class AppRoutes {
  static final routes = [
    // Pemanggilan Global langsung routes full
    ...AuthSplashModule.routes,
    ...AuthLoginModule.routes,
    ...HomeModule.routes,
    ...MasterProdukModule.routes,
    ...MasterProdukGlobalModule.routes,
    ...MasterScanProdukModule.routes,
    ...TransaksiPosModule.routes,

    // Khusus maintenance pemanggilan berbeda karena hanya view saja
    GetPage(
      name: "/maintenance",
      page: () => MaintenancePageView(),
    ),
    GetPage(
      name: "/not_found",
      page: () => MaintenancePageView(),
    ),
  ];
}
