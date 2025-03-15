import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';
import 'routes/app_routes_constant.dart'; // Import konstanta

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FastFlow App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutesConstants.splash, // Sesuaikan dengan pendekatan baru
      getPages: AppRoutes.routes, // Gunakan pendekatan modular baru
    );
  }
}
