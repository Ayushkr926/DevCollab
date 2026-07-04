import 'package:flutter/material.dart';
import '../../core/constants/moods.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/memoji_model.dart';
import '../memoji/mood_see_all_screen.dart';
import 'memoji_card.dart';

/// One horizontally-scrollable mood row: "😀 Happy   See All"
/// followed by a ListView.builder of MemojiCards.
class MoodSection extends StatelessWidget {
  final String mood;
  final List<Memoji> memojis;

  const MoodSection({super.key, required this.mood, required this.memojis});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Row(
            children: [
              Text(Moods.emojiFor(mood), style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(mood, style: AppTextStyles.sectionTitle),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MoodSeeAllScreen(mood: mood, memojis: memojis),
                  ),
                ),
                child: Row(
                  children: [
                    Text('See All', style: AppTextStyles.seeAll),
                    const Icon(Icons.chevron_right_rounded,
                        size: 16, color: Color(0xFF7C6CF6)),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 184,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: memojis.length > 12 ? 12 : memojis.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: MemojiCard(memoji: memojis[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
