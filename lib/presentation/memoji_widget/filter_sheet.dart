import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/moods.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../state/app_state.dart';

/// Bottom sheet for advanced filtering: gender, skin tone, and mood.
/// Reads/writes directly to [MemojiState]; the sheet itself is stateless
/// with respect to filter values so nothing gets out of sync.
class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MemojiState>();

    return DraggableScrollableSheet(
      initialChildSize: 0.62,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4E4EA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters', style: AppTextStyles.largeTitle.copyWith(fontSize: 24)),
                  TextButton(
                    onPressed: () => context.read<MemojiState>().clearFilters(),
                    child: Text('Reset', style: AppTextStyles.seeAll),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Gender', style: AppTextStyles.detailLabel),
              const SizedBox(height: 10),
              Row(
                children: [
                  _OptionChip(
                    label: 'Any',
                    selected: state.selectedGender == null,
                    onTap: () => context.read<MemojiState>().setGenderFilter(null),
                  ),
                  const SizedBox(width: 8),
                  _OptionChip(
                    label: 'male',
                    selected: state.selectedGender == 'male',
                    onTap: () => context.read<MemojiState>().setGenderFilter('male'),
                  ),
                  const SizedBox(width: 8),
                  _OptionChip(
                    label: 'female',
                    selected: state.selectedGender == 'female',
                    onTap: () => context.read<MemojiState>().setGenderFilter('female'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Skin Tone', style: AppTextStyles.detailLabel),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _OptionChip(
                    label: 'Any',
                    selected: state.selectedSkinTone == null,
                    onTap: () => context.read<MemojiState>().setSkinToneFilter(null),
                  ),
                  for (final tone in AppColors.skinTones.keys)
                    _OptionChip(
                      label: tone,
                      swatch: AppColors.skinToneColor(tone),
                      selected: state.selectedSkinTone == tone,
                      onTap: () =>
                          context.read<MemojiState>().setSkinToneFilter(tone),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Mood', style: AppTextStyles.detailLabel),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final mood in Moods.filterOrder)
                    _OptionChip(
                      label: '${Moods.emojiFor(mood)} $mood',
                      selected: state.selectedMood == mood,
                      onTap: () => context.read<MemojiState>().setMoodFilter(mood),
                    ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  child: Text('Show Results', style: AppTextStyles.buttonPrimary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OptionChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? swatch;

  const _OptionChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.swatch,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.brandPrimary : const Color(0xFFF4F4F7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (swatch != null) ...[
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: swatch, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTextStyles.chip.copyWith(
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
