import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/master_scan_produk_controller.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../home/controllers/home_controller.dart';

class MasterScanProdukEditView extends StatefulWidget {
  @override
  _MasterScanProdukEditViewState createState() => _MasterScanProdukEditViewState();
}

class _MasterScanProdukEditViewState extends State<MasterScanProdukEditView> {
  late final MasterScanProdukController controller;
  late final Map<String, dynamic> product;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _hargaBeliController;
  late TextEditingController _hargaJualController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<MasterScanProdukController>();
    product = Map<String, dynamic>.from(Get.arguments ?? {});
    // Retrieve harga beli from online database field
    _hargaBeliController = TextEditingController(
      text: (product['produk_harga_beli'] ?? product['purchasePrice'] ?? '').toString(),
    );
    _hargaJualController = TextEditingController(
      text: (product['produk_harga_jual'] ?? product['finalPrice'] ?? '').toString(),
    );
  }

  @override
  void dispose() {
    _hargaBeliController.dispose();
    _hargaJualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Edit Produk"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                product['productName'] ?? 'Produk',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: _hargaBeliController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga Beli',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Masukkan harga beli' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _hargaJualController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga Jual',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Masukkan harga jual' : null,
              ),
              SizedBox(height: 24),
              Obx(() => controller.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          final hargaBeli = int.tryParse(_hargaBeliController.text) ?? 0;
                          final hargaJual = int.tryParse(_hargaJualController.text) ?? 0;
                          // Parse productId as int safely
                          dynamic productIdRaw = product['productId'] ?? product['product_id'];
                          int? productId = productIdRaw is int
                              ? productIdRaw
                              : int.tryParse(productIdRaw?.toString() ?? '');
                          if (productId == null) {
                            Get.snackbar('Error', 'ID Produk tidak valid');
                            return;
                          }
                          await controller.editProductPrice(
                            productId: productId,
                            hargaBeli: hargaBeli,
                            hargaJual: hargaJual,
                          );
                        }
                      },
                      child: Text('Submit'),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
