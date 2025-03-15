import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';

class TransactionView extends StatelessWidget {
  final TransactionController controller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction List'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (controller.transactions.isEmpty) {
          return Center(child: Text('No transactions available'));
        }

        return ListView.builder(
          itemCount: controller.transactions.length,
          itemBuilder: (context, index) {
            final transaction = controller.transactions[index];
            return ListTile(
              title: Text(transaction.name),
              subtitle: Text('Amount: \$${transaction.amount}'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to transaction details
                Get.toNamed('/transaction/${transaction.id}');
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addTransaction(); // Contoh aksi untuk menambah transaksi
        },
        child: Icon(Icons.add),
      ),
    );
  }
}