// lib/widgets/home/home_widgets.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Screens/storyviewscreen.dart';
import '../../models/hackathon.dart';
import '../../utils/app_theme.dart';
import '../../utils/AppColors.dart';
import 'common_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HomeSearchBar
// ─────────────────────────────────────────────────────────────────────────────
class HomeSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String query;

  const HomeSearchBar({
    super.key,
    required this.onChanged,
    required this.onClear,
    required this.query,
  });

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final _ctrl = TextEditingController();

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: c.surfaceAlt,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _ctrl.text.isNotEmpty ? c.primary : c.border,
            width: _ctrl.text.isNotEmpty ? 1.0 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 13, right: 8),
              child: Icon(Icons.search_rounded, size: 18, color: c.textMuted),
            ),
            Expanded(
              child: TextField(
                controller: _ctrl,
                style: TextStyle(fontSize: 13, color: c.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search devs, skills, projects…',
                  hintStyle: TextStyle(fontSize: 13, color: c.textMuted, fontWeight: FontWeight.w400),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 11),
                ),
                onChanged: (v) {
                  setState(() {});
                  widget.onChanged(v);
                },
              ),
            ),
            if (_ctrl.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _ctrl.clear();
                  widget.onClear();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12, left: 4),
                  child: Icon(Icons.close_rounded, size: 17, color: c.textMuted),
                ),
              )
            else
              const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FilterChipsRow — horizontal scrolling category filter
// ─────────────────────────────────────────────────────────────────────────────
class FilterChipsRow extends StatelessWidget {
  final String active;
  final ValueChanged<String> onSelect;

  static const _filters = [
    ('all',     'All'),
    ('ui-ux',   'UI/UX'),
    ('flutter', 'Flutter'),
    ('ai-ml',   'AI/ML'),
    ('web',     'Web'),
    ('backend', 'Backend'),
  ];

  const FilterChipsRow({
    super.key,
    required this.active,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final (key, label) = _filters[i];
          final isActive = active == key;
          return _FilterChip(
            label: label,
            isActive: isActive,
            onTap: () {
              HapticFeedback.selectionClick();
              onSelect(key);
            },
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.isActive, required this.onTap});

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.92)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: widget.isActive ? c.primary : c.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isActive ? c.primary : c.border,
              width: widget.isActive ? 0 : 0.5,
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: widget.isActive ? Colors.white : c.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DeveloperStoriesRow — horizontal scrollable developer story circles
// ─────────────────────────────────────────────────────────────────────────────
class DeveloperStoriesRow extends StatelessWidget {
  final List<DeveloperStory> stories;
  final VoidCallback onAddStory;

  const DeveloperStoriesRow({
    super.key,
    required this.stories,
    required this.onAddStory,
  });

  @override
  Widget build(BuildContext context) {
    print("stories lengts is :${stories.length}");
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: stories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          if (i == 0) return _AddStoryButton(onTap: onAddStory);
          final story = stories[i - 1];
          return _StoryItem(
            story: story,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StoryViewerScreen(
                    stories: stories,
                    initialIndex: i - 1,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _StoryItem extends StatefulWidget {
  final DeveloperStory story;
  final VoidCallback onTap;
  const _StoryItem({required this.story,required this.onTap,});

  @override
  State<_StoryItem> createState() => _StoryItemState();
}

class _StoryItemState extends State<_StoryItem> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 130));
    _scale = Tween<double>(begin: 1.0, end: 0.9)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final story = widget.story;
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),

      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Story ring
                Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(
                        int.parse(
                          (story.hasSeen
                              ? story.seenBorderColor
                              : story.unseenBorderColor)
                              .replaceFirst('#', '0xff'),
                        ),
                      ),
                      width: 2.5,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: c.surface,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: ClipOval(
                      child: story.profileImage.isNotEmpty
                          ? Image.network(
                        story.profileImage,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _InitialAvatar(story.initials),
                      )
                          : _InitialAvatar(story.initials),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 52,
              child: Text(
                story.name.split(' ').first,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: c.textPrimary,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddStoryButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddStoryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: c.primaryLight,
              shape: BoxShape.circle,
              border: Border.all(color: c.primary.withValues(alpha: 0.3), width: 0.5),
            ),
            child: Icon(Icons.add_rounded, color: c.primary, size: 22),
          ),
          const SizedBox(height: 5),
          Text(
            'Add yours',
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: c.primary),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HackathonCard — with live countdown timer (theme-aware)
// ─────────────────────────────────────────────────────────────────────────────
class HackathonCard extends StatelessWidget {
  final Hackathon hack;
  final VoidCallback onFormTeam;
  final VoidCallback onDetails;

  const HackathonCard({
    super.key,
    required this.hack,
    required this.onFormTeam,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border, width: 0.5),
      ),
      child: Stack(
        children: [
          // Left accent strip
          Positioned(
            left: 0, top: 0, bottom: 0,
            child: Container(
              width: 3.5,
              decoration: BoxDecoration(
                gradient: c.primaryGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 13, 13, 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(hack.title, style: DCText.h3.copyWith(color: c.textPrimary)),
                          const SizedBox(height: 3),
                          Text(hack.subtitle, style: DCText.caption.copyWith(color: c.textSecondary)),
                        ],
                      ),
                    ),
                    DcBadge.open(),
                  ],
                ),
                const SizedBox(height: 9),

                // Tech tags
                Wrap(
                  children: hack.techTags.map((t) => SkillPill(label: t)).toList(),
                ),
                const SizedBox(height: 10),

                // Countdown
                if (hack.isOpen) ...[
                  Text(
                    'Registration closes in',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: c.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _CountdownBlock(value: hack.daysLeft,    label: 'days', colors: c),
                      const SizedBox(width: 5),
                      _CountdownBlock(value: hack.hoursLeft,   label: 'hrs',  colors: c),
                      const SizedBox(width: 5),
                      _CountdownBlock(value: hack.minutesLeft, label: 'min',  colors: c),
                      const SizedBox(width: 5),
                      _CountdownBlock(value: hack.secondsLeft, label: 'sec',  colors: c),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _HackBtn(label: 'Form team', isPrimary: true,  onTap: onFormTeam, colors: c),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _HackBtn(label: 'Details', isPrimary: false, onTap: onDetails, colors: c),
                    ),
                  ],
                ),

                // AI match indicator
                if (hack.isMatchingSkills) ...[
                  const SizedBox(height: 9),
                  AiBadge(label: 'Matches your skills'),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownBlock extends StatelessWidget {
  final int value;
  final String label;
  final AppColorScheme colors;
  const _CountdownBlock({required this.value, required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(color: colors.primaryLight, borderRadius: BorderRadius.circular(9)),
      child: Column(
        children: [
          Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: colors.primary,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: colors.primary),
          ),
        ],
      ),
    );
  }
}

class _HackBtn extends StatefulWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;
  final AppColorScheme colors;
  const _HackBtn({required this.label, required this.isPrimary, required this.onTap, required this.colors});

  @override
  State<_HackBtn> createState() => _HackBtnState();
}

class _HackBtnState extends State<_HackBtn> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: widget.isPrimary ? c.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: widget.isPrimary
                ? null
                : Border.all(color: c.primary, width: 0.5),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: widget.isPrimary ? Colors.white : c.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HomeHeader — greeting + notification bell + avatar (theme-aware)
// ─────────────────────────────────────────────────────────────────────────────
class HomeHeader extends StatelessWidget {
  final String firstName;
  final String initials;
  final int colorIndex;
  final int unreadNotifications;
  final VoidCallback onNotificationsTap;
  final VoidCallback onAvatarTap;

  const HomeHeader({
    super.key,
    required this.firstName,
    required this.initials,
    required this.colorIndex,
    required this.unreadNotifications,
    required this.onNotificationsTap,
    required this.onAvatarTap,
  });

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: c.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: DCText.h2.copyWith(color: c.textPrimary),
                    children: [
                      TextSpan(text: firstName),
                      const TextSpan(text: ' 👋', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Notification bell
          GestureDetector(
            onTap: onNotificationsTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: c.surfaceAlt,
                    shape: BoxShape.circle,
                    border: Border.all(color: c.border, width: 0.5),
                  ),
                  child: Icon(Icons.notifications_none_rounded, size: 19, color: c.textSecondary),
                ),
                if (unreadNotifications > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: c.error,
                        shape: BoxShape.circle,
                        border: Border.all(color: c.surface, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          unreadNotifications > 9 ? '9+' : '$unreadNotifications',
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Avatar
          DcAvatar(
            initials: initials,
            colorIndex: colorIndex,
            size: 38,
            isOnline: true,
            onTap: onAvatarTap,
            hasBorder: false,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HomeErrorView — retry button on network failure
// ─────────────────────────────────────────────────────────────────────────────
class HomeErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const HomeErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: c.errorSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.wifi_off_rounded, color: c.error, size: 30),
            ),
            const SizedBox(height: 16),
            Text('Something went wrong', style: DCText.h3.copyWith(color: c.textPrimary)),
            const SizedBox(height: 8),
            Text(message, style: DCText.caption.copyWith(color: c.textSecondary), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                decoration: BoxDecoration(
                  gradient: c.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _InitialAvatar extends StatelessWidget {
  final String initials;

  const _InitialAvatar(this.initials);

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: c.primaryLight,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: c.primary,
        ),
      ),
    );
  }
}