import 'package:flutter/material.dart';
import '../models/topin_model.dart';

class DetailPage extends StatelessWidget {
  final MenuItemModel item;

  const DetailPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: Center(
        child: Text('Detail untuk: ${item.title}'),
      ),
    );
  }
}
