import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/auth_middleware.dart';

class LoginView extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthMiddleware auth = AuthMiddleware();

  void _handleLogin() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    bool success = await auth.login(username, password);
    if (success) {
      Get.offAllNamed('/home'); // Redirect ke Home jika sukses
    } else {
      Get.snackbar("Login Gagal", "Periksa kembali username/password!",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Login example
  // void _login() {
  //   String username = usernameController.text.trim();
  //   String password = passwordController.text.trim();

  //   if (username == "mabot" && password == "123456") {
  //     Get.offAllNamed('/home'); // 🔥 Menghapus history navigasi
  //   } else {
  //     Get.snackbar("Error", "Login gagal! Periksa kembali kredensial Anda.");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
