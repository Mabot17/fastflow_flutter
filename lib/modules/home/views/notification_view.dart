import 'package:flutter/material.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Ada dua tab: Semua dan Belum Dibaca
      child: Scaffold(
        body: Column(
          children: [
            const TabBar(
              labelColor: Color(0xFF7C4DFF),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF7C4DFF),
              tabs: [
                Tab(text: "Semua Notifikasi"),
                Tab(text: "Belum Dibaca"),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  NotificationTabView(isRead: true),
                  NotificationTabView(isRead: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationTabView extends StatelessWidget {
  final bool isRead;

  const NotificationTabView({super.key, required this.isRead});

  @override
  Widget build(BuildContext context) {
    List<NotificationItem> notifications = [
      NotificationItem(title: 'Pembayaran berhasil', description: 'Transaksi Anda telah berhasil diproses.', date: '2025-05-01 10:30', isRead: true),
      NotificationItem(title: 'Diskon 50% untuk produk baru!', description: 'Dapatkan diskon besar untuk produk baru kami.', date: '2025-05-03 09:15', isRead: false),
      NotificationItem(title: 'Pemberitahuan pengiriman', description: 'Pesanan Anda sedang dalam proses pengiriman.', date: '2025-04-30 14:00', isRead: true),
      NotificationItem(title: 'Promo Hari Ini', description: 'Jangan lewatkan promo khusus hari ini!', date: '2025-05-04 08:00', isRead: false),
    ];

    List<NotificationItem> filteredNotifications = notifications.where((item) => item.isRead == isRead).toList();

    return ListView.builder(
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 5,
      color: notification.isRead ? Colors.white : const Color(0xFFF3EFFF), // Soft purple background
      child: ListTile(
        leading: Icon(
          notification.isRead ? Icons.notifications_none : Icons.notifications_active,
          color: notification.isRead ? Colors.grey : const Color(0xFF7C4DFF),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
            color: notification.isRead ? Colors.black : const Color(0xFF7C4DFF),
          ),
        ),
        subtitle: Text(
          notification.description,
          style: TextStyle(
            fontSize: 12,
            color: notification.isRead ? Colors.grey : Colors.black,
          ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              notification.date,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
            if (!notification.isRead) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Color(0xFF7C4DFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Baru',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ],
          ],
        ),
        onTap: () {
          // Tindakan saat notifikasi ditekan
        },
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String description;
  final String date;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.description,
    required this.date,
    required this.isRead,
  });
}
