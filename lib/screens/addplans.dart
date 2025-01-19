import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_pal/bloc/meal_plan_bloc.dart';

import '../bloc/meal_plan_event.dart';
import '../model/meals.dart';

class Addplans extends StatefulWidget {
  const Addplans({super.key});

  @override
  State<Addplans> createState() => _AddplansState();
}

class _AddplansState extends State<Addplans> {
  bool isPriceBreakdownSelected = false;
  String selectedFrequency = 'Daily';

  final TextEditingController planNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController freqcontroller = TextEditingController();

  final Map<String, TextEditingController> mealControllers = {
    'Breakfast': TextEditingController(),
    'Lunch': TextEditingController(),
    'Dinner': TextEditingController(),
  };

  bool isBreakfastSelected = false;
  bool isLunchSelected = false;
  bool isDinnerSelected = false;

  @override
  void dispose() {
    planNameController.dispose();
    priceController.dispose();
    amountController.dispose();
    freqcontroller.dispose();

    mealControllers.forEach((key, controller) {
      controller.dispose();
    });

    super.dispose();
  }

  void addMealPlan() {
    final formKey = GlobalKey<FormState>();
    if (planNameController.text.isEmpty ||
        mealControllers['Breakfast']!.text.isEmpty ||
        mealControllers['Lunch']!.text.isEmpty ||
        mealControllers['Dinner']!.text.isEmpty ||
        amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final newmealplan = {
      'id': 15,
      'name': planNameController.text,
      'day': 'Sunday',
      'priceBreakdown': PriceBreakdown(
        breakfast:
            double.tryParse(mealControllers['Breakfast']?.text ?? '0') ?? 0.0,
        lunch: double.tryParse(mealControllers['Lunch']?.text ?? '0') ?? 0.0,
        dinner: double.tryParse(mealControllers['Dinner']?.text ?? '0') ?? 0.0,
      ).toMap(),
      'amount': double.tryParse(amountController.text) ?? 0.0,
      'frequency': selectedFrequency,
    };

    print('Adding new meal plan: $newmealplan');

    setState(() {
      context.read<MealPlanBloc>().add(AddMealPlan(mealPlan: newmealplan));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Meal Plan Saved!')),
    );

    Navigator.of(context).pop(newmealplan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Plan'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: planNameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 25),
                        prefixIcon: Icon(Icons.fort_outlined),
                        hintText: 'Enter Plan Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  Text(
                    'Show price breakdown per Meal',
                    style: TextStyle(fontSize: 18),
                  ),
                  Spacer(),
                  Switch(
                    value: isPriceBreakdownSelected,
                    onChanged: (value) {
                      setState(() {
                        isPriceBreakdownSelected = value;
                      });
                    },
                    activeColor: Color.fromARGB(255, 0, 11, 46),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey,
                    activeTrackColor: Colors.blueAccent,
                  )
                ],
              ),
              SizedBox(height: 25),

              _buildMealTypeField('Breakfast', isBreakfastSelected, (value) {
                setState(() {
                  isBreakfastSelected = value;
                });
              }),
              _buildMealTypeField('Lunch', isLunchSelected, (value) {
                setState(() {
                  isLunchSelected = value;
                });
              }),
              _buildMealTypeField('Dinner', isDinnerSelected, (value) {
                setState(() {
                  isDinnerSelected = value;
                });
              }),

              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 25),
                  prefixIcon: Icon(Icons.attach_money),
                  hintText: 'Enter Amount',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(height: 20),

              // Frequency Field
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: freqcontroller,
                      onChanged: (value) {},
                      readOnly: true,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return ListView(
                              children: <Widget>[
                                ListTile(
                                  title: Text('Daily'),
                                  onTap: () {
                                    setState(() {
                                      selectedFrequency = 'Daily';
                                      freqcontroller.text = selectedFrequency;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  title: Text('Weekly'),
                                  onTap: () {
                                    setState(() {
                                      selectedFrequency = 'Weekly';
                                      freqcontroller.text = selectedFrequency;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  title: Text('Monthly'),
                                  onTap: () {
                                    setState(() {
                                      selectedFrequency = 'Monthly';
                                      freqcontroller.text = selectedFrequency;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 25),
                        hintText: 'Select Frequency',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        prefixIcon:
                            Icon(Icons.calendar_today, color: Colors.grey),
                        suffixIcon:
                            Icon(Icons.arrow_drop_down, color: Colors.grey),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),

              Center(
                  child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blue, border: Border.symmetric()),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        addMealPlan();
                      });
                    },
                    child: Text(
                      'Save And Continue',
                      style: TextStyle(color: Colors.white),
                    )),
              ))
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for each meal type with tick option and text field for price
  Widget _buildMealTypeField(
      String meal, bool isSelected, Function(bool) onChanged) {
    return Row(
      children: [
        Checkbox(
          value: isSelected,
          onChanged: (bool? value) {
            onChanged(value!);
          },
        ),
        Text(meal, style: TextStyle(fontSize: 16)),
        if (isPriceBreakdownSelected) ...[
          Spacer(),
          Expanded(
            child: TextField(
              controller: mealControllers[meal],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '₹',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
