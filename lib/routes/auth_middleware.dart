import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';


class AuthMiddleware extends GetMiddleware {
  final GetStorage storage = GetStorage();
  final Dio dio = Dio();

  @override
  RouteSettings? redirect(String? route) {
    String? token = storage.read('access_token');
    if (token != null && route == '/login') {
      return const RouteSettings(name: '/home'); // Redirect jika sudah login
    }
    return token == null ? const RouteSettings(name: '/login') : null;
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await dio.post(
        'https://erp-api.koffiesoft.com/login',
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
          'grant_type': '',
          'username': username,
          'password': password,
          'scope': '',
          'client_id': '',
          'client_secret': '',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status']['code'] == 200) {
          storage.write('access_token', data['access_token']);
          storage.write('user_data', data['data']); // Simpan info user
          return true;
        }
      }
      return false;
    } catch (e) {
      print("⚠ Error login: $e");
      return false;
    }
  }

  void logout() {
    storage.remove('access_token');
    storage.remove('user_data');
    Get.offAllNamed('/login'); // Redirect ke login setelah logout
  }
}
