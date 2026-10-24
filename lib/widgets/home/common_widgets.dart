import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/AppColors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DcAvatar — circular avatar with initials and online dot
// ─────────────────────────────────────────────────────────────────────────────
class DcAvatar extends StatelessWidget {
  final String initials;
  final int colorIndex;
  final double size;
  final bool isOnline;
  final double fontSize;
  final VoidCallback? onTap;
  final bool hasBorder;

  const DcAvatar({
    super.key,
    required this.initials,
    required this.colorIndex,
    this.size = 38,
    this.isOnline = false,
    this.fontSize = 13,
    this.onTap,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: DC.avatarBg(colorIndex),
              shape: BoxShape.circle,
              border: hasBorder
                  ? Border.all(color: c.primary, width: 2)
                  : null,
            ),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w800,
                  color: DC.avatarText(colorIndex),
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
          if (isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: size * 0.27,
                height: size * 0.27,
                decoration: BoxDecoration(
                  color: DC.bg1,
                  shape: BoxShape.circle,
                  border: Border.all(color: c.surface, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DcBadge — colored status pill (theme-aware)
// ─────────────────────────────────────────────────────────────────────────────
class DcBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color textColor;

  const DcBadge({
    super.key,
    required this.label,
    this.bg = DC.bg0,
    this.textColor = DC.textPrimary,
  });

  factory DcBadge.open()      => const DcBadge(label: 'Open',     bg: DC.bg0, textColor: DC.textPrimary);
  factory DcBadge.hackathon() => const DcBadge(label: 'Hackathon',bg: DC.bg1, textColor: DC.textPrimary);
  factory DcBadge.freelance() => const DcBadge(label: 'Freelance',bg: DC.bg1, textColor: DC.textPrimary);
  factory DcBadge.personal()  => const DcBadge(label: 'Personal', bg: DC.bg2, textColor: DC.textPrimary);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: textColor)),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AiBadge — pulsing AI indicator (theme-aware)
// ─────────────────────────────────────────────────────────────────────────────
class AiBadge extends StatefulWidget {
  final String label;
  const AiBadge({super.key, required this.label});

  @override
  State<AiBadge> createState() => _AiBadgeState();
}

class _AiBadgeState extends State<AiBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: c.primaryLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.primary.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _scale,
            builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: 5),
          Text(widget.label, style: DCText.micro.copyWith(color: c.primary)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SkillPill — small tech tag chip (theme-aware)
// ─────────────────────────────────────────────────────────────────────────────
class SkillPill extends StatelessWidget {
  final String label;
  const SkillPill({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      margin: const EdgeInsets.only(right: 4, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: c.primaryLight, borderRadius: BorderRadius.circular(6)),
      child: Text(
        label,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: c.primary),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SectionHeader — "Title" + "See all →" row (theme-aware)
// ─────────────────────────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final bool showDot;
  final VoidCallback? onSeeAll;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.showDot = false,
    this.onSeeAll,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Row(
        children: [
          if (showDot) ...[
            _PulseDot(),
            const SizedBox(width: 6),
          ],
          Text(title, style: DCText.h3.copyWith(color: c.textPrimary)),
          const Spacer(),
          if (trailing != null)
            trailing!
          else if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'See all',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: c.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.8, end: 1.3)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return AnimatedBuilder(
      animation: _scale,
      builder: (_, __) => Transform.scale(
        scale: _scale.value,
        child: Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Skeleton loader — shimmer placeholder (theme-aware)
// ─────────────────────────────────────────────────────────────────────────────
class DcSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const DcSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8,
  });

  const DcSkeleton.circle({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        radius = size / 2;

  @override
  State<DcSkeleton> createState() => _DcSkeletonState();
}

class _DcSkeletonState extends State<DcSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.4, end: 0.85)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return AnimatedBuilder(
      animation: _opacity,
      builder: (_, __) => Opacity(
        opacity: _opacity.value,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: c.surfaceMuted,
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        ),
      ),
    );
  }
}