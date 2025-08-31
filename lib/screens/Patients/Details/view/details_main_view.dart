import 'package:flutter/material.dart';
import 'package:glycosync/screens/Patients/Details/view/details1_view.dart';
import 'package:glycosync/screens/Patients/Details/view/details2_view.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:glycosync/screens/Patients/Details/controller/detail_controller.dart';


class DetailsMainView extends StatefulWidget {
  const DetailsMainView({super.key});

  @override
  State<DetailsMainView> createState() => _DetailsMainViewState();
}

class _DetailsMainViewState extends State<DetailsMainView> {
  // A single controller to manage state across all detail pages
  final DetailController _controller = DetailController();

  @override
  Widget build(BuildContext context) {
    // This list now holds all the individual screens for the details flow.
    final List<Widget> detailPages = [
      PersonalInfoStep(controller: _controller),
      DiabetesTypeStep(controller: _controller),

    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // The title for the entire flow
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                'Create Your Profile',
                style: GoogleFonts.lora(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: detailPages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

