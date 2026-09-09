import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final isGuest = authProvider.isGuest;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = isDark ? const Color(0xFF1E2235) : Colors.white;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                    kHorizontalPadding, 20, kHorizontalPadding, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Header ───────────────────────────────────────────
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Profile / Sign-In card ────────────────────────────
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.06),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                              parent: anim, curve: Curves.easeOutCubic)),
                          child: child,
                        ),
                      ),
                      child: isGuest
                          ? _GuestSignInCard(
                              key: const ValueKey('guest'), cardColor: cardColor, isDark: isDark)
                          : _ProfileCard(
                              key: const ValueKey('profile'),
                              user: user,
                              cardColor: cardColor,
                              isDark: isDark),
                    ),
                    const SizedBox(height: 24),

                    // ── Preferences ──────────────────────────────────────
                    _SectionLabel(label: 'Preferences', isDark: isDark),
                    const SizedBox(height: 10),
                    _PreferencesCard(cardColor: cardColor, isDark: isDark),
                    const SizedBox(height: 24),

                    // ── About ────────────────────────────────────────────
                    _SectionLabel(label: 'About', isDark: isDark),
                    const SizedBox(height: 10),
                    _AboutCard(cardColor: cardColor, isDark: isDark),
                    const SizedBox(height: 24),

                    // ── Developer ────────────────────────────────────────
                    _SectionLabel(label: 'Developer', isDark: isDark),
                    const SizedBox(height: 10),
                    _DeveloperCard(cardColor: cardColor, isDark: isDark),
                    const SizedBox(height: 24),

                    // ── Account (only for signed-in users) ──────────────
                    if (!isGuest) ...[
                      _SectionLabel(label: 'Account', isDark: isDark),
                      const SizedBox(height: 10),
                      _AccountCard(cardColor: cardColor, isDark: isDark),
                    ],
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: isDark ? const Color(0xFF6B7A96) : kTextLight,
      ),
    );
  }
}

// ─── Guest Sign-In Card ───────────────────────────────────────────────────────

class _GuestSignInCard extends StatefulWidget {
  final Color cardColor;
  final bool isDark;
  const _GuestSignInCard({super.key, required this.cardColor, required this.isDark});

  @override
  State<_GuestSignInCard> createState() => _GuestSignInCardState();
}

class _GuestSignInCardState extends State<_GuestSignInCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _shimmerAnim = CurvedAnimation(
        parent: _shimmerController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final iconBg = isDark
        ? const Color(0xFF2A2D42)
        : kPrimaryColor.withValues(alpha: 0.08);
    final subtitleColor =
        isDark ? const Color(0xFF9AA5BB) : kTextSecondary;

    return AnimatedBuilder(
      animation: _shimmerAnim,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: kPrimaryColor.withValues(
                  alpha: 0.12 + _shimmerAnim.value * 0.12),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: kPrimaryColor.withValues(
                    alpha: 0.04 + _shimmerAnim.value * 0.04),
                blurRadius: 24,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child,
        );
      },
      child: Column(
        children: [
          // Icon + title row
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: kPrimaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Browsing as Guest',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? const Color(0xFFF1F3F8)
                            : kTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Sign in to unlock all features',
                      style: TextStyle(
                          fontSize: 13, color: subtitleColor),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Feature hints
          Row(
            children: [
              _FeatureChip(
                  icon: Icons.favorite_rounded,
                  label: 'Favorites',
                  isDark: isDark),
              const SizedBox(width: 8),
              _FeatureChip(
                  icon: Icons.calendar_month_rounded,
                  label: 'Meal Plans',
                  isDark: isDark),
              const SizedBox(width: 8),
              _FeatureChip(
                  icon: Icons.sync_rounded,
                  label: 'Sync',
                  isDark: isDark),
            ],
          ),

          const SizedBox(height: 18),

          // Sign-in button
          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              return _PressableButton(
                onTap: auth.isLoading
                    ? null
                    : () {
                        HapticFeedback.mediumImpact();
                        auth.signInWithGoogle();
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: auth.isLoading
                        ? kPrimaryColor.withValues(alpha: 0.7)
                        : kPrimaryColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryColor.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: auth.isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.login_rounded,
                                color: Colors.white, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Sign In with Google',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  const _FeatureChip(
      {required this.icon, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? kPrimaryColor.withValues(alpha: 0.12)
            : kPrimaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: kPrimaryColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Profile Card ─────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final dynamic user;
  final Color cardColor;
  final bool isDark;
  const _ProfileCard(
      {super.key,
      required this.user,
      required this.cardColor,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    final subtitleColor = isDark ? const Color(0xFF9AA5BB) : kTextSecondary;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? const Color(0xFF2A2D42)
                  : kSurfaceColor,
              border: Border.all(
                  color: kPrimaryColor.withValues(alpha: 0.3), width: 2.5),
            ),
            child: user?.photoURL != null
                ? ClipOval(
                    child:
                        Image.network(user!.photoURL!, fit: BoxFit.cover))
                : const Center(
                    child: Icon(Icons.person_rounded,
                        color: kPrimaryColor, size: 28)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? 'Chef',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? const Color(0xFFF1F3F8)
                        : kTextPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  user?.email ?? '',
                  style:
                      TextStyle(fontSize: 13, color: subtitleColor),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: kSuccessColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.verified_rounded,
                          color: kSuccessColor, size: 12),
                      SizedBox(width: 4),
                      Text(
                        'Google Account',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: kSuccessColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Preferences Card ─────────────────────────────────────────────────────────

class _PreferencesCard extends StatelessWidget {
  final Color cardColor;
  final bool isDark;
  const _PreferencesCard({required this.cardColor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return _SettingsCard(
          cardColor: cardColor,
          isDark: isDark,
          children: [
            _ToggleRow(
              icon: settings.darkMode
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
              label: 'Dark Mode',
              subtitle: settings.darkMode
                  ? 'Currently using dark theme'
                  : 'Switch to a darker theme',
              value: settings.darkMode,
              onChanged: (v) {
                HapticFeedback.lightImpact();
                settings.setDarkMode(v);
              },
              isFirst: true,
              isDark: isDark,
            ),
            _RowDivider(isDark: isDark),
            _ToggleRow(
              icon: settings.notifications
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_off_outlined,
              label: 'Notifications',
              subtitle: 'Get recipe and meal reminders',
              value: settings.notifications,
              onChanged: (v) {
                HapticFeedback.lightImpact();
                settings.setNotifications(v);
              },
              isDark: isDark,
            ),
          ],
        );
      },
    );
  }
}

// ─── About Card ───────────────────────────────────────────────────────────────

class _AboutCard extends StatelessWidget {
  final Color cardColor;
  final bool isDark;
  const _AboutCard({required this.cardColor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      cardColor: cardColor,
      isDark: isDark,
      children: [
        _LinkRow(
          icon: Icons.info_outline_rounded,
          label: 'App Version',
          trailing: '1.0.0',
          isFirst: true,
          isDark: isDark,
        ),
        _RowDivider(isDark: isDark),
        _LinkRow(
          icon: Icons.shield_outlined,
          label: 'Privacy Policy',
          onTap: () {},
          isDark: isDark,
        ),
        _RowDivider(isDark: isDark),
        _LinkRow(
          icon: Icons.description_outlined,
          label: 'Terms of Service',
          onTap: () {},
          isDark: isDark,
        ),
        _RowDivider(isDark: isDark),
        _LinkRow(
          icon: Icons.star_rounded,
          label: 'Rate the App',
          onTap: () {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Thank you for your support! ⭐'),
              ),
            );
          },
          isDark: isDark,
        ),
      ],
    );
  }
}

// ─── Developer Card ───────────────────────────────────────────────────────────

class _DeveloperCard extends StatelessWidget {
  final Color cardColor;
  final bool isDark;
  const _DeveloperCard({required this.cardColor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      cardColor: cardColor,
      isDark: isDark,
      children: [
        _DeveloperRow(isFirst: true, isDark: isDark),
      ],
    );
  }
}

// ─── Account Card ────────────────────────────────────────────────────────────

class _AccountCard extends StatelessWidget {
  final Color cardColor;
  final bool isDark;
  const _AccountCard({required this.cardColor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      cardColor: cardColor,
      isDark: isDark,
      children: [
        _SignOutRow(isDark: isDark),
      ],
    );
  }
}

// ─── Shared Card Shell ────────────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final Color cardColor;
  final bool isDark;
  const _SettingsCard(
      {required this.children,
      required this.cardColor,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

// ─── Reusable Row Widgets ─────────────────────────────────────────────────────

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isFirst;
  final bool isDark;

  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isFirst = false,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? const Color(0xFFF1F3F8) : kTextPrimary;
    final subtitleColor = isDark ? const Color(0xFF9AA5BB) : kTextLight;
    final iconBg = isDark
        ? kPrimaryColor.withValues(alpha: 0.15)
        : kPrimaryColor.withValues(alpha: 0.10);

    return Padding(
      padding: EdgeInsets.fromLTRB(18, isFirst ? 14 : 10, 14, 14),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
                child: Icon(icon, color: kPrimaryColor, size: 20)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: textColor)),
                Text(subtitle,
                    style: TextStyle(fontSize: 12, color: subtitleColor)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback? onTap;
  final bool isFirst;
  final bool isDark;

  const _LinkRow({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
    this.isFirst = false,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? const Color(0xFFF1F3F8) : kTextPrimary;
    final trailColor = isDark ? const Color(0xFF6B7A96) : kTextLight;
    final iconBg = isDark
        ? kPrimaryColor.withValues(alpha: 0.15)
        : kPrimaryColor.withValues(alpha: 0.10);

    return _PressableButton(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(18, isFirst ? 14 : 10, 14, 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                  child: Icon(icon, color: kPrimaryColor, size: 20)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: textColor)),
            ),
            if (trailing != null)
              Text(trailing!,
                  style: TextStyle(
                      color: trailColor, fontWeight: FontWeight.w500))
            else if (onTap != null)
              Icon(Icons.chevron_right_rounded,
                  color: trailColor, size: 20),
          ],
        ),
      ),
    );
  }
}

class _SignOutRow extends StatelessWidget {
  final bool isDark;
  const _SignOutRow({required this.isDark});

  @override
  Widget build(BuildContext context) {
    const redColor = Color(0xFFEF4444);
    final redBg = isDark
        ? redColor.withValues(alpha: 0.15)
        : redColor.withValues(alpha: 0.10);

    return _PressableButton(
      onTap: () {
        HapticFeedback.heavyImpact();
        _showSignOutDialog(context);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: redBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.logout_rounded,
                    color: redColor, size: 20),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                'Sign Out',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: redColor,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: redColor, size: 20),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg =
        isDark ? const Color(0xFF1E2235) : Colors.white;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Sign Out',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 280),
      transitionBuilder: (ctx, anim, _, child) {
        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.88, end: 1.0).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
            ),
            child: child,
          ),
        );
      },
      pageBuilder: (ctx, _, __) {
        return Center(
          child: Material(
            color: dialogBg,
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              width: 320,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444)
                            .withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.logout_rounded,
                          color: Color(0xFFEF4444), size: 28),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sign Out?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? const Color(0xFFF1F3F8)
                            : kTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You\'ll be returned to the sign-in screen. Your data will be safe.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? const Color(0xFF9AA5BB)
                            : kTextSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _PressableButton(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.pop(ctx);
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF2A2D42)
                                    : const Color(0xFFF3F4F6),
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: isDark
                                      ? const Color(0xFFF1F3F8)
                                      : kTextPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _PressableButton(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              Navigator.pop(ctx);
                              context.read<AuthProvider>().signOut();
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                borderRadius:
                                    BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFEF4444)
                                        .withValues(alpha: 0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Sign Out',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RowDivider extends StatelessWidget {
  final bool isDark;
  const _RowDivider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 72,
      endIndent: 0,
      color: isDark
          ? Colors.white.withValues(alpha: 0.06)
          : Colors.grey.withValues(alpha: 0.10),
    );
  }
}

// ─── Developer Row ────────────────────────────────────────────────────────────

class _DeveloperRow extends StatelessWidget {
  final bool isFirst;
  final bool isDark;
  const _DeveloperRow({this.isFirst = false, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? const Color(0xFFF1F3F8) : kTextPrimary;
    final githubBg =
        isDark ? const Color(0xFF24292E) : const Color(0xFF24292E);

    return _PressableButton(
      onTap: () async {
        HapticFeedback.lightImpact();
        final url = Uri.parse('https://github.com/Yeamin-Talukder');
        try {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not open browser')),
            );
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(18, isFirst ? 14 : 10, 14, 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF24292E).withValues(alpha: 0.6)
                    : const Color(0xFF24292E).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.code_rounded,
                  color: isDark ? Colors.white70 : const Color(0xFF24292E),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MD YEAMIN TALUKDER',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'github.com/Yeamin-Talukder',
                    style: TextStyle(
                      fontSize: 12,
                      color: kPrimaryColor.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: githubBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.open_in_new_rounded,
                      color: Colors.white, size: 12),
                  SizedBox(width: 4),
                  Text(
                    'GitHub',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Pressable Button (scale on tap) ─────────────────────────────────────────

class _PressableButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _PressableButton({required this.child, this.onTap});

  @override
  State<_PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<_PressableButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:
          widget.onTap != null ? (_) => _ctrl.forward() : null,
      onTapUp: widget.onTap != null
          ? (_) async {
              await _ctrl.reverse();
              widget.onTap?.call();
            }
          : null,
      onTapCancel: widget.onTap != null ? () => _ctrl.reverse() : null,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: widget.child,
      ),
    );
  }
}
