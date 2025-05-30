// services/laporan_penjualan_service.dart

import 'package:get/get.dart';
import '/core/database/database_helper.dart'; // Import DatabaseHelper

class LaporanPenjualanService extends GetxService {
  final DatabaseHelper _dbHelper = DatabaseHelper(); // Get instance of DatabaseHelper

  Future<List<Map<String, dynamic>>> getDailyTransactions(DateTime date) async {
    return await _dbHelper.getTransactionsByDate(date);
  }

  Future<double> getDailyTotalSales(DateTime date) async {
    return await _dbHelper.getTotalSalesByDate(date);
  }

   Future<int> getDailyTotalItems(DateTime date) async {
    return await _dbHelper.getTotalItemsSoldByDate(date);
  }

  Future<List<Map<String, dynamic>>> getMonthlyTransactions(DateTime date) async {
    return await _dbHelper.getTransactionsByMonth(date);
  }

  Future<double> getMonthlyTotalSales(DateTime date) async {
    return await _dbHelper.getTotalSalesByMonth(date);
  }

   Future<int> getMonthlyTotalItems(DateTime date) async {
    return await _dbHelper.getTotalItemsSoldByMonth(date);
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