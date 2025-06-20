import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/topin_controller.dart';
import '../models/topin_model.dart';

class TopinView extends StatelessWidget {
  final TopinController controller = Get.put(TopinController());
  final HomeController _home_controller = Get.find<HomeController>();

  Widget _buildQuickAction(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 15,
              offset: Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Saldo Akun',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 8),
                // Obx ringan untuk status verifikasi
                Icon(Icons.verified, color: Colors.green, size: 16),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Obx ringan untuk balance
                Text(
                  "Rp. 95.202",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B7F79),
                    letterSpacing: -0.5,
                  ),
                ),
                // Obx ringan untuk verify button
                ElevatedButton(
                  onPressed: () {
                    print("hallo");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1B7F79),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Verifikasi',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickAction(
                  Icons.add_rounded,
                  'Top Up',
                  Colors.green,
                  () {
                    print("hallo top up");
                  },
                ),
                _buildQuickAction(
                  Icons.arrow_upward_rounded,
                  'Transfer',
                  Colors.blue,
                  () {
                    print("hallo transfer");
                  },
                ),
                _buildQuickAction(
                  Icons.arrow_downward_rounded,
                  'Tarik Tunai',
                  Colors.orange,
                  () {
                    print("hallo tunai");
                  },
                ),
                _buildQuickAction(
                  Icons.chat_bubble_outline_rounded,
                  'Saran',
                  Colors.purple,
                  () {
                    print("hallo saran");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF1B7F79),
        title: Text('Hai, mabot'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GestureDetector(
                  onTap: () {
                    _home_controller.handleMenuTap({'route': '/laporan_penjualan'});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 16,
                          color: Colors.teal.shade800,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '1 Trx',
                          style: TextStyle(color: Colors.teal.shade800),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBalanceCard(),

            Obx(
              () => Column(
                children:
                    controller.groupedMenuList.map((group) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  group.groupTitle,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              GridView.builder(
                                padding: const EdgeInsets.all(4),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      childAspectRatio: 0.8,
                                    ),
                                itemCount: group.items.length,
                                itemBuilder: (context, index) {
                                  final item = group.items[index];
                                  return GestureDetector(
                                    onTap: () => controller.onItemTap(item),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.green.shade50,
                                          radius: 28,
                                          child: Icon(
                                            item.icon,
                                            size: 28,
                                            color: Colors.teal,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          item.title,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
