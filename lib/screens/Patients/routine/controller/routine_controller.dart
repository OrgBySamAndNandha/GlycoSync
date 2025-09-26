import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/routine_model.dart';

class RoutineController {
  late final ValueNotifier<RoutineModel> modelNotifier;

  RoutineController() {
    // Initialize with an empty model first
    modelNotifier = ValueNotifier(RoutineModel(levels: []));
    // Then load the actual data from Firestore
    _loadAndMergeRoutineData();
  }

  // --- DATA LOADING AND MERGING ---

  Future<void> _loadAndMergeRoutineData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // 1. Get the static, master list of all possible levels.
    final staticModel = _getInitialRoutineData();

    // 2. Get today's completion data from Firestore.
    final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final snapshot = await FirebaseFirestore.instance
        .collection('patients')
        .doc(user.uid)
        .collection('routine_completions')
        .where('completionDate', isEqualTo: todayString)
        .get();

    final completedLevelTitles = snapshot.docs
        .map((doc) => doc['levelTitle'] as String)
        .toSet();

    // 3. Merge the two: Update the status of levels based on completion data.
    bool previousLevelCompleted = true; // Start with true to unlock level 1
    for (var level in staticModel.levels) {
      if (completedLevelTitles.contains(level.title)) {
        level.status = LevelStatus.completed;
        // Mark all subtasks as complete for display purposes
        for (var subtask in level.subTasks) {
          subtask.isCompleted = true;
        }
        previousLevelCompleted = true;
      } else {
        // If not completed, unlock it only if the previous one was completed.
        level.status = previousLevelCompleted
            ? LevelStatus.unlocked
            : LevelStatus.locked;
        previousLevelCompleted = false; // The chain is broken
      }
    }

    // 4. Update the notifier with the final, merged state.
    modelNotifier.value = staticModel;
  }

  // --- USER ACTIONS ---

  void toggleSubTaskCompletion(
    int levelIndex,
    int subTaskIndex,
    bool isCompleted,
  ) {
    final currentModel = modelNotifier.value;
    currentModel.levels[levelIndex].subTasks[subTaskIndex].isCompleted =
        isCompleted;
    modelNotifier.value = currentModel.copyWith(levels: currentModel.levels);
  }

  Future<void> completeLevel(BuildContext context, int levelIndex) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('You must be logged in.')));
      return;
    }

    final currentModel = modelNotifier.value;
    final level = currentModel.levels[levelIndex];

    if (!level.areAllSubTasksCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all sub-tasks for this level.'),
        ),
      );
      return;
    }

    level.status = LevelStatus.completed;

    if (levelIndex + 1 < currentModel.levels.length) {
      currentModel.levels[levelIndex + 1].status = LevelStatus.unlocked;
    }

    // This calculation now correctly sums positive and negative impacts
    final double totalImpact = level.subTasks.fold(
      0.0,
      (sum, task) => sum + task.glucoseImpact,
    );

    // Save to Firestore
    try {
      final collectionRef = FirebaseFirestore.instance
          .collection('patients')
          .doc(user.uid)
          .collection('routine_completions');

      await collectionRef.add({
        'levelTitle': level.title,
        'glucoseImpact':
            totalImpact, // This can now be positive, negative, or zero
        'completionDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'completedAt': Timestamp.now(),
      });

      modelNotifier.value = currentModel.copyWith(levels: currentModel.levels);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${level.title} completed!')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save progress: $e')));
    }
  }

  void dispose() {
    modelNotifier.dispose();
  }

  // --- STATIC DATA SOURCE ---
  // This remains your single source of truth for what a full day's routine looks like.
  RoutineModel _getInitialRoutineData() {
    return RoutineModel(
      levels: [
        RoutineLevel(
          title: 'Level 1: Morning Rise',
          timeRange: '6:00 AM - 9:00 AM',
          icon: Icons.wb_sunny_outlined,
          subTasks: [
            SubTask(
              title: 'Warm Lemon Water',
              description: 'Kickstart your metabolism and hydrate.',
              glucoseImpact: 0.5, // CORRECTED: Slight positive impact
              instructions: [
                'Mix the juice of half a lemon into a glass (250ml) of warm water.',
                'Drink this on an empty stomach.',
              ],
              rationale:
                  'Lemon water can help in cleansing the system and provides a good dose of Vitamin C.',
              calories: 5,
              protein: 0.1,
              carbs: 1.5,
              fat: 0,
            ),
            SubTask(
              title: 'Fenugreek Water',
              description: 'A traditional remedy for blood sugar regulation.',
              glucoseImpact: -1.0, // CORRECTED: Helps lower glucose
              instructions: [
                'Soak 1 teaspoon (5 grams) of fenugreek seeds in a glass (250ml) of water overnight.',
                'In the morning, drink the water and chew the seeds.',
              ],
              rationale:
                  'Fenugreek seeds are high in soluble fiber, which helps lower blood sugar by slowing down carbohydrate digestion and absorption.',
              calories: 15,
              protein: 1,
              carbs: 3,
              fat: 0.5,
            ),
            SubTask(
              title: 'Yoga for Diabetes',
              description:
                  'A 20-minute session to improve insulin sensitivity.',
              glucoseImpact: -5.0, // CORRECTED: Exercise lowers glucose
              instructions: [
                'Sun Salutation (Surya Namaskar): 5-7 rounds.',
                'Legs-Up-The-Wall Pose (Viparita Karani): Hold for 2-3 minutes.',
                'Corpse Pose (Savasana): Relax for 5 minutes.',
              ],
              gifPath:
                  'assets/gifs/sun_salutation.json', // Placeholder animation
              rationale:
                  'Yoga improves circulation, stimulates abdominal organs (like the pancreas), and reduces cortisol (stress hormone) levels, all of which contribute to better glucose control.',
            ),
          ],
        ),
        RoutineLevel(
          title: 'Level 2: Balanced Breakfast',
          timeRange: '8:30 AM - 9:30 AM',
          icon: Icons.free_breakfast,
          subTasks: [
            SubTask(
              title: 'Vegetable Oats Upma',
              description: 'A fiber-rich breakfast for sustained energy.',
              glucoseImpact:
                  15.0, // CORRECTED: Significant positive impact from carbs
              ingredients: [
                'Rolled Oats: 40 grams',
                'Mixed Vegetables (Carrots, Peas, Beans): 50 grams, finely chopped',
                'Onion: 20 grams, chopped',
                'Mustard Seeds: 1/2 teaspoon',
                'Turmeric Powder: 1/4 teaspoon',
                'Salt to taste',
                'Oil: 1 teaspoon',
              ],
              instructions: [
                'Heat oil in a pan, add mustard seeds.',
                'Once they splutter, add onions and sauté until translucent.',
                'Add mixed vegetables, turmeric, and salt. Cook for 5 minutes.',
                'Add oats and 1 cup of water. Cook until the oats are soft and the water is absorbed.',
              ],
              rationale:
                  'Oats are a great source of complex carbohydrates and beta-glucan fiber, which slows glucose absorption.',
              calories: 250,
              protein: 8,
              carbs: 45,
              fat: 5,
            ),
          ],
        ),
        RoutineLevel(
          title: 'Level 3: Mid-Morning Snack',
          timeRange: '11:00 AM - 11:30 AM',
          icon: Icons.eco,
          subTasks: [
            SubTask(
              title: 'Handful of Almonds',
              description: 'A nutrient-dense snack to prevent hunger.',
              glucoseImpact:
                  2.0, // CORRECTED: Low GI, but still a positive impact
              instructions: ['Consume about 10-12 almonds (around 15 grams).'],
              rationale:
                  'Almonds are rich in healthy fats, fiber, and protein, and have a very low glycemic index, making them an excellent snack for blood sugar control.',
              calories: 100,
              protein: 4,
              carbs: 4,
              fat: 9,
            ),
          ],
        ),
        RoutineLevel(
          title: 'Level 4: Mid-Day Fuel',
          timeRange: '12:30 PM - 2:00 PM',
          icon: Icons.restaurant_menu,
          subTasks: [
            SubTask(
              title: 'Cucumber & Tomato Salad',
              description: 'A pre-lunch salad to slow sugar absorption.',
              glucoseImpact: 1.0, // CORRECTED: Very low positive impact
              instructions: [
                'Combine 50g of sliced cucumber and 50g of sliced tomato.',
                'Add a squeeze of lemon juice and a pinch of black pepper.',
                'Eat this 15 minutes before your lunch.',
              ],
              rationale:
                  'The fiber in the salad creates a "gel" in the stomach, slowing the digestion of the meal that follows, leading to a more gradual rise in blood sugar.',
              calories: 25,
              protein: 1,
              carbs: 5,
              fat: 0.2,
            ),
            SubTask(
              title: 'The Balanced Plate',
              description: 'A wholesome meal with a good mix of nutrients.',
              glucoseImpact:
                  25.0, // CORRECTED: Largest meal, largest positive impact
              instructions: [
                'Chapattis: 2 small whole wheat (or multigrain) chapattis.',
                'Dal: 1 small bowl (100g) of cooked lentils (like moong or toor dal).',
                'Vegetable Curry: 1 small bowl (100g) of a non-starchy vegetable curry (e.g., spinach, bottle gourd, cauliflower).',
                'Yogurt: 1 small bowl (100g) of plain, low-fat yogurt.',
              ],
              rationale:
                  'This combination ensures a balanced intake of macronutrients, preventing energy crashes and keeping you full for longer.',
              calories: 450,
              protein: 20,
              carbs: 60,
              fat: 12,
            ),
          ],
        ),
        RoutineLevel(
          title: 'Level 5: Afternoon Recharge',
          timeRange: '4:00 PM - 4:30 PM',
          icon: Icons.self_improvement,
          subTasks: [
            SubTask(
              title: 'Spiced Buttermilk (Chaas)',
              description: 'A refreshing, probiotic-rich drink.',
              glucoseImpact:
                  3.0, // CORRECTED: Contains lactose, positive impact
              instructions: [
                'Blend 100ml of low-fat yogurt with 150ml of water.',
                'Add a pinch of roasted cumin powder and salt.',
                'Mix well and serve chilled.',
              ],
              rationale:
                  'Buttermilk is low in fat and its probiotics are great for gut health. It\'s a much better alternative to sugary teas or coffees.',
              calories: 50,
              protein: 3,
              carbs: 4,
              fat: 2.5,
            ),
            SubTask(
              title: '5-Minute Desk Stretch',
              description: 'Relieve stiffness and improve blood flow.',
              glucoseImpact: -1.0, // CORRECTED: Minor activity, negative impact
              instructions: [
                'Neck Rolls: Gently roll your neck from side to side (3 times each way).',
                'Shoulder Shrugs: Lift your shoulders to your ears, hold, and release (5 times).',
                'Torso Twist: While seated, gently twist your upper body to the right and left (hold for 15 seconds each side).',
              ],
              gifPath: 'assets/gifs/Desk_stretch.json', // Placeholder animation
              rationale:
                  'Prevents muscular stiffness and the metabolic slowdown associated with prolonged sitting.',
            ),
          ],
        ),
        RoutineLevel(
          title: 'Level 6: Evening Wind-Down',
          timeRange: '7:00 PM - 8:30 PM',
          icon: Icons.dinner_dining,
          subTasks: [
            SubTask(
              title: 'Paneer & Veggie Stir-fry',
              description: 'A light, protein-packed dinner.',
              glucoseImpact:
                  8.0, // CORRECTED: Low carb, moderate positive impact
              ingredients: [
                'Paneer (Cottage Cheese): 50 grams, cubed',
                'Mixed Bell Peppers: 75 grams, sliced',
                'Onion: 25 grams, sliced',
                'Ginger-Garlic Paste: 1/2 teaspoon',
                'Soya Sauce (low sodium): 1 teaspoon',
                'Oil: 1 teaspoon',
              ],
              instructions: [
                'Heat oil in a pan, add ginger-garlic paste and onions. Sauté for a minute.',
                'Add bell peppers and cook until slightly tender.',
                'Add paneer cubes and soya sauce. Stir-fry for 2-3 minutes.',
              ],
              rationale:
                  'An early, low-carb dinner prevents high blood sugar levels while you sleep, promoting restful sleep and better morning glucose readings.',
              calories: 220,
              protein: 12,
              carbs: 8,
              fat: 15,
            ),
            SubTask(
              title: 'Gentle Stroll',
              description: 'A 15-minute slow and steady walk after dinner.',
              glucoseImpact: -4.0, // CORRECTED: Post-meal walk is effective
              gifPath: 'assets/gifs/walking.json', // Placeholder animation
              rationale:
                  'Helps your body use the glucose from your dinner for energy, reducing the amount circulating in your blood.',
              instructions: [],
            ),
          ],
        ),
        RoutineLevel(
          title: 'Level 7: Bedtime Preparation',
          timeRange: '9:30 PM - 10:00 PM',
          icon: Icons.bedtime,
          subTasks: [
            SubTask(
              title: 'Cinnamon & Turmeric Milk',
              description: 'A warm, soothing drink to help you relax.',
              glucoseImpact: -1.0, // CORRECTED: Cinnamon helps regulate
              instructions: [
                'Gently warm 150ml of low-fat milk (or almond milk).',
                'Add a pinch of turmeric and a pinch of cinnamon powder.',
                'Stir well. Avoid adding sugar.',
              ],
              rationale:
                  'Cinnamon is known to have properties that can help with blood sugar regulation, while turmeric has anti-inflammatory benefits. A warm drink before bed is also calming.',
              calories: 80,
              protein: 5,
              carbs: 8,
              fat: 3,
            ),
            SubTask(
              title: 'Daily Foot Check',
              description: 'An essential daily habit to prevent complications.',
              glucoseImpact: 0.0, // CORRECTED: No direct glucose impact
              instructions: [
                'Wash your feet with lukewarm water and mild soap.',
                'Dry them thoroughly, especially between the toes.',
                'Inspect your feet for any cuts, sores, blisters, or redness. Use a mirror if needed.',
                'Apply a thin layer of moisturizer, but not between the toes.',
              ],
              rationale:
                  'People with diabetes can have reduced nerve sensation in their feet. A small cut can go unnoticed and become a serious infection. Daily checks are critical for prevention.',
            ),
          ],
        ),
      ],
    );
  }
}
