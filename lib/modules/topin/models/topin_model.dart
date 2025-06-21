import 'package:flutter/material.dart';

class MenuItemModel {
  final String title;
  final String keyword;
  final IconData icon;

  MenuItemModel({required this.title, required this.keyword, required this.icon});
}

class MenuGroupModel {
  final String groupTitle;
  final List<MenuItemModel> items;

  MenuGroupModel({required this.groupTitle, required this.items});
}