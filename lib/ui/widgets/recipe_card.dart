import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../models/recipe.dart';
import '../../providers/favorite_provider.dart';
import '../screens/recipe_details_screen.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> _heartScale;
  late AnimationController _pressController;
  late Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _heartScale = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.5)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 45),
      TweenSequenceItem(
          tween: Tween(begin: 1.5, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticIn)),
          weight: 55),
    ]).animate(_heartController);

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  Future<void> _onFavoriteTap(FavoriteProvider provider) async {
    HapticFeedback.lightImpact();
    _heartController.forward(from: 0);
    await provider.toggleFavorite(widget.recipe.id);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1A1D2E) : kCardColor;
    final textPrimary = isDark ? const Color(0xFFF0F2FA) : kTextPrimary;
    final textLight   = isDark ? const Color(0xFF5C6880) : kTextLight;
    final favUnselBg  = isDark ? const Color(0xFF252838) : Colors.white;

    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) {
        _pressController.reverse();
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 380),
            reverseTransitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) =>
                RecipeDetailsScreen(recipe: widget.recipe),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // Slide up from bottom + fade in
              final slideAnim = Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ));
              final fadeAnim = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              );
              // Fade out going back
              final exitFade = Tween<double>(
                begin: 1.0,
                end: 0.96,
              ).animate(CurvedAnimation(
                parent: secondaryAnimation,
                curve: Curves.easeIn,
              ));
              return FadeTransition(
                opacity: exitFade,
                child: FadeTransition(
                  opacity: fadeAnim,
                  child: SlideTransition(
                    position: slideAnim,
                    child: child,
                  ),
                ),
              );
            },
          ),
        );
      },
      onTapCancel: () => _pressController.reverse(),
      child: AnimatedBuilder(
        animation: _pressScale,
        builder: (context, child) =>
            Transform.scale(scale: _pressScale.value, child: child),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(kCardRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.07),
                blurRadius: 14,
                spreadRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image section ─────────────────────────────────────────
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(kCardRadius),
                        topRight: Radius.circular(kCardRadius),
                      ),
                      child: Hero(
                        tag: 'recipe-${widget.recipe.id}',
                        child: Image.network(
                          widget.recipe.image,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: isDark
                                ? const Color(0xFF252838)
                                : const Color(0xFFF0F0F0),
                            child: Icon(Icons.broken_image,
                                color: isDark ? Colors.white24 : Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    // Time chip
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Iconsax.clock,
                                color: Colors.white, size: 11),
                            const SizedBox(width: 3),
                            Text(
                              '${widget.recipe.time}m',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Favourite button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Consumer<FavoriteProvider>(
                        builder: (context, favoriteProvider, _) {
                          final isFav =
                              favoriteProvider.isFavorite(widget.recipe.id);
                          return GestureDetector(
                            onTap: () => _onFavoriteTap(favoriteProvider),
                            child: AnimatedBuilder(
                              animation: _heartScale,
                              builder: (context, child) =>
                                  Transform.scale(
                                scale: _heartScale.value,
                                child: child,
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isFav
                                      ? const Color(0xFFFFECF0)
                                      : favUnselBg,
                                  boxShadow: [
                                    BoxShadow(
                                      color: isFav
                                          ? kFavoriteColor
                                              .withValues(alpha: 0.35)
                                          : Colors.black
                                              .withValues(alpha: isDark ? 0.3 : 0.08),
                                      blurRadius: isFav ? 12 : 5,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: AnimatedSwitcher(
                                    duration:
                                        const Duration(milliseconds: 200),
                                    transitionBuilder: (child, animation) =>
                                        ScaleTransition(
                                            scale: animation, child: child),
                                    child: Icon(
                                      isFav ? Iconsax.heart5 : Iconsax.heart,
                                      key: ValueKey<bool>(isFav),
                                      color: isFav
                                          ? kFavoriteColor
                                          : textLight,
                                      size: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // ── Info section ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.recipe.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Iconsax.star5,
                            color: Color(0xFFFFA726), size: 13),
                        const SizedBox(width: 3),
                        Text(
                          '${widget.recipe.rating}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '(${widget.recipe.reviews})',
                            style:
                                TextStyle(fontSize: 11, color: textLight),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Spacer(),
                        // Calories chip
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Iconsax.flash_1,
                                color: kPrimaryColor, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              '${widget.recipe.calories}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
