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
                decoration: const BoxDecoration(color: Colors.blue),
                accountName: Text(
                  controller.username.value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                accountEmail: const Text("user@example.com"), // Bisa diganti dinamis juga
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://media-cgk1-2.cdn.whatsapp.net/v/t61.24694-24/424444826_949488943434172_7615880461474394281_n.jpg?ccb=11-4&oh=01_Q5Aa1QGecpR-ahJIPLkou73uhQP9pDjRt6h3flgCZCVBR9eEOw&oe=6825C4A4&_nc_sid=5e03e0&_nc_cat=106', // Ganti dengan avatar dinamis kalau perlu
                  ),
                ),
              )),
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Profil'),
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('Pengaturan'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              // Menampilkan dialog konfirmasi
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Konfirmasi Logout'),
                    content: const Text('Apakah Anda yakin ingin logout?'),
                    actions: <Widget>[
                      // Tombol Batal dengan rounded style
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Menutup dialog
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
                      // Tombol Logout dengan rounded style dan warna yang menonjol
                      TextButton(
                        onPressed: () {
                          controller.logout(); // Memanggil logout
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.red, // Warna yang menonjol untuk logout
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
