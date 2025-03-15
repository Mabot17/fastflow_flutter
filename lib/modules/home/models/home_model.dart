import 'package:flutter/material.dart';

class HomeModel {
  static IconData getIconData(String iconName) {
    switch (iconName) {
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'straighten':
        return Icons.straighten;
      case 'category':
        return Icons.category;
      case 'person':
        return Icons.person;
      case 'receipt_long':
        return Icons.receipt_long;
      case 'point_of_sale':
        return Icons.point_of_sale;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'assessment':
        return Icons.assessment;
      case 'bar_chart':
        return Icons.bar_chart;
      case 'show_chart':
        return Icons.show_chart;
      default:
        return Icons.help_outline;
    }
  }
}
