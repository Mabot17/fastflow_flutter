import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/login/controllers/auth_login_controller.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/transaction'); // Pindah ke TransactionView
              },
              child: Text("Go to Transaction"),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                authController.logout();
              },
              child: Text("Logout"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
