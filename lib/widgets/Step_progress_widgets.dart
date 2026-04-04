import 'package:flutter/material.dart';

class StepProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Progress bars
        Expanded(
          child: Row(
            children: List.generate(totalSteps, (index) {
              bool isActive = index < currentStep;

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      right: index != totalSteps - 1 ? 6 : 0),
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF6C63FF) // active (purple)
                        : Colors.black12,        // inactive
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }),
          ),
        ),

        const SizedBox(width: 12),

        // Step text (1/3)
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFEDEBFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "$currentStep / $totalSteps",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B3FEA),
            ),
          ),
        ),
      ],
    );
  }
}