import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'routes/app_routes.dart';
import 'modules/auth/login/controllers/auth_login_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Inisialisasi GetStorage sebelum aplikasi dimulai

  // Hindari duplikasi registrasi AuthController
  if (!Get.isRegistered<AuthController>()) {
    Get.put(AuthController());
  }

  runApp(const MyApp()); // Gunakan const jika tidak ada perubahan internal
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Tambahkan super.key untuk optimalisasi

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FastFlow App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/splash', // Sesuaikan dengan pendekatan baru
      getPages: AppRoutes.routes, // Menggunakan pendekatan modular
    );
  }
}
