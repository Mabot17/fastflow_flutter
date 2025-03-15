import 'package:flutter/material.dart';
import '../../../widgets/custom_app_bar.dart';

class MaintenancePageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Maintenance"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.build, size: 100, color: Colors.blueGrey),
            SizedBox(height: 16),
            Text(
              "Sistem sedang dalam perbaikan,\nsilakan kembali nanti.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotFoundPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Halaman Tidak Ditemukan")),
      body: Center(child: Text("Oops! Halaman yang Anda cari tidak tersedia.")),
    );
  }
}
