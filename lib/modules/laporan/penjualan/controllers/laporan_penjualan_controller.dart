// controllers/laporan_penjualan_controller.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Import for showDatePicker/CalendarDatePicker
import 'package:flutter/widgets.dart'; // <-- Add this import if not present
import 'package:intl/intl.dart'; // Import intl for date formatting
import '../services/laporan_penjualan_service.dart'; // Import the service
import '../../../../routes/app_routes_constant.dart'; // Import route constants
import 'dart:collection';

enum SalesFilter { daily, monthly, dateRange }

class LaporanPenjualanController extends GetxController {
  final LaporanPenjualanService _salesService = Get.find<LaporanPenjualanService>();

  var activeFilter = SalesFilter.daily.obs;
  var totalSales = 0.0.obs;
  var totalItems = 0.obs;
  var transactions = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  var startDate = DateTime(2025, 1, 1).obs;
  var endDate = DateTime(2025, 12, 31).obs;

  @override
  void onInit() {
    super.onInit();
    print('[LaporanPenjualanController] onInit');
    ever(activeFilter, (filter) {
      print('[LaporanPenjualanController] activeFilter changed to $filter');
      fetchData();
    });
  }

  @override
  void onReady() {
    super.onReady();
    print('[LaporanPenjualanController] onReady');
    // Defer initial fetchData until after first frame to ensure context/db is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('[LaporanPenjualanController] addPostFrameCallback triggered, calling fetchData');
      fetchData();
    });
  }

  void changeFilter(SalesFilter filter) {
    print('[LaporanPenjualanController] changeFilter called with $filter');
    activeFilter.value = filter;
  }

  Future<void> fetchData() async {
    print('[LaporanPenjualanController] fetchData started for filter: ${activeFilter.value}');
    isLoading.value = true;
    transactions.clear();
    totalSales.value = 0.0;
    totalItems.value = 0;

    try {
      List<Map<String, dynamic>> fetchedData = [];
      double calculatedTotalSales = 0.0;
      int calculatedTotalItems = 0;

      final today = DateTime.now();
      final fixedDummyDate = DateTime(2025, 1, 1); // Still using this for monthly aggregation year

      switch (activeFilter.value) {
        case SalesFilter.daily:
          print('[LaporanPenjualanController] Fetching daily data for today: $today');
          fetchedData = await _salesService.getDailyTransactions(today);
          calculatedTotalSales = fetchedData.fold(0.0, (sum, item) => sum + ((item['total_bayar'] as num?)?.toDouble() ?? 0.0));
          calculatedTotalItems = fetchedData.fold(0, (sum, item) => sum + ((item['total_items'] as int?) ?? 0));
          transactions.assignAll(fetchedData);
          print('[LaporanPenjualanController] Daily data fetched: ${fetchedData.length} items');
          break;

        case SalesFilter.monthly:
          print('[LaporanPenjualanController] Fetching monthly aggregated data for year: ${fixedDummyDate.year}');
          List<Map<String, dynamic>> allYearData = await _salesService.getDateRangeTransactions(
            DateTime(fixedDummyDate.year, 1, 1),
            DateTime(fixedDummyDate.year, 12, 31),
          );
          print('[LaporanPenjualanController] All year data fetched for monthly aggregation: ${allYearData.length} items');

          Map<String, List<Map<String, dynamic>>> grouped = {};
          for (var trx in allYearData) {
            String monthKey = trx['tanggal']?.substring(0, 7) ?? '';
            if (monthKey.isNotEmpty) {
               grouped.putIfAbsent(monthKey, () => []).add(trx);
            }
          }
          print('[LaporanPenjualanController] Grouped into ${grouped.length} months');

          List<Map<String, dynamic>> monthlySummary = [];
          double yearlyTotalSales = 0.0;
          int yearlyTotalItems = 0;
          grouped.forEach((month, list) {
            double monthSales = list.fold(0.0, (sum, item) => sum + ((item['total_bayar'] as num?)?.toDouble() ?? 0.0));
            int monthItems = list.fold(0, (sum, item) => sum + ((item['total_items'] as int?) ?? 0));
            monthlySummary.add({
              'sale_month': month,
              'monthly_total_sales': monthSales,
              'monthly_total_items': monthItems,
            });
            yearlyTotalSales += monthSales;
            yearlyTotalItems += monthItems;
          });

          monthlySummary.sort((a, b) => (b['sale_month'] as String).compareTo(a['sale_month'] as String));
          transactions.assignAll(monthlySummary);
          totalSales.value = yearlyTotalSales;
          totalItems.value = yearlyTotalItems;
          print('[LaporanPenjualanController] Monthly summary generated: ${monthlySummary.length} items');
          // No need to set isLoading = false here, it's done in finally block
          return; // Exit switch case

        case SalesFilter.dateRange:
          print('[LaporanPenjualanController] Fetching date range data from ${startDate.value} to ${endDate.value}');
          fetchedData = await _salesService.getDateRangeTransactions(startDate.value, endDate.value);
          calculatedTotalSales = fetchedData.fold(0.0, (sum, item) => sum + ((item['total_bayar'] as num?)?.toDouble() ?? 0.0));
          calculatedTotalItems = fetchedData.fold(0, (sum, item) => sum + ((item['total_items'] as int?) ?? 0));
          transactions.assignAll(fetchedData);
          print('[LaporanPenjualanController] Date range data fetched: ${fetchedData.length} items');
          break;
      }

      totalSales.value = calculatedTotalSales;
      totalItems.value = calculatedTotalItems;
      print('[LaporanPenjualanController] Totals updated: Sales=${totalSales.value}, Items=${totalItems.value}');


    } catch (e) {
      print("[LaporanPenjualanController] Error fetching sales data: $e");
      // Handle error, maybe show a message
    } finally {
      // Ensure isLoading is set to false AFTER transactions are assigned
      isLoading.value = false;
      print('[LaporanPenjualanController] fetchData finished, isLoading = ${isLoading.value}');
    }
  }

  // Methods for Date Range picker
  Future<void> pickStartDate() async {
    DateTime? picked = await showDatePicker( // Use showDatePicker
      context: Get.context!, // Requires context
      initialDate: startDate.value,
      firstDate: DateTime(2000), // Allow picking dates from 2000
      lastDate: DateTime(2030), // Allow picking dates up to 2030
    );
    if (picked != null && picked != startDate.value) {
      startDate.value = picked;
      // Ensure end date is not before start date
      if (endDate.value.isBefore(startDate.value)) {
          endDate.value = startDate.value;
      }
      if (activeFilter.value == SalesFilter.dateRange) {
        fetchData(); // Refetch data if range filter is active
      }
    }
  }

   Future<void> pickEndDate() async {
    DateTime? picked = await showDatePicker( // Use showDatePicker
      context: Get.context!, // Requires context
      initialDate: endDate.value,
      firstDate: startDate.value, // End date cannot be before start date
      lastDate: DateTime(2030), // Allow picking dates up to 2030
    );
    if (picked != null && picked != endDate.value) {
      endDate.value = picked;
       if (activeFilter.value == SalesFilter.dateRange) {
        fetchData(); // Refetch data if range filter is active
      }
    }
  }

  // Helper to format currency
  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(amount);
  }

  // Helper to format date for display (for individual transactions)
  String formatDate(String dateString) {
     try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy').format(date);
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }

  // Helper to format month for display (for monthly aggregation)
  // This helper might still be useful for displaying the selected month in the UI,
  // but not for formatting items in the list view anymore.
  String formatMonth(String monthString) {
     try {
      // The aggregated data uses 'yyyy-MM' format for 'sale_month'
      final date = DateFormat('yyyy-MM').parse(monthString);
      return DateFormat('MMMM yyyy').format(date);
    } catch (e) {
      return monthString; // Return original if parsing fails
    }
  }


  // Navigate to detail view (only for individual transactions)
  void goToDetail(int transactionId) {
     Get.toNamed("${AppRoutesConstants.laporanPenjualan}/$transactionId");
  }
}