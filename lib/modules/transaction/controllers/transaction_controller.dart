import 'package:get/get.dart';

class Transaction {
  final int id;
  final String name;
  final double amount;

  Transaction({required this.id, required this.name, required this.amount});
}

class TransactionController extends GetxController {
  var transactions = <Transaction>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  void fetchTransactions() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2)); // Simulasi delay pengambilan data
    transactions.value = [
      Transaction(id: 1, name: "Purchase A", amount: 100.0),
      Transaction(id: 2, name: "Purchase B", amount: 250.0),
      Transaction(id: 3, name: "Purchase C", amount: 75.5),
    ];
    isLoading.value = false;
  }

  void addTransaction() {
    int newId = transactions.length + 1;
    transactions.add(Transaction(id: newId, name: "Purchase $newId", amount: 50.0));
  }
}
