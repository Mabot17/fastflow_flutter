import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/master_produk_global_add_controller.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../master/scan_produk/views/master_scan_produk_view.dart'; // Import scanner view
import '../../../master/scan_produk/controllers/master_scan_produk_controller.dart'; // Import the controller

class MasterProdukGlobalAddView extends GetView<MasterProdukGlobalAddController> {
  const MasterProdukGlobalAddView({Key? key}) : super(key: key);

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    IconData? prefixIcon,
    Widget? suffixIcon, // Added for the scan button
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText ?? 'Masukkan $labelText',
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Color(0xFF7C4DFF)) : null,
          suffixIcon: suffixIcon, // Use the suffixIcon parameter
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Color(0xFF7C4DFF), width: 2.0),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        ),
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(color: Colors.black87),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Tambah Produk Baru',
        leading: BackButton(onPressed: () => Get.back()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Informasi Dasar Produk",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
              ),
              SizedBox(height: 12),
              _buildTextField(
                controller: controller.namaController,
                labelText: 'Nama Produk*',
                prefixIcon: Icons.label_important,
                validator: (value) => controller.validateNotEmpty(value, 'Nama Produk'),
              ),
              _buildTextField(
                controller: controller.barcodeController,
                labelText: 'Barcode',
                prefixIcon: Icons.qr_code_scanner, // Changed icon
                suffixIcon: IconButton( // Added scan button
                  icon: Icon(Icons.camera_alt, color: Color(0xFF7C4DFF)),
                  onPressed: () {
                    // Explicitly put the controller before navigating
                    Get.put(MasterScanProdukController());
                    Get.to(() => MasterScanProdukView(
                          onBarcodeScanned: (scannedBarcode) {
                            controller.barcodeController.text = scannedBarcode;
                          },
                        ));
                  },
                ),
              ),
              _buildTextField(
                controller: controller.skuController,
                labelText: 'SKU (Kode Stok)',
                prefixIcon: Icons.inventory_2,
              ),
              _buildTextField(
                controller: controller.pluController,
                labelText: 'PLU (Kode Harga)',
                prefixIcon: Icons.price_check,
              ),
              _buildTextField(
                controller: controller.kategoriController,
                labelText: 'Kategori',
                prefixIcon: Icons.category,
              ),

              SizedBox(height: 24),
              Text(
                "Detail Harga & Stok",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: controller.hargaBeliController,
                      labelText: 'Harga Beli*',
                      prefixIcon: Icons.shopping_cart_checkout,
                      keyboardType: TextInputType.number,
                      validator: (value) => controller.validateNumeric(value, 'Harga Beli'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: controller.hargaJualController,
                      labelText: 'Harga Jual*',
                      prefixIcon: Icons.sell,
                      keyboardType: TextInputType.number,
                      validator: (value) => controller.validateNumeric(value, 'Harga Jual'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: controller.stokController,
                      labelText: 'Stok Awal*',
                      prefixIcon: Icons.store,
                      keyboardType: TextInputType.number,
                      validator: (value) => controller.validateInteger(value, 'Stok Awal'),
                    ),
                  ),
                  SizedBox(width: 16),
                   Expanded(
                    child: _buildTextField(
                      controller: controller.satuanController,
                      labelText: 'Satuan*',
                      prefixIcon: Icons.straighten,
                       validator: (value) => controller.validateNotEmpty(value, 'Satuan'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),
              Text(
                "Informasi Tambahan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
              ),
              SizedBox(height: 12),
               _buildTextField(
                controller: controller.imageUrlController,
                labelText: 'URL Gambar Produk',
                prefixIcon: Icons.image,
                keyboardType: TextInputType.url,
              ),
              _buildTextField(
                controller: controller.deskripsiController,
                labelText: 'Deskripsi Produk',
                prefixIcon: Icons.description,
                keyboardType: TextInputType.multiline,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Obx(() => SwitchListTile(
                  title: Text('Produk Aktif', style: TextStyle(color: Colors.black87)),
                  value: controller.isAktif.value,
                  onChanged: (bool value) {
                    controller.isAktif.value = value;
                  },
                  activeColor: Color(0xFF7C4DFF),
                  tileColor: Colors.grey.shade50,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                )),
              ),
              SizedBox(height: 30),
              Obx(() => controller.isLoading.value
                  ? Center(child: CircularProgressIndicator(color: Color(0xFF7C4DFF)))
                  : ElevatedButton.icon(
                      icon: Icon(Icons.save, color: Colors.white),
                      label: Text('Simpan Produk', style: TextStyle(fontSize: 16, color: Colors.white)),
                      onPressed: controller.saveProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7C4DFF),
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 3,
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}