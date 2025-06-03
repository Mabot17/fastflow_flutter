import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/master_produk_global_controller.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../transaksi/pos/controllers/transaksi_pos_controller.dart';
import '../../../home/controllers/home_controller.dart';
import '../../../../routes/app_routes_constant.dart';


class MasterProdukGlobalView extends StatefulWidget {
  @override
  _MasterProdukGlobalViewState createState() => _MasterProdukGlobalViewState();
}

class _MasterProdukGlobalViewState extends State<MasterProdukGlobalView> {
  final HomeController _home_controller = Get.find<HomeController>();
  final MasterProdukGlobalController _controller = Get.put(MasterProdukGlobalController());
  final TransaksiPosController _pos_controller = Get.find<TransaksiPosController>();
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
    if (value.length >= 3 || value.isEmpty) {
       _controller.fetchProducts(isInitialLoad: true, keywords: value);
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
              if (_controller.isLoading.value && _controller.products.isEmpty) {
                 return Center(child: CircularProgressIndicator(color: Color(0xFF7C4DFF)));
              }
              if (!_controller.isLoading.value && _searchController.text.isNotEmpty && _controller.products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 60, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Produk tidak ditemukan',
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                    ],
                  )
                );
              }

              return AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: ListView.builder(
                        key: ValueKey(_controller.products.length + (_searchController.text.isNotEmpty ? _searchController.text.hashCode : 0)),
                        controller: _scrollController,
                        itemCount: _controller.products.length + (_controller.isLoading.value && !_controller.isLastPage.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _controller.products.length) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CircularProgressIndicator(color: Color(0xFF7C4DFF)),
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
      floatingActionButton: Padding(
        // Symmetrical horizontal padding, and bottom padding
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), // Adjusted padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'addProductFab',
              backgroundColor: Color(0xFF7C4DFF),
              onPressed: () {
                Get.toNamed(AppRoutesConstants.produkGlobalAdd);
              },
              tooltip: "Tambah Produk Baru",
              child: const Icon(Icons.add, color: Colors.white),
            ),
            Obx(() {
              int itemCount = _pos_controller.keranjangCount;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  FloatingActionButton(
                    heroTag: 'cartFab',
                    backgroundColor: const Color(0xFF1A237E),
                    onPressed: () => _home_controller.handleMenuTap({'route': '/pos'}),
                    tooltip: "Lihat Keranjang",
                    child: const Icon(Icons.shopping_cart, color: Colors.white),
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
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Using centerFloat for better Row behavior
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}

// ProductListItem remains the same
class ProductListItem extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductListItem({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductListItem> createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  final TransaksiPosController _pos_controller = Get.find<TransaksiPosController>();
  final MasterProdukGlobalController _masterProdukController = Get.find<MasterProdukGlobalController>();
  final RxInt qty = 1.obs;

  @override
  Widget build(BuildContext context) {
    final String productIdStr = widget.product["productId"].toString();
    final cartItem = _pos_controller.cartItems[productIdStr];
    if (cartItem != null) {
        qty.value = cartItem["qty"];
    } else {
        qty.value = 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        elevation: 3,
        color: Colors.white,
        shadowColor: Colors.deepPurple.withOpacity(0.1),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            final String currentProductIdStr = widget.product["productId"].toString();
            final currentCartItem = _pos_controller.cartItems[currentProductIdStr];
            if (currentCartItem != null) {
                qty.value = currentCartItem["qty"];
            } else {
                qty.value = 1;
            }
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  titlePadding: EdgeInsets.zero,
                  title: Column(
                    children: [
                       ClipRRect(
                         borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                         child: Image.network(
                          widget.product["image"] ?? "",
                          height: 120,
                          width: double.maxFinite,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 120,
                            width: double.maxFinite,
                            color: Colors.grey[200],
                            child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey[400]),
                          ),
                                           ),
                       ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: Text(widget.product["productName"] ?? "Nama Tidak Tersedia", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Harga: Rp ${widget.product["finalPrice"] ?? 0}",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green[700]),
                      ),
                      const SizedBox(height: 16),
                      Text("Jumlah:", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                      Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 28),
                            onPressed: () {
                              if (qty.value > 1) {
                                qty.value--;
                              }
                            },
                          ),
                          Container(
                            width: 40,
                            alignment: Alignment.center,
                            child: Text(qty.value.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline, color: Colors.green, size: 28),
                            onPressed: () {
                              qty.value++;
                            },
                          ),
                        ],
                      )),
                    ],
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actionsPadding: EdgeInsets.fromLTRB(16,0,16,16),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Batal", style: TextStyle(color: Colors.grey[700])),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add_shopping_cart, color: Colors.white, size: 18),
                      label: Text("Tambah", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        _pos_controller.addToCart(widget.product, qty.value);
                        Navigator.pop(context);
                        Get.snackbar(
                          "Keranjang Diperbarui",
                          "${widget.product["productName"]} (${qty.value}x) ditambahkan/diperbarui.",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Color(0xFF7C4DFF),
                          colorText: Colors.white,
                          margin: EdgeInsets.all(10),
                          borderRadius: 8,
                          icon: Icon(Icons.check_circle_outline, color: Colors.white),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF7C4DFF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    ),
                  ],
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Hero(
                    tag: 'product-image-${widget.product["productId"]}',
                    child: Image.network(
                      widget.product["image"] ?? "",
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(width: 70, height: 70, color: Colors.grey[200], child: Icon(Icons.image_not_supported, size: 30, color: Colors.grey[400])),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product["productName"] ?? "Nama Tidak Tersedia",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rp ${widget.product["finalPrice"] ?? 0}",
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Stok: ${widget.product["stock"] ?? 0} ${widget.product["unitName"] ?? ''}",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Icon(Icons.add_shopping_cart, size: 24, color: Color(0xFF7C4DFF)),
                     SizedBox(height: 4),
                     Text("Tambah", style: TextStyle(color: Color(0xFF7C4DFF), fontSize: 10))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}