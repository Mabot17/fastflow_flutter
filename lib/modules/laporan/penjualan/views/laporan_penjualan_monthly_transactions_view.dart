import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting
import '../controllers/laporan_penjualan_monthly_transactions_controller.dart'; // Import the new controller
import '../../../../widgets/custom_app_bar.dart'; // Assuming you have a custom app bar
import '../../../../routes/app_routes_constant.dart'; // <-- Add this import

class LaporanPenjualanMonthlyTransactionsView extends GetView<LaporanPenjualanMonthlyTransactionsController> {
  const LaporanPenjualanMonthlyTransactionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Obx(() => Text('Transaksi Bulan ${controller.monthYearTitle.value}')), // Dynamic title
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }

          if (controller.transactions.isEmpty) {
            return const Center(child: Text('Tidak ada data transaksi untuk bulan ini.'));
          }

          return ListView.builder(
            itemCount: controller.transactions.length,
            itemBuilder: (context, index) {
              final transaction = controller.transactions[index];
              // Reuse the individual transaction card structure
              return _buildTransactionCard(transaction);
            },
          );
        }),
      ),
    );
  }

  // Card for individual transactions (reused from LaporanPenjualanView structure)
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
      child: InkWell( // Make the card tappable
        onTap: () => controller.goToDetail(transactionId), // Navigate to detail on tap
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

   // Helper to get color based on payment method (reused from LaporanPenjualanView)
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
}
