import 'package:get/get.dart';
import 'views/laporan_penjualan_view.dart'; // Import the correct view
import 'views/laporan_penjualan_detail_view.dart'; // Import the new detail view
import 'controllers/laporan_penjualan_controller.dart'; // Import the correct controller
import 'controllers/laporan_penjualan_detail_controller.dart'; // Import the new detail controller
import 'services/laporan_penjualan_service.dart'; // Import the service
import '../../../routes/app_routes_constant.dart'; // Import konstanta

class LaporanPenjualanModule { // Correct the class name
  static final routes = [
    GetPage(
      name: AppRoutesConstants.laporanPenjualan, // Route untuk laporan penjualan
      page: () => LaporanPenjualanView(), // Use the correct view
      binding: BindingsBuilder(() { // Make binding async
        // Await the async registration of DatabaseHelper 

        // Now that DatabaseHelper is guaranteed to be in the container,
        // register the service and controller.
        Get.lazyPut(() => LaporanPenjualanService()); // Service depends on DatabaseHelper
        Get.put(LaporanPenjualanController()); // Controller depends on Service
      }),
    ),
    GetPage(
      name: "${AppRoutesConstants.laporanPenjualan}/:id", // Route for detail view
      page: () => LaporanPenjualanDetailView(),
      binding: BindingsBuilder(() {
        // DatabaseHelper should be available from the parent binding now
        Get.put(LaporanPenjualanDetailController()); // Bind the detail controller
      }),
    ),
    // Remove other routes if they are not part of the main laporan penjualan flow
    // GetPage(
    //   name: "${AppRoutesConstants.pos}/list",
    //   page: () => TransaksiPosListView(),
    // ),
    // GetPage(
    //   name: "${AppRoutesConstants.pos}/:id",
    //   page: () => TransaksiPosDetailView(),
    // ),
  ];
}
