import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, isDark),
            Expanded(
              child: Consumer2<RecipeProvider, FavoriteProvider>(
                builder: (context, recipeProvider, favoriteProvider, child) {
                  final authProvider = context.read<AuthProvider>();
                  if (authProvider.isGuest) {
                    return _buildGuestPrompt(context, isDark);
                  }

                  if (recipeProvider.isLoading || favoriteProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    );
                  }

                  if (favoriteProvider.error != null) {
                    return _buildError(favoriteProvider.error!, isDark);
                  }

                  final favoriteRecipes = recipeProvider.recipes
                      .where((r) => favoriteProvider.isFavorite(r.id))
                      .toList();

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                    child: favoriteRecipes.isEmpty
                        ? _buildEmpty(context, isDark)
                        : _buildGrid(favoriteRecipes),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;
    final headerBg = isDark ? const Color(0xFF1A1D2E) : Colors.white;
    final titleColor =
        isDark ? const Color(0xFFF0F2FA) : const Color(0xFF1A1A2E);
    final subtitleColor =
        isDark ? const Color(0xFF6B7A96) : const Color(0xFF9E9E9E);
    final countBg = isDark
        ? kFavoriteColor.withValues(alpha: 0.15)
        : const Color(0xFFFFECE4);
    final avatarBg = isDark
        ? kPrimaryColor.withValues(alpha: 0.15)
        : const Color(0xFFFFF3E0);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
      color: headerBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Favourites',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (user != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          user.displayName ?? user.email ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            color: subtitleColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Avatar
              GestureDetector(
                onTap: () => _showSignOutDialog(context, isDark),
                child: Container(
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
                      : const Center(
                          child: Icon(
                            Iconsax.user,
                            size: 20,
                            color: kPrimaryColor,
                          ),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Consumer<FavoriteProvider>(
            builder: (context, fp, _) => Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: countBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Iconsax.heart5,
                      color: kFavoriteColor, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    '${fp.count} recipe${fp.count == 1 ? '' : 's'} saved',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kFavoriteColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List favoriteRecipes) {
    return GridView.builder(
      key: const ValueKey('grid'),
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.78,
      ),
      itemCount: favoriteRecipes.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          key: ValueKey(favoriteRecipes[index].id),
          tween: Tween(begin: 0.0, end: 1.0),
          duration:
              Duration(milliseconds: 250 + (index * 40).clamp(0, 400)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          ),
          child: RecipeCard(recipe: favoriteRecipes[index]),
        );
      },
    );
  }

  Widget _buildEmpty(BuildContext context, bool isDark) {
    final titleColor =
        isDark ? const Color(0xFFF0F2FA) : const Color(0xFF1A1A2E);
    final subtitleColor =
        isDark ? const Color(0xFF9AA5BB) : const Color(0xFF9E9E9E);
    final emptyBg = isDark
        ? kFavoriteColor.withValues(alpha: 0.12)
        : const Color(0xFFFFECE4);

    return Center(
      key: const ValueKey('empty'),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, v, child) =>
                  Transform.scale(scale: v, child: child),
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: emptyBg,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: kFavoriteColor.withValues(alpha: 0.12),
                      blurRadius: 24,
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Iconsax.heart,
                    size: 52,
                    color: kFavoriteColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'No Favourites Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tap the ❤️ on any recipe to\nsave it here for later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: subtitleColor,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestPrompt(BuildContext context, bool isDark) {
    final titleColor =
        isDark ? const Color(0xFFF0F2FA) : const Color(0xFF1A1A2E);
    final subtitleColor =
        isDark ? const Color(0xFF9AA5BB) : const Color(0xFF9E9E9E);
    final emptyBg = isDark
        ? kPrimaryColor.withValues(alpha: 0.12)
        : const Color(0xFFE8F5E9);

    return Center(
      key: const ValueKey('guest_prompt'),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: emptyBg,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryColor.withValues(alpha: 0.12),
                    blurRadius: 24,
                    spreadRadius: 6,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Iconsax.user,
                  size: 52,
                  color: kPrimaryColor,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Sign In to Save',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Create an account to save your\nfavorite recipes across all devices.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: subtitleColor,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.read<AuthProvider>().signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Log In / Sign Up',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String error, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline,
              color: Color(0xFFE53935), size: 48),
          const SizedBox(height: 16),
          Text(
            error,
            style: const TextStyle(
              color: Color(0xFFE53935),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, bool isDark) {
    final dialogBg = isDark ? const Color(0xFF1A1D2E) : Colors.white;
    final titleColor =
        isDark ? const Color(0xFFF0F2FA) : const Color(0xFF1A1A2E);
    final cancelBg =
        isDark ? const Color(0xFF252838) : const Color(0xFFF3F4F6);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Sign Out',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 260),
      transitionBuilder: (ctx, anim, _, child) => FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.88, end: 1.0).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOutBack)),
          child: child,
        ),
      ),
      pageBuilder: (ctx, _, __) => Center(
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
                      color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.logout_rounded,
                        color: Color(0xFFEF4444), size: 28),
                  ),
                  const SizedBox(height: 16),
                  Text('Sign Out?',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: titleColor)),
                  const SizedBox(height: 8),
                  Text(
                    'You\'ll be returned to the sign-in screen.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? const Color(0xFF9AA5BB)
                            : kTextSecondary,
                        height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                                color: cancelBg,
                                borderRadius: BorderRadius.circular(14)),
                            alignment: Alignment.center,
                            child: Text('Cancel',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: titleColor)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(ctx);
                            context.read<AuthProvider>().signOut();
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              borderRadius: BorderRadius.circular(14),
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
                            child: const Text('Sign Out',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Colors.white)),
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
      ),
    );
  }
}
