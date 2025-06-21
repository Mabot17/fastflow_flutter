import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/topin_model.dart';
import '../controllers/topin_controller.dart';
import 'topin_detail_item_view.dart';

class DetailProdukPage extends StatefulWidget {
  final MenuItemModel item;

  const DetailProdukPage({Key? key, required this.item}) : super(key: key);

  @override
  State<DetailProdukPage> createState() => _DetailProdukPageState();
}

class _DetailProdukPageState extends State<DetailProdukPage> {
  final TopinController controller = Get.put(TopinController());

  @override
  void initState() {
    super.initState();
    controller.groupItems.clear(); // 🧹 reset/bersihkan terlebih dahulu
    controller.loadGroupProduk(widget.item.keyword); // lalu muat ulang
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          widget.item.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Color(0xFF00695C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.groupItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                  strokeWidth: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  'Memuat data...',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.groupItems.length,
          itemBuilder: (context, index) {
            final group = controller.groupItems[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => Get.to(() => DetailSubProdukPage(item: group)),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // Icon Container
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.teal.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            group.icon,
                            size: 28,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                group.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                group.keyword,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Arrow Icon
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}