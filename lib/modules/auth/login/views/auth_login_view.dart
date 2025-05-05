import 'package:flutter/material.dart';
import '../controllers/auth_login_controller.dart';

class LoginView extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController controller = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background warna putih agar bersih
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo atau gambar header (opsional)
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://fastflow.pybot.cloud/static/fastflow.png'), // Ganti dengan logo
              ),
              const SizedBox(height: 30),
              
              // Username Field
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  labelStyle: const TextStyle(color: Color(0xFF7C4DFF)),
                  border: OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person, color: Color(0xFF7C4DFF)),
                ),
              ),
              const SizedBox(height: 16),
              
              // Password Field
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Color(0xFF7C4DFF)),
                  border: OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF7C4DFF)),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              
              // Login Button
              ElevatedButton(
                onPressed: () {
                  controller.login(
                    usernameController.text.trim(),
                    passwordController.text.trim(),
                  );
                },
                child: const Text("Login", style: TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF7C4DFF), // Warna tombol ungu terang
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Tombol melengkung
                  ),
                ),
              ),
              
              // Option for forgot password or create account
              TextButton(
                onPressed: () {
                  // TODO: Redirect to forgot password or sign up page
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Color(0xFF7C4DFF)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
