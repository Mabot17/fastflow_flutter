import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/master_produk_global_controller.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../home/controllers/home_controller.dart';


class MasterProdukGlobalView extends StatefulWidget {
  @override
  _MasterProdukGlobalViewState createState() => _MasterProdukGlobalViewState();
}

class _MasterProdukGlobalViewState extends State<MasterProdukGlobalView> {
  final MasterProdukGlobalController _controller = Get.put(MasterProdukGlobalController());
  final HomeController _home_controller = Get.find<HomeController>();
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
                        key: ValueKey(_controller.products.length), 
                        controller: _scrollController,
                        itemCount: _controller.products.length + (_controller.isLastPage.value ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index == _controller.products.length) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
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
      floatingActionButton: Obx(() {
        int itemCount = _home_controller.keranjangCount;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            FloatingActionButton(
              backgroundColor: const Color(0xFF1A237E),
              onPressed: () => _home_controller.handleMenuTap({'route': '/pos'}),
              tooltip: "Lihat Keranjang",
              child: const Icon(Icons.shopping_cart, color: Colors.white), // icon putih
            ),
            if (itemCount > 0)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Center(
                    child: Text(
                      itemCount > 99 ? '99+' : itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}

class ProductListItem extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductListItem({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductListItem> createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  final HomeController _homeController = Get.find<HomeController>();
  final RxInt qty = 1.obs; // Ubah ke RxInt

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
          onTap: () {
            qty.value = 1; // Reset qty
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text(widget.product["productName"] ?? "Nama Tidak Tersedia"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                        widget.product["image"] ?? "",
                        height: 100,
                        errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported, size: 100),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Harga: Rp ${widget.product["finalPrice"] ?? 0}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (qty.value > 1) {
                                qty.value--;
                                _homeController.updateQtyInCart(widget.product["productId"].toString(), qty.value);
                              }
                            },
                          ),
                          Text(qty.value.toString(), style: TextStyle(fontSize: 18)),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () {
                              qty.value++;
                              _homeController.updateQtyInCart(widget.product["productId"].toString(), qty.value);
                            },
                          ),
                        ],
                      )),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Batal"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _homeController.addToCart(widget.product, qty.value);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "${widget.product["productName"]} ditambahkan ke keranjang (${qty.value})"),
                          ),
                        );
                      },
                      child: Text("Tambah ke Keranjang"),
                    ),
                  ],
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Hero(
                    tag: 'product-image-${widget.product["productId"]}',
                    child: Image.network(
                      widget.product["image"] ?? "",
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
                        widget.product["productName"] ?? "Nama Tidak Tersedia",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF7C4DFF),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rp ${widget.product["finalPrice"] ?? 0}",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Stok: ${widget.product["stock"] ?? 0}",
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
