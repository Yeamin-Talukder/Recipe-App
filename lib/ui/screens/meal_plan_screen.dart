import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../models/recipe.dart';
import '../../providers/meal_plan_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/guest_helper.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  int _selectedDayIndex = 0;

  static const Map<String, String> _dayLabels = {
    'monday': 'Mon',
    'tuesday': 'Tue',
    'wednesday': 'Wed',
    'thursday': 'Thu',
    'friday': 'Fri',
    'saturday': 'Sat',
    'sunday': 'Sun',
  };

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    // Load plan once recipes are available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final recipes = context.read<RecipeProvider>().recipes;
      context.read<MealPlanProvider>().loadWeekPlan(recipes);

      // Default to today's weekday
      final weekday = DateTime.now().weekday; // 1=Mon, 7=Sun
      setState(() => _selectedDayIndex = weekday - 1);
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  String get _selectedDay => MealPlanProvider.days[_selectedDayIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildDayStrip(),
            Expanded(
              child: Consumer<MealPlanProvider>(
                builder: (context, mealPlanProvider, _) {
                  if (mealPlanProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                        strokeWidth: 2.5,
                      ),
                    );
                  }
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: anim,
                          curve: Curves.easeOutCubic,
                        )),
                        child: child,
                      ),
                    ),
                    child: _buildMealSlots(mealPlanProvider),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(kHorizontalPadding, 20, kHorizontalPadding, 0),
      child: FadeTransition(
        opacity: _entranceController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meal Plan 📅',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Consumer<MealPlanProvider>(
              builder: (context, mp, _) => Text(
                '${mp.totalMealsPlanned} meals planned this week',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayStrip() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(kHorizontalPadding, 18, kHorizontalPadding, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Consumer<MealPlanProvider>(
          builder: (context, mp, _) {
            return Row(
              children: List.generate(MealPlanProvider.days.length, (i) {
                final day = MealPlanProvider.days[i];
                final isSelected = i == _selectedDayIndex;
                final hasMeals = mp.hasAnyMealOnDay(day);
                final date = DateTime.now().subtract(
                    Duration(days: DateTime.now().weekday - 1 - i));

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedDayIndex = i);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? kPrimaryColor
                          : (Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF1A1D2E)
                              : Colors.white),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: kPrimaryColor.withValues(alpha: 0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          _dayLabels[day]!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white70 : kTextLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? Colors.white : kTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Dot indicator for meals
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasMeals
                                ? (isSelected ? Colors.white : kPrimaryColor)
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMealSlots(MealPlanProvider mp) {
    return ListView(
      key: ValueKey(_selectedDayIndex),
      padding: EdgeInsets.fromLTRB(kHorizontalPadding, 8, kHorizontalPadding, 120),
      physics: const BouncingScrollPhysics(),
      children: MealPlanProvider.slots.map((slot) {
        final recipe = mp.getRecipe(_selectedDay, slot);
        return _MealSlotCard(
          slot: slot,
          recipe: recipe,
          onAdd: () => _showPickRecipeSheet(slot),
          onRemove: () => _confirmRemove(slot, recipe!.name),
        );
      }).toList(),
    );
  }

  void _showPickRecipeSheet(String slot) {
    if (context.read<AuthProvider>().isGuest) {
      showGuestLoginDialog(context);
      return;
    }
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _PickRecipeSheet(
        onPick: (recipe) async {
          await context
              .read<MealPlanProvider>()
              .setMeal(_selectedDay, slot, recipe);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    '${recipe.name} added to ${_dayLabels[_selectedDay]} ${slot[0].toUpperCase() + slot.substring(1)}!'),
                backgroundColor: kSuccessColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            );
          }
        },
      ),
    );
  }

  void _confirmRemove(String slot, String recipeName) {
    if (context.read<AuthProvider>().isGuest) {
      showGuestLoginDialog(context);
      return;
    }
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove Meal',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text('Remove "$recipeName" from ${_dayLabels[_selectedDay]} $slot?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: kTextSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<MealPlanProvider>()
                  .removeMeal(_selectedDay, slot);
            },
            child:
                const Text('Remove', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─── Meal Slot Card ──────────────────────────────────────────────────────────

class _MealSlotCard extends StatelessWidget {
  final String slot;
  final Recipe? recipe;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  static const Map<String, IconData> _slotIcons = {
    'breakfast': Iconsax.sun_1,
    'lunch': Iconsax.sun,
    'dinner': Iconsax.moon,
  };

  static const Map<String, Color> _slotColors = {
    'breakfast': Color(0xFFFF9F43),
    'lunch': Color(0xFF26de81),
    'dinner': Color(0xFF4A90D9),
  };

  const _MealSlotCard({
    required this.slot,
    required this.recipe,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1A1D2E) : Colors.white;
    final color = _slotColors[slot]!;
    final slotLabel = slot[0].toUpperCase() + slot.substring(1);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: recipe == null
          ? _buildEmptySlot(color, slotLabel, isDark)
          : _buildFilledSlot(color, slotLabel, isDark),
    );
  }

  Widget _buildEmptySlot(Color color, String slotLabel, bool isDark) {
    return InkWell(
      onTap: onAdd,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(_slotIcons[slot]!, color: color, size: 22),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slotLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: isDark ? const Color(0xFFF0F2FA) : kTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Tap to add a recipe',
                    style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF5C6880) : kTextLight),
                  ),
                ],
              ),
            ),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(Icons.add, color: color, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilledSlot(Color color, String slotLabel, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Recipe image
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              recipe!.image,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 70,
                height: 70,
                color: const Color(0xFFF0F0F0),
                child: const Icon(Icons.fastfood, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(_slotIcons[slot]!, color: color, size: 14),
                    const SizedBox(width: 5),
                    Text(
                      slotLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  recipe!.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: isDark ? const Color(0xFFF0F2FA) : kTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Iconsax.clock, color: kTextLight, size: 12),
                    const SizedBox(width: 3),
                    Text(
                      '${recipe!.time} min',
                      style: const TextStyle(
                          fontSize: 12, color: kTextLight),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Iconsax.flash_1,
                        color: kPrimaryColor, size: 12),
                    const SizedBox(width: 3),
                    Text(
                      '${recipe!.calories} cal',
                      style: const TextStyle(
                          fontSize: 12, color: kPrimaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Remove button
          GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.close,
                    color: Colors.red, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Pick Recipe Bottom Sheet ─────────────────────────────────────────────────

class _PickRecipeSheet extends StatefulWidget {
  final Function(Recipe) onPick;
  const _PickRecipeSheet({required this.onPick});

  @override
  State<_PickRecipeSheet> createState() => _PickRecipeSheetState();
}

class _PickRecipeSheetState extends State<_PickRecipeSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1A1D2E) : Colors.white;
    final rowBg = isDark ? const Color(0xFF252838) : const Color(0xFFF8F9FA);
    final dragHandle = isDark ? const Color(0xFF2A2D42) : Colors.grey.shade300;
    final titleColor = isDark ? const Color(0xFFF0F2FA) : kTextPrimary;
    final textLight = isDark ? const Color(0xFF5C6880) : kTextLight;
    final allRecipes = context.read<RecipeProvider>().recipes;
    final filtered = _query.isEmpty
        ? allRecipes
        : allRecipes
            .where((r) =>
                r.name.toLowerCase().contains(_query.toLowerCase()) ||
                r.category.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
                color: dragHandle,
                borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pick a Recipe',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  autofocus: false,
                  style: TextStyle(color: titleColor),
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search recipes...',
                    hintStyle: TextStyle(color: textLight),
                    prefixIcon: Icon(Iconsax.search_normal, color: textLight),
                    filled: true,
                    fillColor: rowBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text('No recipes found',
                        style: TextStyle(color: textLight)))
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final r = filtered[index];
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                          widget.onPick(r);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: rowBg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  r.image,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    width: 56,
                                    height: 56,
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.fastfood,
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: titleColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${r.category} \u2022 ${r.time} min \u2022 ${r.calories} cal',
                                      style: TextStyle(
                                          fontSize: 12, color: textLight),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right,
                                  color: kTextLight, size: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
