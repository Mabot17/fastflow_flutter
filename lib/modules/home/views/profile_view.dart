import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Section
            Center(
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://media-cgk1-2.cdn.whatsapp.net/v/t61.24694-24/424444826_949488943434172_7615880461474394281_n.jpg?ccb=11-4&oh=01_Q5Aa1QGecpR-ahJIPLkou73uhQP9pDjRt6h3flgCZCVBR9eEOw&oe=6825C4A4&_nc_sid=5e03e0&_nc_cat=106',
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // User Info Section
            const Center(
              child: Column(
                children: [
                  Text(
                    'Nama Pengguna',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'username@example.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Menu Section
            const Text(
              'Pengaturan Akun',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            const SizedBox(height: 12),

            _buildMenuItem(Icons.edit, 'Edit Profil'),
            _buildMenuItem(Icons.lock, 'Ubah Kata Sandi'),
            _buildMenuItem(Icons.notifications, 'Pengaturan Notifikasi'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF7C4DFF)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          // TODO: Tindakan saat menu ditekan
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Colors.grey[100],
      ),
    );
  }
}
