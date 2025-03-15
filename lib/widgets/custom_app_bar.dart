import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic title; // 🔥 Bisa String atau Widget
  final double? elevation;
  final Color backgroundColor;
  final Widget? leading;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.title, // ✅ Bisa String atau Widget
    this.backgroundColor = Colors.blue,
    this.leading,
    this.actions,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title is String
          ? Text(title, style: const TextStyle(color: Colors.white)) // ✅ Jika String, bungkus dengan Text
          : title as Widget, // ✅ Jika Widget, langsung gunakan
      centerTitle: true,
      backgroundColor: backgroundColor,
      elevation: elevation ?? 0.0,
      leading: leading,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
