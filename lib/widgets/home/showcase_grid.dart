// lib/widgets/home/showcase_grid.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/showcase_post.dart';
import '../../utils/app_theme.dart';
import 'common_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ShowcaseGrid — Pinterest-style masonry grid
// Uses two explicit columns (no package dependency) for simplicity.
// Odd-index items get extra height to create the masonry illusion.
// ─────────────────────────────────────────────────────────────────────────────
class ShowcaseGrid extends StatelessWidget {
  final List<ShowcasePost> posts;
  final void Function(String postId) onLike;
  final void Function(ShowcasePost post) onTap;

  const ShowcaseGrid({
    super.key,
    required this.posts,
    required this.onLike,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) return const _EmptyShowcase();

    // Split into two columns
    final leftCol = <ShowcasePost>[];
    final rightCol = <ShowcasePost>[];
    for (var i = 0; i < posts.length; i++) {
      if (i.isEven) {
        leftCol.add(posts[i]);
      } else {
        rightCol.add(posts[i]);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _Column(posts: leftCol, onLike: onLike, onTap: onTap, isLeft: true)),
          const SizedBox(width: 6),
          Expanded(child: _Column(posts: rightCol, onLike: onLike, onTap: onTap, isLeft: false)),
        ],
      ),
    );
  }
}

class _Column extends StatelessWidget {
  final List<ShowcasePost> posts;
  final void Function(String) onLike;
  final void Function(ShowcasePost) onTap;
  final bool isLeft;

  const _Column({
    required this.posts,
    required this.onLike,
    required this.onTap,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: posts.asMap().entries.map((entry) {
        // Alternate heights for masonry effect
        final isShort = (entry.key + (isLeft ? 0 : 1)).isEven;
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: _ShowcaseCard(
            post: entry.value,
            imageHeight: isShort ? 90.0 : 120.0,
            onLike: onLike,
            onTap: onTap,
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual showcase card
// ─────────────────────────────────────────────────────────────────────────────
class _ShowcaseCard extends StatefulWidget {
  final ShowcasePost post;
  final double imageHeight;
  final void Function(String) onLike;
  final void Function(ShowcasePost) onTap;

  const _ShowcaseCard({
    required this.post,
    required this.imageHeight,
    required this.onLike,
    required this.onTap,
  });

  @override
  State<_ShowcaseCard> createState() => _ShowcaseCardState();
}

class _ShowcaseCardState extends State<_ShowcaseCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _heartCtrl;
  late final Animation<double> _heartScale;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _heartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _heartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.5), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.5, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _heartCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _heartCtrl.dispose();
    super.dispose();
  }

  void _handleLike() {
    HapticFeedback.lightImpact();
    _heartCtrl.forward(from: 0);
    widget.onLike(widget.post.id);
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return GestureDetector(
      onTap: () => widget.onTap(post),
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
        child: Container(
          decoration: DCDecoration.card(radius: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image / graphic placeholder ─────────────────────────────
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: _PostImage(
                  post: post,
                  height: widget.imageHeight,
                ),
              ),

              // ── Content ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(9, 7, 9, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author row
                    Row(
                      children: [
                        DcAvatar(
                          initials: post.authorInitials,
                          colorIndex: post.authorColorIndex,
                          size: 16,
                          fontSize: 7,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            post.authorName.split(' ').first,
                            style: DCText.micro.copyWith(
                              fontWeight: FontWeight.w700,
                              color: DC.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (post.isTrending)
                          Text(
                            '↑ hot',
                            style: DCText.micro.copyWith(color: DC.g, fontWeight: FontWeight.w800),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Title
                    Text(
                      post.title,
                      style: DCText.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: DC.textPrimary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),

                    // Tech + Like row
                    Row(
                      children: [
                        Text(post.techStack, style: DCText.micro),
                        const Spacer(),
                        GestureDetector(
                          onTap: _handleLike,
                          child: Row(
                            children: [
                              AnimatedBuilder(
                                animation: _heartScale,
                                builder: (_, __) => Transform.scale(
                                  scale: _heartScale.value,
                                  child: Icon(
                                    post.isLikedByMe
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    size: 13,
                                    color: post.isLikedByMe ? DC.pk : DC.gr,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${post.likes}',
                                style: DCText.micro.copyWith(
                                  color: post.isLikedByMe ? DC.pk : DC.gr,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Post image — uses network image with placeholder graphic fallback
// ─────────────────────────────────────────────────────────────────────────────
class _PostImage extends StatelessWidget {
  final ShowcasePost post;
  final double height;

  const _PostImage({required this.post, required this.height});

  // Map colorIndex → placeholder gradient pair
  static const _palettes = [
    [Color(0xFFEEEDFE), Color(0xFF7F77DD)], // purple
    [Color(0xFFE1F5EE), Color(0xFF1D9E75)], // green
    [Color(0xFFFAEEDA), Color(0xFFEF9F27)], // amber
    [Color(0xFFFAECE7), Color(0xFFD85A30)], // coral
    [Color(0xFFFBEAF0), Color(0xFFD4537E)], // pink
    [Color(0xFFE6F1FB), Color(0xFF378ADD)], // blue
  ];

  @override
  Widget build(BuildContext context) {
    final palette = _palettes[post.authorColorIndex % _palettes.length];

    if (post.imageUrl.isNotEmpty) {
      return Image.network(
        post.imageUrl,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(palette, height),
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _placeholder(palette, height);
        },
      );
    }
    return _placeholder(palette, height);
  }

  Widget _placeholder(List<Color> palette, double h) {
    return SizedBox(
      height: h,
      child: CustomPaint(
        painter: _PlaceholderPainter(bg: palette[0], accent: palette[1]),
        size: Size.infinite,
      ),
    );
  }
}

class _PlaceholderPainter extends CustomPainter {
  final Color bg;
  final Color accent;
  const _PlaceholderPainter({required this.bg, required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = bg);

    final p = Paint()..color = accent.withOpacity(0.25);

    // Decorative rects (UI mockup feel)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.08, size.height * 0.12,
            size.width * 0.84, size.height * 0.76),
        const Radius.circular(6),
      ),
      Paint()..color = accent.withOpacity(0.08),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.14, size.height * 0.18,
            size.width * 0.48, size.height * 0.14),
        const Radius.circular(4),
      ),
      p,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.14, size.height * 0.40,
            size.width * 0.72, size.height * 0.36),
        const Radius.circular(4),
      ),
      Paint()..color = Colors.white.withOpacity(0.5),
    );
    // Subtle lines
    final lp = Paint()
      ..color = accent.withOpacity(0.3)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.22, size.height * 0.50),
      Offset(size.width * 0.6, size.height * 0.50),
      lp,
    );
    canvas.drawLine(
      Offset(size.width * 0.22, size.height * 0.60),
      Offset(size.width * 0.75, size.height * 0.60),
      lp..color = accent.withOpacity(0.18),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Skeleton grid for loading state
// ─────────────────────────────────────────────────────────────────────────────
class ShowcaseGridSkeleton extends StatelessWidget {
  const ShowcaseGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _SkeletonCol(heights: const [100, 130, 90])),
          const SizedBox(width: 6),
          Expanded(child: _SkeletonCol(heights: const [130, 90, 110])),
        ],
      ),
    );
  }
}

class _SkeletonCol extends StatelessWidget {
  final List<double> heights;
  const _SkeletonCol({required this.heights});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: heights.map((h) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Container(
          height: h,
          decoration: DCDecoration.card(),
          child: const DcSkeleton(width: double.infinity, height: double.infinity, radius: 14),
        ),
      )).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyShowcase extends StatelessWidget {
  const _EmptyShowcase();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.grid_view_rounded, size: 40, color: DC.gr),
          const SizedBox(height: 12),
          Text('No posts yet', style: DCText.h3.copyWith(color: DC.gr)),
          const SizedBox(height: 6),
          Text('Be the first to showcase your work!',
              style: DCText.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}