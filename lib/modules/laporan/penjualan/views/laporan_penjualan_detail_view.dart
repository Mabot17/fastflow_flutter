import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting
import '../controllers/laporan_penjualan_detail_controller.dart'; // Import the detail controller
import '../../../../widgets/custom_app_bar.dart'; // Assuming you have a custom app bar

class LaporanPenjualanDetailView extends GetView<LaporanPenjualanDetailController> {
  const LaporanPenjualanDetailView({Key? key}) : super(key: key);

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(amount);
  }

  String _formatDate(String dateString) {
     try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy, HH:mm').format(date); // Include time if available
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detail Transaksi',
        leading: BackButton(),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        final transaction = controller.transaction.value;
        if (transaction == null) {
           return Center(child: Text('Transaksi tidak ditemukan.'));
        }

        final List<Map<String, dynamic>> details = controller.transactionDetails;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Transaction Summary ---
              Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No. Faktur: ${transaction['no_faktur'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[800]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tanggal: ${_formatDate(transaction['tanggal'] ?? '')}',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cara Bayar: ${transaction['cara_bayar'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 16),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text(
                            'Total Bayar:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                          ),
                          Text(
                            _formatCurrency((transaction['total_bayar'] as num?)?.toDouble() ?? 0.0),
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- Transaction Items Header ---
              Text(
                'Detail Barang',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              const SizedBox(height: 16),

              // --- Transaction Items List ---
              if (details.isEmpty)
                Center(child: Text('Tidak ada detail barang untuk transaksi ini.'))
              else
                ListView.builder(
                  shrinkWrap: true, // Use shrinkWrap in a SingleChildScrollView
                  physics: NeverScrollableScrollPhysics(), // Disable scrolling for the inner list
                  itemCount: details.length,
                  itemBuilder: (context, index) {
                    final item = details[index];
                    return _buildTransactionItemCard(item);
                  },
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTransactionItemCard(Map<String, dynamic> item) {
    // Assuming item map contains:
    // 'produk_nama', 'qty', 'harga', 'total'
    final String produkNama = item['produk_nama'] ?? 'N/A';
    final int qty = (item['qty'] as int?) ?? 0;
    final double harga = (item['harga'] as num?)?.toDouble() ?? 0.0;
    final double total = (item['total'] as num?)?.toDouble() ?? 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              produkNama,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Qty: $qty', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                Text('Harga Satuan: ${_formatCurrency(harga)}', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
              ],
            ),
            const SizedBox(height: 4),
             Align(
               alignment: Alignment.bottomRight,
               child: Text(
                'Subtotal: ${_formatCurrency(total)}',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blueGrey[700]),
            ),
             ),
          ],
        ),
      ),
    );
  }
}
