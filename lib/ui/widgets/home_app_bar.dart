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

    final greetingColor = isDark
        ? const Color(0xFF6B7A96)
        : const Color(0xFF9E9E9E);
    final titleColor = isDark
        ? const Color(0xFFF0F2FA)
        : const Color(0xFF1A1A2E);
    final avatarBg = isDark
        ? kPrimaryColor.withValues(alpha: 0.15)
        : const Color(0xFFFFF3E0);

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
                ),
              ),
            ],
          ),
        ),
        // User avatar
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: avatarBg,
            border: Border.all(
              color: kPrimaryColor.withValues(alpha: 0.3),
              width: 2,
            ),
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
