import 'package:get/get.dart';
import '../../../../core/database/database_helper.dart'; // Import DatabaseHelper for detail query

class LaporanPenjualanDetailController extends GetxController {
  final DatabaseHelper _dbHelper = Get.find<DatabaseHelper>(); // Use DatabaseHelper directly for detail query
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
      // Ensure the ID is parsed correctly
      try {
         fetchTransactionDetail(int.parse(transactionId));
      } catch (e) {
         errorMessage.value = 'Invalid Transaction ID.';
         isLoading.value = false;
      }
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
      final db = await _dbHelper.database; // Get the database instance

      // Fetch the main transaction data by ID
      final List<Map<String, dynamic>> transactionList = await db.query(
        'transaksi',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (transactionList.isNotEmpty) {
        transaction.value = transactionList.first;

        // Fetch the transaction details (items) for this transaction ID
        final List<Map<String, dynamic>> detailsList = await db.query(
          'transaksi_detail',
          where: 'id_transaksi = ?',
          whereArgs: [id],
        );
        transactionDetails.assignAll(detailsList);

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
