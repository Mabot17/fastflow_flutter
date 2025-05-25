import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../controllers/transaksi_pos_controller.dart';

class TransaksiPosDetailView extends StatelessWidget {
  final TransaksiPosController controller = Get.find<TransaksiPosController>();
  final DateFormat _formatter = DateFormat('dd MMM yyyy, HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detail Transaksi',
        leading: BackButton(),
      ),
      body: Obx(() {
        final trx = controller.transaksiById.value;

        if (trx == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildReceiptHeader(trx),
              const SizedBox(height: 20),
              _buildProductDetails(trx),
              const SizedBox(height: 20),
              _buildTotalInfo(trx),
              const SizedBox(height: 20),
              _buildActionButton(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildReceiptHeader(Map<String, dynamic> trx) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EFFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No. Faktur: ${trx["no_faktur"]}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7C4DFF),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tanggal: ${_formatter.format(DateTime.parse(trx["tanggal"]))}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Metode Pembayaran: ${trx["cara_bayar"]}',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails(Map<String, dynamic> trx) {
    final detail = trx['detail'] as List<dynamic>? ?? [];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: const Color(0xFFF8F4FF),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: detail.map<Widget>((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gambar produk
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item['url_image'] ?? '',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image_not_supported, size: 30, color: Colors.grey),
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Nama dan qty
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['produk_nama'] ?? '-',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Qty: ${item['qty']}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),

                  // Harga total
                  Text(
                    'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(item['total'] ?? 0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF7C4DFF),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTotalInfo(Map<String, dynamic> trx) {
    final total = trx["total_bayar"] ?? 0;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: const Color(0xFFF3EFFF),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [_buildTotalRow('Total Bayar', total)]),
      ),
    );
  }

  Widget _buildTotalRow(String label, dynamic value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          'Rp ${value.toString()}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Struk siap dicetak')));
        },
        icon: const Icon(Icons.print),
        label: const Text('Cetak Struk'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7C4DFF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
