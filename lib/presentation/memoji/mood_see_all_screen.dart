import 'package:flutter/material.dart';
import '../../core/constants/moods.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/memoji_model.dart';
import '../memoji_widget/memoji_card.dart';

/// Full grid for a single mood, reached via a section's "See All".
/// Uses GridView.builder so it stays smooth even with hundreds of items.
class MoodSeeAllScreen extends StatelessWidget {
  final String mood;
  final List<Memoji> memojis;

  const MoodSeeAllScreen({super.key, required this.mood, required this.memojis});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(Moods.emojiFor(mood), style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(mood, style: AppTextStyles.sectionTitle),
          ],
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        itemCount: memojis.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.82,
        ),
        itemBuilder: (context, index) =>
            MemojiCard(memoji: memojis[index], width: double.infinity),
      ),
    );
  }
}
