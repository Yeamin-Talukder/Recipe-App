import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants.dart';

class MySearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const MySearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? kDarkSurface : Colors.white;
    final iconColor = isDark ? kDarkTextLight : Colors.grey;
    final hintColor = isDark ? kDarkTextLight : Colors.grey;
    final textColor = theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: textColor, fontSize: 15),
        decoration: InputDecoration(
          icon: Icon(Iconsax.search_normal, color: iconColor),
          hintText: "Search any recipes",
          hintStyle: TextStyle(color: hintColor),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
