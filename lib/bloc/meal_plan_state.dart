import 'package:equatable/equatable.dart';

abstract class MealPlanState extends Equatable {
  @override
  List<Object> get props => [];
}

class MealPlanInitial extends MealPlanState {}

class MealPlanLoading extends MealPlanState {}

class MealPlanLoaded extends MealPlanState {
  final List<Map<String, dynamic>> mealPlans;

  MealPlanLoaded(this.mealPlans);

  @override
  List<Object> get props => [mealPlans];
}

class MealPlanError extends MealPlanState {
  final String message;

  MealPlanError(this.message);

  @override
  List<Object> get props => [message];
}
