import 'package:flutter/foundation.dart';

class Ingredient {
  final String name;
  final String image;
  final double baseAmount; // Amount for 1 serving

  const Ingredient({
    required this.name,
    required this.image,
    required this.baseAmount,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      baseAmount: (json['baseAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'baseAmount': baseAmount,
    };
  }

  factory Ingredient.fromFirestore(Map<String, dynamic> data) {
    return Ingredient.fromJson(data);
  }

  Map<String, dynamic> toFirestore() {
    return toJson();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Ingredient &&
        other.name == name &&
        other.image == image &&
        other.baseAmount == baseAmount;
  }

  @override
  int get hashCode => name.hashCode ^ image.hashCode ^ baseAmount.hashCode;
}

class Recipe {
  final String id;
  final String name;
  final String image;
  final String category;
  final int calories;
  final int time;
  final double rating;
  final int reviews;
  final List<Ingredient> ingredients;
  final String description;
  final List<String> instructions;

  const Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.calories,
    required this.time,
    required this.rating,
    required this.reviews,
    required this.ingredients,
    required this.description,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      category: json['category'] as String? ?? '',
      calories: json['calories'] as int? ?? 0,
      time: json['time'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: json['reviews'] as int? ?? 0,
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      description: json['description'] as String? ?? '',
      instructions: (json['instructions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'category': category,
      'calories': calories,
      'time': time,
      'rating': rating,
      'reviews': reviews,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'description': description,
      'instructions': instructions,
    };
  }

  factory Recipe.fromFirestore(String documentId, Map<String, dynamic> data) {
    return Recipe(
      id: documentId,
      name: data['name'] as String? ?? '',
      image: data['image'] as String? ?? '',
      category: data['category'] as String? ?? '',
      calories: data['calories'] as int? ?? 0,
      time: data['time'] as int? ?? 0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: data['reviews'] as int? ?? 0,
      ingredients: (data['ingredients'] as List<dynamic>?)
              ?.map((e) => Ingredient.fromFirestore(e as Map<String, dynamic>))
              .toList() ??
          const [],
      description: data['description'] as String? ?? '',
      instructions: (data['instructions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'image': image,
      'category': category,
      'calories': calories,
      'time': time,
      'rating': rating,
      'reviews': reviews,
      'ingredients': ingredients.map((e) => e.toFirestore()).toList(),
      'description': description,
      'instructions': instructions,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Recipe &&
        other.id == id &&
        other.name == name &&
        other.image == image &&
        other.category == category &&
        other.calories == calories &&
        other.time == time &&
        other.rating == rating &&
        other.reviews == reviews &&
        listEquals(other.ingredients, ingredients) &&
        other.description == description &&
        listEquals(other.instructions, instructions);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        image.hashCode ^
        category.hashCode ^
        calories.hashCode ^
        time.hashCode ^
        rating.hashCode ^
        reviews.hashCode ^
        ingredients.hashCode ^
        description.hashCode ^
        instructions.hashCode;
  }
}
