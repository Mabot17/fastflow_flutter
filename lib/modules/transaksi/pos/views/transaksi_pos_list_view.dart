import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../controllers/transaksi_pos_controller.dart';

class TransaksiPosListView extends StatelessWidget {
  final TransaksiPosController _controller = Get.find<TransaksiPosController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Daftar Transaksi',
        leading: BackButton(), // jika ingin tombol kembali
      ),
      body: Obx(() {
        if (_controller.transaksiList.isEmpty) {
          return Center(child: Text('Belum ada transaksi'));
        }
        return ListView.builder(
          itemCount: _controller.transaksiList.length,
          itemBuilder: (context, index) {
            final transaksi = _controller.transaksiList[index];
            return ListTile(
              leading: Icon(Icons.receipt_long),
              title: Text('Transaksi #${transaksi.id}'),
              subtitle: Text('Total: Rp ${transaksi.total.toStringAsFixed(0)}'),
              trailing: Text(transaksi.tanggal),
              onTap: () {
                // Arahkan ke detail transaksi jika ada
              },
            );
          },
        );
      }),
    );
  }
}
