import 'package:flutter/material.dart';
import '../model/empowerment_model.dart';

class EmpowermentController {
  final List<EmpowermentContent> empowermentList = [
    // --- Existing Workout Content ---
    EmpowermentContent(
      title: 'Beginner Yoga for Diabetes',
      description: 'A 20-minute gentle session to improve insulin sensitivity.',
      type: ContentType.workout,
      icon: Icons.self_improvement,
      videoPath: 'assets/videos/yoga1.mp4', // Local video asset
      difficulty: 'Beginner',
      duration: '20 Mins',
      benefits: [
        KeyBenefit(
          'Lowers Blood Sugar',
          'Yoga poses can help muscles uptake glucose, reducing blood sugar levels.',
        ),
        KeyBenefit(
          'Reduces Stress',
          'Lowers cortisol levels, which can positively impact blood pressure and glucose.',
        ),
        KeyBenefit(
          'Improves Circulation',
          'Enhances blood flow, which is crucial for overall diabetic health.',
        ),
      ],
    ),
    EmpowermentContent(
      title: '5-Minute Office Desk Stretches',
      description: 'Relieve stiffness and improve blood flow while at work.',
      type: ContentType.workout,
      icon: Icons.chair,
      videoPath: 'assets/videos/yoga2.mp4', // Local video asset
      difficulty: 'All Levels',
      duration: '5 Mins',
      benefits: [
        KeyBenefit(
          'Prevents Stiffness',
          'Counteracts the negative effects of prolonged sitting.',
        ),
        KeyBenefit(
          'Boosts Energy',
          'Increases blood flow and can improve focus and productivity.',
        ),
        KeyBenefit(
          'Reduces Tension',
          'Helps relieve tension in the neck, shoulders, and back.',
        ),
      ],
    ),
    EmpowermentContent(
      title: 'Why You Should Walk After Meals',
      description: 'Learn why a gentle walk aids digestion and blood sugar.',
      type: ContentType.workout,
      icon: Icons.directions_walk,
      videoPath: 'assets/videos/walk.mp4', // Local video asset
      difficulty: 'Informational',
      duration: '7 Mins',
      benefits: [
        KeyBenefit(
          'Aids Digestion',
          'Gentle movement helps stimulate the digestive system.',
        ),
        KeyBenefit(
          'Blunts Glucose Spike',
          'Helps your body use the glucose from your meal for energy immediately.',
        ),
        KeyBenefit(
          'Improves Heart Health',
          'Contributes to daily physical activity goals.',
        ),
      ],
    ),

    // --- NEW: Additional Workout Content ---
    EmpowermentContent(
      title: '10-Minute Low-Impact Cardio',
      description:
          'Get your heart rate up without stressing your joints. Perfect for a quick energy boost.',
      type: ContentType.workout,
      icon: Icons.directions_run,
      videoPath: 'assets/videos/cardio.mp4', // Assumes you have this asset
      difficulty: 'Beginner',
      duration: '10 Mins',
      benefits: [
        KeyBenefit(
          'Improves Heart Health',
          'Strengthens the cardiovascular system for better overall health.',
        ),
        KeyBenefit(
          'Boosts Metabolism',
          'Helps your body use energy more efficiently, aiding in weight management.',
        ),
        KeyBenefit(
          'Enhances Mood',
          'Releases endorphins, which act as natural mood elevators.',
        ),
      ],
    ),
    EmpowermentContent(
      title: 'Beginner Bodyweight Strength',
      description:
          'Build a strong foundation with simple, effective bodyweight exercises.',
      type: ContentType.workout,
      icon: Icons.fitness_center,
      videoPath: 'assets/videos/strength.mp4', // Assumes you have this asset
      difficulty: 'Beginner',
      duration: '15 Mins',
      benefits: [
        KeyBenefit(
          'Increases Muscle Mass',
          'More muscle helps improve the body\'s sensitivity to insulin.',
        ),
        KeyBenefit(
          'Strengthens Bones',
          'Weight-bearing exercises are crucial for improving bone density.',
        ),
        KeyBenefit(
          'Improves Glucose Uptake',
          'Active muscles draw glucose from the blood for energy during and after exercise.',
        ),
      ],
    ),

    // --- Existing Ayurvedic Medicine Content ---
    EmpowermentContent(
      title: 'The Power of Fenrugreek',
      description: 'Understand how this seed helps in blood sugar regulation.',
      type: ContentType.ayurveda,
      icon: Icons.eco,
      imagePath: 'assets/images/fenugreek.png',
      sourceUrl: 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4591578/',
      benefits: [
        KeyBenefit(
          'Slows Sugar Absorption',
          'Rich in soluble fiber, it forms a gel in the stomach, slowing carbohydrate digestion and preventing sharp blood sugar spikes.',
        ),
        KeyBenefit(
          'Improves Insulin Production',
          'Contains a unique amino acid (4-hydroxyisoleucine) that may enhance insulin secretion.',
        ),
      ],
      howToUse:
          'Soak one to two teaspoons of fenugreek seeds in a glass of water overnight. Drink the water and chew the seeds on an empty stomach in the morning for best results.',
    ),
    EmpowermentContent(
      title: 'Cinnamon and Insulin Sensitivity',
      description:
          'Learn how this common spice can improve your glucose control.',
      type: ContentType.ayurveda,
      icon: Icons.spa,
      imagePath: 'assets/images/cinnamon.png',
      sourceUrl: 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3767714/',
      benefits: [
        KeyBenefit(
          'Mimics Insulin',
          'Bioactive compounds in cinnamon can help cells absorb glucose, essentially acting like insulin.',
        ),
        KeyBenefit(
          'Enhances Insulin Effectiveness',
          'It improves insulin sensitivity, making your body\'s natural insulin work more efficiently.',
        ),
      ],
      howToUse:
          'Add a quarter to a half teaspoon of Ceylon cinnamon powder to your daily diet. You can sprinkle it on oatmeal, yogurt, or add it to warm water or tea.',
    ),
    EmpowermentContent(
      title: 'The Role of Bitter Gourd',
      description:
          'Discover the benefits of this vegetable for diabetes management.',
      type: ContentType.ayurveda,
      icon: Icons.grass,
      imagePath: 'assets/images/bitter_gourd.png',
      sourceUrl: 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4027280/',
      benefits: [
        KeyBenefit(
          'Lowers Blood Glucose',
          'Contains active substances like Charantin and Polypeptide-p, which have a confirmed blood glucose-lowering effect.',
        ),
        KeyBenefit(
          'Improves Glucose Tolerance',
          'Helps the body\'s cells use glucose more effectively, reducing the amount of sugar circulating in the blood.',
        ),
      ],
      howToUse:
          'Drinking a small glass (around 30-50ml) of fresh bitter gourd juice on an empty stomach each morning is the most effective method.',
    ),

    // --- NEW: Additional Ayurveda Content ---
    EmpowermentContent(
      title: 'Amla: The Vitamin C Powerhouse',
      description:
          'Learn how Indian Gooseberry (Amla) can support your diabetic journey.',
      type: ContentType.ayurveda,
      icon: Icons.energy_savings_leaf,
      imagePath: 'assets/images/amla.png', // Using placeholder image
      sourceUrl: 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6950204/',
      benefits: [
        KeyBenefit(
          'Rich in Antioxidants',
          'The high Vitamin C content helps combat oxidative stress, a common complication in diabetes.',
        ),
        KeyBenefit(
          'Supports Pancreatic Function',
          'Contains chromium, which helps in carbohydrate metabolism and may make the body more responsive to insulin.',
        ),
      ],
      howToUse:
          'Mix one teaspoon of Amla powder in a glass of warm water and drink it on an empty stomach in the morning. Alternatively, consume 1-2 fresh amlas daily.',
    ),
    EmpowermentContent(
      title: 'Turmeric: The Golden Spice',
      description:
          'Discover the anti-inflammatory and blood sugar benefits of curcumin in turmeric.',
      type: ContentType.ayurveda,
      icon: Icons.flare,
      imagePath: 'assets/images/turmeric.png', // Using placeholder image
      sourceUrl: 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5664031/',
      benefits: [
        KeyBenefit(
          'Reduces Inflammation',
          'Curcumin, its active compound, is a powerful anti-inflammatory that can help reduce insulin resistance.',
        ),
        KeyBenefit(
          'May Delay Diabetes Onset',
          'Studies suggest it can improve the function of insulin-producing cells in the pancreas.',
        ),
      ],
      howToUse:
          'Drink a glass of warm milk with half a teaspoon of turmeric powder before bed. You can also add it generously to curries and other dishes.',
    ),
  ];

  // Helper methods to filter the list based on type
  List<EmpowermentContent> get workouts => empowermentList
      .where((item) => item.type == ContentType.workout)
      .toList();

  List<EmpowermentContent> get ayurvedicArticles => empowermentList
      .where((item) => item.type == ContentType.ayurveda)
      .toList();
}
