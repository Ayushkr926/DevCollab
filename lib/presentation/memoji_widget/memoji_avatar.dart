import 'package:flutter/material.dart';
import '../../core/constants/moods.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/memoji_model.dart';

/// Renders the actual Memoji PNG when available at [memoji.imagePath].
/// Falls back to a soft gradient + mood emoji placeholder so the app is
/// fully demo-able before real art assets are wired in — drop your real
/// 3,000+ PNGs into assets/images/memojis/ and this renders them as-is.
class MemojiAvatar extends StatelessWidget {
  final Memoji memoji;
  final double size;
  final String? heroTag;

  const MemojiAvatar({
    super.key,
    required this.memoji,
    this.size = 96,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.28),
      child: Image.asset(
        memoji.imagePath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
        gaplessPlayback: true,
      ),
    );

    final content = SizedBox(width: size, height: size, child: image);

    if (heroTag == null) return content;
    return Hero(tag: heroTag!, child: content);
  }

  Widget _placeholder() {
    final color = AppColors.moodColor(memoji.mood);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.85), color.withOpacity(0.45)],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        Moods.emojiFor(memoji.mood),
        style: TextStyle(fontSize: size * 0.42),
      ),
    );
  }
}
