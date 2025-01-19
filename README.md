MealPal


**1. Home Screen**
The Home Screen displays a list of all saved meal plans.
You can view the meal plans and long-press a card to access the Set Plan Screen for more details.


**2. Add Plan Screen**
On this screen, users can create a new meal plan by entering:
The name of the meal plan.
The individual costs for breakfast, lunch, and dinner.
The frequency of the meals.
After entering these details, users can save the meal plan for future use.


**3. Set Plan Screen**
This screen is accessed by long-pressing a meal card on the Home Screen.
It displays all the details of the selected meal plan, such as meal names, costs, and frequency.
The feature to modify meal plans directly on this screen is still under development.


**Why We Used SharedPreferences**
SharedPreferences is used in this app to save and modify the meal plan data on the user's device. SharedPreferences allows us to store simple key-value pairs (like strings, integers, and booleans) in a persistent way, which is perfect for saving the meal plans without requiring a database.

By saving meal plan data as a JSON file in SharedPreferences, we ensure that the meal plans are preserved even if the app is closed or the device is restarted. This helps us efficiently manage meal plan data without complicated storage systems.

SharedPreferences is particularly helpful for storing user-specific settings and data that doesn't need to be accessed across multiple devices.

**About BLoC Architecture**
BLoC (Business Logic Component) is a state management pattern used in Flutter to separate the business logic from the UI. It helps manage the app's state efficiently and ensures that the UI reacts to changes in data without directly handling the data itself.

In this app, BLoC is used to manage the state of the meal plan creation and modification process. It allows us to:


1) Handle events like adding, updating, or deleting meal plans.

2) Control the app's state in a predictable way by keeping the UI and the business logic separated.

3) Easily test and maintain the logic for handling meal plans without affecting the UI.

By using BLoC, we ensure that the app's state remains consistent, and the UI only reflects the current state, making the app more scalable and easier to maintain in the long run.

Modify feature is not yet complete. You need to add one mealplan in order to see the existing meal details on setplan screen.
