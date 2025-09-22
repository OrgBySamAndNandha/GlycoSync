import 'package:flutter/material.dart';
import '../model/empowerment_model.dart';

class EmpowermentController {
  final List<EmpowermentContent> empowermentList = [
    // --- Workout Content ---
    EmpowermentContent(
      title: 'Yoga for Diabetes',
      description: 'A 20-minute session to improve insulin sensitivity.',
      type: ContentType.workout,
      icon: Icons.self_improvement,
      gifPath: 'assets/gifs/sun_salutation.gif',
      instructions: [
        'Sun Salutation (Surya Namaskar): 5-7 rounds.',
        'Legs-Up-The-Wall Pose (Viparita Karani): Hold for 2-3 minutes.',
        'Corpse Pose (Savasana): Relax for 5 minutes.',
      ],
    ),
    EmpowermentContent(
      title: 'Desk Stretches',
      description: 'Relieve stiffness and improve blood flow while at work.',
      type: ContentType.workout,
      icon: Icons.chair,
      gifPath: 'assets/gifs/desk_stretch.gif',
      instructions: [
        'Neck Rolls: Gently roll your neck from side to side (3 times each way).',
        'Shoulder Shrugs: Lift your shoulders to your ears, hold, and release (5 times).',
        'Torso Twist: While seated, gently twist your upper body to the right and left.',
      ],
    ),
    EmpowermentContent(
      title: 'Post-Dinner Stroll',
      description: 'A 15-minute gentle walk to aid digestion and lower blood sugar.',
      type: ContentType.workout,
      icon: Icons.directions_walk,
      gifPath: 'assets/gifs/walking.gif',
      instructions: [
        'Start walking 10-15 minutes after finishing your dinner.',
        'Maintain a slow and steady pace.',
        'Focus on your breathing and enjoy the walk.',
      ],
    ),
    // --- Ayurvedic Medicine Content ---
    EmpowermentContent(
      title: 'The Power of Fenugreek',
      description: 'Understand how this seed helps in blood sugar regulation.',
      type: ContentType.ayurveda,
      icon: Icons.eco,
      detailedDoc:
          'Fenugreek (Methi) is a powerful herb used in Ayurvedic medicine for centuries. '
          'It is rich in soluble fiber, which forms a gel-like substance in the stomach. '
          'This action slows down the digestion and absorption of carbohydrates, leading to a more gradual rise in blood sugar levels after meals. '
          'Additionally, an amino acid found in fenugreek may stimulate the production of insulin. '
          'Soaking seeds overnight in water and consuming them in the morning is a common and effective practice.',
    ),
    EmpowermentContent(
      title: 'Cinnamon and Insulin Sensitivity',
      description: 'Learn how this common spice can improve your glucose control.',
      type: ContentType.ayurveda,
      icon: Icons.spa,
      detailedDoc:
          'Cinnamon is more than just a flavorful spice. It contains bioactive compounds that can help lower blood sugar levels. '
          'It works by mimicking the effects of insulin and increasing glucose transport into cells. '
          'Cinnamon can also improve insulin sensitivity, making your body\'s own insulin more effective at clearing sugar from the bloodstream. '
          'Adding a pinch of cinnamon to your morning tea, milk, or oats is an easy way to incorporate it into your diet. '
          'Always choose Ceylon cinnamon for best results.',
    ),
     EmpowermentContent(
      title: 'The Role of Bitter Gourd',
      description: 'Discover the benefits of this vegetable for diabetes management.',
      type: ContentType.ayurveda,
      icon: Icons.grass,
      detailedDoc:
          'Bitter Gourd (Karela) contains at least three active substances with anti-diabetic properties, including charantin, which has been confirmed to have a blood glucose-lowering effect, vicine, and an insulin-like compound known as polypeptide-p. '
          'These substances work either individually or together to help reduce blood sugar levels. '
          'It is also known to help with cellular uptake of glucose and improve glucose tolerance. '
          'Drinking a small glass of bitter gourd juice on an empty stomach is a traditional remedy.',
    ),
  ];

  // Helper methods to filter the list based on type
  List<EmpowermentContent> get workouts =>
      empowermentList.where((item) => item.type == ContentType.workout).toList();

  List<EmpowermentContent> get ayurvedicArticles =>
      empowermentList.where((item) => item.type == ContentType.ayurveda).toList();
}
