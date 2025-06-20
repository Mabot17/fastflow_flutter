// services/laporan_dashboard_service.dart

import 'package:get/get.dart';
import '/core/database/database_helper.dart'; // Import DatabaseHelper

class LaporanDashboardService extends GetxService {
  // Use DatabaseHelper() directly as requested
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Fetches total sales amount within a specific date range.
  Future<double> getTotalSalesByDateRange(DateTime startDate, DateTime endDate) async {
    return await _dbHelper.getTotalSalesByDateRange(startDate, endDate);
  }

  /// Fetches all transactions within a specific date range.
  Future<List<Map<String, dynamic>>> getTransactionsByDateRange(DateTime startDate, DateTime endDate) async {
    return await _dbHelper.getTransactionsByDateRange(startDate, endDate);
  }

  // Add other methods if needed for future dashboard features
}
