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
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Cari Produk...",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                filled: true,
                fillColor: Colors.grey.shade100,
                prefixIcon: Icon(Icons.search, color: Color(0xFF7C4DFF)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFF7C4DFF), width: 2),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: _controller.isLoading.value && _controller.products.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        key: ValueKey(_controller.products.length), // For smooth switching
                        controller: _scrollController,
                        itemCount: _controller.products.length + (_controller.isLastPage.value ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index == _controller.products.length) {
                            return Center(child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: CircularProgressIndicator(),
                            ));
                          }

                          var product = _controller.products[index];
                          return ProductListItem(product: product);
                        },
                      ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        elevation: 4,
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _controller.goToDetailProduct(product["productId"]),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Hero(
                    tag: 'product-image-${product["productId"]}',
                    child: Image.network(
                      product["image"] ?? "",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product["productName"] ?? "Nama Tidak Tersedia",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF7C4DFF),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rp ${product["finalPrice"] ?? 0}",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Stok: ${product["stock"] ?? 0}",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF7C4DFF)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
