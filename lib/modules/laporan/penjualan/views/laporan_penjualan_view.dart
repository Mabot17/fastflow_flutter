// views/laporan_penjualan_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/laporan_penjualan_controller.dart'; // Import the controller

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
                                  controller.formatDate(controller.startDate.value.toIso8601String()),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
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
                                  controller.formatDate(controller.endDate.value.toIso8601String()),
                                  style: TextStyle(fontSize: 16),
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
              'Daftar Transaksi',
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
                  return Center(child: CircularProgressIndicator());
                }
                if (controller.transactions.isEmpty) {
                  return Center(child: Text('Tidak ada data transaksi untuk periode ini.'));
                }
                return ListView.builder(
                  itemCount: controller.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = controller.transactions[index];
                    return _buildTransactionCard(transaction);
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

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    // Assuming transaction map contains:
    // 'id', 'no_faktur', 'tanggal', 'total_bayar', 'total_items' (from the join query)
    final int transactionId = transaction['id']; // Get the transaction ID
    final String noFaktur = transaction['no_faktur'] ?? 'N/A';
    final String tanggal = transaction['tanggal'] ?? '';
    final double totalBayar = (transaction['total_bayar'] as num?)?.toDouble() ?? 0.0;
    final int totalItems = (transaction['total_items'] as int?) ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell( // Make the card tappable
        onTap: () => controller.goToDetail(transactionId), // Navigate on tap
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Date prominently
              Text(
                controller.formatDate(tanggal),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              const SizedBox(height: 4),
              // Display Faktur number below date
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
              // Remove the "Lihat Detail" button as the whole card is tappable
              // const SizedBox(height: 8),
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: TextButton(
              //     onPressed: () {
              //       // TODO: Navigate to transaction detail view if needed
              //       print('View details for $noFaktur');
              //     },
              //     child: Text('Lihat Detail'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
