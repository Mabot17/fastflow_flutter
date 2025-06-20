import 'package:flutter/material.dart';

class MenuItemModel {
  final String title;
  final IconData icon;

  MenuItemModel({required this.title, required this.icon});
}

class MenuGroupModel {
  final String groupTitle;
  final List<MenuItemModel> items;

  MenuGroupModel({required this.groupTitle, required this.items});
}