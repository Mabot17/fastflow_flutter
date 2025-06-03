// views/laporan_penjualan_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/laporan_penjualan_controller.dart'; // Import the controller
import 'package:intl/intl.dart'; // Import for date formatting
import '../../../../routes/app_routes_constant.dart'; // <-- Add this import at the top if not present

class LaporanPenjualanView extends GetView<LaporanPenjualanController> {
  const LaporanPenjualanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Penjualan'),
        backgroundColor: Colors.teal, // Professional color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Filter Tabs ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFilterTab(SalesFilter.daily, 'Harian'),
                _buildFilterTab(SalesFilter.monthly, 'Bulanan'),
                _buildFilterTab(SalesFilter.dateRange, 'Rentang Waktu'),
              ],
            ),
            const SizedBox(height: 16),

            // --- Date Range Pickers (Visible only for DateRange filter) ---
            Obx(() => controller.activeFilter.value == SalesFilter.dateRange
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => controller.pickStartDate(),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Dari Tanggal',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                                ),
                                child: Text(
                                  // Ensure startDate.value is not null before calling toIso8601String()
                                  controller.formatDate(controller.startDate.value?.toIso8601String() ?? ''),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                           Expanded(
                            child: InkWell(
                              onTap: () => controller.pickEndDate(),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Sampai Tanggal',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                   contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                                ),
                                child: Text(
                                  // Ensure endDate.value is not null before calling toIso8601String()
                                  controller.formatDate(controller.endDate.value?.toIso8601String() ?? ''),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  )
                : Container()),

            // --- Summary Totals ---
            Obx(() => Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total Penjualan',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.formatCurrency(controller.totalSales.value),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[700],
                          ),
                        ),
                      ],
                    ),
                    Column(
                       crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total Barang Terjual',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                         const SizedBox(height: 4),
                        Text(
                          '${controller.totalItems.value}',
                           style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 24),

            // --- Transaction List Header ---
            Text(
              controller.activeFilter.value == SalesFilter.monthly ? 'Ringkasan Bulanan' : 'Daftar Transaksi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(height: 16),

            // --- Transaction List ---
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.transactions.isEmpty) {
                  return Center(child: Text('Tidak ada data ${controller.activeFilter.value == SalesFilter.monthly ? "ringkasan bulanan" : "transaksi"} untuk periode ini.'));
                }
                return ListView.builder(
                  itemCount: controller.transactions.length,
                  itemBuilder: (context, index) {
                    final data = controller.transactions[index];
                    // Use different card based on filter
                    if (controller.activeFilter.value == SalesFilter.monthly) {
                       return _buildMonthlySummaryCard(data); // Use monthly summary card
                    } else {
                       return _buildTransactionCard(data); // Use individual transaction card
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(SalesFilter filter, String text) {
    return Expanded(
      child: InkWell(
        onTap: () => controller.changeFilter(filter),
        child: Obx(() => Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: controller.activeFilter.value == filter ? Colors.teal : Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: controller.activeFilter.value == filter ? Colors.teal : Colors.transparent,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: controller.activeFilter.value == filter ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        )),
      ),
    );
  }

  // Card for individual transactions (Daily, Date Range)
  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    // Assuming transaction map contains:
    // 'id', 'no_faktur', 'tanggal', 'total_bayar', 'total_items', 'cara_bayar'
    final int transactionId = (transaction['id'] as int?) ?? 0;
    final String noFaktur = transaction['no_faktur'] ?? 'N/A';
    final String tanggal = transaction['tanggal'] ?? '';
    final double totalBayar = (transaction['total_bayar'] as num?)?.toDouble() ?? 0.0;
    final int totalItems = (transaction['total_items'] as int?) ?? 0;
    final String caraBayar = transaction['cara_bayar'] ?? 'N/A'; // Get payment method

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: () => controller.goToDetail(transactionId),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Date on left, Time on right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // Format only the date part
                    DateFormat('dd MMMM yyyy').format(DateTime.parse(tanggal)),
                    style: TextStyle(
                      fontSize: 16, // Slightly smaller font for date
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                   Text(
                    // Format only the time part
                    controller.formatTime(tanggal),
                    style: TextStyle(
                      fontSize: 14, // Smaller font for time
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
               Text(
                'Faktur: $noFaktur',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Bayar:',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  Row( // Row for Total Bayar and Payment Method
                    children: [
                      // Innovation: Payment Method Indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getPaymentMethodColor(caraBayar), // Helper to get color
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          caraBayar,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8), // Space between method and total
                      Text(
                        controller.formatCurrency(totalBayar),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
               const SizedBox(height: 4),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Barang:',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  Text(
                    '$totalItems item',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to get color based on payment method
  Color _getPaymentMethodColor(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return Colors.green;
      case 'qris':
        return Colors.blue;
      case 'debit':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Card for monthly aggregated data
  // Make this card tappable to navigate to the monthly transactions list
  Widget _buildMonthlySummaryCard(Map<String, dynamic> monthlyData) {
    // Assuming monthlyData map contains:
    // 'sale_month', 'monthly_total_sales', 'monthly_total_items'
    final String saleMonth = monthlyData['sale_month'] ?? 'N/A';
    final double monthlyTotalSales = (monthlyData['monthly_total_sales'] as num?)?.toDouble() ?? 0.0;
    final int monthlyTotalItems = (monthlyData['monthly_total_items'] as int?) ?? 0;

    // Parse the month string to get year and month for navigation
    int year = 0;
    int month = 0;
    try {
       // Parse the date assuming 'yyyy-MM' format from the database
       final date = DateFormat('yyyy-MM').parse(saleMonth);
       year = date.year;
       month = date.month;
    } catch (e) {
       // Handle potential parsing errors, maybe log or show an error UI
       print("Error parsing month string '$saleMonth': $e");
       // Optionally set year/month to a default or invalid value
       year = 0;
       month = 0;
    }


    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: () {
          // Only navigate if parsing was successful
          if (year != 0 && month != 0) {
            // Use route constant for navigation!
            Get.toNamed('${AppRoutesConstants.laporanPenjualan}/monthly/$year/$month');
          } else {
            // Optionally show a message if navigation is not possible due to bad data
             Get.snackbar('Error', 'Tidak dapat menampilkan detail bulanan. Data bulan tidak valid.');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Month prominently
              Text(
                controller.formatMonth(saleMonth), // Use the formatMonth helper
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Penjualan Bulan Ini:',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  Text(
                    controller.formatCurrency(monthlyTotalSales),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
             const SizedBox(height: 4),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Barang Terjual Bulan Ini:',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                Text(
                  '$monthlyTotalItems item',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )); // Fixed: Removed the extra '}' and added closing parenthesis for Card widget
  }
}