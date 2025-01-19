import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_pal/bloc/meal_plan_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../bloc/meal_plan_bloc.dart';
import '../bloc/meal_plan_state.dart';
import 'Homepage.dart';

class SetPlanScreen extends StatefulWidget {
  final String mealPlanId;

  const SetPlanScreen({Key? key, required this.mealPlanId}) : super(key: key);

  @override
  _SetPlanScreenState createState() => _SetPlanScreenState();
}

class _SetPlanScreenState extends State<SetPlanScreen> {
  String mealPlanId = '';
  String? breakfastStartTime = '';
  String? breakfastEndTime = '';
  String? lunchStartTime = '';
  String? lunchEndTime = '';
  String? dinnerStartTime = '';
  String? dinnerEndTime = '';
  String mealValue = '';
  String? breakfastItem1Type = '';
  String? breakfastItem1Name = '';
  String? breakfastItem2Type = '';
  String? breakfastItem2Name = '';

  String? lunchItem1Type = '';
  String? lunchItem1Name = '';
  String? lunchItem2Type = '';
  String? lunchItem2Name = '';

  String? dinnerItem1Type = '';
  String? dinnerItem1Name = '';
  String? dinnerItem2Type = '';
  String? dinnerItem2Name = '';

  @override
  void initState() {
    super.initState();
    fetchMealPlanDetails();
    mealPlanId = widget.mealPlanId;
  }

  Future<void> fetchMealPlanDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? foodManagementJsonString = prefs.getString('mealPlans');

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
          print(mealPlansList);
          print(mealPlanId);
          final mealPlan = mealPlansList.firstWhere(
            (mealPlan) => mealPlan['id'].toString() == mealPlanId.toString(),
            orElse: () => {},
          );
          print('mealplan : $mealPlan');

          if (mealPlan.isNotEmpty) {
            setState(() {
              breakfastStartTime = mealPlan['meals'][0]['startTime'];
              breakfastEndTime = mealPlan['meals'][0]['endTime'];
              lunchEndTime = mealPlan['meals'][1]['endTime'];
              lunchStartTime = mealPlan['meals'][1]['startTime'];
              dinnerStartTime = mealPlan['meals'][2]['startTime'];
              dinnerEndTime = mealPlan['meals'][2]['endTime'];
              breakfastItem1Type = mealPlan['meals'][0]['items'][0]['diet'];
              breakfastItem1Name = mealPlan['meals'][0]['items'][0]['name'];

              breakfastItem2Type = mealPlan['meals'][0]['items'][1]['diet'];
              breakfastItem2Name = mealPlan['meals'][0]['items'][1]['name'];
              lunchItem1Type = mealPlan['meals'][1]['items'][0]['diet'];
              lunchItem1Name = mealPlan['meals'][1]['items'][0]['name'];
              print(lunchItem1Name);

              lunchItem2Type = mealPlan['meals'][1]['items'][1]['diet'];
              lunchItem2Name = mealPlan['meals'][1]['items'][1]['name'];

              dinnerItem1Type = mealPlan['meals'][2]['items'][0]['diet'];
              dinnerItem1Name = mealPlan['meals'][2]['items'][0]['name'];

              dinnerItem2Type = mealPlan['meals'][2]['items'][1]['diet'];
              dinnerItem2Name = mealPlan['meals'][2]['items'][1]['name'];
            });
          } else {
            print("Meal Plan with id $mealPlanId not found");
          }
        } else {
          print("Meal plans data not found in stored JSON.");
        }
      } catch (e) {
        print("Error decoding JSON: $e");
      }
    } else {
      print("No meal plans found in SharedPreferences.");
    }
  }

  Future<void> updateMealPlanDetails(String mealPlanId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? foodManagementJsonString = prefs.getString('mealPlans');

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
          print(mealPlansList);

          final mealPlanIndex = mealPlansList.indexWhere(
            (mealPlan) => mealPlan['id'].toString() == mealPlanId.toString(),
          );

          if (mealPlanIndex != -1) {
            Map<String, dynamic> mealPlan = mealPlansList[mealPlanIndex];

            // Ensure `meals` structure exists
            mealPlan['meals'] ??= List.generate(
                3,
                (_) => {
                      'startTime': 0, // Use default `int` values
                      'endTime': 0,
                      'items':
                          List.generate(2, (_) => {'diet': '', 'name': ''}),
                    });

            // Ensure each meal has at least 2 items
            for (var meal in mealPlan['meals']) {
              meal['startTime'] ??= 0;
              meal['endTime'] ??= 0;

              meal['items'] ??=
                  List.generate(2, (_) => {'diet': '', 'name': ''});
              if (meal['items'].length < 2) {
                meal['items'] =
                    List.generate(2, (_) => {'diet': '', 'name': ''});
              }
            }

            // Update meal times
            mealPlan['meals'][0]['startTime'] = breakfastStartTime ?? 0;
            mealPlan['meals'][0]['endTime'] = breakfastEndTime ?? 0;
            mealPlan['meals'][1]['startTime'] = lunchStartTime ?? 0;
            mealPlan['meals'][1]['endTime'] = lunchEndTime ?? 0;
            mealPlan['meals'][2]['startTime'] = dinnerStartTime ?? 0;
            mealPlan['meals'][2]['endTime'] = dinnerEndTime ?? 0;

            // Update meal items
            mealPlan['meals'][0]['items'][0]['diet'] = breakfastItem1Type ?? '';
            mealPlan['meals'][0]['items'][0]['name'] = breakfastItem1Name ?? '';

            mealPlan['meals'][0]['items'][1]['diet'] = breakfastItem2Type ?? '';
            mealPlan['meals'][0]['items'][1]['name'] = breakfastItem2Name ?? '';

            mealPlan['meals'][1]['items'][0]['diet'] = lunchItem1Type ?? '';
            mealPlan['meals'][1]['items'][0]['name'] = lunchItem1Name ?? '';

            mealPlan['meals'][1]['items'][1]['diet'] = lunchItem2Type ?? '';
            mealPlan['meals'][1]['items'][1]['name'] = lunchItem2Name ?? '';

            mealPlan['meals'][2]['items'][0]['diet'] = dinnerItem1Type ?? '';
            mealPlan['meals'][2]['items'][0]['name'] = dinnerItem1Name ?? '';

            mealPlan['meals'][2]['items'][1]['diet'] = dinnerItem2Type ?? '';
            mealPlan['meals'][2]['items'][1]['name'] = dinnerItem2Name ?? '';

            // Save the updated meal plan
            mealPlansList[mealPlanIndex] = mealPlan;
            foodManagementMap['foodManagement']['mealPlans'] = mealPlansList;
            String updatedJsonString = jsonEncode(foodManagementMap);
            await prefs.setString('mealPlans', updatedJsonString);
            setState(() {});

            print("Meal Plan updated successfully");
          } else {
            print("Meal Plan with id $mealPlanId not found");
          }
        } else {
          print("Meal plans data not found in stored JSON.");
        }
      } catch (e) {
        print("Error decoding or updating JSON: $e");
      }
    } else {
      print("No meal plans found in SharedPreferences.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title:
            const Text('Set Meal Plan', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildMealCard(context, "Breakfast"),
            const SizedBox(height: 16),
            _buildMealCard(context, "Lunch"),
            const SizedBox(height: 16),
            _buildMealCard(context, "Dinner"),
            const SizedBox(
              height: 20,
            ),
            Center(
                child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      updateMealPlanDetails(mealPlanId);
                      Navigator.pop(context);
                    });
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w800),
                  )),
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, String mealType) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Colors.grey),
      ),
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  mealType == "Breakfast"
                      ? Icons.free_breakfast
                      : mealType == "Lunch"
                          ? Icons.lunch_dining
                          : Icons.dinner_dining,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  mealType,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (mealType == 'Breakfast') ...[
                  _buildTimeField("Start Time", breakfastStartTime ?? "",
                      (value) {
                    setState(() {
                      breakfastStartTime = value;
                    });
                  }),
                  const SizedBox(width: 20),
                  _buildTimeField("End Time", breakfastEndTime ?? "", (value) {
                    setState(() {
                      breakfastEndTime = value;
                    });
                  }),
                ] else if (mealType == 'Lunch') ...[
                  _buildTimeField("Start Time", lunchStartTime ?? "", (value) {
                    setState(() {
                      lunchStartTime = value;
                    });
                  }),
                  const SizedBox(width: 20),
                  _buildTimeField("End Time", lunchEndTime ?? "", (value) {
                    setState(() {
                      lunchEndTime = value;
                    });
                  }),
                ] else if (mealType == 'Dinner') ...[
                  _buildTimeField("Start Time", dinnerStartTime ?? "", (value) {
                    setState(() {
                      dinnerStartTime = value;
                    });
                  }),
                  const SizedBox(width: 20),
                  _buildTimeField("End Time", dinnerEndTime ?? "", (value) {
                    setState(() {
                      dinnerEndTime = value;
                    });
                  }),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "$mealType List",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8),
            _buildMealItems(mealType),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.blueGrey,
                mini: true,
                onPressed: () {
                  fetchMealPlanDetails();

                  _addMeal(context, mealType);
                },
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField(
      String label, String initialValue, ValueChanged<String> onChanged) {
    TextEditingController controller =
        TextEditingController(text: initialValue);

    Future<void> _selectTime(BuildContext context) async {
      final initialTime = const TimeOfDay(hour: 8, minute: 30);

      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );

      if (pickedTime != null) {
        final formattedTime = pickedTime.format(context);
        controller.text = formattedTime;
        onChanged(formattedTime);
      }
    }

    TimeOfDay _parseTime(String timeString) {
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      return TimeOfDay(hour: hour, minute: minute);
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[700],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: controller,
                    onChanged: onChanged,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    readOnly: true,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.access_time, color: Colors.white),
                  onPressed: () => _selectTime(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealItems(String mealType) {
    List<Widget> mealWidgets = [];

    if (mealType == "Breakfast") {
      mealWidgets.add(_buildMealItem(breakfastItem1Name!, breakfastItem1Type!));
      mealWidgets.add(_buildMealItem(breakfastItem2Name!, breakfastItem2Type!));
    } else if (mealType == "Lunch") {
      mealWidgets.add(_buildMealItem(lunchItem1Name!, lunchItem1Type!));
      mealWidgets.add(_buildMealItem(lunchItem2Name!, lunchItem2Type!));
    } else if (mealType == "Dinner") {
      mealWidgets.add(_buildMealItem(dinnerItem1Name!, dinnerItem1Type!));
      mealWidgets.add(_buildMealItem(dinnerItem2Name!, dinnerItem2Type!));
    }

    return Column(
      children: mealWidgets,
    );
  }

  Widget _buildMealItem(String? itemName, String? dietType) {
    // Define default colors for Veg and Non-Veg
    const Color vegDotColor = Colors.green;
    const Color nonVegDotColor = Colors.red;

    // Fallbacks for null values
    String currentItemName = itemName ?? ''; // Default to an empty string
    String currentDietType = dietType ?? ''; // Default to an empty string

    // Boolean flags based on the diet type
    bool isVegSelected = currentDietType == "veg";
    bool isNonVegSelected = currentDietType == "non-veg";

    // If the item name is empty, show input and options
    if (currentItemName.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                currentItemName = value; // Update item name
              });
            },
            decoration: const InputDecoration(
              labelText: 'Enter Meal Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Diet Type:'),
                    RadioListTile<String>(
                      title: const Text('Veg'),
                      value: 'veg',
                      groupValue:
                          currentDietType.isEmpty ? null : currentDietType,
                      onChanged: (value) {
                        setState(() {
                          isVegSelected;
                          currentDietType = value ?? ''; // Update diet type
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Non-Veg'),
                      value: 'non-veg',
                      groupValue:
                          currentDietType.isEmpty ? null : currentDietType,
                      onChanged: (value) {
                        setState(() {
                          isNonVegSelected;
                          currentDietType = value ?? ''; // Update diet type
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Save action logic (if needed)
              });
            },
            child: const Text('Save Meal'),
          ),
        ],
      );
    } else {
      // Display meal information if itemName is not empty
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            currentItemName,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: vegDotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              _buildCheckbox(isVegSelected, (value) {
                setState(() {
                  if (value != null && value) {
                    currentDietType = "veg"; // Update diet to Veg
                  } else {
                    currentDietType = ""; // Clear selection
                  }
                });
              }),
            ],
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: nonVegDotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              _buildCheckbox(isNonVegSelected, (value) {
                setState(() {
                  if (value != null && value) {
                    currentDietType = "non-veg"; // Update diet to Non-Veg
                  } else {
                    currentDietType = ""; // Clear selection
                  }
                });
              }),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildCheckbox(bool isChecked, ValueChanged<bool?> onChanged) {
    return GestureDetector(
      onTap: () {
        onChanged(!isChecked); // Toggle the check state
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white),
        ),
        child: Icon(
          isChecked ? Icons.check : null, // Show a check icon when selected
          color: isChecked ? Colors.blue : Colors.transparent, // Color the icon
        ),
      ),
    );
  }

  void _addMeal(BuildContext context, String mealType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[850],
        title: Text("Add $mealType Meal",
            style: const TextStyle(color: Colors.white)),
        content: const Text(
            "Functionality to add meals will be implemented here.",
            style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text("Close", style: TextStyle(color: Colors.blueGrey)),
          ),
        ],
      ),
    );
  }
}
