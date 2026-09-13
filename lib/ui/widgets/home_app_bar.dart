import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final firstName = user?.displayName?.split(' ').first ?? 'Chef';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Warm-palette greeting and title colors
    final greetingColor = isDark ? kDarkTextSecondary : kTextSecondary;
    final titleColor    = isDark ? kDarkTextPrimary   : kTextPrimary;
    // Warm tinted avatar background
    final avatarBg = isDark
        ? kPrimaryColor.withValues(alpha: 0.18)
        : const Color(0xFFFFF0E8);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $firstName 👋',
                style: TextStyle(
                  fontSize: 14,
                  color: greetingColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "What are you\ncooking today?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  color: titleColor,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        // User avatar
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: avatarBg,
            border: Border.all(
              color: kPrimaryColor.withValues(alpha: 0.35),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: kPrimaryColor.withValues(alpha: isDark ? 0.15 : 0.10),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: user?.photoURL != null
              ? ClipOval(
                  child: Image.network(
                    user!.photoURL!,
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Icon(
                    Iconsax.user,
                    size: 20,
                    color: kPrimaryColor,
                  ),
                ),
        ),
      ],
    );
  }
}
