import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../models/review.dart';
import '../../providers/auth_provider.dart';
import '../../providers/review_provider.dart';
import 'review_card.dart';
import 'review_input_sheet.dart';

/// The full review section embedded in the recipe details screen.
/// Shows a rating summary bar, a "Write a Review" CTA, and the review list.
class ReviewSection extends StatelessWidget {
  final String recipeId;

  const ReviewSection({super.key, required this.recipeId});

  void _openSheet(BuildContext context, {Review? existing}) {
    HapticFeedback.mediumImpact();
    final auth = context.read<AuthProvider>();
    if (auth.isGuest || !auth.isSignedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Sign in to write a review'),
          action: SnackBarAction(label: 'OK', onPressed: () {}),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<ReviewProvider>(),
        child: ReviewInputSheet(
          recipeId: recipeId,
          userId: auth.user!.uid,
          existingReview: existing,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, Review review) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? kDarkCard : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Review',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to delete your review?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: kPrimaryColor)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete',
                style: TextStyle(color: Color(0xFFE53935))),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await context.read<ReviewProvider>().deleteReview(
            recipeId: recipeId,
            review: review,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? kDarkTextPrimary : kTextPrimary;
    final textSec = isDark ? kDarkTextSecondary : kTextSecondary;

    return Consumer2<ReviewProvider, AuthProvider>(
      builder: (context, reviewProvider, authProvider, _) {
        final reviews = reviewProvider.reviews;
        final userId = authProvider.user?.uid ?? '';
        final myReview = reviewProvider.myReview(userId);
        final isSignedIn = authProvider.isSignedIn;
        final breakdown = reviewProvider.ratingBreakdown;
        final avg = reviewProvider.averageRating;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section header ─────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                Text(
                  '${reviews.length} ${reviews.length == 1 ? 'review' : 'reviews'}',
                  style: TextStyle(fontSize: 13, color: textSec),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Rating summary ─────────────────────────────────────────────
            if (reviews.isNotEmpty) ...[
              _RatingSummary(
                average: avg,
                total: reviews.length,
                breakdown: breakdown,
                isDark: isDark,
                textPrimary: textPrimary,
                textSec: textSec,
              ),
              const SizedBox(height: 20),
            ],

            // ── Write / Edit CTA ───────────────────────────────────────────
            _WriteReviewButton(
              isSignedIn: isSignedIn,
              isGuest: authProvider.isGuest,
              hasReview: myReview != null,
              onTap: () => _openSheet(context, existing: myReview),
              isDark: isDark,
            ),
            const SizedBox(height: 20),

            // ── Loading ────────────────────────────────────────────────────
            if (reviewProvider.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(color: kPrimaryColor),
                ),
              )

            // ── Empty ──────────────────────────────────────────────────────
            else if (reviews.isEmpty)
              _EmptyReviews(isDark: isDark, textSec: textSec)

            // ── Review list ────────────────────────────────────────────────
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: reviews.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  final isOwn = review.userId == userId;
                  return AnimatedReviewCard(
                    key: ValueKey(review.id),
                    review: review,
                    isOwn: isOwn,
                    onEdit: () => _openSheet(context, existing: review),
                    onDelete: () => _confirmDelete(context, review),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

// ─── Rating summary bar chart ──────────────────────────────────────────────
class _RatingSummary extends StatelessWidget {
  final double average;
  final int total;
  final Map<int, int> breakdown;
  final bool isDark;
  final Color textPrimary;
  final Color textSec;

  const _RatingSummary({
    required this.average,
    required this.total,
    required this.breakdown,
    required this.isDark,
    required this.textPrimary,
    required this.textSec,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? kDarkCard : const Color(0xFFFAF8F5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? kDarkDivider : const Color(0xFFEDE8E3),
        ),
      ),
      child: Row(
        children: [
          // Big number
          Column(
            children: [
              Text(
                average.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: textPrimary,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              _StarRowDisplay(rating: average),
              const SizedBox(height: 4),
              Text(
                '$total ${total == 1 ? 'review' : 'reviews'}',
                style: TextStyle(fontSize: 11, color: textSec),
              ),
            ],
          ),
          const SizedBox(width: 20),

          // Bar chart (5→1 star)
          Expanded(
            child: Column(
              children: List.generate(5, (i) {
                final star = 5 - i;
                final count = breakdown[star] ?? 0;
                final frac = total > 0 ? count / total : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Text(
                        '$star',
                        style: TextStyle(fontSize: 11, color: textSec),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Iconsax.star5, size: 10, color: kStarColor),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: frac,
                            minHeight: 7,
                            backgroundColor: isDark
                                ? kDarkDivider
                                : Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                kPrimaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      SizedBox(
                        width: 20,
                        child: Text(
                          '$count',
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 10, color: textSec),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRowDisplay extends StatelessWidget {
  final double rating;
  const _StarRowDisplay({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < rating.floor() ? Iconsax.star5 : Iconsax.star,
          color: i < rating ? kStarColor : Colors.grey.shade400,
          size: 13,
        );
      }),
    );
  }
}

// ─── Write review button ────────────────────────────────────────────────────
class _WriteReviewButton extends StatelessWidget {
  final bool isSignedIn;
  final bool isGuest;
  final bool hasReview;
  final VoidCallback onTap;
  final bool isDark;

  const _WriteReviewButton({
    required this.isSignedIn,
    required this.isGuest,
    required this.hasReview,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final label = !isSignedIn || isGuest
        ? 'Sign in to Write a Review'
        : hasReview
            ? '✏️  Edit Your Review'
            : '⭐  Write a Review';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kPrimaryColor,
              kGradientEnd,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Empty state ────────────────────────────────────────────────────────────
class _EmptyReviews extends StatelessWidget {
  final bool isDark;
  final Color textSec;

  const _EmptyReviews({required this.isDark, required this.textSec});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: isDark ? kDarkCard : const Color(0xFFFAF8F5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            Iconsax.message,
            size: 44,
            color: isDark ? kDarkTextLight : Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            'No reviews yet',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: textSec,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Be the first to share your experience!',
            style: TextStyle(fontSize: 12, color: textSec),
          ),
        ],
      ),
    );
  }
}

// ─── Animated review card wrapper ─────────────────────────────────────────
class AnimatedReviewCard extends StatefulWidget {
  final Review review;
  final bool isOwn;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AnimatedReviewCard({
    super.key,
    required this.review,
    required this.isOwn,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<AnimatedReviewCard> createState() => _AnimatedReviewCardState();
}

class _AnimatedReviewCardState extends State<AnimatedReviewCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ReviewCard(
          review: widget.review,
          isOwn: widget.isOwn,
          onEdit: widget.onEdit,
          onDelete: widget.onDelete,
        ),
      ),
    );
  }
}
