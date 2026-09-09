import '../models/recipe.dart';

// --- Original 10 Images ---
const String _pizzaImg = "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _steakImg = "https://images.unsplash.com/photo-1600891964092-4316c288032e?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _burgerImg = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _cakeImg = "https://images.unsplash.com/photo-1578985545062-69928b1d9587?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _salmonImg = "https://images.unsplash.com/photo-1485921325833-c519f76c4927?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _avocadoToastImg = "https://images.unsplash.com/photo-1525351484163-7529414344d8?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _pastaImg = "https://images.unsplash.com/photo-1612874742237-6526221588e3?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _pancakesImg = "https://images.unsplash.com/photo-1565299585323-38d6b0865b47?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _tacosImg = "https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _curryImg = "https://images.unsplash.com/photo-1565557623262-b51c2513a641?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _brownieImg = "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _ramenImg = "https://images.unsplash.com/photo-1557872943-16a5ac26437e?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _macCheeseImg = "https://images.unsplash.com/photo-1543339494-b4cd4f7ba686?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";

// --- New 20 Images ---
const String _sandwichImg = "https://images.unsplash.com/photo-1528735602780-2552fd46c7af?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _roastChickenImg = "https://images.unsplash.com/photo-1598514982205-f36b96d1e8d4?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _risottoImg = "https://thumb.wikimedia.org/wikipedia/commons/thumb/a/a5/Risotto_with_speck_and_goat_cheese_%286101067436%29.jpg/960px-Risotto_with_speck_and_goat_cheese_%286101067436%29.jpg";
const String _paellaImg = "https://images.unsplash.com/photo-1534080564583-6be75777b70a?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _bruschettaImg = "https://images.unsplash.com/photo-1572695157366-5e585ab2b69f?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _muffinImg = "https://thumb.wikimedia.org/wikipedia/commons/thumb/4/4c/02116jfMuffins_in_Philippinesfvf_02.jpg/960px-02116jfMuffins_in_Philippinesfvf_02.jpg";
const String _croissantImg = "https://thumb.wikimedia.org/wikipedia/commons/thumb/2/2a/Croissant-Petr_Kratochvil.jpg/960px-Croissant-Petr_Kratochvil.jpg";
const String _donutImg = "https://images.unsplash.com/photo-1551024601-bec78aea704b?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _iceCreamImg = "https://images.unsplash.com/photo-1497034825429-c343d7c6a68f?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _ribsImg = "https://thumb.wikimedia.org/wikipedia/commons/thumb/2/20/Balinese_Roasted_Pork_Ribs_-_Iga_Babi_Panggang_Bali.JPG/960px-Balinese_Roasted_Pork_Ribs_-_Iga_Babi_Panggang_Bali.JPG";
const String _biryaniImg = "https://images.unsplash.com/photo-1631515243349-e0cb75fb8d3a?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _lasagnaImg = "https://images.unsplash.com/photo-1574894709920-11b28e7367e3?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _falafelImg = "https://thumb.wikimedia.org/wikipedia/commons/thumb/5/57/Falafels_2.jpg/960px-Falafels_2.jpg";
const String _saladBowlImg = "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _noodleSoupImg = "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _meatballsImg = "https://images.unsplash.com/photo-1529042410759-befb1204b468?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _bakedPotatoImg = "https://images.unsplash.com/photo-1585032226651-759b368d7246?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _fishChipsImg = "https://thumb.wikimedia.org/wikipedia/commons/thumb/f/ff/Fish_and_chips_blackpool.jpg/960px-Fish_and_chips_blackpool.jpg";
const String _hotDogImg = "https://thumb.wikimedia.org/wikipedia/commons/thumb/b/b1/Hot_dog_with_mustard.png/960px-Hot_dog_with_mustard.png";
const String _burritoImg = "https://images.unsplash.com/photo-1626700051175-6818013e1d4f?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _wafflesImg = "https://images.unsplash.com/photo-1562376552-0d160a2f5f14?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";
const String _sushiImg = "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80";

// --- Ingredients Images ---
const String _cheeseImg = "https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?auto=format&fit=crop&w=300&q=80";
const String _tomatoImg = "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=300&q=80";
const String _beefImg = "https://images.unsplash.com/photo-1603048588665-791ca8aea617?auto=format&fit=crop&w=300&q=80";
const String _vegetableImg = "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=300&q=80";
const String _breadImg = "https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=300&q=80";
const String _eggImg = "https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=300&q=80";
const String _butterImg = "https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?auto=format&fit=crop&w=300&q=80";
const String _salmonIngImg = "https://images.unsplash.com/photo-1599084993091-1cb5c0721cc6?auto=format&fit=crop&w=300&q=80";
const String _avocadoImg = "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?auto=format&fit=crop&w=300&q=80";
const String _pastaIngImg = "https://images.unsplash.com/photo-1551222137-ec56b0258169?auto=format&fit=crop&w=300&q=80";
const String _chickenImg = "https://images.unsplash.com/photo-1604544837500-2e4a4dae9729?auto=format&fit=crop&w=300&q=80";
const String _riceImg = "https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=300&q=80";
const String _garlicImg = "https://images.unsplash.com/photo-1615477550388-34ebbd02dcd0?auto=format&fit=crop&w=300&q=80";
const String _onionImg = "https://images.unsplash.com/photo-1518977676601-b53f82aba655?auto=format&fit=crop&w=300&q=80";

final List<String> categories = [
  "All",
  "Dinner",
  "Lunch",
  "Breakfast",
  "Dessert"
];

final List<Recipe> mockRecipes = [
  // --- Original 10 Recipes ---
  Recipe(
    id: "1",
    name: "Classic Cheeseburger",
    image: _burgerImg,
    category: "Lunch",
    calories: 550,
    time: 20,
    rating: 4.8,
    reviews: 320,
    description: "A juicy, perfectly grilled beef patty topped with melted cheese, fresh lettuce, and tomatoes in a toasted brioche bun.",
    instructions: [
      "Form the beef into patties and season generously with salt and pepper.",
      "Grill patties over medium-high heat for 4-5 minutes per side.",
      "Add a thick slice of cheddar cheese during the last minute of cooking.",
      "Toast the buns and assemble with fresh lettuce, tomato, and your favorite sauces."
    ],
    ingredients: [
      Ingredient(name: "Beef", image: _beefImg, baseAmount: 200),
      Ingredient(name: "Bread", image: _breadImg, baseAmount: 80),
      Ingredient(name: "Cheese", image: _cheeseImg, baseAmount: 40),
      Ingredient(name: "Tomato", image: _tomatoImg, baseAmount: 30),
    ],
  ),
  Recipe(
    id: "2",
    name: "Spaghetti Carbonara",
    image: _pastaImg,
    category: "Dinner",
    calories: 420,
    time: 30,
    rating: 4.7,
    reviews: 310,
    description: "Authentic Italian pasta tossed in a creamy sauce made of eggs, Pecorino Romano cheese, pancetta, and freshly cracked black pepper.",
    instructions: [
      "Boil pasta in salted water until al dente.",
      "Crisp pancetta in a skillet over medium heat.",
      "Whisk fresh eggs and grated cheese in a separate bowl.",
      "Combine pasta, pancetta, and egg mixture off the heat, tossing vigorously to create a silky, creamy sauce."
    ],
    ingredients: [
      Ingredient(name: "Pasta", image: _pastaIngImg, baseAmount: 150),
      Ingredient(name: "Egg", image: _eggImg, baseAmount: 60),
      Ingredient(name: "Cheese", image: _cheeseImg, baseAmount: 50),
    ],
  ),
  Recipe(
    id: "3",
    name: "Avocado Toast",
    image: _avocadoToastImg,
    category: "Breakfast",
    calories: 220,
    time: 10,
    rating: 4.6,
    reviews: 210,
    description: "Crispy artisan sourdough toast topped with creamy smashed avocado, a perfectly poached egg, and a sprinkle of chili flakes.",
    instructions: [
      "Toast the sourdough bread until golden and crisp.",
      "Mash the avocado with a pinch of sea salt, black pepper, and lime juice.",
      "Spread avocado over toast and carefully top with a poached egg.",
      "Sprinkle with chili flakes and microgreens, then serve immediately."
    ],
    ingredients: [
      Ingredient(name: "Avocado", image: _avocadoImg, baseAmount: 100),
      Ingredient(name: "Bread", image: _breadImg, baseAmount: 60),
      Ingredient(name: "Egg", image: _eggImg, baseAmount: 50),
    ],
  ),
  Recipe(
    id: "4",
    name: "Grilled Salmon",
    image: _salmonImg,
    category: "Dinner",
    calories: 320,
    time: 20,
    rating: 4.9,
    reviews: 450,
    description: "Perfectly grilled salmon fillets with a crispy skin and a tender, flaky inside, seasoned with fresh lemon and herbs.",
    instructions: [
      "Preheat grill or cast-iron skillet to medium-high heat.",
      "Brush salmon fillets with olive oil and season with salt, pepper, and fresh dill.",
      "Grill for 4-5 minutes per side until the fish is fully cooked and flakes easily.",
      "Serve hot with fresh lemon wedges and a side of asparagus."
    ],
    ingredients: [
      Ingredient(name: "Salmon", image: _salmonIngImg, baseAmount: 250),
      Ingredient(name: "Vegetables", image: _vegetableImg, baseAmount: 150),
    ],
  ),
  Recipe(
    id: "5",
    name: "Spicy Beef Tacos",
    image: _tacosImg,
    category: "Lunch",
    calories: 380,
    time: 20,
    rating: 4.6,
    reviews: 250,
    description: "Warm soft tortillas filled with spicy ground beef, fresh homemade salsa, shredded cheese, and crisp lettuce.",
    instructions: [
      "Brown ground beef in a skillet and drain any excess fat.",
      "Stir in taco seasoning, chopped onions, and a splash of water, simmering until thick.",
      "Warm the tortillas on a dry skillet.",
      "Assemble tacos with the savory beef, cheddar cheese, crisp lettuce, and salsa."
    ],
    ingredients: [
      Ingredient(name: "Beef", image: _beefImg, baseAmount: 200),
      Ingredient(name: "Cheese", image: _cheeseImg, baseAmount: 40),
      Ingredient(name: "Tomato", image: _tomatoImg, baseAmount: 30),
      Ingredient(name: "Onion", image: _onionImg, baseAmount: 30),
    ],
  ),
  Recipe(
    id: "6",
    name: "Shoyu Ramen",
    image: _ramenImg,
    category: "Dinner",
    calories: 520,
    time: 45,
    rating: 4.8,
    reviews: 330,
    description: "A comforting, authentic bowl of Japanese ramen featuring a deep soy sauce-based broth, tender pork chashu, and a soft-boiled egg.",
    instructions: [
      "Boil the fresh ramen noodles according to package instructions and drain well.",
      "Prepare the umami broth by simmering soy sauce, dashi, garlic, and chicken stock.",
      "Soft boil an egg (6.5 minutes) and slice the tender pork chashu.",
      "Assemble the bowl with hot noodles, steaming broth, and all toppings."
    ],
    ingredients: [
      Ingredient(name: "Pasta", image: _pastaIngImg, baseAmount: 120),
      Ingredient(name: "Egg", image: _eggImg, baseAmount: 50),
      Ingredient(name: "Beef", image: _beefImg, baseAmount: 80),
      Ingredient(name: "Garlic", image: _garlicImg, baseAmount: 10),
    ],
  ),
  Recipe(
    id: "7",
    name: "Fluffy Pancakes",
    image: _pancakesImg,
    category: "Breakfast",
    calories: 300,
    time: 25,
    rating: 4.9,
    reviews: 400,
    description: "Soft, thick, and incredibly fluffy buttermilk pancakes stacked high and served hot with melting butter and rich maple syrup.",
    instructions: [
      "Whisk flour, sugar, baking powder, and salt together in a large bowl.",
      "Add buttermilk, eggs, and melted butter, mixing gently until just combined (lumps are okay).",
      "Pour batter onto a hot, lightly greased griddle.",
      "Flip when bubbles form on the surface and cook until golden brown on both sides."
    ],
    ingredients: [
      Ingredient(name: "Egg", image: _eggImg, baseAmount: 50),
      Ingredient(name: "Butter", image: _butterImg, baseAmount: 30),
    ],
  ),
  Recipe(
    id: "8",
    name: "Chicken Curry",
    image: _curryImg,
    category: "Dinner",
    calories: 480,
    time: 35,
    rating: 4.7,
    reviews: 210,
    description: "A rich, vibrant, and aromatic chicken curry simmered in a spiced tomato and creamy coconut milk sauce, served with jasmine rice.",
    instructions: [
      "Sauté diced onions, minced garlic, and grated ginger until fragrant and golden.",
      "Add warm curry spices and cook for another minute to release their oils.",
      "Add chicken chunks and brown on all sides.",
      "Pour in coconut milk and diced tomatoes, simmering gently until the chicken is cooked through."
    ],
    ingredients: [
      Ingredient(name: "Chicken", image: _chickenImg, baseAmount: 250),
      Ingredient(name: "Rice", image: _riceImg, baseAmount: 150),
      Ingredient(name: "Tomato", image: _tomatoImg, baseAmount: 100),
      Ingredient(name: "Onion", image: _onionImg, baseAmount: 50),
    ],
  ),
  Recipe(
    id: "9",
    name: "Chocolate Brownie",
    image: _brownieImg,
    category: "Dessert",
    calories: 350,
    time: 30,
    rating: 4.9,
    reviews: 450,
    description: "Fudgy, gooey, and intensely chocolatey brownies with a perfect crinkly top and chunks of melted dark chocolate inside.",
    instructions: [
      "Melt butter and high-quality dark chocolate together over a double boiler until smooth.",
      "Whisk sugar and eggs vigorously until pale and fluffy, then gently fold in the chocolate mixture.",
      "Gently fold in the flour, cocoa powder, and a pinch of salt.",
      "Pour into a lined baking pan and bake at 350°F (175°C) for exactly 25 minutes for a fudgy center."
    ],
    ingredients: [
      Ingredient(name: "Butter", image: _butterImg, baseAmount: 120),
      Ingredient(name: "Egg", image: _eggImg, baseAmount: 100),
    ],
  ),
  Recipe(
    id: "10",
    name: "Mac and Cheese",
    image: _macCheeseImg,
    category: "Lunch",
    calories: 550,
    time: 30,
    rating: 4.8,
    reviews: 280,
    description: "The ultimate cozy comfort food, featuring tender elbow macaroni completely smothered in a rich, creamy, and gooey cheddar cheese sauce.",
    instructions: [
      "Boil macaroni in salted water until perfectly al dente, then drain.",
      "Melt butter in a pan, whisk in flour to create a roux, and slowly stream in warm milk.",
      "Stir in freshly shredded cheddar and gruyere cheese until completely melted and smooth.",
      "Mix the velvety cheese sauce with the drained macaroni and serve piping hot."
    ],
    ingredients: [
      Ingredient(name: "Pasta", image: _pastaIngImg, baseAmount: 200),
      Ingredient(name: "Cheese", image: _cheeseImg, baseAmount: 150),
      Ingredient(name: "Butter", image: _butterImg, baseAmount: 40),
    ],
  ),

  // --- New 20 Recipes ---
  Recipe(
    id: "11",
    name: "Club Sandwich",
    image: _sandwichImg,
    category: "Lunch",
    calories: 450,
    time: 15,
    rating: 4.5,
    reviews: 180,
    description: "A classic triple-decker club sandwich layered with roasted turkey, crispy bacon, fresh lettuce, and ripe tomatoes.",
    instructions: [
      "Toast three slices of bread until golden brown.",
      "Spread mayonnaise on one side of each slice.",
      "Layer turkey, cheese, and lettuce on the bottom slice.",
      "Add the middle slice, then layer bacon, tomatoes, and more lettuce.",
      "Top with the final slice, cut into quarters, and secure with toothpicks."
    ],
    ingredients: [
      Ingredient(name: "Bread", image: _breadImg, baseAmount: 100),
      Ingredient(name: "Chicken", image: _chickenImg, baseAmount: 100), // Using chicken for turkey
      Ingredient(name: "Tomato", image: _tomatoImg, baseAmount: 40),
      Ingredient(name: "Cheese", image: _cheeseImg, baseAmount: 30),
    ],
  ),
  Recipe(
    id: "12",
    name: "Herb Roasted Chicken",
    image: _roastChickenImg,
    category: "Dinner",
    calories: 650,
    time: 90,
    rating: 4.9,
    reviews: 520,
    description: "A beautifully roasted whole chicken seasoned with fresh rosemary, thyme, and garlic, offering crispy skin and tender meat.",
    instructions: [
      "Preheat the oven to 400°F (200°C).",
      "Pat the chicken dry and rub generously with butter, salt, pepper, and mixed herbs.",
      "Stuff the cavity with lemon halves, garlic cloves, and onion wedges.",
      "Roast for 1 hour and 20 minutes, basting occasionally until juices run clear.",
      "Let rest for 15 minutes before carving."
    ],
    ingredients: [
      Ingredient(name: "Chicken", image: _chickenImg, baseAmount: 800),
      Ingredient(name: "Garlic", image: _garlicImg, baseAmount: 20),
      Ingredient(name: "Butter", image: _butterImg, baseAmount: 50),
    ],
  ),
  Recipe(
    id: "13",
    name: "Mushroom Risotto",
    image: _risottoImg,
    category: "Dinner",
    calories: 480,
    time: 40,
    rating: 4.7,
    reviews: 290,
    description: "A creamy, comforting Italian risotto made with Arborio rice, sautéed mushrooms, white wine, and parmesan cheese.",
    instructions: [
      "Warm the vegetable broth in a saucepan.",
      "In a large skillet, sauté mushrooms in butter until browned, then remove.",
      "Sauté onions and garlic, add the Arborio rice, and toast for 2 minutes.",
      "Gradually add the warm broth one ladle at a time, stirring continuously until absorbed.",
      "Stir in the cooked mushrooms and grated parmesan cheese before serving."
    ],
    ingredients: [
      Ingredient(name: "Rice", image: _riceImg, baseAmount: 150),
      Ingredient(name: "Vegetables", image: _vegetableImg, baseAmount: 100), // For mushrooms
      Ingredient(name: "Cheese", image: _cheeseImg, baseAmount: 50),
      Ingredient(name: "Butter", image: _butterImg, baseAmount: 30),
    ],
  ),
  Recipe(
    id: "14",
    name: "Seafood Paella",
    image: _paellaImg,
    category: "Dinner",
    calories: 550,
    time: 50,
    rating: 4.8,
    reviews: 380,
    description: "A vibrant Spanish dish combining saffron-infused rice, shrimp, mussels, and chorizo for a flavorful feast.",
    instructions: [
      "Sauté onions, garlic, and bell peppers in a large paella pan.",
      "Add chorizo and cook until lightly browned.",
      "Stir in Bomba rice, saffron, and smoked paprika, then pour in chicken broth.",
      "Simmer without stirring, and arrange shrimp and mussels on top during the last 10 minutes.",
      "Let it rest off the heat, garnished with lemon wedges."
    ],
    ingredients: [
      Ingredient(name: "Rice", image: _riceImg, baseAmount: 200),
      Ingredient(name: "Beef", image: _beefImg, baseAmount: 100), // For chorizo
      Ingredient(name: "Vegetables", image: _vegetableImg, baseAmount: 80),
    ],
  ),
  Recipe(
    id: "15",
    name: "Tomato Bruschetta",
    image: _bruschettaImg,
    category: "Lunch",
    calories: 180,
    time: 15,
    rating: 4.6,
    reviews: 150,
    description: "Toasted slices of rustic bread rubbed with garlic and topped with a fresh mix of diced tomatoes, basil, and balsamic glaze.",
    instructions: [
      "Dice ripe tomatoes and mix with finely chopped red onion, fresh basil, salt, and pepper.",
      "Slice the baguette and toast the slices until golden and crisp.",
      "Rub each toasted slice with a halved clove of raw garlic.",
      "Top with the tomato mixture and drizzle with balsamic glaze and olive oil."
    ],
    ingredients: [
      Ingredient(name: "Bread", image: _breadImg, baseAmount: 120),
      Ingredient(name: "Tomato", image: _tomatoImg, baseAmount: 150),
      Ingredient(name: "Garlic", image: _garlicImg, baseAmount: 10),
    ],
  ),
  Recipe(
    id: "16",
    name: "Blueberry Muffins",
    image: _muffinImg,
    category: "Breakfast",
    calories: 280,
    time: 35,
    rating: 4.7,
    reviews: 210,
    description: "Soft, tender muffins bursting with juicy blueberries, topped with a sweet, crumbly streusel topping.",
    instructions: [
      "Preheat the oven to 375°F (190°C) and line a muffin tin.",
      "Whisk flour, sugar, baking powder, and salt together.",
      "In a separate bowl, mix milk, oil, eggs, and vanilla extract.",
      "Combine wet and dry ingredients, then fold in the fresh blueberries.",
      "Divide the batter into the tin, add streusel topping, and bake for 20 minutes."
    ],
    ingredients: [
      Ingredient(name: "Bread", image: _breadImg, baseAmount: 100), // For flour
      Ingredient(name: "Egg", image: _eggImg, baseAmount: 50),
      Ingredient(name: "Butter", image: _butterImg, baseAmount: 40),
    ],
  ),
  Recipe(
    id: "17",
    name: "Butter Croissant",
    image: _croissantImg,
    category: "Breakfast",
    calories: 320,
    time: 120,
    rating: 4.9,
    reviews: 340,
    description: "Classic French pastry that is beautifully flaky on the outside and wonderfully soft and buttery on the inside.",
    instructions: [
      "Prepare a yeast dough and let it rest in the refrigerator.",
      "Enclose a block of cold butter within the dough and roll it out.",
      "Perform several 'turns' (folding and rolling) to create the flaky layers, chilling in between.",
      "Cut into triangles, roll into the classic crescent shape, and let proof.",
      "Brush with egg wash and bake at 400°F (200°C) until golden brown."
    ],
    ingredients: [
      Ingredient(name: "Butter", image: _butterImg, baseAmount: 150),
      Ingredient(name: "Bread", image: _breadImg, baseAmount: 150), // For flour
      Ingredient(name: "Egg", image: _eggImg, baseAmount: 20),
    ],
  ),
  Recipe(
    id: "18",
    name: "Glazed Donuts",
    image: _donutImg,
    category: "Dessert",
    calories: 310,
    time: 90,
    rating: 4.8,
    reviews: 280,
    description: "Soft, pillowy yeast donuts deep-fried to perfection and coated in a sweet, translucent vanilla glaze.",
    instructions: [
      "Make a soft yeast dough with warm milk, sugar, butter, and flour, then let it rise until doubled.",
      "Roll out the dough and cut out donut shapes.",
      "Let the donuts rise again until puffy.",
      "Fry in hot oil at 350°F (175°C) for 1 minute per side until golden.",
      "Dip warm donuts in a simple sugar glaze and let set."
    ],
    ingredients: [
      Ingredient(name: "Bread", image: _breadImg, baseAmount: 120), // For flour
      Ingredient(name: "Butter", image: _butterImg, baseAmount: 40),
      Ingredient(name: "Egg", image: _eggImg, baseAmount: 30),
    ],
  ),
  Recipe(
    id: "19",
    name: "Vanilla Ice Cream",
    image: _iceCreamImg,
    category: "Dessert",
    calories: 250,
    time: 45,
    rating: 4.7,
    reviews: 190,
    description: "A rich, creamy, and smooth homemade vanilla ice cream made with real vanilla beans and a rich egg custard base.",
    instructions: [
      "Simmer heavy cream, milk, sugar, and scraped vanilla beans in a saucepan.",
      "Whisk egg yolks in a bowl, then slowly temper them with the hot cream mixture.",
      "Return the mixture to the stove and cook gently until it thickens into a custard.",
      "Chill the custard completely, then churn in an ice cream maker.",
      "Freeze for 2 hours before serving."
    ],
    ingredients: [
      Ingredient(name: "Egg", image: _eggImg, baseAmount: 80),
      Ingredient(name: "Butter", image: _butterImg, baseAmount: 50), // For cream representation
    ],
  ),
  Recipe(
    id: "20",
    name: "BBQ Ribs",
    image: _ribsImg,
    category: "Dinner",
    calories: 700,
    time: 180,
    rating: 4.9,
    reviews: 410,
    description: "Fall-off-the-bone tender pork ribs slow-cooked and slathered in a sticky, sweet, and smoky barbecue sauce.",
    instructions: [
      "Remove the membrane from the back of the ribs and apply a dry rub of paprika, brown sugar, salt, and pepper.",
      "Wrap the ribs tightly in foil and bake at 275°F (135°C) for 2.5 hours.",
      "Remove from foil and brush generously with your favorite BBQ sauce.",
      "Broil or grill on high for 5-10 minutes until the sauce is caramelized and sticky."
    ],
    ingredients: [
      Ingredient(name: "Beef", image: _beefImg, baseAmount: 500), // Using beef img for meat
      Ingredient(name: "Tomato", image: _tomatoImg, baseAmount: 50), // For sauce
    ],
  ),
  Recipe(
    id: "21",
    name: "Chicken Biryani",
    image: _biryaniImg,
    category: "Dinner",
    calories: 600,
    time: 60,
    rating: 4.8,
    reviews: 480,
    description: "A highly aromatic and flavorful Indian dish consisting of spiced basmati rice layered with marinated chicken and caramelized onions.",
    instructions: [
      "Marinate chicken pieces in yogurt, ginger, garlic, and biryani spices for at least 1 hour.",
      "Parboil basmati rice with whole spices until 70% cooked.",
      "In a heavy-bottomed pot, layer the marinated chicken, fried onions, fresh mint, and the parboiled rice.",
      "Drizzle with saffron milk, seal the pot tightly, and cook on low heat (dum) for 30 minutes.",
      "Fluff gently and serve with raita."
    ],
    ingredients: [
      Ingredient(name: "Chicken", image: _chickenImg, baseAmount: 300),
      Ingredient(name: "Rice", image: _riceImg, baseAmount: 200),
      Ingredient(name: "Onion", image: _onionImg, baseAmount: 80),
      Ingredient(name: "Garlic", image: _garlicImg, baseAmount: 15),
    ],
  ),
  Recipe(
    id: "22",
    name: "Classic Lasagna",
    image: _lasagnaImg,
    category: "Dinner",
    calories: 580,
    time: 75,
    rating: 4.8,
    reviews: 370,
    description: "Layers of tender pasta, rich meat sauce, creamy ricotta, and melted mozzarella cheese baked to bubbly perfection.",
    instructions: [
      "Cook a rich meat sauce by browning ground beef and simmering with crushed tomatoes, garlic, and Italian herbs.",
      "Mix ricotta cheese with an egg, parmesan, and parsley.",
      "In a baking dish, layer meat sauce, boiled lasagna noodles, ricotta mixture, and mozzarella cheese.",
      "Repeat the layers, finishing with a generous layer of mozzarella.",
      "Bake at 375°F (190°C) for 45 minutes, letting it rest before slicing."
    ],
    ingredients: [
      Ingredient(name: "Pasta", image: _pastaIngImg, baseAmount: 150),
      Ingredient(name: "Beef", image: _beefImg, baseAmount: 200),
      Ingredient(name: "Cheese", image: _cheeseImg, baseAmount: 150),
      Ingredient(name: "Tomato", image: _tomatoImg, baseAmount: 100),
    ],
  ),
  Recipe(
    id: "23",
    name: "Falafel Wrap",
    image: _falafelImg,
    category: "Lunch",
    calories: 420,
    time: 30,
    rating: 4.6,
    reviews: 220,
    description: "Crispy, golden-brown chickpea falafels wrapped in a warm pita with fresh veggies and a generous drizzle of tahini sauce.",
    instructions: [
      "Blend soaked chickpeas with onions, garlic, parsley, cumin, and coriander until coarsely ground.",
      "Form the mixture into small balls or patties and deep fry until crispy and brown.",
      "Warm a pita bread and spread hummus or tahini inside.",
      "Fill with the hot falafels, diced tomatoes, cucumbers, and mixed greens.",
      "Wrap tightly and serve."
    ],
    ingredients: [
      Ingredient(name: "Vegetables", image: _vegetableImg, baseAmount: 150), // Chickpeas
      Ingredient(name: "Bread", image: _breadImg, baseAmount: 80),
      Ingredient(name: "Tomato", image: _tomatoImg, baseAmount: 40),
    ],
  ),
  Recipe(
    id: "24",
    name: "Quinoa Salad Bowl",
    image: _saladBowlImg,
    category: "Lunch",
    calories: 340,
    time: 20,
    rating: 4.7,
    reviews: 160,
    description: "A nutrient-packed bowl featuring fluffy quinoa, roasted sweet potatoes, fresh kale, avocado, and a lemon-tahini dressing.",
    instructions: [
      "Cook quinoa in vegetable broth until fluffy and let cool slightly.",
      "Roast cubed sweet potatoes with olive oil, salt, and paprika until tender.",
      "Massage fresh chopped kale with a little olive oil to soften it.",
      "Assemble the bowls with quinoa, kale, sweet potatoes, and sliced avocado.",
      "Drizzle generously with a homemade lemon-tahini dressing."
    ],
    ingredients: [
      Ingredient(name: "Vegetables", image: _vegetableImg, baseAmount: 200),
      Ingredient(name: "Avocado", image: _avocadoImg, baseAmount: 80),
      Ingredient(name: "Rice", image: _riceImg, baseAmount: 100), // Using rice img for quinoa
    ],
  ),
  Recipe(
    id: "25",
    name: "Chicken Noodle Soup",
    image: _noodleSoupImg,
    category: "Dinner",
    calories: 280,
    time: 45,
    rating: 4.8,
    reviews: 310,
    description: "A soothing, classic soup loaded with tender chicken, egg noodles, carrots, and celery in a savory, golden broth.",
    instructions: [
      "In a large pot, sauté chopped onions, carrots, and celery in a little butter until softened.",
      "Add chicken broth and bring to a simmer.",
      "Add raw chicken breasts and simmer until cooked through, then remove and shred the meat.",
      "Add egg noodles to the boiling broth and cook until tender.",
      "Return the shredded chicken to the pot, season with salt, pepper, and fresh parsley, and serve hot."
    ],
    ingredients: [
      Ingredient(name: "Chicken", image: _chickenImg, baseAmount: 150),
      Ingredient(name: "Pasta", image: _pastaIngImg, baseAmount: 100),
      Ingredient(name: "Vegetables", image: _vegetableImg, baseAmount: 80),
    ],
  ),
  Recipe(
    id: "26",
    name: "Italian Meatballs",
    image: _meatballsImg,
    category: "Dinner",
    calories: 460,
    time: 40,
    rating: 4.7,
    reviews: 270,
    description: "Juicy, flavorful meatballs made with a blend of ground beef and pork, simmered in a rich marinara sauce.",
    instructions: [
      "Mix ground meat with breadcrumbs, parmesan cheese, minced garlic, egg, and fresh parsley.",
      "Roll the mixture into golf-ball-sized meatballs.",
      "Brown the meatballs in a skillet with olive oil until golden on all sides.",
      "Pour marinara sauce over the meatballs, cover, and simmer gently for 20 minutes.",
      "Serve hot over spaghetti or in a hoagie roll."
    ],
    ingredients: [
      Ingredient(name: "Beef", image: _beefImg, baseAmount: 250),
      Ingredient(name: "Tomato", image: _tomatoImg, baseAmount: 150),
      Ingredient(name: "Cheese", image: _cheeseImg, baseAmount: 40),
    ],
  ),
  Recipe(
    id: "27",
    name: "Loaded Baked Potato",
    image: _bakedPotatoImg,
    category: "Lunch",
    calories: 410,
    time: 60,
    rating: 4.6,
    reviews: 190,
    description: "A large, fluffy baked potato stuffed to the brim with melted cheddar, crispy bacon bits, sour cream, and chives.",
    instructions: [
      "Scrub a large russet potato, pierce it several times with a fork, and rub with olive oil and salt.",
      "Bake at 400°F (200°C) for about 50-60 minutes until the skin is crisp and the inside is tender.",
      "Slice the potato open lengthwise and fluff the insides with a fork.",
      "Mix in butter and shredded cheddar cheese until melted.",
      "Top generously with sour cream, crumbled bacon, and fresh chives."
    ],
    ingredients: [
      Ingredient(name: "Vegetables", image: _vegetableImg, baseAmount: 200), // Potato
      Ingredient(name: "Cheese", image: _cheeseImg, baseAmount: 50),
      Ingredient(name: "Butter", image: _butterImg, baseAmount: 20),
    ],
  ),
  Recipe(
    id: "28",
    name: "Fish and Chips",
    image: _fishChipsImg,
    category: "Lunch",
    calories: 650,
    time: 35,
    rating: 4.8,
    reviews: 300,
    description: "A British classic featuring flaky white fish encased in a light, crispy beer batter, served with thick-cut golden fries.",
    instructions: [
      "Cut potatoes into thick fries and fry them in oil at 320°F (160°C) until tender, then drain.",
      "Prepare a batter using flour, baking powder, salt, and cold beer.",
      "Dip cod or haddock fillets into the batter, letting excess drip off.",
      "Fry the fish in hot oil (375°F/190°C) until deeply golden and crispy.",
      "Increase the oil temperature and fry the potatoes a second time to crisp them up.",
      "Serve hot with tartar sauce and a lemon wedge."
    ],
    ingredients: [
      Ingredient(name: "Salmon", image: _salmonIngImg, baseAmount: 200), // Fish representation
      Ingredient(name: "Vegetables", image: _vegetableImg, baseAmount: 250), // Potatoes
      Ingredient(name: "Bread", image: _breadImg, baseAmount: 50), // Flour
    ],
  ),
  Recipe(
    id: "29",
    name: "Gourmet Hot Dog",
    image: _hotDogImg,
    category: "Lunch",
    calories: 480,
    time: 15,
    rating: 4.4,
    reviews: 140,
    description: "A premium all-beef frankfurter grilled to perfection, nestled in a toasted bun and topped with caramelized onions and spicy mustard.",
    instructions: [
      "Slice onions thinly and slowly caramelize them in a skillet with a little butter and oil until sweet and golden brown.",
      "Grill or pan-fry the hot dogs until they are heated through and have nice char marks.",
      "Lightly toast the hot dog buns.",
      "Place the hot dogs in the buns, top generously with the caramelized onions, and finish with a drizzle of spicy mustard."
    ],
    ingredients: [
      Ingredient(name: "Beef", image: _beefImg, baseAmount: 100), // Hot dog
      Ingredient(name: "Bread", image: _breadImg, baseAmount: 60),
      Ingredient(name: "Onion", image: _onionImg, baseAmount: 40),
    ],
  ),
  Recipe(
    id: "30",
    name: "Breakfast Burrito",
    image: _burritoImg,
    category: "Breakfast",
    calories: 520,
    time: 20,
    rating: 4.7,
    reviews: 260,
    description: "A hearty and satisfying start to the day: a warm flour tortilla packed with scrambled eggs, spicy chorizo, melted cheese, and crispy hash browns.",
    instructions: [
      "Cook the chorizo in a skillet until browned, then remove.",
      "In the same skillet, fry the hash browns until crispy.",
      "Whisk eggs and scramble them gently over medium-low heat.",
      "Warm a large flour tortilla.",
      "Layer the eggs, chorizo, hash browns, and shredded cheese in the center of the tortilla.",
      "Fold in the sides and roll tightly, then optionally toast the burrito seam-side down in the skillet."
    ],
    ingredients: [
      Ingredient(name: "Egg", image: _eggImg, baseAmount: 100),
      Ingredient(name: "Beef", image: _beefImg, baseAmount: 80), // Chorizo
      Ingredient(name: "Cheese", image: _cheeseImg, baseAmount: 40),
      Ingredient(name: "Bread", image: _breadImg, baseAmount: 60), // Tortilla
    ],
  ),
];
