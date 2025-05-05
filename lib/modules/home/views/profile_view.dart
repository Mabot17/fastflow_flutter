import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Section
            Center(
              child: ClipOval(
                child: Image.network(
                  'https://media-cgk1-2.cdn.whatsapp.net/v/t61.24694-24/424444826_949488943434172_7615880461474394281_n.jpg?ccb=11-4&oh=01_Q5Aa1QGecpR-ahJIPLkou73uhQP9pDjRt6h3flgCZCVBR9eEOw&oe=6825C4A4&_nc_sid=5e03e0&_nc_cat=106',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // User Info Section
            const Text(
              'Nama Pengguna',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'username@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),

            // Menu Section
            const Text(
              'Pengaturan Akun',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        onTap: () {
          // Tindakan saat menu ditekan
        },
      ),
    );
  }
}
