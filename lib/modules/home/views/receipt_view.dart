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
            _buildReceiptHeader(),
            const SizedBox(height: 20),
            _buildProductDetails(),
            const SizedBox(height: 20),
            _buildTotalAndStatus(),
            const SizedBox(height: 20),
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EFFF), // Latar belakang ungu muda
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'No. Transaksi: #123456789',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7C4DFF),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tanggal: 2025-05-05',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Status: Berhasil',
            style: TextStyle(fontSize: 14, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails() {
    List<Map<String, String>> products = [
      {'name': 'Produk A', 'quantity': '2', 'price': 'Rp 50.000'},
      {'name': 'Produk B', 'quantity': '1', 'price': 'Rp 100.000'},
      {'name': 'Produk C', 'quantity': '3', 'price': 'Rp 30.000'},
    ];

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: const Color(0xFFF8F4FF),
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

  Widget _buildTotalAndStatus() {
    double total = 50000 * 2 + 100000 * 1 + 30000 * 3; // Fix angka titik jadi koma

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: const Color(0xFFF3EFFF),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Subtotal'),
                Text('Rp 290.000', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Diskon'),
                Text('Rp 10.000', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Total'),
                Text(
                  'Rp 280.000',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7C4DFF),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaksi telah selesai')),
          );
        },
        icon: const Icon(Icons.print),
        label: const Text('Cetak Struk'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7C4DFF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
