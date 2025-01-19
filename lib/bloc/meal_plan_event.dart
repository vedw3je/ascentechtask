import 'package:equatable/equatable.dart';

abstract class MealPlanEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadMealPlans extends MealPlanEvent {}

class AddMealPlan extends MealPlanEvent {
  final dynamic mealPlan;
  AddMealPlan({required this.mealPlan});

  @override
  List<Object> get props => [mealPlan];
}

class EditMealPlan extends MealPlanEvent {
  final int index;
  final Map<String, dynamic> updatedMealPlan;

  EditMealPlan(this.index, this.updatedMealPlan);

  @override
  List<Object> get props => [index, updatedMealPlan];
}

class DeleteMealPlan extends MealPlanEvent {
  final int index;

  // Constructor
  DeleteMealPlan({required this.index});

  @override
  List<Object> get props => [index];
}

class LoadMealPlanDetails extends MealPlanEvent {
  final String mealPlanId;
  final String startTime;
  final String endTime;
  final String mealValue;
  final List<String> items;
  LoadMealPlanDetails({
    required this.mealPlanId,
    required this.startTime,
    required this.endTime,
    required this.mealValue,
    required this.items,
  });
}
