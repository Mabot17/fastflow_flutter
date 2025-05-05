import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';

// Untuk konfigurasi awal aplikasi
// Menggunakan GetX untuk state management dan routing
class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fastflow App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: initialRoute,
      getPages: AppRoutes.routes
    );
  }
}
