import 'package:flutter/material.dart';
import '../../core/constants/moods.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Horizontal, animated mood filter chips. Selected chip transitions
/// its color and scale smoothly rather than snapping.
class MoodFilterChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const MoodFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: Moods.filterOrder.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final mood = Moods.filterOrder[index];
          final isSelected = mood == selected;
          final color = AppColors.moodColor(mood);
          return GestureDetector(
            onTap: () => onSelected(mood),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? color : const Color(0xFFF4F4F7),
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(Moods.emojiFor(mood), style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: AppTextStyles.chip.copyWith(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                    child: Text(mood),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
