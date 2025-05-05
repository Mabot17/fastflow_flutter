import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Obx(() => UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF1A237E), // Deep Blue
                ),
                accountName: Text(
                  controller.username.value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                accountEmail: const Text(
                  "user@example.com",
                  style: TextStyle(color: Colors.white70),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://media-cgk1-2.cdn.whatsapp.net/v/t61.24694-24/424444826_949488943434172_7615880461474394281_n.jpg?ccb=11-4&oh=01_Q5Aa1QGecpR-ahJIPLkou73uhQP9pDjRt6h3flgCZCVBR9eEOw&oe=6825C4A4&_nc_sid=5e03e0&_nc_cat=106',
                  ),
                ),
              )),
          ListTile(
            leading: const Icon(Icons.person, color: Color(0xFF1A237E)),
            title: const Text(
              'Profil',
              style: TextStyle(color: Color(0xFF1A237E)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Color(0xFF1A237E)),
            title: const Text(
              'Pengaturan',
              style: TextStyle(color: Color(0xFF1A237E)),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: const Color(0xFFE8EAF6), // Soft background
                    title: const Text(
                      'Konfirmasi Logout',
                      style: TextStyle(color: Color(0xFF1A237E)),
                    ),
                    content: const Text(
                      'Apakah Anda yakin ingin logout?',
                      style: TextStyle(color: Color(0xFF212121)),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text('Batal', style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.logout();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text('Ya, Logout', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
