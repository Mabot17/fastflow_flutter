// services/laporan_penjualan_service.dart

import 'package:get/get.dart';
import '/core/database/database_helper.dart'; // Import DatabaseHelper

class LaporanPenjualanService extends GetxService {
  // Use DatabaseHelper() directly as requested
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Map<String, dynamic>>> getDailyTransactions(DateTime date) async {
    return await _dbHelper.getTransactionsByDate(date);
  }

  Future<double> getDailyTotalSales(DateTime date) async {
    return await _dbHelper.getTotalSalesByDate(date);
  }

   Future<int> getDailyTotalItems(DateTime date) async {
    return await _dbHelper.getTotalItemsSoldByDate(date);
  }

  // This method is still used by the controller for the monthly filter,
  // but the list view will display aggregated data instead of these individual transactions.
  // It is also used by the new monthly transactions list controller.
  Future<List<Map<String, dynamic>>> getMonthlyTransactions(DateTime date) async {
    return await _dbHelper.getTransactionsByMonth(date);
  }

  Future<List<Map<String, dynamic>>> getMonthlyAggregatedSales(int year) async {
    return await _dbHelper.getMonthlyAggregatedSales(year);
  }

  Future<List<Map<String, dynamic>>> getDateRangeTransactions(DateTime startDate, DateTime endDate) async {
    return await _dbHelper.getTransactionsByDateRange(startDate, endDate);
  }

  Future<double> getDateRangeTotalSales(DateTime startDate, DateTime endDate) async {
    return await _dbHelper.getTotalSalesByDateRange(startDate, endDate);
  }

   Future<int> getDateRangeTotalItems(DateTime startDate, DateTime endDate) async {
    return await _dbHelper.getTotalItemsSoldByDateRange(startDate, endDate);
  }
}