import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback pressed;
  final Color? iconColor;
  final double size;

  const MyIconButton({
    super.key,
    required this.icon,
    required this.pressed,
    this.iconColor,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1D2E) : Colors.white;
    final defaultIconColor = isDark ? const Color(0xFFF0F2FA) : Colors.black;

    return IconButton(
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: bgColor,
        fixedSize: const Size(50, 50),
        elevation: 2,
        shadowColor: Colors.black.withAlpha(isDark ? 60 : 20),
      ),
      onPressed: pressed,
      icon: Icon(
        icon,
        size: size,
        color: iconColor ?? defaultIconColor,
      ),
    );
  }
}
