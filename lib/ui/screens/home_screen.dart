import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../utils/mock_data.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/my_search_bar.dart';
import '../widgets/banner_to_explore.dart';
import '../widgets/category_selector.dart';
import '../widgets/section_header.dart';
import '../widgets/recipe_card.dart';
import '../../providers/recipe_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _staggerController;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  static const int _sectionCount = 5;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _buildAnimations();
    _staggerController.forward();
  }

  void _buildAnimations() {
    _slideAnimations = List.generate(_sectionCount, (i) {
      final start = i * 0.12;
      final end = (start + 0.5).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _staggerController,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ));
    });
    _fadeAnimations = List.generate(_sectionCount, (i) {
      final start = i * 0.12;
      final end = (start + 0.45).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  Widget _stagger(int index, Widget child) {
    return FadeTransition(
      opacity: _fadeAnimations[index],
      child:
          SlideTransition(position: _slideAnimations[index], child: child),
    );
  }

  Future<void> _onRefresh() async {
    HapticFeedback.mediumImpact();
    await context.read<RecipeProvider>().fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? const Color(0xFFF0F2FA) : kTextPrimary;
    final textSecondary =
        isDark ? const Color(0xFF9AA5BB) : kTextSecondary;

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        color: kPrimaryColor,
        backgroundColor: isDark ? const Color(0xFF1A1D2E) : Colors.white,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                kHorizontalPadding,
                16,
                kHorizontalPadding,
                100,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 0: App bar
                  _stagger(0, const HomeAppBar()),
                  const SizedBox(height: 20),

                  // 1: Search bar
                  _stagger(
                      1,
                      MySearchBar(
                        onChanged: (value) =>
                            context.read<RecipeProvider>().setSearchQuery(value),
                      )),
                  const SizedBox(height: 20),

                  // 2: Banner
                  _stagger(2, const BannerToExplore()),
                  const SizedBox(height: 24),

                  // 3: Categories
                  _stagger(
                      3,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Categories",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Consumer<RecipeProvider>(
                            builder: (context, recipeProvider, child) {
                              return CategorySelector(
                                categories: categories,
                                selectedCategory:
                                    recipeProvider.selectedCategory,
                                onSelect: recipeProvider.setCategory,
                              );
                            },
                          ),
                        ],
                      )),
                  const SizedBox(height: 24),

                  // 4: Recipe grid
                  _stagger(
                      4,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(
                            title: "Quick & Easy",
                            onActionTap: () {},
                          ),
                          const SizedBox(height: 14),
                          Consumer<RecipeProvider>(
                            builder: (context, recipeProvider, child) {
                              if (recipeProvider.isLoading) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(40),
                                    child: CircularProgressIndicator(
                                      color: kPrimaryColor,
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                );
                              }
                              if (recipeProvider.error != null) {
                                return _buildError(
                                    recipeProvider.error!, textSecondary);
                              }
                              final recipes = recipeProvider.filteredRecipes;
                              if (recipes.isEmpty) {
                                return _buildEmptySearch(
                                    textPrimary, textSecondary);
                              }
                              return GridView.builder(
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 220,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: recipes.length,
                                itemBuilder: (context, index) =>
                                    RecipeCard(recipe: recipes[index]),
                              );
                            },
                          ),
                        ],
                      )),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String error, Color textColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.error_outline,
                color: Colors.redAccent, size: 48),
            const SizedBox(height: 12),
            Text(error,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  context.read<RecipeProvider>().fetchRecipes(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearch(Color textPrimary, Color textSecondary) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const Text('🔍', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              'No recipes found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try a different search or category',
              style: TextStyle(color: textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
