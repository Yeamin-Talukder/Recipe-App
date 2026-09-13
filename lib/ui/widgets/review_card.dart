import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants.dart';
import '../../models/review.dart';
import 'package:intl/intl.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final bool isOwn;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ReviewCard({
    super.key,
    required this.review,
    this.isOwn = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor  = isDark ? kDarkCard : Colors.white;
    final textPrimary = isDark ? kDarkTextPrimary : kTextPrimary;
    final textSec = isDark ? kDarkTextSecondary : kTextSecondary;
    final borderColor = isDark ? kDarkDivider : const Color(0xFFEDE8E3);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isOwn
              ? kPrimaryColor.withValues(alpha: 0.35)
              : borderColor,
          width: isOwn ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              _Avatar(
                name: review.userName,
                photoUrl: review.userPhoto,
                isDark: isDark,
              ),
              const SizedBox(width: 12),

              // Name + date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            review.userName,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isOwn)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: kPrimaryColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'You',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(review.createdAt),
                      style: TextStyle(fontSize: 11, color: textSec),
                    ),
                  ],
                ),
              ),

              // Edit/Delete menu (own review only)
              if (isOwn)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') onEdit?.call();
                    if (value == 'delete') onDelete?.call();
                  },
                  color: isDark ? kDarkCard : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  icon: Icon(Iconsax.more, color: textSec, size: 18),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Iconsax.edit, size: 16,
                              color: kPrimaryColor),
                          const SizedBox(width: 8),
                          Text('Edit', style: TextStyle(color: textPrimary)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Iconsax.trash, size: 16,
                              color: Color(0xFFE53935)),
                          const SizedBox(width: 8),
                          Text('Delete',
                              style: const TextStyle(color: Color(0xFFE53935))),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Star rating display
          _StarDisplay(rating: review.rating),
          const SizedBox(height: 10),

          // Comment
          if (review.comment.trim().isNotEmpty)
            Text(
              review.comment,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: textPrimary,
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return DateFormat('MMM d, yyyy').format(dt);
  }
}

// ─── Avatar ──────────────────────────────────────────────────────────────────
class _Avatar extends StatelessWidget {
  final String name;
  final String? photoUrl;
  final bool isDark;

  const _Avatar(
      {required this.name, required this.photoUrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((w) => w[0].toUpperCase()).take(2).join()
        : '?';

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kPrimaryColor.withValues(alpha: isDark ? 0.20 : 0.12),
        border: Border.all(
            color: kPrimaryColor.withValues(alpha: 0.30), width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: photoUrl != null
          ? Image.network(
              photoUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _InitialsWidget(initials: initials),
            )
          : _InitialsWidget(initials: initials),
    );
  }
}

class _InitialsWidget extends StatelessWidget {
  final String initials;
  const _InitialsWidget({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          color: kPrimaryColor,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}

// ─── Star display (read-only) ─────────────────────────────────────────────
class _StarDisplay extends StatelessWidget {
  final double rating;
  const _StarDisplay({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.floor();
        final half = !filled && (i < rating);
        return Icon(
          filled
              ? Iconsax.star5
              : half
                  ? Iconsax.star5
                  : Iconsax.star,
          color: filled || half ? kStarColor : Colors.grey.shade400,
          size: 15,
        );
      }),
    );
  }
}
