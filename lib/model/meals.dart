class Meal {
  final int id;
  final String type;
  final String startTime;
  final String endTime;
  final List<Item> items;

  Meal({
    required this.id,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.items,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List?)
            ?.map((itemJson) => Item.fromJson(itemJson))
            .toList() ??
        [];

    return Meal(
      id: json['id'] ?? 0, // Default to 0 if `id` is null
      type: json['type'] ?? '', // Default to empty string
      startTime: json['startTime'] ?? '', // Default to empty string
      endTime: json['endTime'] ?? '', // Default to empty string
      items: itemsList,
    );
  }
}

class Item {
  final String diet;
  final String name;

  Item({required this.diet, required this.name});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      diet: json['diet'] ?? '', // Default to empty string
      name: json['name'] ?? '', // Default to empty string
    );
  }
}

class PriceBreakdown {
  final double breakfast;
  final double lunch;
  final double dinner;

  PriceBreakdown({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  factory PriceBreakdown.fromJson(Map<String, dynamic> json) {
    return PriceBreakdown(
      breakfast: (json['breakfast']?.toDouble()) ?? 0.0, // Default to 0.0
      lunch: (json['lunch']?.toDouble()) ?? 0.0, // Default to 0.0
      dinner: (json['dinner']?.toDouble()) ?? 0.0, // Default to 0.0
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Breakfast': breakfast,
      'Lunch': lunch,
      'Dinner': dinner,
    };
  }
}

class MealPlan {
  final int id;
  final String name;
  final String day;
  final String frequency;
  final double amount;
  final PriceBreakdown priceBreakdown;
  final List<Meal>? meals;

  MealPlan({
    required this.id,
    required this.name,
    required this.day,
    required this.frequency,
    required this.amount,
    required this.priceBreakdown,
    this.meals,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'day': day,
      'frequency': frequency,
      'amount': amount,
      'priceBreakdown': priceBreakdown.toMap(),
      'meals': meals?.map((meal) => meal.toString()).toList() ?? [],
    };
  }

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    var mealsList = (json['meals'] as List?)
            ?.map((mealJson) => Meal.fromJson(mealJson))
            .toList() ??
        [];

    return MealPlan(
      id: json['id'] ?? 0, // Default to 0
      name: json['name'] ?? '', // Default to empty string
      day: json['day'] ?? '', // Default to empty string
      frequency: json['frequency'] ?? '', // Default to empty string
      amount: (json['amount']?.toDouble()) ?? 0.0, // Default to 0.0
      priceBreakdown: PriceBreakdown.fromJson(json['priceBreakdown'] ?? {}),
      meals: mealsList,
    );
  }
}

class FoodManagement {
  final List<MealPlan> mealPlans;

  FoodManagement({required this.mealPlans});

  factory FoodManagement.fromJson(Map<String, dynamic> json) {
    var mealPlansList = (json['mealPlans'] as List?)
            ?.map((mealPlanJson) => MealPlan.fromJson(mealPlanJson))
            .toList() ??
        [];

    return FoodManagement(
      mealPlans: mealPlansList,
    );
  }
}
