import 'package:flutter/material.dart';
import 'package:glycosync/screens/Patients/Details/model/detail_model.dart';

class DetailController {
  final DetailModel model = DetailModel();
  final PageController pageController = PageController();

  // This function will navigate to the next page in the details flow.
  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  // This function would handle the final submission of all the collected details.
  void saveDetails(BuildContext context) {
    print('All details collected and ready to be saved!');
    // Here you would typically save the 'model' data to Firebase or another backend.

    // After saving, you might navigate to the app's main dashboard.
    // For example:
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => const DashboardView()),
    //   (route) => false,
    // );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile created successfully!')),
    );
  }

  // A method to update the gender in the model and trigger a state update if needed.
  void updateGender(String gender) {
    model.gender = gender;
    // If you were using a state management solution, you would notify listeners here.
  }
}
