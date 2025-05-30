import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../services/laporan_penjualan_service.dart';
import '../../../../routes/app_routes_constant.dart';

class LaporanPenjualanMonthlyTransactionsController extends GetxController {
  final LaporanPenjualanService _salesService = Get.find<LaporanPenjualanService>();

  var transactions = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var monthYearTitle = ''.obs;

  int? year;
  int? month;

  @override
  void onInit() {
    super.onInit();
    final String? yearStr = Get.parameters['year'];
    final String? monthStr = Get.parameters['month'];
    print('[MonthlyTransactionsController] Route params: year=$yearStr, month=$monthStr');

    if (yearStr != null && monthStr != null) {
      try {
        year = int.tryParse(yearStr);
        month = int.tryParse(monthStr);
        if (year == null || month == null) {
          errorMessage.value = 'Invalid year or month parameter (null after parsing).';
          print('[MonthlyTransactionsController] ERROR: $errorMessage');
          isLoading.value = false;
          return;
        }
        final date = DateTime(year!, month!);
        monthYearTitle.value = DateFormat('MMMM yyyy').format(date);
        print('[MonthlyTransactionsController] Parsed year=$year, month=$month, title=${monthYearTitle.value}');
        fetchMonthlyTransactions();
      } catch (e) {
        errorMessage.value = 'Invalid date parameters: $e';
        print('[MonthlyTransactionsController] ERROR: $errorMessage');
        isLoading.value = false;
      }
    } else {
      errorMessage.value = 'Month and Year parameters not provided.';
      print('[MonthlyTransactionsController] ERROR: $errorMessage');
      isLoading.value = false;
    }
  }

  Future<void> fetchMonthlyTransactions() async {
    if (year == null || month == null) {
      errorMessage.value = 'Date parameters are missing.';
      print('[MonthlyTransactionsController] ERROR: $errorMessage');
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    transactions.clear();
    errorMessage.value = '';

    try {
      final dateForQuery = DateTime(year!, month!, 1);
      print('[MonthlyTransactionsController] Fetching transactions for $dateForQuery');
      final fetchedData = await _salesService.getMonthlyTransactions(dateForQuery);
      print('[MonthlyTransactionsController] Fetched ${fetchedData.length} transactions');
      transactions.assignAll(fetchedData);

      if (fetchedData.isEmpty) {
         errorMessage.value = 'Tidak ada transaksi untuk bulan ini.';
         print('[MonthlyTransactionsController] INFO: $errorMessage');
      }

    } catch (e) {
      print("[MonthlyTransactionsController] ERROR fetching monthly transactions: $e");
      errorMessage.value = 'Failed to load monthly transactions.';
    } finally {
      isLoading.value = false;
    }
  }

  void goToDetail(int transactionId) {
    print('[MonthlyTransactionsController] Navigating to detail for transactionId=$transactionId');
    Get.toNamed("${AppRoutesConstants.laporanPenjualan}/$transactionId");
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(amount);
  }

  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
