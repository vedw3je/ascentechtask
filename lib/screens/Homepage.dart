import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_pal/screens/addplans.dart';
import 'package:meal_pal/screens/setplan.dart';

import '../bloc/meal_plan_bloc.dart';
import '../bloc/meal_plan_event.dart';
import '../bloc/meal_plan_state.dart';
import '../model/meals.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MealPlanBloc>(context).add(LoadMealPlans());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Row(
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.blue,
                    weight: 25,
                  ),
                  SizedBox(width: 2),
                  Text(
                    'Add Plan',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Addplans(),
                  ),
                );
              },
            ),
          ],
          title: const Text(
            'MealPal',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          forceMaterialTransparency: true,
          bottom: TabBar(
            tabs: [
              const Tab(
                  icon: Icon(
                    Icons.food_bank,
                    size: 35,
                  ),
                  text: 'Meal Plan'),
              Tab(
                icon: Image.asset(
                  'assets/menu.png',
                  height: 30,
                ),
                text: 'Menu',
              ),
              const Tab(
                  icon: Icon(
                    Icons.track_changes,
                    size: 35,
                  ),
                  text: 'Meal Track'),
              const Tab(
                  icon: Icon(
                    Icons.feedback,
                    size: 35,
                  ),
                  text: 'Feedback'),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  BlocBuilder<MealPlanBloc, MealPlanState>(
                    builder: (context, state) {
                      if (state is MealPlanLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is MealPlanLoaded) {
                        print(
                            'Rebuilding UI with meal plans: ${state.mealPlans}');
                        return ListView.builder(
                          itemCount: state.mealPlans.length,
                          itemBuilder: (context, index) {
                            final mealPlan =
                                MealPlan.fromJson(state.mealPlans[index]);
                            return MealPlanCard(mealPlan: mealPlan);
                          },
                        );
                      } else if (state is MealPlanError) {
                        return const Center(
                            child: Text('Error loading meal plans'));
                      } else {
                        return const Center(child: Text('No data available'));
                      }
                    },
                  ),
                  const Center(child: Text('Menu')),
                  const Center(child: Text('Meal Track')),
                  const Center(child: Text('Feedback')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MealPlanCard extends StatelessWidget {
  final MealPlan mealPlan;

  const MealPlanCard({Key? key, required this.mealPlan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void deleteMealPlanById(BuildContext context, int id) {
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: const Text(
              "Confirm Delete",
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              "Are you sure you want to delete this meal plan?",
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  Navigator.of(context).pop();

                  context.read<MealPlanBloc>().add(DeleteMealPlan(index: id));
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }

    return GestureDetector(
      onLongPress: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                SetPlanScreen(mealPlanId: mealPlan.id.toString()),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        elevation: 5,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    mealPlan.name,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const Spacer(),
                  IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        deleteMealPlanById(context, mealPlan.id);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.black,
                      )),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: _buildMealTypes(),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 25, 46),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Text(
                    'Amount:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '₹${mealPlan.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMealTypes() {
    return [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildBulletPoint('Breakfast', mealPlan.priceBreakdown.breakfast),
              _buildBulletPoint('Lunch', mealPlan.priceBreakdown.lunch),
            ],
          ),
          _buildBulletPoint('Dinner', mealPlan.priceBreakdown.dinner),
        ],
      )
    ];
  }

  Widget _buildBulletPoint(String mealType, double price) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        const Icon(Icons.circle, size: 8, color: Colors.white),
        const SizedBox(width: 10),
        Text(
          mealType,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }
}
