import 'package:flutter/material.dart';
import 'package:glycosync/screens/Patients/Details/view/details1_view.dart';
import 'package:glycosync/screens/Patients/Details/view/details2_view.dart';
import 'package:glycosync/screens/Patients/Details/view/details3_view.dart';
import 'package:glycosync/screens/Patients/Details/view/details4_view.dart';
import 'package:glycosync/screens/Patients/Details/view/details5_view.dart';
import 'package:glycosync/screens/Patients/Details/view/details6_view.dart';
import 'package:glycosync/screens/Patients/Details/view/details7_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glycosync/screens/Patients/Details/controller/detail_controller.dart';

class DetailsMainView extends StatefulWidget {
  const DetailsMainView({super.key});

  @override
  State<DetailsMainView> createState() => _DetailsMainViewState();
}

class _DetailsMainViewState extends State<DetailsMainView> {
  final DetailController _controller = DetailController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Listen to page changes to show/hide the back button
    _controller.pageController.addListener(() {
      if (_controller.pageController.page?.round() != _currentPageIndex) {
        setState(() {
          _currentPageIndex = _controller.pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This list now holds all the individual screens for the details flow in the correct order.
    final List<Widget> detailPages = [
      PersonalInfoStep(controller: _controller),
      PhysicalMetricsStep(controller: _controller),
      PillsStep(controller: _controller),
      InsulinTherapyStep(controller: _controller),
      DiabetesTypeStep(controller: _controller),
      UnitsStep(controller: _controller),
      GoalsStep(controller: _controller),
    ];

    return Scaffold(
      // Added an AppBar for the back button and title
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Create Your Profile',
          style: GoogleFonts.lora(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87, // Title color
          ),
        ),
        // Conditionally display the back button
        leading: _currentPageIndex > 0
            ? IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () {
            _controller.previousPage(); // Navigate back
          },
        )
            : null, // No button on the first page
      ),
      body: PageView(
        controller: _controller.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: detailPages,
      ),
    );
  }
}

