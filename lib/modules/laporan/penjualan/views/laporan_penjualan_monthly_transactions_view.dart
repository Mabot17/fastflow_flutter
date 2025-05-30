import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/laporan_penjualan_monthly_transactions_controller.dart'; // Import the new controller
import '../../../../widgets/custom_app_bar.dart'; // Assuming you have a custom app bar

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
            return Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          }

          if (controller.transactions.isEmpty) {
            return Center(child: Text('Tidak ada data transaksi untuk bulan ini.'));
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
        onTap: () => controller.goToDetail(transactionId), // Navigate to detail on tap
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
            ],
          ),
        ),
      ),
    );
  }
}
