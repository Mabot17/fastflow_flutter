import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/laporan_dashboard_service.dart'; // Import the new service

// Enum for time range selection
enum TimeRange {
  oneDay,
  oneWeek,
  oneMonth,
  threeMonths,
  yearToDate,
  oneYear,
  // Add more if needed like 3Y, 5Y
}

// Data class to hold processed data points for easier reference
class PendapatanDataPoint {
  final DateTime date;
  final double amount;
  final double xValue; // X-coordinate for the chart spot

  PendapatanDataPoint(
      {required this.date, required this.amount, required this.xValue});
}

class PendapatanController extends GetxController {
  // Inject the service instead of using DatabaseHelper directly
  final LaporanDashboardService _dashboardService = Get.find<LaporanDashboardService>();

  // --- Observables for UI reactivity ---
  var selectedTimeRange = TimeRange.threeMonths.obs;
  var totalRevenue = 0.0.obs;
  var chartSpots = <FlSpot>[].obs;
  var isLoading = true.obs;

  // Store details of highest and lowest points including their chart x-value
  var highestPendapatan = Rxn<PendapatanDataPoint>();
  var lowestPendapatan = Rxn<PendapatanDataPoint>();

  // Chart axis bounds - dynamic based on data
  var minX = 0.0.obs;
  var maxX = 0.0.obs;
  var minY = 0.0.obs;
  var maxY = 0.0.obs;

  // Store the actual start date used for the current range calculation
  var currentRangeStartDate = DateTime.now().obs;


  // Currency formatter
  final NumberFormat _currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  String formatCurrency(double amount) => _currencyFormatter.format(amount);

  @override
  void onInit() {
    super.onInit();
    // Ensure DB is initialized if not done globally
    // For now, assuming DatabaseHelper handles its own initialization states.
    // Example: await _dbHelper.initDatabaseOffline(); // If needed here
    fetchPendapatanData(selectedTimeRange.value);
  }

  Future<void> changeTimeRange(TimeRange newRange) async {
    if (selectedTimeRange.value == newRange && !isLoading.value) return; // Avoid redundant calls
    selectedTimeRange.value = newRange;
    await fetchPendapatanData(newRange);
  }

  Future<void> fetchPendapatanData(TimeRange range) async {
    isLoading.value = true;
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate;

      // Determine date range
      switch (range) {
        case TimeRange.oneDay:
          startDate = DateTime(endDate.year, endDate.month, endDate.day);
          break;
        case TimeRange.oneWeek:
          startDate = endDate.subtract(const Duration(days: 6));
          break;
        case TimeRange.oneMonth:
          // Be careful with month arithmetic, subtracting days is safer for exact ranges
          startDate = endDate.subtract(const Duration(days: 29)); // Approx 1 month
          // startDate = DateTime(endDate.year, endDate.month - 1, endDate.day);
          break;
        case TimeRange.threeMonths:
          startDate = endDate.subtract(const Duration(days: 89)); // Approx 3 months
          // startDate = DateTime(endDate.year, endDate.month - 3, endDate.day);
          break;
        case TimeRange.yearToDate:
          startDate = DateTime(endDate.year, 1, 1);
          break;
        case TimeRange.oneYear:
          startDate = DateTime(endDate.year - 1, endDate.month, endDate.day);
          break;
        default:
          startDate = endDate.subtract(const Duration(days: 89)); // Default to 3 months
      }
      // Normalize start date to the beginning of the day for iteration
      startDate = DateTime(startDate.year, startDate.month, startDate.day);
      currentRangeStartDate.value = startDate; // Store the actual start date


      // 1. Fetch total revenue for the period using the service
      totalRevenue.value = await _dashboardService.getTotalSalesByDateRange(startDate, endDate);

      // 2. Fetch all transactions in the range to aggregate daily sales using the service
      List<Map<String, dynamic>> transactions =
          await _dashboardService.getTransactionsByDateRange(startDate, endDate);

      Map<String, double> dailyAggregatedSales = {};
      for (var trx in transactions) {
        // Ensure 'tanggal' is treated as UTC or local consistently.
        // Assuming it's stored as ISO8601 string, parse it.
        // Use .toLocal() if the chart should display based on local time.
        DateTime trxDate = DateTime.parse(trx['tanggal']).toLocal();
        String dateKey = DateFormat('yyyy-MM-dd').format(trxDate);
        double amount = (trx['total_bayar'] as num?)?.toDouble() ?? 0.0;
        dailyAggregatedSales.update(dateKey, (value) => value + amount,
            ifAbsent: () => amount);
      }

      List<FlSpot> spotsData = [];
      List<PendapatanDataPoint> dataPoints = []; // To store full data point info

      PendapatanDataPoint? currentHighest;
      PendapatanDataPoint? currentLowest;
      double tempMaxY = 0.0; // Start with 0 for sales
      double tempMinY = double.infinity;

      int dayIndex = 0;
      DateTime currentDateIter = startDate;
      // Iterate up to and including the end date's day
      final endOfDayForEndDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);


      while (!currentDateIter.isAfter(endOfDayForEndDate)) {
        String dateKey = DateFormat('yyyy-MM-dd').format(currentDateIter);
        double dailySale = dailyAggregatedSales[dateKey] ?? 0.0;

        final dataPoint = PendapatanDataPoint(
            date: currentDateIter,
            amount: dailySale,
            xValue: dayIndex.toDouble());
        dataPoints.add(dataPoint);
        spotsData.add(FlSpot(dayIndex.toDouble(), dailySale));

        if (currentHighest == null || dailySale > currentHighest.amount) {
          currentHighest = dataPoint;
        }
        // The image shows lowest point, even if zero.
        if (currentLowest == null || dailySale < currentLowest.amount) {
          currentLowest = dataPoint;
        }
        
        if (dailySale > tempMaxY) tempMaxY = dailySale;
        // Initialize tempMinY with the first data point's value if it's still infinity
        if (tempMinY == double.infinity || dailySale < tempMinY) {
             tempMinY = dailySale;
        }


        currentDateIter = currentDateIter.add(const Duration(days: 1));
        dayIndex++;
      }
      
      if (spotsData.isEmpty) {
          // If no data points were generated (e.g., range is empty or no transactions)
          spotsData.add(const FlSpot(0,0)); // Default spot to avoid chart error
          minX.value = 0;
          maxX.value = 1; // A small range
          minY.value = 0;
          maxY.value = 100000; // Default Y if no data
          highestPendapatan.value = null;
          lowestPendapatan.value = null;
      } else {
          highestPendapatan.value = currentHighest;
          lowestPendapatan.value = currentLowest;
          chartSpots.assignAll(spotsData);

          minX.value = 0;
          maxX.value = (dayIndex - 1).toDouble(); // Last index used

          // Adjust Y-axis scaling for better visualization
          if (tempMaxY == tempMinY) { // All data points are the same (e.g. all zero)
            minY.value = tempMaxY > 0 ? tempMaxY * 0.5 : 0; // Avoid negative if min is 0
            maxY.value = tempMaxY > 0 ? tempMaxY * 1.5 : 100000; // Provide some default height if all 0
          } else {
            // Add padding; ensure minY is not negative if data is non-negative
            double padding = (tempMaxY - tempMinY) * 0.1; // 10% padding
            minY.value = (tempMinY - padding < 0 && tempMinY >=0) ? 0 : (tempMinY - padding);
            maxY.value = tempMaxY + padding;
          }
          // Ensure maxY is greater than minY, especially if minY became 0
          if (minY.value >= maxY.value) {
              maxY.value = minY.value + (tempMaxY > 0 ? tempMaxY * 0.5 : 100000); // Add some height
          }
      }


    } catch (e, s) {
      print("Error fetching pendapatan data: $e\n$s");
      chartSpots.assignAll([]);
      totalRevenue.value = 0.0;
      highestPendapatan.value = null;
      lowestPendapatan.value = null;
      minX.value = 0;
      maxX.value = 1;
      minY.value = 0;
      maxY.value = 100000;
      // Optionally show an error message to the user via an observable
    } finally {
      isLoading.value = false;
    }
  }
}