import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'app.dart';
import 'routes/app_routes_constant.dart';
import 'modules/auth/login/controllers/auth_login_controller.dart';
import 'modules/transaksi/pos/controllers/transaksi_pos_controller.dart';
import 'core/services/storage_service.dart';
import 'core/database/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();

  final storageService = StorageService();
  final dbHelper = DatabaseHelper();

  // Tentukan path database
  final docsDir = await getApplicationDocumentsDirectory();
  final dbPath = join(docsDir.path, 'fastflow_pos.db');

  // Simpan path ke storage jika belum ada
  final savedPath = await storageService.read('offline_db_path');
  if (savedPath == null) {
    await storageService.write('offline_db_path', dbPath);
  }

  // Inisialisasi database dan buat tabel-tabel
  await dbHelper.openDatabaseFromPath(dbPath);
  await dbHelper.initDatabaseOffline();

  // Inisialisasi global controller
  Get.put(AuthController());
  Get.put(TransaksiPosController());

  // Menentukan initial route
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
