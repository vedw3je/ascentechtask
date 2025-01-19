import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'meal_plan_event.dart';
import 'meal_plan_state.dart';

class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  MealPlanBloc() : super(MealPlanInitial()) {
    on<LoadMealPlans>(_loadMealPlans);
    on<AddMealPlan>(_addMealPlan);
    on<EditMealPlan>(_editMealPlan);
    on<DeleteMealPlan>(_deleteMealPlan);
    on<LoadMealPlanDetails>(loadMealPlanDetails);
  }

  List<Map<String, dynamic>> mealPlans = [];

  void loadMealPlanDetails(
      LoadMealPlanDetails event, Emitter<MealPlanState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? foodManagementJsonString = prefs.getString('mealPlans');
    print("Stored JSON: $foodManagementJsonString");

    if (foodManagementJsonString != null &&
        foodManagementJsonString.isNotEmpty) {
      try {
        Map<String, dynamic> foodManagementMap =
            jsonDecode(foodManagementJsonString);
        print(foodManagementMap);

        if (foodManagementMap.containsKey('foodManagement') &&
            foodManagementMap['foodManagement'].containsKey('mealPlans')) {
          List<Map<String, dynamic>> mealPlansList =
              List<Map<String, dynamic>>.from(
                  foodManagementMap['foodManagement']['mealPlans']);
          print(mealPlansList);

          final mealPlanToUpdate = mealPlansList.firstWhere(
            (mealPlan) => mealPlan['id'] == event.mealPlanId,
          );
          print('$mealPlanToUpdate');
          if (mealPlanToUpdate != null) {
            mealPlanToUpdate['startTime'] = event.startTime;
            mealPlanToUpdate['endTime'] = event.endTime;
            mealPlanToUpdate['mealValue'] = event.mealValue;
            mealPlanToUpdate['items'] = event.items;

            foodManagementMap['foodManagement']['mealPlans'] = mealPlansList;

            bool success = await prefs.setString(
                'mealPlans', jsonEncode(foodManagementMap));

            if (success) {
              emit(MealPlanLoaded(mealPlansList));
            } else {
              emit(MealPlanError('Failed to save updated meal plans.'));
            }
          } else {
            emit(MealPlanError(
                'Meal plan with id ${event.mealPlanId} not found.'));
          }
        } else {
          emit(MealPlanError('Meal plans data not found in the stored JSON.'));
        }
      } catch (e) {
        print("Error decoding JSON: $e");
        emit(MealPlanError('Error decoding meal plans.'));
      }
    } else {
      emit(MealPlanError('No meal plans found in SharedPreferences.'));
    }
  }

  void _deleteMealPlan(
      DeleteMealPlan event, Emitter<MealPlanState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? foodManagementJsonString = prefs.getString('mealPlans');
    print("Stored JSON: $foodManagementJsonString");

    if (foodManagementJsonString != null &&
        foodManagementJsonString.isNotEmpty) {
      try {
        Map<String, dynamic> foodManagementMap =
            jsonDecode(foodManagementJsonString);

        if (foodManagementMap.containsKey('foodManagement') &&
            foodManagementMap['foodManagement'].containsKey('mealPlans')) {
          List<Map<String, dynamic>> mealPlansList =
              List<Map<String, dynamic>>.from(
                  foodManagementMap['foodManagement']['mealPlans']);

          final mealPlanToDelete = mealPlansList.firstWhere(
            (mealPlan) => mealPlan['id'] == event.index,
          );

          if (mealPlanToDelete != null) {
            mealPlansList.remove(mealPlanToDelete);

            foodManagementMap['foodManagement']['mealPlans'] = mealPlansList;

            bool success = await prefs.setString(
                'mealPlans', jsonEncode(foodManagementMap));

            if (success) {
              emit(MealPlanLoaded(mealPlansList));
            } else {
              emit(MealPlanError('Failed to save updated meal plans.'));
            }
          } else {
            emit(MealPlanError('Meal plan with id ${event.index} not found.'));
          }
        } else {
          emit(MealPlanError('Meal plans data not found in the stored JSON.'));
        }
      } catch (e) {
        print("Error decoding JSON: $e");
        emit(MealPlanError('Error decoding meal plans.'));
      }
    } else {
      emit(MealPlanError('No meal plans found in SharedPreferences.'));
    }
  }

  Future<void> _saveMealPlansToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = {
      'foodManagement': {'mealPlans': mealPlans},
    };
    await prefs.setString('mealPlans', jsonEncode(jsonData));
  }

  Future<void> _loadMealPlans(
      LoadMealPlans event, Emitter<MealPlanState> emit) async {
    emit(MealPlanLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? storedMealPlansJson = prefs.getString('mealPlans');

      if (storedMealPlansJson != null) {
        final Map<String, dynamic> storedData = jsonDecode(storedMealPlansJson);
        final List<dynamic> storedMealPlans =
            storedData['foodManagement']['mealPlans'];

        if (storedMealPlans.length >= 7) {
          mealPlans =
              storedMealPlans.map((e) => Map<String, dynamic>.from(e)).toList();
          emit(MealPlanLoaded(List.from(mealPlans)));
          return;
        }
      }

      final String response =
          await rootBundle.loadString('assets/mealplan.json');
      print('Raw JSON content: $response');
      final Map<String, dynamic> data = jsonDecode(response);

      final List<dynamic> mealPlansData = data['foodManagement']['mealPlans'];

      mealPlans =
          mealPlansData.map((e) => Map<String, dynamic>.from(e)).toList();

      if (mealPlans.length < 7) {
        await prefs.setString(
            'mealPlans',
            jsonEncode({
              'foodManagement': {
                'mealPlans': mealPlans,
              }
            }));
      }

      emit(MealPlanLoaded(List.from(mealPlans)));
    } catch (e) {
      emit(MealPlanError('Failed to load meal plans: $e'));
    }
  }

  void _addMealPlan(AddMealPlan event, Emitter<MealPlanState> emit) async {
    mealPlans.add(event.mealPlan);
    await _saveMealPlansToSharedPreferences();
    emit(MealPlanLoaded(List.from(mealPlans)));
  }

  void _editMealPlan(EditMealPlan event, Emitter<MealPlanState> emit) {
    if (event.index < 0 || event.index >= mealPlans.length) {
      emit(MealPlanError('Invalid index: ${event.index}'));
      return;
    }
    mealPlans[event.index] = event.updatedMealPlan;
    emit(MealPlanLoaded(List.from(mealPlans)));
  }
}
