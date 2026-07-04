import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/memoji_model.dart';
import '../../state/app_state.dart';
import '../memoji/detail_screen.dart';
import 'memoji_avatar.dart';
import 'skin_tone_badge.dart';

/// Square, rounded Memoji card with press-scale animation, favorite
/// heart, and a Hero transition into the detail screen.
/// Mixes in [AutomaticKeepAliveClientMixin] so scroll position and
/// press state survive being scrolled off/on screen inside long lists.
class MemojiCard extends StatefulWidget {
  final Memoji memoji;
  final double width;

  const MemojiCard({super.key, required this.memoji, this.width = 148});

  @override
  State<MemojiCard> createState() => _MemojiCardState();
}

class _MemojiCardState extends State<MemojiCard>
    with AutomaticKeepAliveClientMixin {
  bool _pressed = false;

  @override
  bool get wantKeepAlive => true;

  String get _heroTag => 'memoji-hero-${widget.memoji.id}';

  void _openDetail() {
    final state = context.read<MemojiState>();
    state.addRecent(widget.memoji.id);
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 380),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: DetailScreen(memoji: widget.memoji, heroTag: _heroTag),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isFav = context.select<MemojiState, bool>(
      (s) => s.isFavorite(widget.memoji.id),
    );

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: _openDetail,
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: Container(
          width: widget.width,
          padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MemojiAvatar(
                    memoji: widget.memoji,
                    size: 84,
                    heroTag: _heroTag,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.memoji.person,
                    style: AppTextStyles.cardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  SkinToneBadge(tone: widget.memoji.skinTone),
                ],
              ),
              Positioned(
                top: -4,
                right: -4,
                child: _FavoriteButton(
                  isFavorite: isFav,
                  onTap: () => context
                      .read<MemojiState>()
                      .toggleFavorite(widget.memoji.id),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const _FavoriteButton({required this.isFavorite, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Color(0x14000000), blurRadius: 6),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            key: ValueKey(isFavorite),
            size: 16,
            color: isFavorite ? AppColors.brandSecondary : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }
}
