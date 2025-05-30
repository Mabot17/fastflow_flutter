import 'package:get/get.dart';
import 'views/laporan_penjualan_view.dart'; // Import the correct view
import 'views/laporan_penjualan_detail_view.dart'; // Import the new detail view
import 'views/laporan_penjualan_monthly_transactions_view.dart'; // Import the new monthly transactions view
import 'controllers/laporan_penjualan_controller.dart'; // Import the correct controller
import 'controllers/laporan_penjualan_detail_controller.dart'; // Import the new detail controller
import 'controllers/laporan_penjualan_monthly_transactions_controller.dart'; // Import the new monthly transactions controller
import 'services/laporan_penjualan_service.dart'; // Import the service
import '../../../routes/app_routes_constant.dart'; // Import konstanta
import '../../../core/database/database_helper.dart'; // Import DatabaseHelper

class LaporanPenjualanModule { // Correct the class name
  static final routes = [
    GetPage(
      name: AppRoutesConstants.laporanPenjualan, // Route untuk laporan penjualan (main view)
      page: () => LaporanPenjualanView(), // Use the correct view
      binding: BindingsBuilder(() {
        // Register DatabaseHelper asynchronously first.
        // Get.putAsync will ensure the Future completes before dependencies are resolved.
        Get.putAsync<DatabaseHelper>(() async {
          final dbHelper = DatabaseHelper(); // Create instance
          await dbHelper.initDatabaseOffline(); // Initialize asynchronously
          return dbHelper; // Return the initialized instance
        }, permanent: true); // Make it permanent so it's available for detail route

        // Register Service and Controller. GetX will wait for async dependencies.
        Get.lazyPut(() => LaporanPenjualanService()); // Service depends on DatabaseHelper
        Get.put(LaporanPenjualanController()); // Controller depends on Service
      }),
    ),
    GetPage(
      name: "${AppRoutesConstants.laporanPenjualan}/:id", // Route for single transaction detail view
      page: () => LaporanPenjualanDetailView(),
      binding: BindingsBuilder(() {
        // DatabaseHelper should be available because it was registered as permanent
        Get.put(LaporanPenjualanDetailController()); // Bind the detail controller
      }),
    ),
    // New route for listing transactions for a specific month
     GetPage(
      name: "${AppRoutesConstants.laporanPenjualan}/monthly/:year/:month", // Route for monthly transactions list
      page: () => LaporanPenjualanMonthlyTransactionsView(),
      binding: BindingsBuilder(() {
        // DatabaseHelper and LaporanPenjualanService should be available (permanent/lazyPut)
        Get.put(LaporanPenjualanMonthlyTransactionsController()); // Bind the monthly transactions controller
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
