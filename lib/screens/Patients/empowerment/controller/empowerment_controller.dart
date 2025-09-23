import 'package:flutter/material.dart';
import '../model/empowerment_model.dart';

class EmpowermentController {
  final List<EmpowermentContent> empowermentList = [
    // --- NEW: Enriched Workout Content with new, unrestricted YouTube Links ---
    EmpowermentContent(
      title: 'Beginner Yoga for Diabetes',
      description: 'A 20-minute gentle session to improve insulin sensitivity.',
      type: ContentType.workout,
      icon: Icons.self_improvement,
      youtubeVideoId: 's2n2y33v6mU', // New, unrestricted video
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
      youtubeVideoId: 'g_Nn0glnf3k', // New, unrestricted video
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
      youtubeVideoId: 'J2ckA21tO0Y', // New, unrestricted video
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

    // --- Ayurvedic Medicine Content (Unchanged) ---
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
  ];

  // Helper methods to filter the list based on type
  List<EmpowermentContent> get workouts => empowermentList
      .where((item) => item.type == ContentType.workout)
      .toList();

  List<EmpowermentContent> get ayurvedicArticles => empowermentList
      .where((item) => item.type == ContentType.ayurveda)
      .toList();
}
