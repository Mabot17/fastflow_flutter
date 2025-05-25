import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../controllers/transaksi_pos_controller.dart';

class TransaksiPosListView extends StatelessWidget {
  final TransaksiPosController _controller = Get.find<TransaksiPosController>();
  final DateFormat _formatter = DateFormat('dd MMM yyyy, HH:mm');

  final RxBool _isLoaded = false.obs;

  Color _getPaymentColor(String caraBayar) {
    switch (caraBayar.toLowerCase()) {
      case 'tunai':
        return Colors.green.shade100;
      case 'kartu':
        return Colors.blue.shade100;
      case 'transfer':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  IconData _getPaymentIcon(String caraBayar) {
    switch (caraBayar.toLowerCase()) {
      case 'tunai':
        return Icons.money;
      case 'kartu':
        return Icons.credit_card;
      case 'transfer':
        return Icons.account_balance_wallet;
      default:
        return Icons.payment;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Load hanya sekali
    if (!_isLoaded.value) {
      _controller.loadTransaksi();
      _isLoaded.value = true;
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Daftar Transaksi',
        leading: BackButton(),
      ),
      body: Obx(() {
        if (_controller.transaksiList.isEmpty) {
          return Center(
            child: Text(
              'Belum ada transaksi',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: _controller.transaksiList.length,
          itemBuilder: (context, index) {
            final transaksi = _controller.transaksiList[index];
            final tanggalFormatted = transaksi.tanggal.isNotEmpty
                ? _formatter.format(DateTime.parse(transaksi.tanggal))
                : '-';

            final paymentColor = _getPaymentColor(transaksi.caraBayar);
            final paymentIcon = _getPaymentIcon(transaksi.caraBayar);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: paymentColor,
              child: ListTile(
                leading: Icon(
                  paymentIcon,
                  color: Colors.deepPurple,
                  size: 32,
                ),
                title: Text(
                  'No. Faktur: ${transaksi.noFaktur}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.deepPurple.shade700,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total: Rp ${transaksi.totalBayar.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.deepPurple.shade900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tanggal: $tanggalFormatted',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.deepPurple.shade400,
                      ),
                    ),
                  ],
                ),
                trailing: Chip(
                  label: Text(
                    transaksi.caraBayar.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.deepPurple,
                ),
                onTap: () {
                  // TODO: Navigasi ke detail transaksi
                },
              ),
            );
          },
        );
      }),
    );
  }
}
