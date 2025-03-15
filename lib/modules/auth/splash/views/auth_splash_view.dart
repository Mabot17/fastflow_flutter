import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_splash_controller.dart';

class SplashView extends StatelessWidget {
  final SplashController splashController = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
