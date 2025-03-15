import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaksi_pos_controller.dart';

class TransaksiPosDetailView extends StatelessWidget {
  final TransaksiPosController controller = Get.put(TransaksiPosController());

  @override
  Widget build(BuildContext context) {
    final String transactionId = Get.parameters['id'] ?? '0';

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Detail #$transactionId'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.offAllNamed('/home'),
        ),
      ),
      body: Center(
        child: Text('Detail transaksi dengan ID: $transactionId'),
      ),
    );
  }
}
