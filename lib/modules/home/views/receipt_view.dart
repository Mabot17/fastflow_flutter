import 'package:flutter/material.dart';

class ReceiptView extends StatelessWidget {
  const ReceiptView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaksi Header
            _buildReceiptHeader(),
            const SizedBox(height: 20),
            // Rincian Produk
            _buildProductDetails(),
            const SizedBox(height: 20),
            // Total Harga dan Status Pembayaran
            _buildTotalAndStatus(),
            const SizedBox(height: 20),
            // Tombol Aksi
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  // Bagian Header Transaksi
  Widget _buildReceiptHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'No. Transaksi: #123456789',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tanggal: 2025-05-05',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Status: Berhasil',
            style: TextStyle(fontSize: 14, color: Colors.green),
          ),
        ],
      ),
    );
  }

  // Rincian Produk yang Dibeli
  Widget _buildProductDetails() {
    List<Map<String, String>> products = [
      {'name': 'Produk A', 'quantity': '2', 'price': 'Rp 50.000'},
      {'name': 'Produk B', 'quantity': '1', 'price': 'Rp 100.000'},
      {'name': 'Produk C', 'quantity': '3', 'price': 'Rp 30.000'},
    ];

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: products.map((product) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(product['name']!),
                  Text('Qty: ${product['quantity']}'),
                  Text(product['price']!),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Total Harga dan Status Pembayaran
  Widget _buildTotalAndStatus() {
    double total = 50.000 * 2 + 100.000 * 1 + 30.000 * 3;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal'),
                Text('Rp 210.000', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Diskon'),
                Text('Rp 10.000', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total'),
                Text(
                  'Rp ${total - 10.000}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Tombol untuk Melakukan Aksi lebih lanjut (Misalnya kembali ke beranda atau cetak)
  Widget _buildActionButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          // Tindakan pada tombol, seperti kembali ke beranda atau cetak
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaksi telah selesai')),
          );
        },
        icon: const Icon(Icons.print),
        label: const Text('Cetak Struk'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
    );
  }
}
