import 'package:get/get.dart';
import '../services/laporan_penjualan_service.dart'; // Import the service
import '../../../../core/database/database_helper.dart'; // Import DatabaseHelper for detail query

class LaporanPenjualanDetailController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper(); // Use DatabaseHelper directly for detail query
  // Note: Could also add a method to LaporanPenjualanService for this

  var transaction = Rx<Map<String, dynamic>?>(null);
  var transactionDetails = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final String? transactionId = Get.parameters['id'];
    if (transactionId != null) {
      fetchTransactionDetail(int.parse(transactionId));
    } else {
      errorMessage.value = 'Transaction ID not provided.';
      isLoading.value = false;
    }
  }

  Future<void> fetchTransactionDetail(int id) async {
    isLoading.value = true;
    errorMessage.value = '';
    transaction.value = null;
    transactionDetails.clear();

    try {
      // Fetch the main transaction data
      final List<Map<String, dynamic>> transactionList = await _dbHelper.getDataFromTable('transaksi');
      final mainTransaction = transactionList.firstWhereOrNull((t) => t['id'] == id);

      if (mainTransaction != null) {
        transaction.value = mainTransaction;

        // Fetch the transaction details (items)
        final List<Map<String, dynamic>> detailsList = await _dbHelper.getDataFromTable('transaksi_detail');
        final details = detailsList.where((d) => d['id_transaksi'] == id).toList();
        transactionDetails.assignAll(details);

      } else {
        errorMessage.value = 'Transaction not found.';
      }

    } catch (e) {
      print("Error fetching transaction detail: $e");
      errorMessage.value = 'Failed to load transaction details.';
    } finally {
      isLoading.value = false;
    }
  }
}
