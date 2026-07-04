import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/moods.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/memoji_model.dart';
import '../../providers/profileprovider.dart';
import '../../state/app_state.dart';
import '../memoji_widget/glass_container.dart';
import '../memoji_widget/memoji_avatar.dart';
import '../memoji_widget/skin_tone_badge.dart';

/// Large hero avatar, animated in from the grid, with a glass info card
/// and primary/secondary actions.
class DetailScreen extends StatelessWidget {
  final Memoji memoji;
  final String heroTag;

  const DetailScreen({super.key, required this.memoji, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final moodColor = AppColors.moodColor(memoji.mood);
    final isFav = context.select<MemojiState, bool>((s) => s.isFavorite(memoji.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient gradient backdrop tinted to the mood color.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [moodColor.withOpacity(0.16), AppColors.background],
                  stops: const [0.0, 0.55],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                const Spacer(),
                Hero(
                  tag: heroTag,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: moodColor.withOpacity(0.35),
                          blurRadius: 48,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: MemojiAvatar(memoji: memoji, size: 220),
                  ),
                ),
                const SizedBox(height: 28),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) => Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * 16),
                      child: child,
                    ),
                  ),
                  child: Text(memoji.person, style: AppTextStyles.detailName),
                ),
                const SizedBox(height: 6),
                Text('${Moods.emojiFor(memoji.mood)}  ${memoji.mood}',
                    style: AppTextStyles.subtitle),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: GlassContainer(
                    borderRadius: 24,
                    padding: const EdgeInsets.all(20),
                    tint: Colors.white.withOpacity(0.75),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _InfoTile(label: 'GENDER', value: memoji.gender),
                            ),
                            Container(width: 1, height: 34, color: const Color(0xFFECECF1)),
                            Expanded(
                              child: _InfoTile(label: 'POSTURE', value: memoji.posture),
                            ),
                            Container(width: 1, height: 34, color: const Color(0xFFECECF1)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('SKIN TONE', style: AppTextStyles.detailLabel),
                                  const SizedBox(height: 8),
                                  SkinToneBadge(tone: memoji.skinTone, compact: false),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: const LinearGradient(colors: AppColors.brandGradient),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.brandPrimary.withOpacity(0.35),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: AppColors.textPrimary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      content: Text('${memoji.person} is now your avatar ✨',
                                          style: const TextStyle(color: Colors.white)),
                                    ),
                                  );

                                  final profileProvider = Provider.of<ProfileProvider>(
                                    context,
                                    listen: false,
                                  );
                                  profileProvider.setMemoji(memoji);
                                },
                                child: Center(
                                  child: Text('Use Avatar', style: AppTextStyles.buttonPrimary),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: OutlinedButton(
                            onPressed: () =>
                                context.read<MemojiState>().toggleFavorite(memoji.id),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: AppColors.brandPrimary.withOpacity(0.3),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (child, anim) =>
                                      ScaleTransition(scale: anim, child: child),
                                  child: Icon(
                                    isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                    key: ValueKey(isFav),
                                    size: 18,
                                    color: AppColors.brandSecondary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isFav ? 'Added to Favorites' : 'Add to Favorites',
                                  style: AppTextStyles.buttonSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.detailLabel),
        const SizedBox(height: 8),
        Text(value, style: AppTextStyles.cardTitle),
      ],
    );
  }
}
