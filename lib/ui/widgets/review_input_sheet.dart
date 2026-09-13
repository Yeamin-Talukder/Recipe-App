import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../models/review.dart';
import '../../providers/review_provider.dart';

/// Animated star rating picker + comment field modal bottom sheet.
class ReviewInputSheet extends StatefulWidget {
  final String recipeId;
  final String userId;
  final Review? existingReview; // null = new review, not null = editing

  const ReviewInputSheet({
    super.key,
    required this.recipeId,
    required this.userId,
    this.existingReview,
  });

  @override
  State<ReviewInputSheet> createState() => _ReviewInputSheetState();
}

class _ReviewInputSheetState extends State<ReviewInputSheet>
    with TickerProviderStateMixin {
  late int _selectedStars;
  late TextEditingController _commentCtrl;
  late AnimationController _sheetController;
  late Animation<double> _sheetFade;

  final List<AnimationController> _starControllers = [];
  final List<Animation<double>> _starScales = [];

  @override
  void initState() {
    super.initState();
    _selectedStars = widget.existingReview?.rating.round() ?? 0;
    _commentCtrl = TextEditingController(
      text: widget.existingReview?.comment ?? '',
    );

    // Sheet entrance animation
    _sheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _sheetFade = CurvedAnimation(
      parent: _sheetController,
      curve: Curves.easeOutCubic,
    );
    _sheetController.forward();

    // Per-star bounce controllers
    for (int i = 0; i < 5; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 280),
      );
      final scale = TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.45)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 40,
        ),
        TweenSequenceItem(
          tween: Tween(begin: 1.45, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticIn)),
          weight: 60,
        ),
      ]).animate(ctrl);
      _starControllers.add(ctrl);
      _starScales.add(scale);
    }
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    _sheetController.dispose();
    for (final c in _starControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onStarTap(int starIndex) {
    HapticFeedback.selectionClick();
    setState(() => _selectedStars = starIndex + 1);
    _starControllers[starIndex].forward(from: 0);
  }

  Future<void> _submit() async {
    if (_selectedStars == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a star rating first')),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    final provider = context.read<ReviewProvider>();
    final success = await provider.submitReview(
      recipeId: widget.recipeId,
      rating: _selectedStars.toDouble(),
      comment: _commentCtrl.text.trim(),
      userId: widget.userId,
      existingReview: widget.existingReview,
    );

    if (mounted) {
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.error ?? 'Something went wrong')),
        );
      }
    }
  }

  String _starLabel(int stars) {
    switch (stars) {
      case 1: return 'Terrible 😞';
      case 2: return 'Poor 😕';
      case 3: return 'Okay 😐';
      case 4: return 'Good 😊';
      case 5: return 'Amazing! 🤩';
      default: return 'Tap a star to rate';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? kDarkSurface : Colors.white;
    final textPrimary = isDark ? kDarkTextPrimary : kTextPrimary;
    final textSec = isDark ? kDarkTextSecondary : kTextSecondary;
    final fillColor = isDark ? kDarkCard : const Color(0xFFF5F0EC);
    final isEditing = widget.existingReview != null;

    return FadeTransition(
      opacity: _sheetFade,
      child: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 28,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? kDarkDivider : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                isEditing ? 'Edit Your Review' : 'Write a Review',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Share your experience with this recipe',
                style: TextStyle(fontSize: 13, color: textSec),
              ),
              const SizedBox(height: 28),

              // Star picker
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final filled = i < _selectedStars;
                  return GestureDetector(
                    onTap: () => _onStarTap(i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: AnimatedBuilder(
                        animation: _starScales[i],
                        builder: (context, child) => Transform.scale(
                          scale: _starScales[i].value,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              filled ? Iconsax.star5 : Iconsax.star,
                              size: 42,
                              color: filled
                                  ? kStarColor
                                  : isDark
                                      ? kDarkTextLight
                                      : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),

              // Star label
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _starLabel(_selectedStars),
                  key: ValueKey<int>(_selectedStars),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _selectedStars > 0 ? kPrimaryColor : textSec,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Comment field
              Container(
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _commentCtrl,
                  maxLines: 4,
                  maxLength: 500,
                  style: TextStyle(fontSize: 14, color: textPrimary),
                  decoration: InputDecoration(
                    hintText:
                        'Tell others what you thought about this recipe...',
                    hintStyle: TextStyle(color: textSec, fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    counterStyle:
                        TextStyle(fontSize: 11, color: textSec),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit button
              Consumer<ReviewProvider>(
                builder: (context, provider, _) {
                  return SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: provider.isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            kPrimaryColor.withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: provider.isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              isEditing ? 'Update Review' : 'Submit Review',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
