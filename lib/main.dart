import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // tambahkan ini

import 'app.dart';
import 'routes/app_routes_constant.dart';
import 'modules/auth/login/controllers/auth_login_controller.dart';
import 'core/services/storage_service.dart'; // Storage service

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();

  // Inisialisasi global controller
  Get.put(AuthController());

  // Menunggu hingga token dibaca dari storage
  final storageService = StorageService();
  final String? token = await storageService.read<String>('access_token');
  final bool isValidToken = token != null;

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => child!,
      child: MyApp(
        initialRoute: isValidToken
            ? AppRoutesConstants.home
            : AppRoutesConstants.login,
      ),
    ),
  );
}

