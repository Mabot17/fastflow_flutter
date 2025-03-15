import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaksi_pos_controller.dart';
import '../../../../widgets/custom_app_bar.dart';

class TransaksiPosView extends StatelessWidget {
  final TransaksiPosController _controller = Get.put(TransaksiPosController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Point Of Sales List',
      ),
      body: Obx(() => _buildBody()),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading.value) {
      return Center(child: CircularProgressIndicator());
    }
    if (_controller.transactions.isEmpty) {
      return Center(child: Text('No transactions available'));
    }
    return _buildTransactionList();
  }

  Widget _buildTransactionList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _controller.transactions.length,
      itemBuilder: (context, index) {
        final transaction = _controller.transactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildTransactionCard(transaction) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(Icons.payment, color: Colors.blue.shade700),
        ),
        title: Text(transaction.name,
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Amount: \$${transaction.amount}'),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue.shade700),
        onTap: () => _controller.goToDetail(transaction.id),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _controller.addTransaction,
      backgroundColor: Colors.blue,
      child: Icon(Icons.add, color: Colors.white),
    );
  }
}