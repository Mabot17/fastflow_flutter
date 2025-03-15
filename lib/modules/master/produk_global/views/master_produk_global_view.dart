import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/master_produk_global_controller.dart';
import '../../../../widgets/custom_app_bar.dart';

class MasterProdukGlobalView extends StatefulWidget {
  @override
  _MasterProdukGlobalViewState createState() => _MasterProdukGlobalViewState();
}

class _MasterProdukGlobalViewState extends State<MasterProdukGlobalView> {
  final MasterProdukGlobalController _controller = Get.put(MasterProdukGlobalController());
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.fetchProducts(isInitialLoad: true);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      _controller.fetchProducts();
    }
  }

  void _onSearchChanged(String value) {
    if (value.length > 3) {
      _controller.fetchProducts(isInitialLoad: true, keywords: value);
    } else if (value.isEmpty) {
      _controller.fetchProducts(isInitialLoad: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Master Produk Global"),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Cari Produk",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value && _controller.products.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: _controller.products.length + 1,
                itemBuilder: (context, index) {
                  if (index == _controller.products.length) {
                    return _controller.isLastPage.value
                        ? SizedBox.shrink()
                        : Center(child: CircularProgressIndicator());
                  }

                  var product = _controller.products[index];
                  return ProductListItem(product: product);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}

class ProductListItem extends StatelessWidget {
  final Map<String, dynamic> product;
  final MasterProdukGlobalController _controller = Get.put(MasterProdukGlobalController());

  ProductListItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: () => _controller.goToDetailProduct(product["productId"]),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product["image"],
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 60),
          ),
        ),
        title: Text(
          product["productName"] ?? "Nama Tidak Tersedia",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rp ${product["finalPrice"] ?? 0}",
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            Text(
              "Stok: ${product["stock"] ?? 0}",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}