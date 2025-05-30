// controllers/laporan_penjualan_controller.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Import for showDatePicker/CalendarDatePicker
import 'package:intl/intl.dart'; // Import intl for date formatting
import '../services/laporan_penjualan_service.dart'; // Import the service
import '../../../../routes/app_routes_constant.dart'; // Import route constants

enum SalesFilter { daily, monthly, dateRange }

class LaporanPenjualanController extends GetxController {
  final LaporanPenjualanService _salesService = Get.find<LaporanPenjualanService>();

  var activeFilter = SalesFilter.daily.obs;
  var totalSales = 0.0.obs;
  var totalItems = 0.obs;
  var transactions = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  // Date pickers for Range filter
  // Default dates set to cover the dummy data year (2025)
  var startDate = DateTime(2025, 1, 1).obs; // Default start of dummy data year
  var endDate = DateTime(2025, 12, 31).obs; // Default end of dummy data year

  @override
  void onInit() {
    super.onInit();
    // Listen to filter changes and fetch data
    ever(activeFilter, (_) => fetchData());
    // Initial data fetch
    // fetchData is called by the ever listener when activeFilter is initialized
  }

  void changeFilter(SalesFilter filter) {
    activeFilter.value = filter;
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    transactions.clear();
    totalSales.value = 0.0;
    totalItems.value = 0;

    try {
      List<Map<String, dynamic>> fetchedTransactions = [];
      double fetchedTotalSales = 0.0;
      int fetchedTotalItems = 0;

      final now = DateTime.now();
      // Adjust date to 2025 to match dummy data
      final dateInDummyYear = DateTime(2025, now.month, now.day);
      final monthInDummyYear = DateTime(2025, now.month, 1);


      switch (activeFilter.value) {
        case SalesFilter.daily:
          // Use current day/month but year 2025
          fetchedTransactions = await _salesService.getDailyTransactions(dateInDummyYear);
          fetchedTotalSales = await _salesService.getDailyTotalSales(dateInDummyYear);
          fetchedTotalItems = await _salesService.getDailyTotalItems(dateInDummyYear);
          break;
        case SalesFilter.monthly:
          // Use current month but year 2025
          fetchedTransactions = await _salesService.getMonthlyTransactions(monthInDummyYear);
          fetchedTotalSales = await _salesService.getMonthlyTotalSales(monthInDummyYear);
          fetchedTotalItems = await _salesService.getMonthlyTotalItems(monthInDummyYear);
          break;
        case SalesFilter.dateRange:
          // Use selected start and end dates (defaulting to 2025 range)
          fetchedTransactions = await _salesService.getDateRangeTransactions(startDate.value, endDate.value);
          fetchedTotalSales = await _salesService.getDateRangeTotalSales(startDate.value, endDate.value);
          fetchedTotalItems = await _salesService.getDateRangeTotalItems(startDate.value, endDate.value);
          break;
      }

      transactions.assignAll(fetchedTransactions);
      totalSales.value = fetchedTotalSales;
      totalItems.value = fetchedTotalItems;

    } catch (e) {
      print("Error fetching sales data: $e");
      // Handle error, maybe show a message
    } finally {
      isLoading.value = false;
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

  // Helper to format date for display
  String formatDate(String dateString) {
     try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy').format(date);
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }

  // Navigate to detail view
  void goToDetail(int transactionId) {
     Get.toNamed("${AppRoutesConstants.laporanPenjualan}/$transactionId");
  }
}