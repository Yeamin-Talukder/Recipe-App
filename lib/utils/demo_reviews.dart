import 'package:cloud_firestore/cloud_firestore.dart';

// ---------------------------------------------------------------------------
// Demo reviews for seeding Firestore.
// Key = recipe id (String). Value = list of review maps.
// Each review map uses userId as the document ID (one review per user).
// ---------------------------------------------------------------------------

Map<String, List<Map<String, dynamic>>> get demoReviews => {
      // 1 — Classic Cheeseburger
      '1': [
        _r('user_demo_001', 'Marcus Thompson', 5.0,
            'Absolutely nailed it! Juicy patty, melted cheese, perfect buns. My family asks for this every weekend now.',
            days: 3),
        _r('user_demo_002', 'Priya Sharma', 5.0,
            "Best homemade burger I've ever had. The seasoning tip with salt & pepper makes all the difference.",
            days: 10),
        _r('user_demo_003', 'Jake Wilson', 4.0,
            'Really solid recipe. I added caramelized onions on top — took it to the next level!',
            days: 18),
        _r('user_demo_004', 'Sofia Andrade', 5.0,
            'Made this for a BBQ and everyone was asking for the recipe. Definitely a keeper.',
            days: 30),
        _r('user_demo_005', "Liam O'Brien", 4.0,
            'Great flavors. I used ground chuck which made the patty extra juicy.',
            days: 45),
      ],

      // 2 — Spaghetti Carbonara
      '2': [
        _r('user_demo_006', 'Chiara Rossi', 5.0,
            "Authentic and rich. I'm Italian and this recipe is spot on — no cream needed!",
            days: 5),
        _r('user_demo_007', 'David Park', 4.0,
            'Took me two tries to get the egg mixture right off the heat, but totally worth the effort.',
            days: 14),
        _r('user_demo_008', 'Amara Okonkwo', 5.0,
            'Silky, creamy, and incredibly flavorful. Easily restaurant-quality at home.',
            days: 22),
        _r('user_demo_009', 'Elena Petrov', 4.0,
            'The tip about tossing vigorously off the heat is the key. Perfect result.',
            days: 40),
        _r('user_demo_010', 'Noah Cruz', 5.0,
            'My go-to weeknight dinner now. Under 30 minutes and tastes incredible.',
            days: 60),
      ],

      // 3 — Avocado Toast
      '3': [
        _r('user_demo_011', 'Zoe Campbell', 5.0,
            'Simple, fresh, and so satisfying. The chili flakes add a perfect kick!',
            days: 2),
        _r('user_demo_012', 'Ben Nguyen', 4.0,
            'Love this for brunch. I add a squeeze of extra lime — really brightens it up.',
            days: 12),
        _r('user_demo_013', 'Mia Kowalski', 5.0,
            'The poached egg on top makes it a full meal. Highly recommend.',
            days: 25),
        _r('user_demo_014', 'Caleb Foster', 4.0,
            'Healthy and delicious. My go-to breakfast before work.',
            days: 38),
      ],

      // 4 — Grilled Salmon
      '4': [
        _r('user_demo_015', 'Hannah Lee', 5.0,
            'Perfectly flaky and so flavorful. Fresh dill and lemon is the magic combo.',
            days: 4),
        _r('user_demo_016', 'Ethan Rivera', 5.0,
            "Restaurant quality at home. I can't believe how easy this is.",
            days: 11),
        _r('user_demo_017', 'Isabelle Dupont', 5.0,
            'The cast-iron skillet gives the skin an incredible crunch. Outstanding!',
            days: 21),
        _r('user_demo_018', 'Aiden Murphy', 4.0,
            'Used a charcoal grill and the smoky flavor paired with the herbs was unbeatable.',
            days: 35),
        _r('user_demo_019', 'Luna Martinez', 5.0,
            'My favorite healthy dinner recipe. Quick, clean, and absolutely delicious.',
            days: 50),
      ],

      // 5 — Spicy Beef Tacos
      '5': [
        _r('user_demo_020', 'Carlos Vega', 5.0,
            'These are amazing! The spice level is just right and the homemade salsa makes them pop.',
            days: 6),
        _r('user_demo_021', 'Olivia Bennett', 4.0,
            'So good! I added jalapenos for extra heat. My friends loved them.',
            days: 15),
        _r('user_demo_022', 'Ryan Cho', 5.0,
            'Quick Taco Tuesday staple now. Way better than any fast food version.',
            days: 28),
        _r('user_demo_023', 'Emma Walsh', 4.0,
            'Great recipe. I swapped in turkey mince for a lighter option and it still tasted amazing.',
            days: 42),
      ],

      // 6 — Shoyu Ramen
      '6': [
        _r('user_demo_024', 'Kenji Yamamoto', 5.0,
            'This brought me right back to Tokyo. The soy broth is deep and complex — absolutely authentic.',
            days: 7),
        _r('user_demo_025', 'Sara Kim', 5.0,
            'Made this on a cold rainy day and it was pure comfort in a bowl.',
            days: 16),
        _r('user_demo_026', 'Tyler Brooks', 4.0,
            'Took some prep time but 100% worth it. The soft-boiled egg with the ramen is divine.',
            days: 30),
        _r('user_demo_027', 'Fatima Al-Hassan', 5.0,
            'Absolutely delicious. I made the chashu from scratch and it melted in my mouth.',
            days: 48),
        _r('user_demo_028', 'Jack Donnelly', 5.0,
            'My new favorite comfort food. The umami broth is everything.',
            days: 65),
      ],

      // 7 — Fluffy Pancakes
      '7': [
        _r('user_demo_029', 'Grace Turner', 5.0,
            "These are LIFE CHANGING. So thick and fluffy — I'll never use box mix again.",
            days: 1),
        _r('user_demo_030', 'Henry Adams', 5.0,
            'Perfect weekend breakfast. My kids absolutely devoured them with maple syrup.',
            days: 9),
        _r('user_demo_031', 'Nadia Svensson', 5.0,
            "The buttermilk is the secret! Lightest, fluffiest pancakes I've ever made.",
            days: 20),
        _r('user_demo_032', 'Oscar Lima', 4.0,
            "Delicious! Tip: don't overmix the batter — the lumps disappear during cooking.",
            days: 33),
        _r('user_demo_033', 'Chloe Patel', 5.0,
            'My Sunday morning tradition now. Added blueberries on top — perfection!',
            days: 55),
      ],

      // 8 — Chicken Curry
      '8': [
        _r('user_demo_034', 'Raj Patel', 5.0,
            "This is incredibly close to my grandmother's recipe. The coconut milk makes it so rich.",
            days: 8),
        _r('user_demo_035', 'Sophie Martin', 4.0,
            'Wonderful flavor. I added extra ginger and it was superb.',
            days: 19),
        _r('user_demo_036', 'Daniel Osei', 5.0,
            'The aroma while cooking is incredible. This curry is a true crowd-pleaser.',
            days: 32),
        _r('user_demo_037', 'Yuki Tanaka', 4.0,
            'Great recipe. I simmered it longer for an even deeper flavor — highly recommend.',
            days: 52),
      ],

      // 9 — Chocolate Brownie
      '9': [
        _r('user_demo_038', 'Lily Chen', 5.0,
            "The most fudgy, gooey brownies I've ever tasted. That crinkly top is pure perfection.",
            days: 3),
        _r('user_demo_039', 'Max Hoffman', 5.0,
            'Baked exactly 25 minutes as instructed and the center was gloriously fudgy. 10/10.',
            days: 13),
        _r('user_demo_040', 'Aria Johnson', 5.0,
            'These disappeared within minutes at my party. Absolutely divine.',
            days: 24),
        _r('user_demo_041', 'Tom Bradley', 4.0,
            'Very rich and chocolatey. I added sea salt flakes on top — next level!',
            days: 40),
        _r('user_demo_042', 'Nina Kowalczyk', 5.0,
            "I've tried dozens of brownie recipes. This is definitively the best.",
            days: 58),
      ],

      // 10 — Mac and Cheese
      '10': [
        _r('user_demo_043', 'Sam Rivera', 5.0,
            'This beats Kraft by a mile. Creamy, cheesy, and so satisfying.',
            days: 5),
        _r('user_demo_044', 'Jasmine White', 5.0,
            'The gruyere and cheddar combo is brilliant. Restaurant quality at home.',
            days: 17),
        _r('user_demo_045', 'Lucas Pereira', 4.0,
            'So good! I added breadcrumbs on top and broiled it for a crunchy crust.',
            days: 29),
        _r('user_demo_046', 'Amelia Scott', 5.0,
            "The ultimate comfort food done right. My family's new favorite.",
            days: 44),
      ],

      // 11 — Club Sandwich
      '11': [
        _r('user_demo_047', 'Chris Evans', 5.0,
            'Classic and delicious. The triple layer makes it so satisfying.',
            days: 6),
        _r('user_demo_048', 'Rachel Green', 4.0,
            'Love this for a quick lunch. I used homemade mayo and it was incredible.',
            days: 18),
        _r('user_demo_049', 'Alex Turner', 4.0,
            'Simple and tasty. I added avocado — highly recommend!',
            days: 35),
      ],

      // 12 — Herb Roasted Chicken
      '12': [
        _r('user_demo_050', 'Patricia Moore', 5.0,
            "The crispiest, most flavorful roast chicken I've ever made. The lemon in the cavity is genius.",
            days: 7),
        _r('user_demo_051', 'George Harris', 5.0,
            'Absolutely stunning Sunday roast. Basted it twice and it came out golden and perfect.',
            days: 16),
        _r('user_demo_052', 'Sandra Clark', 5.0,
            'The fresh herbs under the butter make it taste incredible. Made this for Christmas — got rave reviews!',
            days: 30),
        _r('user_demo_053', 'James Lewis', 4.0,
            'Excellent recipe. The 15-minute rest before carving keeps all the juices in.',
            days: 50),
        _r('user_demo_054', 'Maria Garcia', 5.0,
            "Perfect roast every time. My family's Sunday tradition now.",
            days: 70),
      ],

      // 13 — Mushroom Risotto
      '13': [
        _r('user_demo_055', 'Isabella Romano', 5.0,
            'Creamy, earthy, and absolutely perfect. Stirring continuously is key!',
            days: 8),
        _r('user_demo_056', 'William Jones', 4.0,
            'The white wine adds a lovely depth. I used a mix of wild mushrooms — fantastic.',
            days: 22),
        _r('user_demo_057', 'Emma Davis', 5.0,
            'Restaurant quality risotto at home. The parmesan finish is everything.',
            days: 40),
        _r('user_demo_058', 'Luca Ferrari', 4.0,
            'Excellent technique guide. The gradual broth addition makes the texture silky.',
            days: 60),
      ],

      // 14 — Seafood Paella
      '14': [
        _r('user_demo_059', 'Antonio Ruiz', 5.0,
            'The saffron gives it that gorgeous golden color and authentic flavor. Reminded me of Valencia!',
            days: 5),
        _r('user_demo_060', 'Charlotte Hughes', 5.0,
            'Made this for a dinner party — everyone was speechless. The socarrat crust at the bottom is incredible.',
            days: 15),
        _r('user_demo_061', 'Michael Brown', 4.0,
            'Very impressive dish. The key is not stirring once the rice is in!',
            days: 28),
        _r('user_demo_062', 'Valentina Cruz', 5.0,
            'Perfect paella. The chorizo adds such depth to the broth.',
            days: 45),
        _r('user_demo_063', 'Oliver Robinson', 4.0,
            'Takes effort but the result is spectacular. My new favorite special occasion dish.',
            days: 65),
      ],

      // 15 — Tomato Bruschetta
      '15': [
        _r('user_demo_064', 'Francesca Bianchi', 5.0,
            'So fresh and vibrant! The balsamic drizzle is the perfect finishing touch.',
            days: 3),
        _r('user_demo_065', 'Andrew Taylor', 4.0,
            'Perfect summer appetizer. I used heirloom tomatoes and it looked gorgeous.',
            days: 14),
        _r('user_demo_066', 'Mia Bergstrom', 5.0,
            'The garlic-rubbed toast makes all the difference. Simple perfection.',
            days: 28),
      ],

      // 16 — Blueberry Muffins
      '16': [
        _r('user_demo_067', 'Claire Dubois', 5.0,
            'The streusel topping makes these absolutely irresistible. Moist, fluffy, and bursting with blueberries.',
            days: 6),
        _r('user_demo_068', "Patrick O'Connor", 4.0,
            'Perfect bakery-style muffins at home. My kids ask for these every weekend.',
            days: 20),
        _r('user_demo_069', 'Sophie Muller', 5.0,
            'These came out bakery-perfect. I added a hint of lemon zest — highly recommend.',
            days: 38),
        _r('user_demo_070', 'Finn Larsen', 4.0,
            'Light, fluffy, and not too sweet. The fresh blueberries are key.',
            days: 55),
      ],

      // 17 — Butter Croissant
      '17': [
        _r('user_demo_071', 'Julie Moreau', 5.0,
            'I spent a whole weekend making these and they were absolutely worth every fold. Flaky, buttery perfection!',
            days: 10),
        _r('user_demo_072', 'Pierre Lambert', 5.0,
            'Truly authentic. The lamination technique guide was so clear and helpful.',
            days: 25),
        _r('user_demo_073', 'Anya Petrov', 4.0,
            'Challenging but rewarding. Mine looked like real Parisian croissants!',
            days: 45),
        _r('user_demo_074', 'Tom Watson', 5.0,
            "The best baking project I've ever done. The result is absolutely stunning.",
            days: 70),
      ],

      // 18 — Glazed Donuts
      '18': [
        _r('user_demo_075', 'Ashley Chen', 5.0,
            'Light, airy, and that glaze is perfection! So much better than store-bought.',
            days: 4),
        _r('user_demo_076', 'Jake Morrison', 4.0,
            'The second fry makes them perfectly crispy. Worth every step!',
            days: 18),
        _r('user_demo_077', 'Lauren Kim', 5.0,
            'Made these for a bake sale and sold out immediately. The recipe is foolproof.',
            days: 35),
        _r('user_demo_078', 'Brandon Lee', 4.0,
            'Fluffy and delicious. I dipped some in chocolate too — incredible.',
            days: 52),
      ],

      // 19 — Vanilla Ice Cream
      '19': [
        _r('user_demo_079', 'Sophia Martinez', 5.0,
            "Real vanilla beans make a world of difference. This is the creamiest ice cream I've ever made.",
            days: 9),
        _r('user_demo_080', 'Ethan Williams', 4.0,
            'The custard base technique is excellent. Rich, smooth, and absolutely delicious.',
            days: 22),
        _r('user_demo_081', 'Ava Thompson', 5.0,
            'My family said it was better than any ice cream shop. Pure heaven.',
            days: 40),
      ],

      // 20 — BBQ Ribs
      '20': [
        _r('user_demo_082', 'Derek Jackson', 5.0,
            'Fall-off-the-bone tender. The dry rub is incredible and the caramelized sauce finish is legendary.',
            days: 6),
        _r('user_demo_083', 'Melissa Harris', 5.0,
            'Worth every hour of cooking. The 2.5 hours in foil makes them absolutely perfect.',
            days: 20),
        _r('user_demo_084', 'Connor Murphy', 4.0,
            'Best ribs I have ever made at home. The broiling step at the end is key.',
            days: 38),
        _r('user_demo_085', 'Tanya Robinson', 5.0,
            'Incredible flavor. I used homemade BBQ sauce and it was unbelievable.',
            days: 58),
      ],

      // 21 — Chicken Biryani
      '21': [
        _r('user_demo_086', 'Arjun Sharma', 5.0,
            'The dum cooking method gives it that authentic restaurant flavor. Absolutely magnificent.',
            days: 4),
        _r('user_demo_087', 'Preethi Nair', 5.0,
            'The layering technique and saffron milk make this truly special. This is the real deal!',
            days: 14),
        _r('user_demo_088', 'Zara Ahmed', 5.0,
            'Marinating the chicken overnight made it incredibly tender. Best biryani I have cooked at home.',
            days: 28),
        _r('user_demo_089', 'Hassan Ali', 4.0,
            'Excellent recipe! The fried onions add such a beautiful caramel depth.',
            days: 45),
        _r('user_demo_090', 'Ananya Das', 5.0,
            "This is my grandmother's taste in a modern recipe. Truly exceptional.",
            days: 65),
      ],

      // 22 — Classic Lasagna
      '22': [
        _r('user_demo_091', 'Marco Colombo', 5.0,
            'The layering technique is perfect. The meat sauce and ricotta combination is absolutely divine.',
            days: 7),
        _r('user_demo_092', 'Elena Rossi', 5.0,
            "Better than any Italian restaurant I've been to. The mozzarella finish is perfect.",
            days: 19),
        _r('user_demo_093', 'Stefan Weber', 4.0,
            'Excellent comfort food. I added Italian sausage to the meat sauce — wow.',
            days: 35),
        _r('user_demo_094', 'Giulia Marino', 5.0,
            "Perfect lasagna. The resting time before slicing is crucial — don't skip it!",
            days: 55),
      ],

      // 23 — Falafel Wrap
      '23': [
        _r('user_demo_095', 'Leila Hassan', 5.0,
            'Crispy outside, fluffy inside — just like the falafel I had in Cairo. Wonderful recipe!',
            days: 5),
        _r('user_demo_096', 'Omar Saad', 4.0,
            'The tahini drizzle makes these perfect. I added pickled vegetables too.',
            days: 18),
        _r('user_demo_097', 'Ruby Anderson', 5.0,
            'My favorite veggie meal. So flavorful and filling!',
            days: 33),
        _r('user_demo_098', 'Malik Johnson', 4.0,
            'Great texture on the falafel. The soaking step for chickpeas is essential.',
            days: 50),
      ],

      // 24 — Quinoa Salad Bowl
      '24': [
        _r('user_demo_099', 'Jessica Taylor', 5.0,
            'The lemon-tahini dressing is absolutely incredible. This bowl is nutritious AND delicious!',
            days: 8),
        _r('user_demo_100', 'Nathan Green', 4.0,
            'Great healthy meal prep option. I make a big batch and eat it all week.',
            days: 22),
        _r('user_demo_101', 'Sarah Mitchell', 5.0,
            'The massaged kale technique makes such a difference — so tender.',
            days: 40),
      ],

      // 25 — Chicken Noodle Soup
      '25': [
        _r('user_demo_102', 'Dorothy Wilson', 5.0,
            "Like a warm hug in a bowl. This is the ultimate comfort food when you're feeling under the weather.",
            days: 3),
        _r('user_demo_103', 'Charlie Brown', 5.0,
            'The golden broth is everything. Shredding the chicken into the soup is key.',
            days: 15),
        _r('user_demo_104', 'Alice Cooper', 4.0,
            'Classic and comforting. I added a parmesan rind while simmering — amazing depth!',
            days: 28),
        _r('user_demo_105', 'Bob Marley', 5.0,
            "My family's favorite when someone is sick. Works like magic.",
            days: 45),
      ],

      // 26 — Italian Meatballs
      '26': [
        _r('user_demo_106', 'Giovanni Esposito', 5.0,
            "These taste like my nonna's recipe. The browning step before simmering is essential.",
            days: 9),
        _r('user_demo_107', 'Camille Bernard', 4.0,
            'Incredibly juicy and flavorful. I served them over fresh pasta — bellissimo!',
            days: 24),
        _r('user_demo_108', 'Victor Santos', 5.0,
            'The parmesan in the meatball mix is the secret. Absolutely outstanding.',
            days: 42),
        _r('user_demo_109', 'Anna Nowak', 4.0,
            'Great recipe. The marinara sauce absorbed the flavors beautifully.',
            days: 60),
      ],

      // 27 — Loaded Baked Potato
      '27': [
        _r('user_demo_110', 'Greg Miller', 5.0,
            'The crispy skin and fluffy interior are perfect. The loaded toppings make it a full meal!',
            days: 11),
        _r('user_demo_111', 'Karen White', 4.0,
            'Super easy and incredibly satisfying. I added chili on top — game changer.',
            days: 26),
        _r('user_demo_112', 'Steve Rogers', 4.0,
            'Great comfort food. The olive oil rub on the skin makes it perfectly crispy.',
            days: 44),
      ],

      // 28 — Fish and Chips
      '28': [
        _r('user_demo_113', 'Harry Potter', 5.0,
            'Perfectly crispy beer batter and fluffy fish inside. Tastes like a proper British chippy!',
            days: 6),
        _r('user_demo_114', 'Hermione Granger', 5.0,
            'The double-fry method for the chips is a revelation. Crispy and golden every time.',
            days: 20),
        _r('user_demo_115', 'Ron Weasley', 4.0,
            'Brilliant recipe! I used haddock and it was absolutely perfect with tartar sauce.',
            days: 38),
        _r('user_demo_116', 'Ginny Weasley', 5.0,
            'Spot on fish and chips. The beer batter puffs up beautifully.',
            days: 58),
      ],

      // 29 — Gourmet Hot Dog
      '29': [
        _r('user_demo_117', 'Bobby Flay', 4.0,
            'The caramelized onions make this gourmet! Worth the extra 20 minutes.',
            days: 7),
        _r('user_demo_118', 'Julia Child', 4.0,
            'Elevated street food at its finest. The spicy mustard is the perfect companion.',
            days: 21),
        _r('user_demo_119', 'Gordon Ramsay', 5.0,
            'Simple but elegant. The char marks on the frank and the sweet onions are perfection.',
            days: 40),
      ],

      // 30 — Breakfast Burrito
      '30': [
        _r('user_demo_120', 'Elena Flores', 5.0,
            'The most satisfying breakfast ever! The crispy hash browns inside make it extraordinary.',
            days: 4),
        _r('user_demo_121', 'Carlos Mendez', 4.0,
            'Hearty and delicious. I added salsa and it was absolutely perfect.',
            days: 16),
        _r('user_demo_122', 'Maria Lopez', 5.0,
            'The toasting step at the end creates a perfect crispy wrap. My husband asks for this every Sunday.',
            days: 30),
        _r('user_demo_123', 'Jose Ramirez', 4.0,
            'Great breakfast burrito. I used spicy chorizo and it was incredible.',
            days: 48),
      ],
    };

/// Helper to build a review map with a past [days] offset.
Map<String, dynamic> _r(
  String userId,
  String userName,
  double rating,
  String comment, {
  required int days,
}) {
  return {
    'userId': userId,
    'userName': userName,
    'userPhoto': null,
    'rating': rating,
    'comment': comment,
    'createdAt': Timestamp.fromDate(
      DateTime.now().subtract(Duration(days: days)),
    ),
  };
}
