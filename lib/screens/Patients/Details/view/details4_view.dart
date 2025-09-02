import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:glycosync/screens/Patients/Details/controller/detail_controller.dart';

class PillsStep extends StatefulWidget {
  final DetailController controller;
  const PillsStep({super.key, required this.controller});

  @override
  State<PillsStep> createState() => _PillsStepState();
}

class _PillsStepState extends State<PillsStep> {
  bool? _takesPills;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Do you take pills for diabetes?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildChoiceCard(context, 'Yes', true, 'assets/animations/yes.json'),
              _buildChoiceCard(context, 'No', false, 'assets/animations/no.json'),
            ],
          ),
          const Spacer(),
          FloatingActionButton(
            onPressed: () {
              if (_takesPills != null) {
                widget.controller.updateTakesPills(_takesPills!);
                widget.controller.nextPage();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select an option.')),
                );
              }
            },
            child: const Icon(Icons.arrow_forward_ios),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildChoiceCard(
      BuildContext context, String text, bool value, String lottieAsset) {
    final isSelected = _takesPills == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _takesPills = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 150,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: Theme.of(context).primaryColor, width: 3)
              : Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(lottieAsset, height: 100),
            const SizedBox(height: 16),
            Text(
              text,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
