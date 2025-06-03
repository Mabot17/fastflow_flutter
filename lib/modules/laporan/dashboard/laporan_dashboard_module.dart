import 'package:get/get.dart';
import 'views/laporan_dashboard_view.dart'; // Import the dashboard view (PendapatanView)
import 'controllers/laporan_dashboard_controller.dart'; // Import the dashboard controller (PendapatanController)
import 'services/laporan_dashboard_service.dart'; // Import the dashboard service
import '../../../routes/app_routes_constant.dart'; // Import konstanta
import '../../../core/database/database_helper.dart'; // Import DatabaseHelper

class LaporanDashboardModule { // Correct the class name
  static final routes = [
    GetPage(
      name: AppRoutesConstants.laporanDashboard, // Define a route constant for dashboard
      page: () => PendapatanView(), // Use the correct view name
      binding: BindingsBuilder(() {
        // Register DatabaseHelper asynchronously first if not already permanent
        // Assuming DatabaseHelper is already registered as permanent in another module (e.g., LaporanPenjualanModule)
        // If not, uncomment and adjust the following:
        /*
        Get.putAsync<DatabaseHelper>(() async {
          final dbHelper = DatabaseHelper();
          await dbHelper.initDatabaseOffline();
          return dbHelper;
        }, permanent: true);
        */

        // Register Service and Controller.
        // Service depends on DatabaseHelper (which should be available via Get.find)
        Get.lazyPut(() => LaporanDashboardService());
        // Controller depends on Service
        Get.put(PendapatanController()); // Use the correct controller name
      }),
    ),
    // Add other dashboard-related routes here if any
  ];
}
