import 'package:get/get.dart';
import '../../../../routes/app_routes_constant.dart'; // Import konstanta

class Transaction {
  final int id;
  final String name;
  final double amount;

  Transaction({required this.id, required this.name, required this.amount});
}

class TransaksiPosController extends GetxController {
  var isLoading = true.obs;
  var transactions = <Transaction>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadTransactions();
  }

  void _loadTransactions() async {
    await Future.delayed(Duration(seconds: 2)); // Simulasi loading
    transactions.assignAll([
      Transaction(id: 1, name: 'Order #1001', amount: 250.0),
      Transaction(id: 2, name: 'Order #1002', amount: 100.0),
      Transaction(id: 3, name: 'Order #1003', amount: 75.5),
    ]);
    isLoading.value = false;
  }

  void addTransaction() {
    int newId = transactions.length + 1;
    transactions.add(Transaction(
      id: newId,
      name: 'Order #$newId',
      amount: (50 + newId * 10).toDouble(),
    ));
  }

  void goToDetail(int transactionId) {
    Get.toNamed('${AppRoutesConstants.pos}/$transactionId');
  }
}
