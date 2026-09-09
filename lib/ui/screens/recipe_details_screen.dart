import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../models/recipe.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/meal_plan_provider.dart';
import '../../providers/quantity_provider.dart';
import '../widgets/my_icon_button.dart';
import '../widgets/quantity_increment_decrement.dart';
import 'cooking_mode_screen.dart';
import '../../core/guest_helper.dart';
import '../../providers/auth_provider.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _contentController;
  late List<Animation<Offset>> _itemSlideAnimations;
  late List<Animation<double>> _itemFadeAnimations;

  static const int _sectionCount = 6;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final baseAmounts =
            widget.recipe.ingredients.map((ing) => ing.baseAmount).toList();
        Provider.of<QuantityProvider>(context, listen: false)
            .setBaseAmounts(baseAmounts);
      }
    });

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _itemSlideAnimations = List.generate(_sectionCount, (i) {
      final start = 0.05 + i * 0.10;
      final end = (start + 0.40).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
          .animate(CurvedAnimation(
        parent: _contentController,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ));
    });

    _itemFadeAnimations = List.generate(_sectionCount, (i) {
      final start = 0.05 + i * 0.10;
      final end = (start + 0.35).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _contentController,
        curve: Interval(start, end, curve: Curves.easeOut),
      ));
    });

    _contentController.forward();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Widget _stagger(int i, Widget child) => FadeTransition(
        opacity: _itemFadeAnimations[i],
        child: SlideTransition(
            position: _itemSlideAnimations[i], child: child),
      );

  void _showAddToMealPlanSheet(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddToMealPlanSheet(recipe: widget.recipe),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = (screenHeight * 0.42).clamp(280.0, 420.0);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF0F1117) : Colors.white;
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero image
                Hero(
                  tag: 'recipe-${recipe.id}',
                  child: SizedBox(
                    height: imageHeight,
                    width: double.infinity,
                    child: Image.network(
                      recipe.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),

                // Details card
                Transform.translate(
                  offset: const Offset(0, -28),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: scaffoldBg,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF2A2D42) : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // 0: Title
                        _stagger(
                            0,
                            Text(
                              recipe.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            )),
                        const SizedBox(height: 12),

                        // 1: Info chips
                        _stagger(
                            1,
                            Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              children: [
                                _InfoChip(
                                    icon: Iconsax.flash_1,
                                    label: '${recipe.calories} Cal',
                                    color: kPrimaryColor),
                                _InfoChip(
                                    icon: Iconsax.clock,
                                    label: '${recipe.time} Min',
                                    color: const Color(0xFF4A90D9)),
                                _InfoChip(
                                    icon: Iconsax.category,
                                    label: recipe.category,
                                    color: const Color(0xFF9B59B6)),
                              ],
                            )),
                        const SizedBox(height: 14),

                        // Rating row
                        _stagger(
                            1,
                            Row(
                              children: [
                                const Icon(Iconsax.star5,
                                    color: Color(0xFFFFA726), size: 18),
                                const SizedBox(width: 5),
                                Text(
                                  '${recipe.rating}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                const Text('/5  ',
                                    style: TextStyle(
                                        fontSize: 13, color: kTextSecondary)),
                                Text(
                                  '(${recipe.reviews} Reviews)',
                                  style: const TextStyle(
                                      fontSize: 13),
                                ),
                              ],
                            )),
                        const SizedBox(height: 26),

                        // 2: Ingredients header
                        _stagger(
                            2,
                            Consumer<QuantityProvider>(
                              builder: (context, quantityProvider, _) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Ingredients",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          "How many servings?",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55)),
                                        ),
                                      ],
                                    ),
                                    QuantityIncrementDecrement(
                                      currentNumber:
                                          quantityProvider.currentNumber,
                                      onAdd: quantityProvider.increaseQuantity,
                                      onRemove:
                                          quantityProvider.decreaseQuantity,
                                    ),
                                  ],
                                );
                              },
                            )),
                        const SizedBox(height: 16),

                        // 3: Ingredients list
                        _stagger(
                            3,
                            Consumer<QuantityProvider>(
                              builder: (context, quantityProvider, _) {
                                final servings =
                                    quantityProvider.currentNumber;
                                return ListView.separated(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  itemCount: recipe.ingredients.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final ingredient =
                                        recipe.ingredients[index];
                                    final amount = (ingredient.baseAmount *
                                            servings)
                                        .toStringAsFixed(1);
                                    return _IngredientRow(
                                      ingredient: ingredient,
                                      amount: amount,
                                    );
                                  },
                                );
                              },
                            )),
                        const SizedBox(height: 26),

                        // 4: Description
                        _stagger(
                            4,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Description",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  recipe.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.65,
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(height: 26),

                        // 5: Instructions
                        _stagger(
                            5,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Instructions",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                ListView.separated(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  itemCount: recipe.instructions.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 14),
                                  itemBuilder: (context, index) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4),
                                            child: Text(
                                              recipe.instructions[index],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                height: 1.55,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            )),
                        const SizedBox(height: 110),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating top bar
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyIconButton(
                    icon: Icons.arrow_back_ios_new,
                    pressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                  ),
                  MyIconButton(
                    icon: Iconsax.calendar_add,
                    pressed: () => _showAddToMealPlanSheet(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom action bar
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: _StartCookingButton(recipe: recipe),
            ),
            const SizedBox(width: 12),
            _FavoriteButton(recipe: recipe),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final dynamic ingredient;
  final String amount;

  const _IngredientRow({required this.ingredient, required this.amount});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final outerBg = isDark ? const Color(0xFF1E2235) : const Color(0xFFF8F9FA);
    final innerBg = isDark ? const Color(0xFF252838) : Colors.white;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: outerBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: innerBg,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: ingredient.image.startsWith('http')
                ? Image.network(
                    ingredient.image,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) =>
                        const Icon(Icons.fastfood, color: Colors.grey),
                  )
                : Image.asset(
                    'assets/images/${ingredient.image}',
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) =>
                        const Icon(Icons.fastfood, color: Colors.grey),
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              ingredient.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: kPrimaryColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${amount}g',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: kPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StartCookingButton extends StatefulWidget {
  final Recipe recipe;
  const _StartCookingButton({required this.recipe});

  @override
  State<_StartCookingButton> createState() => _StartCookingButtonState();
}

class _StartCookingButtonState extends State<_StartCookingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 110));
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _launchCookingMode(BuildContext context) {
    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CookingModeScreen(recipe: widget.recipe),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        _launchCookingMode(context);
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [kPrimaryColor, kPrimaryLight],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(kButtonRadius),
            boxShadow: [
              BoxShadow(
                color: kPrimaryColor.withValues(alpha: 0.40),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.restaurant_menu, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text(
                  'Start Cooking',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatefulWidget {
  final Recipe recipe;
  const _FavoriteButton({required this.recipe});

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.5)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 45),
      TweenSequenceItem(
          tween: Tween(begin: 1.5, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticIn)),
          weight: 55),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favUnselBg = isDark ? const Color(0xFF1A1D2E) : Colors.white;
    final favUnselBorder =
        isDark ? const Color(0xFF2A2D42) : Colors.grey.shade200;

    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, _) {
        final isFav = favoriteProvider.isFavorite(widget.recipe.id);
        return GestureDetector(
          onTap: () {
            if (context.read<AuthProvider>().isGuest) {
              showGuestLoginDialog(context);
              return;
            }
            HapticFeedback.lightImpact();
            _controller.forward(from: 0);
            favoriteProvider.toggleFavorite(widget.recipe.id);
          },
          child: AnimatedBuilder(
            animation: _scaleAnim,
            builder: (context, child) =>
                Transform.scale(scale: _scaleAnim.value, child: child),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isFav ? const Color(0xFFFFECF0) : favUnselBg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isFav
                      ? kFavoriteColor.withValues(alpha: 0.4)
                      : favUnselBorder,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isFav
                        ? kFavoriteColor.withValues(alpha: 0.25)
                        : Colors.black
                            .withValues(alpha: isDark ? 0.3 : 0.07),
                    blurRadius: isFav ? 14 : 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    isFav ? Iconsax.heart5 : Iconsax.heart,
                    key: ValueKey<bool>(isFav),
                    color: isFav ? kFavoriteColor : kTextSecondary,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Add to Meal Plan Sheet ─────────────────────────────────────────────────

class _AddToMealPlanSheet extends StatefulWidget {
  final Recipe recipe;
  const _AddToMealPlanSheet({required this.recipe});

  @override
  State<_AddToMealPlanSheet> createState() => _AddToMealPlanSheetState();
}

class _AddToMealPlanSheetState extends State<_AddToMealPlanSheet> {
  String _selectedDay = MealPlanProvider.days[0];
  String _selectedSlot = MealPlanProvider.slots[1]; // lunch default

  static const Map<String, String> _dayLabels = {
    'monday': 'Monday',
    'tuesday': 'Tuesday',
    'wednesday': 'Wednesday',
    'thursday': 'Thursday',
    'friday': 'Friday',
    'saturday': 'Saturday',
    'sunday': 'Sunday',
  };

  static const Map<String, IconData> _slotIcons = {
    'breakfast': Iconsax.sun_1,
    'lunch': Iconsax.sun,
    'dinner': Iconsax.moon,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1A1D2E) : Colors.white;
    final chipInactive = isDark ? const Color(0xFF252838) : const Color(0xFFF8F9FA);
    final chipInactiveText = isDark ? const Color(0xFF9AA5BB) : kTextSecondary;
    final dragHandle = isDark ? const Color(0xFF2A2D42) : Colors.grey.shade300;
    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
          22, 16, 22, MediaQuery.of(context).viewInsets.bottom + 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: dragHandle,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Add to Meal Plan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isDark ? const Color(0xFFF0F2FA) : kTextPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.recipe.name,
            style: TextStyle(fontSize: 14, color: isDark ? const Color(0xFF9AA5BB) : kTextSecondary),
          ),
          const SizedBox(height: 22),

          // Day selector
          Text(
            'Day',
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 14, color: isDark ? const Color(0xFFF0F2FA) : kTextPrimary),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: MealPlanProvider.days.map((day) {
                final selected = _selectedDay == day;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedDay = day);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? kPrimaryColor : chipInactive,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _dayLabels[day]!.substring(0, 3).toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: selected ? Colors.white : chipInactiveText,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Slot selector
          Text(
            'Meal',
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 14, color: isDark ? const Color(0xFFF0F2FA) : kTextPrimary),
          ),
          const SizedBox(height: 10),
          Row(
            children: MealPlanProvider.slots.map((slot) {
              final selected = _selectedSlot == slot;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedSlot = slot);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(
                        right: slot != MealPlanProvider.slots.last ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selected ? kPrimaryColor : chipInactive,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _slotIcons[slot]!,
                          color: selected ? Colors.white : chipInactiveText,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          slot[0].toUpperCase() + slot.substring(1),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: selected ? Colors.white : chipInactiveText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 26),

          // Save button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () async {
                HapticFeedback.mediumImpact();
                await context.read<MealPlanProvider>().setMeal(
                    _selectedDay, _selectedSlot, widget.recipe);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '${widget.recipe.name} added to ${_dayLabels[_selectedDay]} $_selectedSlot!'),
                      backgroundColor: kSuccessColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text(
                'Add to Plan',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
